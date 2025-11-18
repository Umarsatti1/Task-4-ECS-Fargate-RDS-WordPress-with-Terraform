# Public Security Group
resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "Allows HTTP traffic from the internet"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "public-sg"
    Application = "Wordpress Application"
    Service     = "ECS"
  }
}

# Private Security Group used for RDS
resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Allows MySQL traffic from ECS (public-sg) only"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "private-sg"
    Application = "RDS MySQL Database"
  }
}