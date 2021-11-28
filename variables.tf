#-----------------------------root/variables.tf-----------------------------
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#--------------------------------------------------------------------------
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
variable "default-route-table-id" {
  description = "stores default route table of VPC"
  default = " "
}
variable "vpc-public-cidrs" {
  description = "stores list of public subnet IP's"
  type        = list(string)
  default = ["10.0.0.0/24", "10.0.0.10/24"]
}
variable "vpc-private-cidrs" {
  description = "stores list of private subnet IP's"
  type        = list(string)
  default = ["10.0.0.20/24", "10.0.0.30/24"]
}
variable "vpc-db-cidrs" {
  description = "stores list of database subnet IP's"
  type        = list(string)
  default = ["10.0.0.40/24", "10.0.0.60/24"]

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

variable "domain-name" {
  description = "store public domain name you purchased"
  default = "oouve.com"
}