locals {
  # Cluster Configuration
  cluster_name    = "${var.environment}-${var.cluster_name}"
  cluster_info    = module.eks
  enable_automode = var.enable_automode
  region          = var.region
  cluster_version = var.kubernetes_version
  delegate_scope  = lower(var.delegate_scope)

  # delegate configuration
  delegate_token = {
    name       = "${var.environment}-${var.delegate_token_name}"
    org_id     = local.delegate_scope == "org" ? var.delegate_org_id : ""
    project_id = local.delegate_scope == "project" ? var.delegate_project_id : ""
  }

  delegate = {
    name             = "${var.environment}-${var.delegate_name}"
    namespace        = var.delegate_namespace
    deploy_mode      = var.delegate_deploy_mode
    replicas         = var.delegate_replicas
    assumed_role_arn = var.delegate_assumed_role_arn
  }

  kubernetes_connector = {
    name        = "${var.environment}-${var.kubernetes_connector_name}"
    identifier  = replace("${var.environment}_${var.kubernetes_connector_identifier}", "-", "")
    description = var.kubernetes_connector_description
  }

  tags = {
    Blueprint  = local.cluster_name
    GithubRepo = "github.com/gitops-bridge-dev/gitops-bridge"
  }
}


# Create a local variable where i define the delegate scope account, org, project
