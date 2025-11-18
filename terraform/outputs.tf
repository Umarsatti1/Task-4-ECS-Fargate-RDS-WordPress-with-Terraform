output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "ecr_uri_wordpress" {
  value       = module.ecr.ecr_uri_wordpress
  description = "ECR Private Registry Wordpress URI"
}

output "rds_endpoint" {
  value       = module.rds.db_endpoint
  description = "RDS MySQL Database Endpoint"
}