variable "project" {}
variable "environment" {}

resource "random_id" "suffix" { byte_length = 4 }

locals {
  bucket = "${var.project}-${var.environment}-bucket-${random_id.suffix.hex}"
}

resource "aws_s3_bucket" "this" { bucket = local.bucket }

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "bucket_name" { value = aws_s3_bucket.this.bucket }
