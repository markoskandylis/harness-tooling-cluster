data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}

data "aws_iam_roles" "eks_admin_role" {
  name_regex = "AWSReservedSSO_AWSPowerUserAccess_.*"
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}"]
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  tags = {
    Name = "eks-vpc-private-*"
  }
}


data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  tags = {
    Name = "eks-vpc-public-*"
  }
}