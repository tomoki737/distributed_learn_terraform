resource "aws_instance" "hello-world" {
    ami = "ami-08a8688fb7eacb171"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_1a.id
    vpc_security_group_ids = [aws_security_group.book_question_instance_sg.id]
    key_name               = aws_key_pair.question.id
    tags = {
        Name = "book_question_instance"
    }

}

resource "aws_key_pair" "question" {
  key_name   = "question"
  public_key = file("./question.pub") 
}