#----10_VPC_IGW/main.tf----

# create AWS VPC with specific CIDR
resource "aws_vpc" "tf-vpc" {
  cidr_block           = "${var.vpc-cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    name = "tf-vpc"
  }
}

# create and attach Internet Gateway
resource "aws_internet_gateway" "tf-internet-gateway" {
  vpc_id = "${aws_vpc.tf-vpc.id}"

  tags = {
    Name = "tf-internet-gateway"
  }
}
