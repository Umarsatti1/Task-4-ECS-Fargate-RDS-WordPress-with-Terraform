output "igw_name" {
  description = "Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "VPC Public Subnets"
  value       = [for s in aws_subnet.public_subnet : s.id]
}

output "private_subnets" {
  description = "VPC Private Subnets"
  value       = [for s in aws_subnet.private_subnet : s.id]
}