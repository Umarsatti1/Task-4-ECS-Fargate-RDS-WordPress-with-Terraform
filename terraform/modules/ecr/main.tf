# Contains ECR repository creation

resource "aws_ecr_repository" "ecr_wordpress" {
  name                 = var.ecr_wordpress_name
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = false
  }
}
