# This script creates a s3 bucket
# You can find available options at the following link.
# https://www.terraform.io/docs/providers/aws/r/s3_bucket.html
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "s3-bucket" {
  bucket = "${var.bucket_name}-${data.aws_caller_identity.current.account_id}-${terraform.workspace}"
  force_destroy = true
  acl    = "${var.acl}"
}