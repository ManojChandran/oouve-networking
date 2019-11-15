#----root/variables.tf----

variable "aws-region" {
  description = "stored aws region data"
}

variable "env" {
  description = "env: prod or test or dev"
}

variable "vpc-cidr" {
  description = "stores ip cidr for the VPC"
}
variable "vpc-id" {
  description = "store vpc id"
}
variable "igw-id" {
  description = "stores igw id"
}
variable "vpc-public-cidrs" {
  description = "stores list of public subnet IP's"
  type        = "list"
}
variable "default-route-table-id" {
  description = "stores default route table of VPC"
}
variable "vpc-private-cidrs" {
  description = "stores list of private subnet IP's"
  type        = "list"
}
