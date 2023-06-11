#-----------------------21_asg/main.tf---------------------------
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
variable "web-ami" {}
variable "web-instance-type" {}
#-------------data section--------------------------

#-------------control section-----------------------
resource "aws_launch_configuration" "web-lc" {
  name = "oouve-web-lc"
  image_id = var.web-ami
  instance_type = var.web-instance-type
}

resource "aws_autoscaling_group" "web-asg" {
  launch_configuration = "${aws_launch_configuration.web-lc.id}"
  max_size = 5
  min_size = 2  
}
#-------------output section------------------------
output "web-lc" {
  value = "${aws_launch_configuration.web-lc.id}"
}