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
  default = ["10.0.0.0/28", "10.0.0.32/28"]
}
variable "default-route-table-id" {
  description = "stores default route table of VPC"
  default = " "
}
variable "vpc-private-cidrs" {
  description = "stores list of private subnet IP's"
  type        = list(string)
  default = ["10.0.0.16/28", "10.0.0.48/28"]
}
variable "vpc-db-cidrs" {
  description = "stores list of database subnet IP's"
  type        = list(string)
  default = ["10.0.0.32/28"]
}

variable "public-subnet-ids" {
  description = "stores list of subnet ids"
  type        = list(string)
  default     = []
}

variable "private-subnet-ids" {
  description = "stores list of subnet ids"
  type        = list(string)
  default     = []
}

variable "public-eip-ids" {
  description = "stores list of nat ips"
  type        = list(string)
  default     = []
}

variable "sg-public-lb-id" {
  description = "stores security group id"
  default = " "
}

variable "sg-private-lb-id" {
  description = "stores security group id"
  default = " "
}

variable "sg-public-subnet-id" {
  description = "stores security group id"
  default = " "
}

variable "sg-private-subnet-id" {
  description = "stores security group id"
  default = " "
}

variable "sg-database-id" {
  description = "stores security group id"
  default = " "
}