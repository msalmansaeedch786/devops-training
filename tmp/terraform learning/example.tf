
provider "aws" {
  region = var.region
}

# resource "aws_instance" "example" {
#   ami           = var.amis[var.region]
#   instance_type = "t2.micro"
# }

# resource "aws_eip" "ip" {
#     vpc = true
#     instance = aws_instance.example.id
# }

# output "ip" {
#   value = aws_eip.ip.public_ip
# }

resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}