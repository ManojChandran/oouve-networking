#-----------------------20_route_53/main.tf---------------------------
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
# variable "vpc-id" {}
variable "domain-name" {}

#-------------data section--------------------------
# get availability zone from specified AWS region

#-------------control section-----------------------
resource "aws_route53_zone" "oouve-zone" {
  name = "${var.domain-name}"

  tags = {
    Environment = "oouve-zone"
  }
}

#resource "aws_route53_record" "dev-ns" {
#  zone_id = aws_route53_zone.main.zone_id
#  name    = "example.com"
#  type    = "NS"
#  ttl     = "30"
#}

#-------------output section------------------------
output "zone-id" {
  value = "${aws_route53_zone.oouve-zone.zone_id}"
}
