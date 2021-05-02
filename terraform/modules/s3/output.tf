# This file outputs the following value

output "arn" {
  value = "${aws_s3_bucket.s3-bucket.arn}"
}

output "name" {
  value = "${aws_s3_bucket.s3-bucket.bucket}"
}

output "bucket_id" {
  value = "${aws_s3_bucket.s3-bucket.id}"
}