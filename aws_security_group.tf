resource "aws_security_group" "book_question_instance_sg" {
  vpc_id = aws_vpc.main.id
  name   = "book_question_sg"
  tags = {
    Name = "book_question_sg"
  }
}

resource "aws_security_group_rule" "in_ssh" {
  security_group_id = aws_security_group.book_question_instance_sg.id
  type              = "ingress"
  cidr_blocks       = [var.my_ip]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

resource "aws_security_group_rule" "in_http" {
  type              = "ingress"
  security_group_id = aws_security_group.book_question_instance_sg.id
  source_security_group_id = aws_security_group.book_question_alb_sg.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}

resource "aws_security_group_rule" "out_all" {
  security_group_id = aws_security_group.book_question_instance_sg.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}


resource "aws_security_group" "praivate-db-sg" {
    name = "book_question_db_sg"
    vpc_id = aws_vpc.main.id
    tags = {
      Name = "book_question_db_sg"
    }
}

resource "aws_security_group_rule" "in_db" {
  security_group_id = aws_security_group.praivate-db-sg.id
  source_security_group_id = aws_security_group.praivate-db-sg.id
        type =   "ingress" 
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
}

resource "aws_security_group_rule" "out_db" {
  security_group_id = aws_security_group.praivate-db-sg.id
    type = "ingress" 
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
}



#ALB
resource "aws_security_group" "book_question_alb_sg" {
    name = "book_question_alb_sg"
    vpc_id = aws_vpc.main.id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "book_question_alb_sg"
    }
}

