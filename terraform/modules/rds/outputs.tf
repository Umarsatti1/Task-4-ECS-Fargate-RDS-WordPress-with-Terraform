output "db_endpoint" {
  value       = aws_db_instance.db_instance.address
  description = "RDS endpoint address"
}

output "db_username" {
  value       = aws_db_instance.db_instance.username
  description = "RDS username"
}

output "db_name" {
  value       = aws_db_instance.db_instance.db_name
  description = "RDS DB name"
}

output "db_password" {
  value       = var.db_password
  sensitive   = true
  description = "RDS DB password (sensitive input forwarded)"
}