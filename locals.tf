locals {
  # Cluster Configuration
  cluster_name    = var.cluster_name
  cluster_info    = module.eks
  enable_automode = var.enable_automode
  region          = var.region
  cluster_version = var.kubernetes_version
  delegate_scope  = lower(var.delegate_scope)
  # delegate configuration
  delegate_token = {
    name       = "${var.environmet}-${var.delegate_name}"
    org_id     = local.delegate_scope == "org" ? var.harness_org_id : ""
    project_id = local.delegate_scope == "project" ? var.harness_project_id : ""
  }

  delegate = {
    name                      = "${var.environmet}-${var.delegate_name}"
    namespace                 = var.delegate_namespace
    delegate_deploy_mode      = var.delegate_deploy_mode
    harness_delegate_replicas = var.harness_delegate_replicas
  }

  tags = {
    Blueprint  = local.cluster_name
    GithubRepo = "github.com/gitops-bridge-dev/gitops-bridge"
  }
}


# Create a local variable where i define the delegate scope account, org, project
