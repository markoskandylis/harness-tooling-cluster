# Create a Harness Delegate Token
resource "harness_platform_delegatetoken" "this" {
  name       = var.delegate_token_name
  account_id = var.harness_account_id
  org_id     = local.org_id
  project_id = local.project_id
  tags       = local.tags
}

module "delegate" {
  source  = "harness/harness-delegate/kubernetes"
  version = "0.2.3"

  account_id       = var.harness_account_id
  delegate_token   = resource.harness_platform_delegatetoken.this.token
  delegate_name    = var.delegate_name
  deploy_mode      = var.delegate_deploy_mode
  namespace        = var.delegate_namespace
  manager_endpoint = "https://app.harness.io"
  delegate_image   = "us-docker.pkg.dev/gar-prod-setup/harness-public/harness/delegate:25.12.87402"
  replicas         = var.harness_delegate_replicas
  upgrader_enabled = true
}
