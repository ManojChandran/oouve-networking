#----root/outputs.tf----

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
