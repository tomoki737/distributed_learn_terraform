resource "aws_alb" "distributed_learning_alb" {
  name               = "distributed-learning-alb"
  load_balancer_type = "application"
  security_groups = [aws_security_group.distributed_learning_alb_sg.id]
  subnets         = [aws_subnet.public_1a.id, aws_subnet.public_1c.id]
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.distributed_learning_alb.id
  port     = "80"
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.distributed-learning-alb-target-group.id
  }
}


resource "aws_alb_target_group" "distributed-learning-alb-target-group" {
  name     = "distributed-alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    interval            = 30
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    matcher             = 200
  }
}

resource "aws_alb_target_group_attachment" "distributed_learning_ga" {
  target_group_arn = aws_alb_target_group.distributed-learning-alb-target-group.id
  target_id        = aws_instance.distributed_learning_instance.id
  port             = 80
}

