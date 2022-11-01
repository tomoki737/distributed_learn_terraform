resource "aws_alb" "distributed_learn_alb" {
  name               = "distributed-learn-alb"
  load_balancer_type = "application"
  security_groups = [aws_security_group.distributed_learn_alb_sg.id]
  subnets         = [aws_subnet.public_1a.id, aws_subnet.public_1c.id]
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.distributed_learn_alb.arn
  certificate_arn = aws_acm_certificate.cert.arn
  port     = "443"
  protocol = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.task-tg.arn
  }
}


resource "aws_alb_target_group" "task-tg" {
  name     = "distributed-alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "ip"
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

