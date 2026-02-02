output "eks_cluster_name" {
  value = module.eks.cluster_name
}
output "eks_endpoint" {
  value = module.eks.cluster_endpoint
}

output "ecr_repository_urls" {
  value = module.ecr.repository_urls
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "redis_endpoint" {
  value = module.caching.redis_primary_endpoint
}

output "s3_bucket" {
  value = module.s3.bucket_name
}
