output "security_group_id" {
  value       = aws_security_group.public_sg.id
  description = "Security group ID for public resources"
}

output "security_group_private_id" {
  value       = aws_security_group.private_sg.id
  description = "Security group ID for private resources (RDS)"
}