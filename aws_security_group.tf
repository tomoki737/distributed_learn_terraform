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
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

resource "aws_security_group_rule" "in_icmp" {
  security_group_id = aws_security_group.book_question_instance_sg.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
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
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["10.0.1.0/24"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "book_question_db_sg"
    }
}