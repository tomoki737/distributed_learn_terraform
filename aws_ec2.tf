resource "aws_instance" "distributed_learning_instance" {
  ami                    = "ami-08a8688fb7eacb171"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_1a.id
  vpc_security_group_ids = [aws_security_group.distributed_learning_instance_sg.id]
  key_name               = aws_key_pair.learning.id
  tags = {
    Name = "distributed_learning_instance"
  }

}

resource "aws_key_pair" "learning" {
  key_name   = "learning"
  public_key = file("learning.pem.pub")
}


