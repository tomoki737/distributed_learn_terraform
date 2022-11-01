resource "aws_db_instance" "distributed_learn_db" {
  identifier             = "distributed-learn-db"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t2.micro"
  username               = var.db_username
  password               = var.db_password
  db_name                = var.db_name
  vpc_security_group_ids = [aws_security_group.praivate-db-sg.id]
  db_subnet_group_name = aws_db_subnet_group.private_db_subnet_group.name
  skip_final_snapshot  = true
}
