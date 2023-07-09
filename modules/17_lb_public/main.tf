#-----------------------17_lb_public/main.tf---------------------------
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
variable "public-subnet-ids" {}
variable "sg-public-lb-id" {}

#-------------data section--------------------------

#-------------control section-----------------------
#resource "aws_s3_bucket" "oouve-lb-logs" {
#  bucket = "myterraformstatebackupfile0002"
#  acl    = "private"
#
#  tags = {
#    Name        = "oouve-lb-logs"
#  }
#}

resource "aws_lb" "oouve-pub-lb" {
  name               = "oouve-pub-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.sg-public-lb-id}"]
  subnets            = "${var.public-subnet-ids}"
  enable_deletion_protection = false

#  access_logs {
#    bucket  = aws_s3_bucket.oouve-lb-logs.bucket
#    prefix  = "oouve-pub-lb"
#    enabled = true
#  }
#
#  depends_on = [
#    aws_s3_bucket.oouve-lb-logs,
#  ]

  tags = {
    Environment = "oouve-pub-lb"
  }
}

resource "aws_lb_target_group" "pub-target-grp" {
  name        = "oouve-pub-target-grp"
  port        = 9000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = "${var.vpc-id}"

  stickiness {
    type            = "lb_cookie"
    cookie_duration =  1800
    enabled         = false
  }

  health_check{
    interval     = 30
    path         = "/"
    port         = 9000
    healthy_threshold =  5
    unhealthy_threshold = 2
    timeout = 5
    protocol = "HTTP"
    matcher = "200,202"
  }

  tags = {
    Environment = "oouve-pub-trgget"
  }

}

#resource "aws_lb_listener" "oouve-https-listner" {
#  load_balancer_arn = aws_lb.oouve-pub-lb.arn
#  port = "443"
#  protocol = "HTTPS"
#  certificate_arn = ""
#
#  default_action {
#    type = "forward"
#    target_group_arn = aws_lb_target_group.pub-target-grp.arn
#  }
#}

resource "aws_lb_listener" "oouve-http-listner" {
  load_balancer_arn = aws_lb.oouve-pub-lb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.pub-target-grp.arn
  }
#  default_action {
#    type = "redirect"
#    redirect {
#      port = "443"
#      protocol = "HTTPS"
#      status_code = "HTTP_301"
#    }
#  }
}
#-------------output section------------------------
output "public-lb-id" {
  value = "${aws_lb.oouve-pub-lb.id}"
}
output "public-lb-trget-grp" {
  value = "${aws_lb_target_group.pub-target-grp.arn}"
}