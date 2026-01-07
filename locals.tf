locals {
  cluster_name            = var.cluster_name
  cluster_info            = module.eks
  enable_automode         = var.enable_automode
  region                  = data.aws_region.current.id
  cluster_version         = var.kubernetes_version

  tags = {
    Blueprint  = local.cluster_name
    GithubRepo = "github.com/gitops-bridge-dev/gitops-bridge"
  }
}


