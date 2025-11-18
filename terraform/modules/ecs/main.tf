# Create ECS Cluster and Service

# Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "wordpress-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enhanced"
  }

  configuration {
    execute_command_configuration {
    logging = "DEFAULT"
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

# Service

resource "aws_ecs_service" "wordpress-service" {
  name                   = "wordpress-service"
  cluster                = aws_ecs_cluster.ecs_cluster.id
  task_definition        = var.task_definition_arn
  desired_count          = 2
  launch_type            = "FARGATE"
  platform_version       = "LATEST"
  scheduling_strategy    = "REPLICA"
  enable_execute_command = true
  
  deployment_configuration {
    strategy = "ROLLING"
  }

  network_configuration {
    assign_public_ip = true
    security_groups  = [var.security_group_id]
    subnets          = var.public_subnets
  }
}

