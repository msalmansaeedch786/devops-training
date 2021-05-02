#This file creates AWS S3 bucket variables that are being referred in main script

variable "bucket_name" {
  type = "string"
}

variable "acl" {
  default = "private"
}
