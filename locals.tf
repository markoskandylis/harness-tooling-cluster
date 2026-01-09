locals {
  # Cluster Configuration
  cluster_name    = var.cluster_name
  cluster_info    = module.eks
  enable_automode = var.enable_automode
  region          = var.region
  cluster_version = var.kubernetes_version
  # delegate configuration
  scope      = lower(var.delegate_scope)
  account_id = local.scope == "account" ? var.harness_account_id : ""
  org_id     = local.scope == "org" ? var.harness_org_id : ""
  project_id = local.scope == "project" ? var.harness_project_id : ""

  tags = {
    Blueprint  = local.cluster_name
    GithubRepo = "github.com/gitops-bridge-dev/gitops-bridge"
  }
}


# Create a local variable where i define the delegate scope account, org, project
