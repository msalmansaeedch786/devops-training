terraform {
  backend "s3" {
    bucket = "devops-training-terraform-state-us-east-1"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}
