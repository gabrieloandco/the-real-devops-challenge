terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "aws_ecr_repository" "challenge" {
  name                 = "api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "defaulta" {
  availability_zone = "us-east-2a"

  tags = {
    Name = "Default subnet for us-east-2a"
  }
}

resource "aws_default_subnet" "defaultb" {
  availability_zone = "us-east-2b"

  tags = {
    Name = "Default subnet for us-east-2b"
  }
}

module "challenge_cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "challenge-cluster"
  cluster_version = "1.19"
  subnets            = [aws_default_subnet.defaulta.id,aws_default_subnet.defaultb.id ]
  vpc_id          = aws_default_vpc.default.id
  manage_aws_auth = true

  worker_groups = [
    {
      name = "worker-group-1"
      instance_type = "t2.small"
      asg_desired_capacity = 2
    },
    {
      name = "worker-group-2"
      instance_type = "t2.small"
      asg_desired_capacity = 2
    }
  ]
}

data "aws_eks_cluster" "challenge_cluster" {
  name = module.challenge_cluster.cluster_id
}

data "aws_eks_cluster_auth" "challenge_cluster" {
  name = module.challenge_cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.challenge_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.challenge_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.challenge_cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}

provider "helm" {
  kubernetes{
    host                   = data.aws_eks_cluster.challenge_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.challenge_cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.challenge_cluster.token
  }
}


resource "helm_release" "aws_ingress" {

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.2.2"

  create_namespace = true
  namespace        = "ingress-controller"
  name             = "ingress-aws-alb"

  set {
    name  = "clusterName"
    value = "challenge-cluster"
  }

  depends_on = [module.challenge_cluster]
}