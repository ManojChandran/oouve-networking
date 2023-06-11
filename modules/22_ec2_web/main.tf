#-----------------------22_ec2_web/main.tf---------------------------
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
variable "public-subnet-ids" {}
variable "web-ami" {}
variable "web-instance-type" {}

#-------------data section--------------------------
# get availability zone from specified AWS region
data "aws_availability_zones" "available" {}

#-------------control section-----------------------
resource "random_shuffle" "web_az" {
    input = "${var.public-subnet-ids}"
    result_count = 1
    count = 10
}

resource "aws_instance" "web" {
    ami           = "${var.web-ami}"
    instance_type = "${var.web-instance-type}"
    key_name 		= "demo-key"
  
    tags = {
      Name = "oouve-web-server"
    }    
}