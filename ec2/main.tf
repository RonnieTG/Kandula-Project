# This file contains all modules # 


module "vpc" {
    source = "../vpc/"
}

#module "ekscluster" {
#    source = "../ekscluster/"
#}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "13.2.1"
  cluster_name    = local.cluster_name
  cluster_version = var.kubernetes_version
  subnets         = module.vpc.private_subnet
  enable_irsa = true
  
  tags = {
    Environment = "prod"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = module.vpc.vpc_cidr

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.micro"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      additional_security_group_ids = [module.vpc.aws_security_group_all_worker_mgmt]
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t2.micro"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      additional_security_group_ids = [module.vpc.aws_security_group_all_worker_mgmt]
    }
  ]
}

