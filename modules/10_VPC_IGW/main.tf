#------------------------------10_VPC_IGW/main.tf---------------------------
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
#-------------variable section--------------------
variable "vpc-cidr" {}

#-------------control section-----------------------
# create AWS VPC with specific CIDR
resource "aws_vpc" "tf-vpc" {
  cidr_block           = "${var.vpc-cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    name = "tf-vpc"
  }
}

# create and attach Internet Gateway
resource "aws_internet_gateway" "tf-internet-gateway" {
  vpc_id = "${aws_vpc.tf-vpc.id}"

  tags = {
    Name = "tf-internet-gateway"
  }
}

#-------------output section------------------------
output "vpc-id" {
  value = "${aws_vpc.tf-vpc.id}"
}

output "igw-id" {
  value = "${aws_internet_gateway.tf-internet-gateway.id}"
}
