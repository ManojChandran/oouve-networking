#------------------------------root/main.tf-------------------------------
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

terraform {
# To prevent automatic upgrades to new major versions 
# that may contain breaking changes
#--------------------------------------------------------------------------
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
## Stores the state file back up in s3 bucket
## interpolations cannot be used becasue the actvity is done initial stage
## need to create s3 bucket and folder prior to using the backend
#--------------------------------------------------------------------------
#  backend "s3" {
#    bucket = "myterraformstatebackupfile0002"
#    key    = "terraform/terraform.tfstate"
#    region = "us-east-1"
#  }
}

provider "aws" {
  region = "${var.aws-region}"
}


# Deploy VPC and attach IGW
module "vpc-igw" {
  source   = "./modules/10_VPC_IGW"
  vpc-cidr = "${var.vpc-cidr}"
}

# Deploy public subnet
module "public-subnet" {
  source           = "./modules/11_public_subnet"
  vpc-id           = "${module.vpc-igw.vpc-id}"
  igw-id           = "${module.vpc-igw.igw-id}"
  vpc-public-cidrs = "${var.vpc-public-cidrs}"
  default-route-table-id = "${module.vpc-igw.default-route-table-id}"
}

# Deploy private subnet
module "private-subnet" {
  source                 = "./modules/12_private_subnet"
  vpc-id                 = "${module.vpc-igw.vpc-id}"
  vpc-private-cidrs      = "${var.vpc-private-cidrs}"
  default-route-table-id = "${module.vpc-igw.default-route-table-id}"
}

## Deploy security groups
module "security-group" {
  source          = "./modules/13_security_groups"
  vpc-id          = "${module.vpc-igw.vpc-id}"
}

# Deploy VPC flow logs
module "vpc-flow-logs" {
  source = "./modules/14_vpc_flow_logs"
  vpc-id = "${module.vpc-igw.vpc-id}"
}

# Deploy Nat gateway
module "nat-gateway"{
  source            = "./modules/15_nat_gateway"
  public-subnet-ids = "${module.public-subnet.public-subnet-ids}"
}

# Deploy NACL 
module "network-acl"{
  source            = "./modules/16_network_acl"
  vpc-id            = "${module.vpc-igw.vpc-id}"
}

# Deploy LB public
module "lb-public" {
  source            = "./modules/17_lb_public"  
  public-subnet-ids = "${module.public-subnet.public-subnet-ids}"
  sg-public-lb-id   = "${module.security-group.security-group-lb-pub}"
}

# Deploy LB private
module "lb-private" {
  source             = "./modules/18_lb_private"  
  private-subnet-ids = "${module.private-subnet.private-subnet-ids}"
  sg-private-lb-id    = "${module.security-group.security-group-lb-pvt}"
}