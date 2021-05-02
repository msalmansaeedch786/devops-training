# variables.tf
variable "region" {
        default = "us-east-1"
}
variable "InstanceTenancy" {
        default = "default"
}
variable "DnsSupport" {
        default = true
}
variable "DnsHostNames" {
        default = true
}
variable "AvailabilityZoneOne" {
        default = "us-east-1a"
}
variable "AvailabilityZoneTwo" {
        default = "us-east-1b"
}
variable "VpcCidrBlock" {
        default = "10.0.0.0/16"
}
variable "PublicSubnetOneCidrBlock" {
        default = "10.0.1.0/24"
}
variable "PublicSubnetTwoCidrBlock" {
        default = "10.0.2.0/24"
}
variable "PrivateSubnetOneCidrBlock" {
        default = "10.0.3.0/24"
}
variable "PrivateSubnetTwoCidrBlock" {
        default = "10.0.4.0/24"
}
variable "MapPublicIP" {
        default = true
}
variable "bucket_One_name" {}
variable "bucket_Two_name" {}
# end of variables.tf