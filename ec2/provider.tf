provider "aws" {
    region  = var.region
    #version = "~> 2.0"
    #shared_credentials_file = "%USERPROFILE%/.aws/credentials"
    profile = "ronnie"
}


provider "kubernetes" {
  load_config_file       = "false"
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

resource "kubernetes_service_account" "kandula_sa" {
  metadata {
    name      = local.k8s_service_account_name
    namespace = local.k8s_service_account_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_assumable_role_admin.this_iam_role_arn
    }
  }
  depends_on = [module.eks]
}
