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
  required_version = ">= 0.12"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 2.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">=1.13.3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.28.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 1.2"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 2.1"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.1"
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_ami" "ubuntu-18" {
  most_recent      = true
  owners           = [var.ubuntu_account_number]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}
