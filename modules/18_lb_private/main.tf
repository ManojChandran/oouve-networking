#-----------------------18_lb_private/main.tf---------------------------
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
variable "private-subnet-ids" {}
variable "sg-private-lb-id" {}

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

resource "aws_lb" "oouve-pvt-lb" {
  name               = "oouve-pvt-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.sg-private-lb-id}"]
  subnets            = "${var.private-subnet-ids}"
  enable_deletion_protection = false

#  access_logs {
#    bucket  = aws_s3_bucket.oouve-lb-logs.bucket
#    prefix  = "oouve-pvt-lb"
#    enabled = true
#  }
#
#  depends_on = [
#    aws_s3_bucket.oouve-lb-logs,
#  ]

  tags = {
    Environment = "oouve-pvt-lb"
  }
}
#-------------output section------------------------
output "private-lb-id" {
  value = "${aws_lb.oouve-pvt-lb.id}"
}