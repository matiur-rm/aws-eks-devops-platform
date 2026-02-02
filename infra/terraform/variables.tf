variable "project"     { type = string, default = "multi-app-platform" }
variable "environment" { type = string, default = "dev" }
variable "aws_region"  { type = string, default = "ap-south-1" }

# VPC
variable "vpc_cidr" { type = string, default = "10.0.0.0/16" }
variable "azs" { type = list(string), default = ["ap-south-1a", "ap-south-1b"] }
variable "public_subnet_cidrs"  { type = list(string), default = ["10.0.1.0/24", "10.0.2.0/24"] }
variable "private_subnet_cidrs" { type = list(string), default = ["10.0.11.0/24", "10.0.12.0/24"] }

# EKS
variable "cluster_version"     { type = string, default = "1.33" }
variable "node_instance_types" { type = list(string), default = ["t3.nano"] }
variable "node_desired_size"   { type = number, default = 2 }
variable "node_min_size"       { type = number, default = 1 }
variable "node_max_size"       { type = number, default = 4 }

# RDS
variable "db_engine"         { type = string, default = "mysql" }
variable "db_engine_version" { type = string, default = "8.4.8" }
variable "db_instance_class" { type = string, default = "db.t3.micro" }
variable "db_name"           { type = string, default = "appdb" }
variable "db_username"       { type = string, default = "appuser" }
variable "db_password"       { type = string, sensitive = true }

# Redis
variable "redis_node_type" { type = string, default = "cache.t3.micro" }
