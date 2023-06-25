module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.0"
  cluster_name    = "space-beacon"
  cluster_version = "1.27"

  vpc_id     = aws_vpc.space_beacon.id
  subnet_ids = [aws_subnet.space_beacon.id]

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 10
      min_capacity     = 1

      instance_type = "m5.large"
      key_name      = "space-beacon"

      additional_tags = {
        Environment = "test"
        Name        = "eks-worker-node"
      }
    }
  }

  manage_aws_auth    = true
  write_kubeconfig   = true
  config_output_path = "./"

  map_users = var.map_users
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap"
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}