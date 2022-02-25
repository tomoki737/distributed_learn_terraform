#EC2
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "book_question_vpc"
  }
}

resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"

  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "book_question_public-1a"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1c"

  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "book_question_public-1c"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id = aws_vpc.main.id

  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.0.10.0/24"

  tags = {
    Name = "book_question_private-1a"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id = aws_vpc.main.id

  availability_zone = "ap-northeast-1c"
  cidr_block        = "10.0.20.0/24"

  tags = {
    Name = "book_question_private_1c"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "book_question_igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "book_question_private_public"
  }
}

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

#RDS
resource "aws_db_subnet_group" "private_db_subnet_group" {
  name       = "private_db"
  subnet_ids = [aws_subnet.private_1a.id, aws_subnet.private_1c.id]
  tags = {
    Name = "private_db"
  }
}

