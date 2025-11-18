# IAM Role for ECS Tasks
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ECS-Task-Execution-Role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Action    = "sts:AssumeRole",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

# IAM Policy
resource "aws_iam_role_policy_attachment" "ecs_exec_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/wordpress-app"
  retention_in_days = 7
}

# ECS Task Definition
resource "aws_ecs_task_definition" "task_definition" {
  family                   = "wordpress-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "wordpress"
      image     = "${var.ecr_uri_wordpress}:latest"
      essential = true
      cpu       = 200
      memory    = 512

      environment = [
        { name = "WORDPRESS_DB_HOST",     value = "${var.rds_endpoint}:3306" },
        { name = "WORDPRESS_DB_USER",     value = var.db_username },
        { name = "WORDPRESS_DB_PASSWORD", value = var.db_password },
        { name = "WORDPRESS_DB_NAME",     value = var.db_name }
      ]

      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "wordpress"
        }
      }
    }
  ])
}