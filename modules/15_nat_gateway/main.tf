#-----------------------15_nat_gateway/main.tf---------------------------
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
#variable "vpc-id" {}
 variable "public-subnet-ids" {}

#-------------data section--------------------------

#-------------control section-----------------------
resource "aws_eip" "oouve-nat-ip" {
  count    = "${length(var.public-subnet-ids)}"
  vpc      = true

  tags = {
    "Name" = "oouve-nat-eip"
  }
}

resource "aws_nat_gateway" "oouve-nat-gateway" {
  count          = "${length(var.public-subnet-ids)}"
  allocation_id  = "${aws_eip.oouve-nat-ip.*.id[count.index]}"  
  subnet_id      = "${var.public-subnet-ids[count.index]}"    

  depends_on = [
    aws_eip.oouve-nat-ip,
  ]
  
  tags = {
    Name = "oouve-nat-gateway"
  }
}

#-------------output section------------------------
output "public-nat-ids" {
  value = "${aws_nat_gateway.oouve-nat-gateway.*.id}"
}

output "public-eip-ids" {
  value = "${aws_eip.oouve-nat-ip.*.id}"
}