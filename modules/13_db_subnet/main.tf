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
variable "vpc-db-cidrs" {}

#-------------data section--------------------------
# get availability zone from specified AWS region
data "aws_availability_zones" "available" {}

#-------------control section-----------------------
# create databe subnet
resource "aws_subnet" "oouve-db-subnet" {
  count             = "${length(var.vpc-db-cidrs)}"
  vpc_id            = "${var.vpc-id}"
  cidr_block        = "${var.vpc-db-cidrs[count.index]}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  tags = {
    Name = "oouve-db-subnet{count.index +1}"
  }
}

#-------------output section------------------------

output "database-subnet-ids" {
  value = "${aws_subnet.oouve-db-subnet.*.id}"
}
output "database-subnets" {
  value = "${aws_subnet.oouve-db-subnet.*.cidr_block}"
}
