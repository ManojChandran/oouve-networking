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
variable "sg-public-id" {}
variable "public-lb-id" {}
variable "pub-target-grp" {}
#-------------data section--------------------------

#-------------control section-----------------------

resource "aws_launch_template" "web-tf" {
  name = "oouve-web-tf"
  image_id = var.web-ami
  instance_type = var.web-instance-type 
  vpc_security_group_ids = [var.sg-public-id] 

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  tags = {
    Name = "oouve-web-server"
  }
}

resource "aws_autoscaling_group" "web-asg" {
  launch_template{
    id = "${aws_launch_template.web-tf.id}"
  }
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 3
  force_delete              = true
  max_size = 5
  min_size = 2
  vpc_zone_identifier = var.public-subnet-ids 

  tag {
    key                 = "Name"
    value               = "oouve-web-server"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "web-scale-up" {
  name = "oouve-web-scale-up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.web-asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "web-scale-up-alarm" {
  alarm_name                = "oouve-web-scale-up-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web-asg.name
  }

  alarm_actions     = [aws_autoscaling_policy.web-scale-up.arn]
}

resource "aws_autoscaling_policy" "web-scale-down" {
  name = "oouve-web-scale-down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.web-asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "web-scale-down-alarm" {
  alarm_name                = "terraform-test-foobar5"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 5
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 30
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web-asg.name
  }

  alarm_actions     = [aws_autoscaling_policy.web-scale-down.arn]
}

resource "aws_autoscaling_attachment" "oouve-web-attach" {
  autoscaling_group_name = aws_autoscaling_group.web-asg.id
  lb_target_group_arn = var.pub-target-grp
}
#-------------output section------------------------
output "web-lc" {
  value = "${aws_launch_template.web-tf.id}"
}
output "web-asg-id" {
  value = "${aws_autoscaling_group.web-asg.id}"
}