resource "aws_alb" "book_question_alb" {
  name               = "book-question-alb"
  load_balancer_type = "application"
  security_groups = [aws_security_group.book_question_alb_sg.id]
  subnets         = [aws_subnet.public_1a.id, aws_subnet.public_1c.id]
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.book_question_alb.id
  port     = "80"
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.book-question-alb-target-group.id
  }
}


resource "aws_alb_target_group" "book-question-alb-target-group" {
  name     = "book-question-alb-target-group"
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

resource "aws_alb_target_group_attachment" "book_question_ga" {
  target_group_arn = aws_alb_target_group.book-question-alb-target-group.id
  target_id        = aws_instance.book_question_instance.id
  port             = 80
}

