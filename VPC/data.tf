# This file contains information about Terraform and AWS # 


data "aws_availability_zones" "available" {
  state = "available"
}


terraform {
  backend "s3" {
    bucket = "kandula-prod-remote-state"
    key    = "kandula/terraform.tfstate"
    region = "us-east-1"
  }
}


data "aws_ami" "ubuntu-18" {
  most_recent      = true
  owners           = [var.ubuntu_account_number]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}