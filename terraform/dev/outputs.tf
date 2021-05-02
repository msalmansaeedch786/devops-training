# output "devops-training-bastion-host" {
#   value = "${aws_instance.devops-training-bastion-host.id}"
# }

# output "devops-training-private-ec2-instance" {
#   value = "${aws_instance.devops-training-private-ec2-instance.id}"
# }

output "devops-training-us-easat-1-bucket-1" {
  value = "${module.devops-training-us-easat-1-bucket-1.arn}"
}

output "devops-training-us-easat-1-bucket-2" {
  value = "${module.devops-training-us-easat-1-bucket-2.arn}"
}