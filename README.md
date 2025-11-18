# ECS Fargate WordPress Deployment using Terraform

This project provisions a complete WordPress environment on **Amazon ECS
Fargate** using **Terraform**, including networking, security, container
images, task definitions, ECS services, and RDS MySQL database.

## Overview

The deployment includes:

-   A VPC with public subnets\
-   Security groups for WordPress and MySQL\
-   ECR repositories for storing Docker images\
-   ECS Task Definition running WordPress + MySQL containers\
-   ECS Cluster and Service running on AWS Fargate\
-   Automated deployment using Terraform with remote S3 backend

WordPress becomes accessible via a public IP assigned to ECS tasks.

## Project Structure

terraform-project/
├── terraform.tf          # Provider, version, S3 backend
├── main.tf               # Connects all modules together
├── variables.tf          # Root variables
├── outputs.tf            # Exposed outputs (VPC ID, ECR URI, RDS endpoint)
├── terraform.tfvars      # User-supplied values
└── modules/
     ├── vpc/
     ├── sg/
     ├── ecr/
     ├── rds/
     ├── task_definition/
     └── ecs/

## Architecture Diagram

<p align="center">
  <img src="./images/Architecture Diagram.png" alt="Terraform-EC2-WordPress" width="850">
</p>

------------------------------------------------------------------------
