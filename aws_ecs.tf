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
    "command": ["php artisan config:cache && chmod -R 777 storage/* && php-fpm && php artisan migrate --force" ] ,
    "root_directory" = " /var/www/html",
    "entryPoint": ["sh","-c"],
    "environment": [
      {"name": "APP_ENV", "value": "production"},
      {"name": "APP_DEBUG", "value": "false"},
      {"name": "APP_KEY", "value": var.app_key},
      {"name": "DB_CONNECTION", "value": "mysql"},
      {"name": "DB_HOST", "value": var.db_host},
      {"name": "DB_PORT", "value": "3306"},
      {"name": "DB_DATABASE", "value": var.db_name},
      {"name": "DB_USERNAME", "value": var.db_username},
      {"name": "DB_PASSWORD", "value": var.db_password},
      {"name": "AWS_ACCESS_KEY_ID", "value": var.access_key},
      {"name": "AWS_SECRET_ACCESS_KEY", "value": var.access_key},
      {"name": "AWS_BUCKET", "value": var.aws_bucket},
      {"name": "SESSION_DOMAIN", "value": var.app_url},
      {"name": "SANCTUM_STATEFUL_DOMAINS", "value": var.app_url},
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