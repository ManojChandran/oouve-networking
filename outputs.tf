#------------------------------root/outputs.tf-----------------------------
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

output "VPC-id" {
  value = "${module.vpc-igw.vpc-id}"
}

output "IGW-id" {
  value = "${module.vpc-igw.igw-id}"
}

output "Default-route-table" {
  value = "${module.vpc-igw.default-route-table-id}"
}

output "Public-Subnet-IDs" {
  value = "${join(", ", module.public-subnet.public-subnet-ids)}"
}

output "Private-Subnet-IDs" {
  value = "${join(", ", module.private-subnet.private-subnet-ids)}"
}

#output "database-Subnet-IDs" {
#  value = "${join(", ", module.db-subnet.database-subnet-ids)}"
#}
#
output "Private-route-table" {
  value = "${module.private-subnet.private-route-table}"
}

output "Public-route-table" {
  value = "${module.public-subnet.public-route-table}"
}

output "VPC-flowlogs-id" {
  value = "${module.vpc-flow-logs.flowlogs-id}"
}

output "Public-nat-IDs" {
  value = "${join(", ", module.nat-gateway.public-nat-ids)}"
}

output "Public-lb-id" {
  value = "${module.lb-public.public-lb-id}"
}

output "Private-lb-id" {
  value = "${module.lb-private.private-lb-id}"
}
#output "Public-nat-eips" {
#  value = "${join(", ", module.nat-eip.public-eip-ids)}"
#}

output "Default-nacl" {
  value = "${module.network-acl.example}"
}

output "security-group-lb-pub" {
  value = "${module.security-group.security-group-lb-pub}"
}

output "security-group-lb-pvt" {
  value = "${module.security-group.security-group-lb-pvt}"
}

output "security-group-pub" {
  value = "${module.security-group.security-group-pub}"
}

output "security-group-pvt" {
  value = "${module.security-group.security-group-pvt}"
}

output "security-group-db" {
  value = "${module.security-group.security-group-db}"
}