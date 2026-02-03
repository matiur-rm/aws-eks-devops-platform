variable "project" {}
variable "environment" {}
variable "cluster_name" {}
variable "region" {}
variable "vpc_id" {}
variable "oidc_provider_arn" {}
variable "oidc_provider_url" {}

locals {
  name      = "${var.project}-${var.environment}"
  namespace = "kube-system"
}

# IRSA role for ALB controller
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${local.namespace}:aws-load-balancer-controller"]
    }
  }
}

resource "aws_iam_role" "alb_controller" {
  name               = "${local.name}-alb-controller-irsa"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Simple broad policy (easy mode). Later you can replace with AWS official least-privilege JSON.
resource "aws_iam_role_policy" "alb_controller" {
  name = "${local.name}-alb-controller-policy"
  role = aws_iam_role.alb_controller.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["elasticloadbalancing:*","ec2:Describe*","iam:CreateServiceLinkedRole","iam:GetServerCertificate","iam:ListServerCertificates","cognito-idp:DescribeUserPoolClient","waf-regional:*","wafv2:*","shield:*"]
      Resource = "*"
    }]
  })
}

resource "kubernetes_service_account_v1" "alb_sa" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = local.namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller.arn
    }
  }
}




resource "helm_release" "alb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = local.namespace

  values = [
    yamlencode({
      clusterName = var.cluster_name
      region      = var.region
      vpcId        = var.vpc_id

      serviceAccount = {
        create = false
        name   = kubernetes_service_account_v1.alb_sa.metadata[0].name
      }
    })
  ]
}

