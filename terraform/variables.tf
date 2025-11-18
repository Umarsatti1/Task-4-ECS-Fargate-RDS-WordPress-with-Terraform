variable "vpc_name" {
  type        = string
  description = "VPC Name"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR Block"
}

variable "ecr_wordpress_name" {
  type        = string
  description = "Wordpress ECR repo name"
}

variable "db_username" {
  type        = string
  description = "RDS MySQL DB Username"
}

variable "db_password" {
  type        = string
  description = "RDS MySQL DB Password"
  sensitive   = true
}

variable "db_name" {
  type        = string
  description = "RDS MySQL DB Name"
}