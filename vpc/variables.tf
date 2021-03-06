# This file contains variables for the VPC module #


variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
    default = "10.10.0.0/16"
}

variable "private_subnets" {
    type = list(string)
    default = ["10.10.10.0/24", "10.10.11.0/24", "10.10.12.0/24"]
}

variable "public_subnets" {
    type = list(string)
    default = ["10.10.100.0/24", "10.10.110.0/24", "10.10.120.0/24"]
}

variable "environment_tag" {
    default = "kandula-prod"
}

variable "ubuntu_account_number" {
  default = "099720109477"
}
