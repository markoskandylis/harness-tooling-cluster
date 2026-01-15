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
  depends_on = [module.eks, module.delegate_pod_identity]
  source     = "harness/harness-delegate/kubernetes"
  version    = "0.2.3"

  delegate_name    = local.delegate.name
  namespace        = local.delegate.namespace
  account_id       = var.harness_account_id
  delegate_token   = resource.harness_platform_delegatetoken.this[0].value
  deploy_mode      = local.delegate.deploy_mode
  manager_endpoint = "https://app.harness.io"
  delegate_image   = "us-docker.pkg.dev/gar-prod-setup/harness-public/harness/delegate:25.12.87402"
  replicas         = local.delegate.replicas
  upgrader_enabled = true

  # IMPORTANT: installs aws-iam-authenticator inside the delegate container
  init_script = <<-EOT
  #!/bin/sh
  set -e

  # Download aws-iam-authenticator (amd64)
  curl -fsSL -o /usr/local/bin/aws-iam-authenticator \
    https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.5.9/aws-iam-authenticator_0.5.9_linux_amd64

  chmod +x /usr/local/bin/aws-iam-authenticator

  # Verify
  /usr/local/bin/aws-iam-authenticator help >/dev/null 2>&1
EOT
}


resource "harness_platform_connector_kubernetes" "this" {
  count       = var.deploy_delegate ? 1 : 0
  org_id      = local.kubernetes_connector.org_id
  project_id  = local.kubernetes_connector.project_id
  identifier  = local.kubernetes_connector.identifier
  name        = local.kubernetes_connector.name
  description = local.kubernetes_connector.description
  tags        = ["foo:bar"]

  inherit_from_delegate {
    delegate_selectors = [local.delegate.name]
  }
}

# If we use OIDC we will not need delegate Pod identitry the related permissions are used from the OIDC role
module "delegate_pod_identity" {
  count  = local.delegate.deploy_pod_identity ? 1 : 0
  source = "terraform-aws-modules/eks-pod-identity/aws"

  name = local.delegate.name

  attach_custom_policy = true
  policy_statements = [
    {
      sid       = "DelegateOIDCAssumeRole"
      actions   = ["sts:AssumeRole", "sts:TagSession"]
      resources = [local.delegate.assumed_role_arn]
    }
  ]

  # Pod Identity Associations
  association_defaults = {
    namespace = local.delegate.namespace
  }

  associations = {
    delegate = {
      cluster_name    = local.cluster_info.cluster_name
      service_account = local.delegate.name
    }
  }

}

# Translate this to module for the delegate