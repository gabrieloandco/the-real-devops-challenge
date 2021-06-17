- https://github.com/terraform-aws-modules/terraform-aws-eks/issues/911
- https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller
- https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
- https://learn.hashicorp.com/tutorials/terraform/eks

aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
helm -n ingress-controller repo add aws https://aws.github.io/eks-charts
helm -n ingress-controller install ingress-aws-alb aws/aws-load-balancer-controller --version 1.2.2 --set clusterName=challenge-cluster