############################################
# Project / Environment
############################################
variable "project" {
  type        = string
  description = "Project name"
  default     = "multi-app-platform"
}

variable "environment" {
  type        = string
  description = "Environment name (dev/stage/prod)"
  default     = "dev"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "ap-south-1"
}

############################################
# VPC
############################################
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet CIDRs"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDRs"
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

############################################
# EKS
############################################
# NOTE: EKS version 1.34 is not available at many times.
# Common stable versions are 1.29/1.30/1.31 (depends on AWS availability).
variable "cluster_version" {
  type        = string
  description = "EKS Kubernetes version"
  default     = "1.29"
}

variable "node_instance_types" {
  type        = list(string)
  description = "EKS node instance types"
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  type        = number
  description = "Desired node count"
  default     = 2
}

variable "node_min_size" {
  type        = number
  description = "Minimum node count"
  default     = 1
}

variable "node_max_size" {
  type        = number
  description = "Maximum node count"
  default     = 4
}

############################################
# RDS
############################################
variable "db_engine" {
  type        = string
  description = "RDS engine (mysql/postgres)"
  default     = "mysql"
}


variable "db_engine_version" {
  type        = string
  description = "RDS engine version"
  default     = "8.0.36"
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance class"
  default     = "db.t3.micro"
}

variable "db_name" {
  type        = string
  description = "Database name"
  default     = "appdb"
}

variable "db_username" {
  type        = string
  description = "Database username"
  default     = "appuser"
}

variable "db_password" {
  type        = string
  description = "Database password (DO NOT commit tfvars with real password)"
  sensitive   = true
}

############################################
# Redis (ElastiCache)
############################################
variable "redis_node_type" {
  type        = string
  description = "Redis node type"
  default     = "cache.t3.micro"
}
