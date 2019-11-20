#--------------------------15_nacl/main.tf--------------------------------
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
variable "vpc-cidr" {}

#-------------data section--------------------------

#-------------control section-----------------------
resource "aws_network_acl" "oouve-nacl" {
  vpc_id  = "${var.vpc-id}"

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "${var.vpc-cidr}"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.vpc-cidr}"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "oouve-nacl"
  }
}
#-------------output section------------------------
