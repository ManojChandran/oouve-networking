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
    ami           = "ami-04505e74c0741db8d"
    instance_type = "t3.micro"
    key_name 		= "demo-key"
    provisioner "remote-exec" {
      inline = [
        "sudo apt-get update",
        "sudo apt-get install apache2 -y",
        "sudo systemctl start apache2",
      ]
  
    }
    connection {
      type     = "ssh"
      user     = "ubuntu"
#      private_key = file("demokey.pem")
      host     = "${self.public_ip}"
    }
  
    tags = {
      Name = "oouve-web-server"
    }    
}