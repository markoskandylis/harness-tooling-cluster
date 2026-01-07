provider "aws" {
  region = "eu-west-2"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.67.0"
    }

    harness = {
      source  = "harness/harness"
      version = "0.38.8"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.10.1"
    }
  }
}



provider "helm" {
  kubernetes {
    host                   = local.cluster_info.cluster_endpoint
    cluster_ca_certificate = base64decode(local.cluster_info.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = [
        "eks",
        "get-token",
        "--cluster-name", local.cluster_info.cluster_name,
        "--region", local.region
      ]
    }
  }
}