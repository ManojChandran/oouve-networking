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
#variable "vpc-db-cidrs" {}

#-------------data section--------------------------
# get availability zone from specified AWS region
#data "aws_availability_zones" "available" {}

#-------------control section-----------------------
resource "aws_security_group" "web-sg" {
  name        = "webserver-sg"
  description = "Security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}
# create Security group for load balancer
resource "aws_security_group" "oouve-sg-lb-pub" {
  name        = "oouve-sg-lb-pub"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${var.vpc-id}"

#  ingress {
#  }
#
#  egress {
#  }

  tags = {
    Name = "oouve-sg-lb-pub"
  }
}

# create Security group for private load balancer
resource "aws_security_group" "oouve-sg-lb-pvt" {
  name        = "oouve-sg-lb-pvt"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${var.vpc-id}"

#  ingress {
#  }
#
#  egress {
#  }

  tags = {
    Name = "oouve-sg-lb-pvt"
  }
}

# create Security group for public server
resource "aws_security_group" "oouve-sg-pub" {
  name        = "oouve-sg-pub"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${var.vpc-id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "oouve-sg-pub"
  }
}

# create Security group for private server
resource "aws_security_group" "oouve-sg-pvt" {
  name        = "oouve-sg-pvt"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${var.vpc-id}"

#  ingress {
#  }
#
#  egress {
#  }

  tags = {
    Name = "oouve-sg-pvt"
  }
}

# create Security group for public server
resource "aws_security_group" "oouve-sg-db" {
  name        = "oouve-sg-db"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${var.vpc-id}"

#  ingress {
#  }
#
#  egress {
#  }

  tags = {
    Name = "oouve-sg-db"
  }
}
#-------------output section------------------------

output "security-group-lb-pub" {
  value = "${aws_security_group.oouve-sg-lb-pub.id}"
}
output "security-group-lb-pvt" {
  value = "${aws_security_group.oouve-sg-lb-pvt.id}"
}
output "security-group-pub" {
  value = "${aws_security_group.oouve-sg-pub.id}"
}
output "security-group-pvt" {
  value = "${aws_security_group.oouve-sg-pvt.id}"
}
output "security-group-db" {
  value = "${aws_security_group.oouve-sg-db.id}"
}

