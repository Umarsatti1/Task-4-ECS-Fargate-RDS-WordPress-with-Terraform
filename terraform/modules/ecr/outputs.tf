output "ecr_uri_wordpress" {
  value       = aws_ecr_repository.ecr_wordpress.repository_url
  description = "Wordpress ECR Repository URI"
}