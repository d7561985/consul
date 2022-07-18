locals {
  region        = "eu-central-1"
  azs           = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]

  tags = {
    k8s              = var.cluster_name
    "label"    = var.cluster_name
    "vpc/type" = "managed"
  }
}

module "vpc" {
  source  = "registry.terraform.io/terraform-aws-modules/vpc/aws"
  version = "~> 3.14"

  name = var.cluster_name
  cidr ="10.0.0.0/21"

  azs             = local.azs
  private_subnets = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]

  enable_ipv6                     = true
  assign_ipv6_address_on_creation = true
  create_egress_only_igw          = true

  public_subnet_ipv6_prefixes  = [0, 1, 2]
  private_subnet_ipv6_prefixes = [3, 4, 5]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "label"                               = var.cluster_name
    "isPublic"                                  = true
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
    "label"                               = var.cluster_name
    "isPrivate"                                 = true
  }

  tags = local.tags
}