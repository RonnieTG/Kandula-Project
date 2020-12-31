# This file contains variables for the EC2 module #


provider "aws" {
    region  = var.region
    profile = "ronnie"
}

variable "ubuntu_account_number" {
  default = "099720109477"
}

variable "environment_tag" {
    default = "Kandula-PROD"
}