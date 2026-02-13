terraform {
  required_providers {
    aws = { source = "hashicorp/aws",    version = "~> 6.0" }
    random = { source = "hashicorp/random", version = "~> 3.5" }
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  # Keep your existing constraint (or the exact version you had when it worked).
  # The key here is using the legacy inputs this runtime expects.
  version = "~> 21.0"

  # NOTE: Using 'name' here to match the module schema Stacks is resolving today.
  name                = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  subnet_ids          = var.subnet_ids
  vpc_id              = var.vpc_id

  # Legacy endpoint args (the "cluster_endpoint_*" variants triggered 'unsupported' earlier)
  endpoint_public_access  = true
  endpoint_private_access = true

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    demo = {
      desired_size   = 1
      max_size       = 1
      min_size       = 1
      instance_types = ["t3.small"]

      # Give the nodegroup more time to become healthy while the separate 'auth' component
      # writes aws-auth (if that's not immediate).
      create_timeout = "40m"
      update_timeout = "60m"
      delete_timeout = "40m"
    }
  }

  tags = { demo = "stacks" }
}

############################################
# EKS Addons as native AWS resources
# (module version independent)
############################################

# Ensure addons get created after the cluster exists
resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = var.cluster_name
  addon_name                  = "vpc-cni"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  depends_on                  = [module.eks]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = var.cluster_name
  addon_name                  = "kube-proxy"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  depends_on                  = [module.eks]
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = var.cluster_name
  addon_name                  = "coredns"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  depends_on                  = [module.eks]
}
