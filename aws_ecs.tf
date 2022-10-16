resource "aws_ecs_task_definition" "main" {
  family = "distributed_learning_task_definition"

  requires_compatibilities = ["FARGATE"]

  memory = "512"
  cpu    = "256"

  network_mode = "awsvpc"
  task_role_arn = aws_iam_role.ECS-Exec-Fargate-role.arn
  execution_role_arn = aws_iam_role.ECS-Task-Execution-Role.arn
  container_definitions = jsonencode(
[
  {
    "name": "nginx",
    "image": "${var.ecr_url}nginx:prod",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],

    "logConfiguration": {
    "logDriver": "awslogs",
    "options": {
        "awslogs-create-group": "true",
        "awslogs-group": aws_cloudwatch_log_group.main.name,
        "awslogs-region": var.default_region,
        "awslogs-stream-prefix": "ecs"
    }
},
  },

  {
    "name": "php",
    "image": "${var.ecr_url}php:prod",
    "command": ["php artisan config:cache && chmod -R 777 storage/* && php-fpm"],
    "root_directory" = " /var/www/html",
    "entryPoint": ["sh","-c"],
    "environment": [
      {"name": "APP_ENV", "value": "production"}
    ],

    "logConfiguration": {
    "logDriver": "awslogs",
    "options": {
        "awslogs-create-group": "true",
        "awslogs-group": aws_cloudwatch_log_group.main.name,
        "awslogs-region": var.default_region,
        "awslogs-stream-prefix": "ecs"
    }
    }
  }
])
}

#クラスター
# resource "aws_kms_key" "main" {
#   description             = "main"
#   deletion_window_in_days = 7
# }

resource "aws_cloudwatch_log_group" "main" {
  name = "distributed_learn_task_definition"
}

resource "aws_ecs_cluster" "main" {
  name = "distributed_learn_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

#ECS Service
resource "aws_ecs_service" "main" {
  name = "distributed_learning"

  depends_on = [aws_alb_listener.http]

  cluster = aws_ecs_cluster.main.arn

  launch_type = "FARGATE"

  desired_count = "1"


  task_definition = aws_ecs_task_definition.main.arn

  network_configuration {
    subnets         = [aws_subnet.public_1a.id, aws_subnet.public_1c.id]
    security_groups = [aws_security_group.task_sg.id]
    assign_public_ip = true
  }

  load_balancer {
      target_group_arn = aws_alb_target_group.task-tg.arn
      container_name   = "nginx"
      container_port   = "80"
  }
}