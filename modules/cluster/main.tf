terraform {
  required_providers {
    aws    = { source = "hashicorp/aws",    version = "~> 6.0" }
    random = { source = "hashicorp/random", version = "~> 3.5" }
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  cluster_name                       = var.cluster_name
  kubernetes_version                 = var.kubernetes_version
  subnet_ids                         = var.subnet_ids
  vpc_id                             = var.vpc_id

  # Admin + endpoint access
  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # endpoint_public_access  = true
  # endpoint_private_access = true  # optional, but recommended

  eks_managed_node_groups = {
    demo = {
      desired_size   = 1
      max_size       = 1
      min_size       = 1
      instance_types = ["t3.small"]
    }
  }
  ############################################
  # EKS Core Addons (required)
  ############################################
  cluster_addons = {
    vpc-cni = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }
    coredns = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }
  }
  
  ############################################
  # AWS Auth (critical!!)
  ############################################
  manage_aws_auth = true

  tags = { demo = "stacks" }
}
