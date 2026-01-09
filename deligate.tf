# Create a Harness Delegate Token
resource "harness_platform_delegatetoken" "this" {
  name       = local.delegate_token.name
  account_id = var.harness_account_id
  org_id     = local.delegate_token.org_id
  project_id = local.delegate_token.project_id
}

module "delegate" {
  depends_on = [module.eks]
  source     = "harness/harness-delegate/kubernetes"
  version    = "0.2.3"

  delegate_name    = local.delegate.name
  namespace        = local.delegate.namespace
  account_id       = var.harness_account_id
  delegate_token   = resource.harness_platform_delegatetoken.this.value
  deploy_mode      = local.delegate.delegate_deploy_mode
  manager_endpoint = "https://app.harness.io"
  delegate_image   = "us-docker.pkg.dev/gar-prod-setup/harness-public/harness/delegate:25.12.87402"
  replicas         = local.delegate.harness_delegate_replicas
  upgrader_enabled = true
}

resource "harness_platform_connector_kubernetes" "this" {
  identifier  = var.kubernetes_connector_identifier
  name        = var.kubernetes_connector_name
  description = var.kubernetes_connector_description
  tags        = ["foo:bar"]

  inherit_from_delegate {
    delegate_selectors = [var.delegate_name]
  }
}
