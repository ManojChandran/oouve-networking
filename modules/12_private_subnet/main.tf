#-----------------------12_private_subnet/main.tf---------------------------
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
#-------------variable section----------------------
variable "vpc-id" {}
variable "vpc-private-cidrs" {}
variable "default-route-table-id" {}

#-------------data section--------------------------
# get availability zone from specified AWS region
data "aws_availability_zones" "available" {}

#-------------control section-----------------------
# Private route table
resource "aws_default_route_table" "oouve-pvt-route-table" {
  default_route_table_id = "${var.default-route-table-id}"
}

# create private subnet
resource "aws_subnet" "oouve-pvt-subnet" {
  count                   = "${length(var.vpc-private-cidrs)}"
  vpc_id                  = "${var.vpc-id}"
  cidr_block              = "${var.vpc-private-cidrs[count.index]}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name = "oouve-pvt-subnet{count.index +1}"
  }
}

# Associating private subnet route table
resource "aws_route_table_association" "oouve-pvt-subnet-association" {
  count          = "${length(var.vpc-private-cidrs)}"
  subnet_id      = "${aws_subnet.oouve-pvt-subnet.*.id[count.index]}"
  route_table_id = "${aws_default_route_table.oouve-pvt-route-table.id}"

}
#-------------output section------------------------

output "private-subnet-ids" {
  value = "${aws_subnet.oouve-pvt-subnet.*.id}"
}
output "private-route-table" {
  value = "${aws_default_route_table.oouve-pvt-route-table.id}"
}
output "private-subets" {
  value = "${aws_subnet.oouve-pvt-subnet.*.cidr_block}"
}
