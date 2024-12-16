module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluster_version

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets


  eks_managed_node_group_defaults = {
    instance_types = ["t2.medium"]

  }

  eks_managed_node_groups = {
    example = {
      min_size     = 1
      max_size     = 1
      desired_size = 1
      capacity_type  = "SPOT"
    }
  }


  enable_cluster_creator_admin_permissions = true

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

# aws eks update-kubeconfig --region <region-code> --name <cluster-name>
#https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html

    # eksctl create iamserviceaccount \
    #   --cluster=TestCluster \
    #   --namespace=kube-system \
    #   --name=aws-load-balancer-controller \
    #   --role-name AmazonEKSLoadBalancerControllerRole \
    #   --attach-policy-arn=arn:aws:iam::036270952534:policy/AWSLoadBalancerControllerIAMPolicy \
    #   --approve


