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
variable "public-subnet-ids" {}
variable "public-lb-id" {}
#-------------data section--------------------------

#-------------control section-----------------------
resource "aws_launch_configuration" "web-lc" {
  name = "oouve-web-lc"
  image_id = var.web-ami
  instance_type = var.web-instance-type
}

resource "aws_autoscaling_group" "web-asg" {
  launch_configuration = "${aws_launch_configuration.web-lc.id}"
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 3
  force_delete              = true
  max_size = 5
  min_size = 2
  vpc_zone_identifier = var.public-subnet-ids 
}

resource "aws_autoscaling_policy" "web-scale-up" {
  name = "oouve-web-scale-up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.web-asg.name}"
}

resource "aws_autoscaling_policy" "web-scale-down" {
  name = "oouve-web-scale-down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.web-asg.name}"
}
#-------------output section------------------------
output "web-lc" {
  value = "${aws_launch_configuration.web-lc.id}"
}
output "web-asg-id" {
  value = "${aws_autoscaling_group.web-asg.id}"
}