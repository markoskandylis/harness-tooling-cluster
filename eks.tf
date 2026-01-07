module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = local.cluster_name
  kubernetes_version = "1.34"

  vpc_id     = data.aws_vpc.vpc.id
  subnet_ids = data.aws_subnets.private_subnets.ids

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  # Create just the IAM resources for EKS Auto Mode for use with custom node pools
  create_auto_mode_iam_resources = true

  eks_managed_node_groups = local.enable_automode ? {} : {
    platform = {
      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore    = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
        AmazonSSMDirectoryServiceAccess = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess",
        CloudWatchAgentServerPolicy     = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
      }

      instance_types = var.managed_node_group_instance_types
      ami_type       = var.managed_node_group_ami
      # In Case you want to control the version of the ami
      ami_release_version            = var.ami_release_version
      use_latest_ami_release_version = var.managed_node_group_ami != "" ? false : true
      min_size                       = 3
      max_size                       = 6
      desired_size                   = 3
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 10
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 125
            encrypted             = true
            delete_on_termination = true
          }
        }
        xvdb = {
          device_name = "/dev/xvdb"
          ebs = {
            volume_size           = 25
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 125
            encrypted             = true
            delete_on_termination = true
          }
        }
      }
      labels = {
        type = "criticalAddons"
      }
    }
  }

  # If automode is enabled the following addons are managed by Automode
  addons = local.enable_automode ? {} : {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
    amazon-cloudwatch-observability = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
    vpc-cni = {
      # Specify the VPC CNI addon should be deployed before compute to ensure
      # the addon is configured before data plane compute resources are created
      # See README for further details
      before_compute = true
      most_recent    = true # To ensure access to the latest settings provided
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  node_security_group_tags = {
    # NOTE - if creating multiple security groups with this module, only tag the
    # security group that Karpenter should utilize with the following tag
    # (i.e. - at most, only one security group should have this tag in your account)
    "karpenter.sh/discovery" = local.cluster_name
  }

  compute_config =  local.enable_automode ? {
    enabled    = true
    node_pools = ["general-purpose"]
  } : null

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}


module "aws_ebs_csi_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"

  name = "aws-ebs-csi"

  attach_aws_ebs_csi_policy = true
  aws_ebs_csi_kms_arns      = ["arn:aws:kms:*:*:key/*"]

  # Pod Identity Associations
  associations = {
    addon = {
      cluster_name    = local.cluster_info.cluster_name
      namespace       = "kube-system"
      service_account = "ebs-csi-controller-sa"
    }
  }

  tags = local.tags
}