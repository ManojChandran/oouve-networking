#----root/variables.tf----

variable "aws-region" {
  description = "stored aws region data(N. Virginia)"
  default = "us-east-1"
}

#variable "env" {
#  description = "env: prod or test or dev"
#}

variable "vpc-cidr" {
  description = "stores ip cidr for the VPC"
  default = "10.0.0.0/26"
}
variable "vpc-id" {
  description = "store vpc id"
  default = "myvpc"
}
variable "igw-id" {
  description = "stores igw id"
  default = "myigw"
}
variable "vpc-public-cidrs" {
  description = "stores list of public subnet IP's"
  type        = list(string)
  default = ["10.0.0.0/28"]
}
variable "default-route-table-id" {
  description = "stores default route table of VPC"
}
variable "vpc-private-cidrs" {
  description = "stores list of private subnet IP's"
  type        = list(string)
  default = ["10.0.0.16/28"]
}
variable "vpc-db-cidrs" {
  description = "stores list of database subnet IP's"
  type        = list(string)
  default = ["10.0.0.32/28"]
}
