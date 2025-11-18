locals {
  public_subnets = {
    public-subnet-a = {
      cidr = "10.0.1.0/24"
      az   = "us-east-1a"
    }
    public-subnet-b = {
      cidr = "10.0.2.0/24"
      az   = "us-east-1b"
    }
  }

  private_subnets = {
    private-subnet-a = {
      cidr = "10.0.3.0/24"
      az   = "us-east-1a"
    }
    private-subnet-b = {
      cidr = "10.0.4.0/24"
      az   = "us-east-1b"
    }
  }
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

# Subnets

# Public Subnets
resource "aws_subnet" "public_subnet" {
  for_each = local.public_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}

# Private Subnets
resource "aws_subnet" "private_subnet" {
  for_each = local.private_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "ecs-igw" }
}

# EIP
resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-gateway-eip"
  }

  depends_on = [aws_internet_gateway.igw]
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.public_subnet["public-subnet-a"].id

  tags = {
    Name = "nat-gateway"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Route Tables

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-Route-Table"
  }
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "Private-Route-Table"
  }
}

# Route Table Associations

# Public Route Association
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public_subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

# Private Route Association
resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private_subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}