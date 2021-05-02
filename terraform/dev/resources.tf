# # Create Provider
# provider "aws" {
# 		profile    = "default"
#     region     = "${var.region}"
# } # end provider

# # Create VPC
# resource "aws_vpc" "devops-training-vpc" {
#   cidr_block           = "${var.VpcCidrBlock}"
#   instance_tenancy     = "${var.InstanceTenancy}" 
#   enable_dns_support   = "${var.DnsSupport}" 
#   enable_dns_hostnames = "${var.DnsHostNames}"
#   tags = {
#     Name = "devops-training-vpc"
#   }
# } # end resource

# # Create Public Subnet One
# resource "aws_subnet" "devops-training-public-subnet-one" {
#   vpc_id                  = "${aws_vpc.devops-training-vpc.id}"
#   cidr_block              = "${var.PublicSubnetOneCidrBlock}"
#   map_public_ip_on_launch = "${var.MapPublicIP}" 
#   availability_zone       = "${var.AvailabilityZoneOne}"
#   tags = {
#    Name = "devops-training-public-subnet-one"
#   }
# } # end resource

# # Create Public Subnet Two
# resource "aws_subnet" "devops-training-public-subnet-two" {
#   vpc_id                  = "${aws_vpc.devops-training-vpc.id}"
#   cidr_block              = "${var.PublicSubnetTwoCidrBlock}"
#   map_public_ip_on_launch = "${var.MapPublicIP}" 
#   availability_zone       = "${var.AvailabilityZoneTwo}"
#   tags = {
#    Name = "devops-training-public-subnet-two"
#   }
# } # end resource

# # Create Private Subnet One
# resource "aws_subnet" "devops-training-private-subnet-one" {
#   vpc_id                  = "${aws_vpc.devops-training-vpc.id}"
#   cidr_block              = "${var.PrivateSubnetOneCidrBlock}"
#   availability_zone       = "${var.AvailabilityZoneOne}"
#   tags = {
#    Name = "devops-training-private-subnet-one"
#   }
# } # end resource

# # Create Private Subnet Two
# resource "aws_subnet" "devops-training-private-subnet-two" {
#   vpc_id                  = "${aws_vpc.devops-training-vpc.id}"
#   cidr_block              = "${var.PrivateSubnetTwoCidrBlock}"
#   availability_zone       = "${var.AvailabilityZoneTwo}"
#   tags = {
#    Name = "devops-training-private-subnet-two"
#   }
# } # end resource

# # Create Public Security Group
# resource "aws_security_group" "devops-training-public-security-group" {
#   vpc_id      = "${aws_vpc.devops-training-vpc.id}"
#   name        = "devops-training-public-security-group"
#   description = "allow ssh, http and https access"
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
# 	  protocol = -1
# 	  from_port = 0 
# 	  to_port = 0 
# 	  cidr_blocks = ["0.0.0.0/0"]
# 	}
#   tags = {
#     Name = "devops-training-public-security-group"
#   }
# } # end resource

# # Create Private Security Group
# resource "aws_security_group" "devops-training-private-security-group" {
#   vpc_id      = "${aws_vpc.devops-training-vpc.id}"
#   name        = "devops-training-private-security-group"
#   description = "allow ssh, http and https access"
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#    ingress {
#     from_port   = 8
#     to_port     = -1
#     protocol    = "icmp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
# 	  protocol = -1
# 	  from_port = 0 
# 	  to_port = 0 
# 	  cidr_blocks = ["0.0.0.0/0"]
# 	}
#   tags = {
#     Name = "devops-training-private-security-group"
#   }
# } # end resource

# resource "aws_internet_gateway" "devops-training-internet-gateway" {
#   vpc_id  = "${aws_vpc.devops-training-vpc.id}"
#   tags = {
#     Name = "devops-training-internet-gateway"
#   }
# }

# resource "aws_route_table" "devops-training-public-route-table" {
#   vpc_id = "${aws_vpc.devops-training-vpc.id}"
#   tags = {
#     Name = "devops-training-public-route-table"
#   }
# }

# resource "aws_route" "devops-training-public-route" {
#   route_table_id            = "${aws_route_table.devops-training-public-route-table.id}"
#   destination_cidr_block    = "0.0.0.0/0"
#   gateway_id                = "${aws_internet_gateway.devops-training-internet-gateway.id}"
# }

# resource "aws_route_table_association" "devops-training-public-subnet-one-route-table-association" {
#   subnet_id      = "${aws_subnet.devops-training-public-subnet-one.id}"
#   route_table_id = "${aws_route_table.devops-training-public-route-table.id}"
# }

# resource "aws_route_table_association" "devops-training-public-subnet-two-route-table-association" {
#   subnet_id      = "${aws_subnet.devops-training-public-subnet-two.id}"
#   route_table_id = "${aws_route_table.devops-training-public-route-table.id}"
# }

# resource "aws_eip" "devops-training-eip" {
#   tags = {
#     Name = "devops-training-eip"
#   }
# }

# resource "aws_nat_gateway" "devops-training-ngw" {
#   allocation_id = "${aws_eip.devops-training-eip.id}"
#   subnet_id     = "${aws_subnet.devops-training-public-subnet-one.id}"
#   tags = {
#     Name = "devops-training-ngw"
#   }
# }

# resource "aws_route_table" "devops-training-private-route-table" {
#   vpc_id = "${aws_vpc.devops-training-vpc.id}"
#   tags = {
#     Name = "devops-training-private-route-table"
#   }
# }

# resource "aws_route" "devops-training-private-route" {
#   route_table_id            = "${aws_route_table.devops-training-private-route-table.id}"
#   destination_cidr_block    = "0.0.0.0/0"
#   nat_gateway_id            = "${aws_nat_gateway.devops-training-ngw.id}"
# }

# resource "aws_route_table_association" "devops-training-private-subnet-one-route-table-association" {
#   subnet_id      = "${aws_subnet.devops-training-private-subnet-one.id}"
#   route_table_id = "${aws_route_table.devops-training-private-route-table.id}"
# }

# resource "aws_route_table_association" "devops-training-private-subnet-two-route-table-association" {
#   subnet_id      = "${aws_subnet.devops-training-private-subnet-two.id}"
#   route_table_id = "${aws_route_table.devops-training-private-route-table.id}"
# }

# resource "aws_instance" "devops-training-bastion-host" {
#   ami =  "ami-0b69ea66ff7391e80"
#   instance_type = "t2.micro"
#   subnet_id = "${aws_subnet.devops-training-public-subnet-one.id}"
#   associate_public_ip_address = "true"
#   key_name = "devops-training-keypair"
#   vpc_security_group_ids = [ "${aws_security_group.devops-training-public-security-group.id}" ]
#   tags = {
#     Name = "devops-training-bastion-host"
#   }
# }

# resource "aws_instance" "devops-training-private-ec2-instance" {
#   ami =  "ami-0b69ea66ff7391e80"
#   instance_type = "t2.micro"
#   subnet_id = "${aws_subnet.devops-training-private-subnet-one.id}"
#   key_name = "devops-training-keypair"
#   vpc_security_group_ids = [ "${aws_security_group.devops-training-private-security-group.id}" ]
#   tags = {
#     Name = "devops-training-private-ec2-instance"
#   }
# }

# Bucket 1
module "devops-training-us-easat-1-bucket-1" {
  source = "../modules/s3"
  bucket_name = "${var.bucket_One_name}"
}

# Bucket 2
module "devops-training-us-easat-1-bucket-2" {
  source = "../modules/s3"
  bucket_name = "${var.bucket_Two_name}"
}