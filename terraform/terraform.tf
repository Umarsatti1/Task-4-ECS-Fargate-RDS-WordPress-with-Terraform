terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.21.0"
    }
  }
  
  backend "s3" {  
    bucket         = "umarsatti-terraform-state-file-s3-bucket"  
    key            = "Task4-with-RDS/terraform.tfstate"
    region         = "us-east-1"  
    encrypt        = true
    use_lockfile   = true
  }
}

provider "aws" {
  region = "us-east-1"
}