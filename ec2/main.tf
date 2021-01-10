module "VPC" {
    source = "../VPC/"
}

#module "ekscluster" {
#    source = "../ekscluster/"
#}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "13.2.1"
  cluster_name    = local.cluster_name
  cluster_version = var.kubernetes_version
  subnets         = module.VPC.private_subnet
  enable_irsa = true
  
  tags = {
    Environment = "prod"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = module.VPC.vpc_cidr

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t3.medium"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      additional_security_group_ids = [module.VPC.aws_security_group_all_worker_mgmt]
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t3.large"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      additional_security_group_ids = [module.VPC.aws_security_group_all_worker_mgmt]
    }
  ]
}