variable "region"            { type = string }
variable "role_arn"          { type = string }
variable "identity_token"    { type = string }
variable "default_tags"      { type = map(string) }
variable "cluster_name"      { type = string }
variable "kubernetes_version" { type = string }
variable "vpc_cidr"          { type = string }
