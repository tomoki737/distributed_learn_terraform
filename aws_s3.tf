resource "aws_s3_bucket" "main" {
  bucket = "distributed-learn-image-bucket"

  tags = {
    Name        = "distributed-learn-image-bucket"
  }
}