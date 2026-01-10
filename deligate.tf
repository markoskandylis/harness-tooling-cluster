# Create a Harness Delegate Token
resource "harness_platform_delegatetoken" "this" {
  count      = var.deploy_delegate ? 1 : 0
  name       = local.delegate_token.name
  account_id = var.harness_account_id
  org_id     = local.delegate_token.org_id
  project_id = local.delegate_token.project_id
}

module "delegate" {
  count      = var.deploy_delegate ? 1 : 0
  depends_on = [module.eks]
  source     = "harness/harness-delegate/kubernetes"
  version    = "0.2.3"

  delegate_name    = local.delegate.name
  namespace        = local.delegate.namespace
  account_id       = var.harness_account_id
  delegate_token   = resource.harness_platform_delegatetoken.this[0].value
  deploy_mode      = local.delegate.delegate_deploy_mode
  manager_endpoint = "https://app.harness.io"
  delegate_image   = "us-docker.pkg.dev/gar-prod-setup/harness-public/harness/delegate:25.12.87402"
  replicas         = local.delegate.harness_delegate_replicas
  upgrader_enabled = true
}

resource "harness_platform_connector_kubernetes" "this" {
  count       = var.deploy_delegate ? 1 : 0
  identifier  = local.kubernetes_connector.identifier
  name        = local.kubernetes_connector.name
  description = local.kubernetes_connector.description
  tags        = ["foo:bar"]

  inherit_from_delegate {
    delegate_selectors = [local.delegate.name]
  }
}

module "delegate_pod_identity" {
  source = "terraform-aws-modules/eks-pod-identity/aws"

  name = loca.delegate.name

  attach_custom_policy = true
  policy_statements = [
    {
      sid       = "ArgoCD"
      actions   = ["sts:AssumeRole", "sts:TagSession"]
      resources = ["arn:aws:iam::*:role/oidc-mk"]
    }
  ]

  # Pod Identity Associations
  association_defaults = {
    namespace = local.delegate.namespace
  }

  associations = {
    delegate = {
      cluster_name    = local.cluster_info.cluster_name
      service_account = "non-prod-tooling-delegate"
    }
  }

}