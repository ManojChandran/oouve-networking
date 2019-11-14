#----root/variables.tf----

variable "aws-region" {
  description = "stored aws region data"
  default = "us-east-1"
}

variable "vpc-cidr" {
  description = "stores ip cidr for the VPC"
  default = "10.23.0.0/16"
}
