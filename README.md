# AWS 3 Tier VPC network

This repository is a HCL code for implemenatation of three tier VPC network. Terraform version details are mentioned below in the istallation section.


> This repository tries to follow the checklist items formulated by gruntworks to have a production ready infrastructure, reference provided at the end.

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
$ export AWS_ACCESS_KEY_ID=YOUR_AKID</br>
$ export AWS_SECRET_ACCESS_KEY=YOUR_SECRET_KEY</br>
$ export AWS_SESSION_TOKEN=TOKEN</br>
$ export AWS_REGION=us-east-1</br>
```

Windows

```
C:\> set AWS_ACCESS_KEY_ID=YOUR_AKID</br>
C:\> set AWS_SECRET_ACCESS_KEY=YOUR_SECRET_KEY</br>
C:\> set AWS_SESSION_TOKEN=TOKEN</br>
C:\> set AWS_REGION=us-east-1</br>
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

# Checklist of items to have production ready Networking
## Set up VPCs
Don't use the Default VPC, as everything in it is publicly accessible by default. Instead, create one or more custom Virtual Private Clouds (VPC), each with their own IP address range (see VPC and subnet sizing), and deploy all of your apps into those VPCs.

## Set up subnets
Create three "tiers" of subnets in each VPC: public, private-app, private-persistence. The public subnets are directly accessible from the public Internet and should only be used for a small number of highly locked down, user-facing services, such as load balancers and Bastion Hosts. The private-apps subnets are only accessible from within the VPC from the public subnets and should be used to run your apps (Auto Scaling Groups, Docker containers, etc.). The private-persistence subnets are also only accessible from within the VPC from the private-app subnets (but NOT the public subnets) and should be used to run all your data stores (RDS, ElastiCache, etc.). See A Reference VPC Architecture.

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
