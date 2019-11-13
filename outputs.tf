#----root/outputs.tf----

output "VPC-id" {
  value = "${module.vpc-igw.vpc-id}"
}

output "IGW-id" {
  value = "${module.vpc-igw.igw-id}"
}
