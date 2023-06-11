# AWS 3 Tier VPC network

This repository is a HCL code for implemenatation of three tier VPC network. Terraform version details are mentioned below in the istallation section.

![Design](./images/Architecture_layout.png?raw=true "Title")</br>


# RUN Terraform

## Instalation  

Follow the commands to complete Terraform installation for ubuntu:
```
$ sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
$ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
$ sudo apt-get update && sudo apt-get install terraform
```
> Check reference below for additional insatllation information.

Verify installation by version check: 

```
$ terraform --version
Terraform v0.15.3
on linux_amd64
+ provider registry.terraform.io/hashicorp/aws v3.42.0
```

## Set AWS account

By default, Terraform can detects AWS credentials set in our environment and uses them to sign requests to AWS. That way we don't need to manage credentials in your applications. The set your credentials in the following environment variables:

AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY /AWS_SESSION_TOKEN (optional)

The following examples show how you configure the environment variables.

Linux, OS X, or Unix

```
$ export AWS_ACCESS_KEY_ID=YOUR_AKID
$ export AWS_SECRET_ACCESS_KEY=YOUR_SECRET_KEY
$ export AWS_SESSION_TOKEN=TOKEN
$ export AWS_REGION=us-east-1
```

Windows

```
C:\> set AWS_ACCESS_KEY_ID=YOUR_AKID
C:\> set AWS_SECRET_ACCESS_KEY=YOUR_SECRET_KEY
C:\> set AWS_SESSION_TOKEN=TOKEN
C:\> set AWS_REGION=us-east-1
```
## CLONE 

clone the repo, using git command.
```
$ git clone https://github.com/ManojChandran/oouve-networking.git
```

## Run
Navigate in to our project directory, follow the below commands.
```
$ terraform init
$ terrafrom plan 
$ terraform apply
```
> Refer "variable.tf" file in root directory for default values of VPC.

# Configuring your infrastructure

## Set up VPCs
Don't use the Default VPC, as everything in it is publicly accessible by default. Instead, create one or more custom Virtual Private Clouds (VPC), each with their own IP address range (see VPC and subnet sizing), and deploy all of your apps into those VPCs.

## Set up subnets
Create three "tiers" of subnets in each VPC: public, private-app, private-persistence. The public subnets are directly accessible from the public Internet and should only be used for a small number of highly locked down, user-facing services, such as load balancers and Bastion Hosts. The private-apps subnets are only accessible from within the VPC from the public subnets and should be used to run your apps (Auto Scaling Groups, Docker containers, etc.). The private-persistence subnets are also only accessible from within the VPC from the private-app subnets (but NOT the public subnets) and should be used to run all your data stores (RDS, ElastiCache, etc.). See A Reference VPC Architecture.

### Set your CIDR
CIDR (Classless Inter-Domain Routing) notation is used to represent and manage IP address blocks more efficiently. 
To accommodate 200+ IP addresses and create 6 subnets in an AWS VPC (Virtual Private Cloud), we can use the following CIDR notation and IP range configuration:

Determine the required number of IP addresses: Let's assume you need a minimum of 200 IP addresses. To calculate the number of IP addresses required, you can use the formula 2^(32 - n) - 2, where 'n' represents the number of bits borrowed from the original CIDR block for subnetting. In this case, we'll start with 'n' as 8 to create 6 subnets.

Determine the subnet mask and CIDR notation: Since we need 6 subnets, we'll borrow 3 bits (2^3 = 8) from the original CIDR block. The subnet mask for the subnets will be 255.255.255.224 (/27 CIDR notation) to accommodate 32 IP addresses per subnet (30 usable IPs per subnet).

Calculate the IP ranges for each subnet: Starting with the base CIDR block, which we'll assume as 10.0.0.0/24, we'll divide it into 6 subnets with the /27 subnet mask:

Subnet 1: 10.0.0.0/27 (IP Range: 10.0.0.0 - 10.0.0.31) </br>
Subnet 2: 10.0.0.32/27 (IP Range: 10.0.0.32 - 10.0.0.63)</br>
Subnet 3: 10.0.0.64/27 (IP Range: 10.0.0.64 - 10.0.0.95)</br>
Subnet 4: 10.0.0.96/27 (IP Range: 10.0.0.96 - 10.0.0.127)</br>
Subnet 5: 10.0.0.128/27 (IP Range: 10.0.0.128 - 10.0.0.159)</br>
Subnet 6: 10.0.0.160/27 (IP Range: 10.0.0.160 - 10.0.0.191)</br>
Allocate the IP ranges to your VPC subnets: In the AWS VPC management console, you can create 6 subnets with the specified CIDR blocks and assign them to your desired availability zones.

Open "variables.tf" and update CIDR.
```go
variable "vpc-cidr" {
  description = "stores ip cidr for the VPC"
  default = "10.0.0.0/24"
}
variable "vpc-public-cidrs" {
  description = "stores list of public subnet IP's"
  type        = list(string)
  default = ["10.0.0.0/27", "10.0.0.32/27"]
}
variable "vpc-private-cidrs" {
  description = "stores list of private subnet IP's"
  type        = list(string)
  default = ["10.0.0.64/27", "10.0.0.96/27"]
}
variable "vpc-db-cidrs" {
  description = "stores list of database subnet IP's"
  type        = list(string)
  default = ["10.0.0.128/27", "10.0.0.160/27"]
}
```
## Set your Domain

Open "variables.tf" and update domain.
```go
variable "domain-name" {
  description = "store public domain name you purchased"
  default = "oouve.com"
}
```

## Configure Network ACLs
Create Network Access Control Lists (NACLs) to control what traffic can go between different subnets. We recommend allowing the public subnets to receive traffic from anywhere, the private-app subnets to only receive traffic from the public subnets, and the private-persistence subnets to only receive traffic from the private-app subnets.

## Configure Security Groups
Every AWS resource (e.g., EC2 Instances, Load Balancers, RDS DBs, etc.) has a Security Group that acts as a firewall, controlling what traffic is allowed in and out of that resource. By default, no traffic is allowed in or out. Follow the Principle of Least Privilege and open up the absolute minimum number of ports you can for each resource. When opening up a port, you can also specify either the CIDR block (IP address range) or ID of another Security Group that is allowed to access that port. Reduce these to solely trusted servers where possible. For example, EC2 Instances should only allow SSH access (port 22) from the Security Group of a single, locked-down, trusted server (the Bastion Host).

## Configure Static IPs
By default, all AWS resources (e.g., EC2 Instances, Load Balancers, RDS DBs, etc.) have dynamic IP addresses that could change over time (e.g., after a redeploy). When possible, use Service Discovery to find the IPs of services you depend on. If that's not possible, you can create static IP addresses that can be attached and detached from resources using Elastic IP Addresses (EIPs) for public IPs or Elastic Network Interfaces (ENIs) for private IPs.

## Configure DNS using Route 53
Manage DNS entries using Route 53. You can buy public domain names using the Route 53 Registrar or create custom private domain names, accessible only from within your VPC, using Route 53 Private Hosted Zones.

# Reference

Link 1 : https://www.gruntwork.io/devops-checklist/</br>
Link 2 : https://learn.hashicorp.com/tutorials/terraform/install-cli</br>
Link 3 : https://cidr.xyz/</br>
