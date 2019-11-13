#----10_VPC_IGW/outputs.tf----

output "vpc-id" {
  value = "${aws_vpc.tf-vpc.id}"
}

output "igw-id" {
  value = "${aws_internet_gateway.tf-internet-gateway.id}"
}
