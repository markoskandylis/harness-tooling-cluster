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
variable "delegate_token_name" {
  description = "The name of the delegate token to be created."
  type        = string
  default     = "harness-delegate-token"
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

variable "harness_org_id" {
  description = "The Harness Organization ID where the delegate will be registered."
  type        = string
  default     = ""
}

variable "harness_project_id" {
  description = "The Harness Project ID where the delegate will be registered."
  type        = string
  default     = ""
}

variable "delegate_name" {
  description = "The name of the Harness Delegate."
  type        = string
  default     = "harness-delegate"
}

variable "delegate_deploy_mode" {
  description = "The deployment mode for the Harness Delegate."
  type        = string
  default     = "KUBERNETES"
}

variable "delegate_namespace" {
  description = "The Kubernetes namespace where the Harness Delegate will be deployed."
  type        = string
  default     = "harness-delegate"
}

variable "harness_delegate_replicas" {
  description = "The number of replicas for the Harness Delegate."
  type        = number
  default     = 1
}

variable "kubernetes_connector_identifier" {
  description = "The identifier for the Kubernetes connector in Harness."
  type        = string
  default     = ""
}

variable "kubernetes_connector_name" {
  description = "The name for the Kubernetes connector in Harness."
  type        = string
  default     = ""
}

variable "kubernetes_connector_description" {
  description = "The description for the Kubernetes connector in Harness."
  type        = string
  default     = ""
}

################################################################################
# Sensitive variable for Harness Platform
variable "harness_platform_api_key" {
  description = "The API key for accessing the Harness Platform."
  type        = string
  sensitive   = true
  default     = ""
}
