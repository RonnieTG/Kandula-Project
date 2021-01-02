# This file contains variables for the EC2 module #


variable "region" {
  default = "us-east-1"
}

variable "ubuntu_account_number" {
  default = "099720109477"
}

variable "environment_tag" {
    default = "Kandula-PROD"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "key_name" {
  default = "Ronnie-US-key-pair"
}

#variable "ebs_block_device" {
#  default = {
#    device_name = "/dev/sdb"
#    volume_size = "10"
#    volume_type = "standard"
#    encrypted   = true
#  }
#}
