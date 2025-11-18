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

## Key Components

### VPC Module

Creates the networking layer: - VPC, public and private subnets\
- Internet Gateway\
- NAT Gateway and EIP\
- Route tables and associations

### Security Group Module

Defines firewall rules: - Allows HTTP (80)\
- Allows MySQL (3306)\
- Enables outbound internet access

### ECR Module

Creates two private ECR repositories: - `wordpress`\
- `mysql`

### Task Definition Module

Defines an ECS Task running:
- **WordPress container** (from ECR)\
- CloudWatch logging\
- IAM execution role

### ECS Module

Deploys: - ECS Cluster\
- Fargate Service (2 tasks)\
- Public subnets + SG\
- Rolling deployments enabled

## RDS Module

Deploys: 
- Private DB Subnet Group
- RDS MySQL DB Instance(s)

## Deployment Steps

### 1. Initialize Terraform

    terraform init

### 2. Validate Configuration

    terraform validate

### 3. View Execution Plan

    terraform plan

### 4. Deploy Infrastructure

    terraform apply --auto-approve

### 5. Push Docker Images to ECR

Use "View push commands" in AWS ECR, then run: -
`docker pull wordpress` - Tag and push the image
to ECR

### 6. Access WordPress

Use the **public IP** of the ECS task's ENI:

    http://<public-ip>

## Verification

After deployment, confirm in AWS Console: 
- VPC, subnets, and route tables exist\
- ECR repositories contains WordPress image\
- ECS Cluster has 2 running tasks\
- Task Definition contains WordPress containers\
- WordPress loads successfully in browser

## Cleanup

Before destroying: - Manually delete image from ECR

Then run:

    terraform destroy --auto-approve

## Conclusion

This project demonstrates a full Infrastructure-as-Code deployment of
WordPress on AWS ECS Fargate and RDS using Terraform.