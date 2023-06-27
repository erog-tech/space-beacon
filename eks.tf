/*data "aws_eks_cluster" "default" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.default.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.default.token
  }
}*/
module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  version                        = "19.0"
  cluster_name                   = "space-beacon"
  cluster_version                = "1.27"
  cluster_endpoint_public_access = true

  vpc_id                 = aws_vpc.space_beacon.id
  subnet_ids             = [aws_subnet.space_beacon_1.id, aws_subnet.space_beacon_2.id]
  node_security_group_id = aws_security_group.space_beacon.id

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

  # aws-auth configmap

  manage_aws_auth_configmap = true

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::603956422639:user/pri.chauhan"
      username = "pri.chauhan"
      groups   = ["system:masters"]
    }
  ]
  aws_auth_accounts = [
    "603956422639"
  ]

  tags = {
    Environment = "prod"
    Terraform   = "true"
  }
}