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
  default     = "eks-vpc"
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
