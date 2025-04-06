provider "aws" {
  region = "us-east-1" // Changed region to us-east-1
}

# Data block to fetch default VPC
data "aws_vpc" "default" {
  default = true
}

# Data block to fetch default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group for ECS
resource "aws_security_group" "ecs" {
  vpc_id = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "medusa-security-group"
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "medusa-cluster"
}

# ECS Service with Fargate
resource "aws_ecs_service" "medusa" {
  name            = "medusa-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.medusa.arn
  desired_count   = 1

  # Define capacity provider strategy for Fargate
  capacity_provider_strategy {
    capacity_provider = "FARGATE" // Ensure Fargate is used
    weight            = 1
  }

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }
}

# IAM Role for ECS Task Execution
data "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role_new"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "medusa" {
  family                   = "medusa-task"
  requires_compatibilities = ["FARGATE"] // Ensure Fargate compatibility
  network_mode            = "awsvpc"
  cpu                     = 1024
  memory                  = 3072
  execution_role_arn      = data.aws_iam_role.ecs_execution_role.arn
  container_definitions   = jsonencode([
    {
      name      = "medusa"
      image     = "${aws_ecr_repository.medusa.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 9000
          hostPort      = 9000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# ECR Repository
resource "aws_ecr_repository" "medusa" {
  name = "medusa-new"
}
