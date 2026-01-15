################################################################################
# Infrastructure Variables
################################################################################
variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "vpc_name" {
  description = "VPC name to be used by pipelines for data"
  type        = string
  default     = "eks-hub-cluster"
}

variable "ecr_account" {
  description = "The account the the ECR images for the gitops bridge are hosted"
  type        = string
  default     = ""
}

variable "kms_key_admin_roles" {
  description = "list of role ARNs to add to the KMS policy"
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "non-prod"
}

variable "public_subnets_prefix" {
  description = "The prefix for the private subnets to be used by the EKS cluster"
  type        = string
  default     = "eks-hub-cluster-private-*"
}

variable "private_subnets_prefix" {
  description = "The prefix for the private subnets to be used by the EKS cluster"
  type        = string
  default     = "eks-hub-cluster-private-*"
}

################################################################################
# Cluster Realted Variables
################################################################################
variable "eks_cluster_endpoint_public_access" {
  description = "Deploying public or private endpoint for the cluster"
  type        = bool
  default     = true
}

variable "managed_node_group_ami" {
  description = "The ami type of managed node group"
  type        = string
  default     = "BOTTLEROCKET_x86_64"
}

variable "managed_node_group_instance_types" {
  description = "List of managed node group instances"
  type        = list(string)
  default     = ["m5.large"]
}

variable "ami_release_version" {
  description = "The AMI version of the Bottlerocket worker nodes"
  type        = string
  default     = ""
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.34"
}

variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
  default     = "hub-cluster"
}

variable "enable_automode" {
  description = "Enabling Automode Cluster"
  type        = bool
  default     = false
}

# Harness Variables
variable "deploy_delegate" {
  description = "Deploy or Not delegate to the cluster"
  type        = bool
  default     = true
}

variable "delegate_token_name" {
  description = "The name of the delegate token to be created."
  type        = string
  default     = ""
}

variable "delegate_scope" {
  type        = string
  description = "account | org | project"
  default     = "org"
  validation {
    condition     = contains(["account", "org", "project"], lower(var.delegate_scope))
    error_message = "delegate_scope must be account, org, or project."
  }
}

variable "harness_account_id" {
  description = "The Harness Account ID where the delegate will be registered."
  type        = string
  default     = ""
}

################################################################################
# Delegate variables configuration
################################################################################

variable "delegate_org_id" {
  description = "The Harness Organization ID where the delegate will be registered."
  type        = string
  default     = ""
}

variable "delegate_project_id" {
  description = "The Harness Project ID where the delegate will be registered."
  type        = string
  default     = ""
}

variable "delegate_name" {
  description = "The name of the Harness Delegate."
  type        = string
  default     = "tooling-delegate"
}

variable "delegate_deploy_mode" {
  description = "The deployment mode for the Harness Delegate."
  type        = string
  default     = "KUBERNETES"
}

variable "delegate_namespace" {
  description = "The Kubernetes namespace where the Harness Delegate will be deployed."
  type        = string
  default     = "harness-delegate-tooling"
}

variable "delegate_replicas" {
  description = "The number of replicas for the Harness Delegate."
  type        = number
  default     = 1
}

variable "delegate_assumed_role_arn" {
  description = "Allowing EKS pod identity delegate to assume role"
  type        = string
}

################################################################################
# Kubernetes Connector Variables
################################################################################

variable "kubernetes_connector_identifier" {
  description = "The identifier for the Kubernetes connector in Harness."
  type        = string
  default     = "toolingconnector"
}

variable "kubernetes_connector_name" {
  description = "The name for the Kubernetes connector in Harness."
  type        = string
  default     = "tooling-conector"
}

variable "kubernetes_connector_description" {
  description = "The description for the Kubernetes connector in Harness."
  type        = string
  default     = "Kubernetes connector for tooling cluster"
}

variable "deploy_delegate_pod_identity" {
  description = "Deploying delegate pod identity"
  type = bool
  default = false
}

################################################################################
# Sensitive variable for Harness Platform
################################################################################

variable "harness_platform_api_key" {
  description = "The API key for accessing the Harness Platform."
  type        = string
  sensitive   = true
  default     = ""
}
