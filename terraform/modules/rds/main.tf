resource "aws_db_subnet_group" "subnet_group" {
  name       = "private-db-subnet"
  subnet_ids = var.private_subnets

  tags = {
    Name        = "private-db-subnet"
    Description = "Private DB Subnet Group for MySQL"
  }
}

resource "aws_db_instance" "db_instance" {
  allocated_storage      = 20
  db_name                = var.db_name
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
  identifier             = "umarsatti"
  engine                 = "mysql"
  engine_version         = "8.0.43"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql8.0"
  vpc_security_group_ids = [var.security_group_private_id]
  skip_final_snapshot    = true
}