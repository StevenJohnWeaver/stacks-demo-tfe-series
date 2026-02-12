terraform {
  required_providers {
    aws    = { source = "hashicorp/aws",    version = "~> 5.0" }
    random = { source = "hashicorp/random", version = "~> 3.5" }
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name                               = var.cluster_name
  kubernetes_version                 = var.kubernetes_version
  subnet_ids                         = var.subnet_ids
  vpc_id                             = var.vpc_id
  enable_cluster_creator_admin_permissions = true

  endpoint_public_access  = true
  endpoint_private_access = true  # optional, but recommended

  tags = { demo = "stacks" }
}

# data "aws_eks_cluster" "this" {
#   name = module.eks.cluster_name
# }

# data "aws_eks_cluster_auth" "this" {
#   name = module.eks.cluster_name
# }

# output "cluster_url" {
#   value = data.aws_eks_cluster.this.endpoint
# }

# output "cluster_ca" {
#   value = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
# }

# output "cluster_token" {
#   value     = data.aws_eks_cluster_auth.this.token
#   sensitive = true
# }
