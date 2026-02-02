terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.25"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# -----------------------
# 1) VPC
# -----------------------

module "vpc" {
  source               = "./vpc"
  project              = var.project
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# -----------------------
# 2) IAM roles (EKS)
# -----------------------
module "iam" {
  source      = "./iam"
  project     = var.project
  environment = var.environment
}

# -----------------------
# 3) EKS
# -----------------------

module "eks" {
  source               = "./eks"
  project              = var.project
  environment          = var.environment
  cluster_version      = var.cluster_version
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_role_arn    = module.iam.eks_node_role_arn

  node_instance_types  = var.node_instance_types
  node_desired_size    = var.node_desired_size
  node_min_size        = var.node_min_size
  node_max_size        = var.node_max_size
}

# Kubernetes/Auth for Helm (After EKS created)
data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

# -----------------------
# 4) ECR
# -----------------------
module "ecr" {
  source      = "./ecr"
  project     = var.project
  environment = var.environment
  repositories = [
    "laravel",
    "django",
    "react"
  ]
}

# -----------------------
# 5) RDS (DB)
# -----------------------
module "rds" {
  source             = "./rds"
  project            = var.project
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  eks_node_sg_id     = module.eks.node_security_group_id

  db_engine         = var.db_engine
  db_engine_version = var.db_engine_version
  db_instance_class = var.db_instance_class
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
}

# -----------------------
# 6) Redis (ElastiCache)
# -----------------------
module "caching" {
  source             = "./caching"
  project            = var.project
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  eks_node_sg_id     = module.eks.node_security_group_id
  redis_node_type    = var.redis_node_type
}

# -----------------------
# 7) S3
# -----------------------
module "s3" {
  source      = "./s3"
  project     = var.project
  environment = var.environment
}

# -----------------------
# 8) ALB Controller (Ingress controller)
# -----------------------

module "alb" {
  source            = "./alb"
  project           = var.project
  environment       = var.environment
  cluster_name      = module.eks.cluster_name
  region            = var.aws_region
  vpc_id            = module.vpc.vpc_id
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url
}
