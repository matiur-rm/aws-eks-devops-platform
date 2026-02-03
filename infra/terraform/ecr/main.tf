variable "project" {}
variable "environment" {}
variable "repositories" { type = list(string) }

locals {
  name = "${var.project}-${var.environment}"
  tags = { Project = var.project, Environment = var.environment, ManagedBy = "Terraform" }
}

resource "aws_ecr_repository" "repo" {
  for_each = toset(var.repositories)
  name     = "${local.name}-${each.value}"

  image_scanning_configuration { scan_on_push = true }
  image_tag_mutability = "MUTABLE"
  tags = local.tags
}

output "repository_urls" {
  value = { for k, r in aws_ecr_repository.repo : k => r.repository_url }
}
