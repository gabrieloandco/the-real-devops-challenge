- https://github.com/terraform-aws-modules/terraform-aws-eks/issues/911
- https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller
- https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
- https://learn.hashicorp.com/tutorials/terraform/eks
- https://gitlab.com/gabrieloandco/real-devops-challenge/-/settings/ci_cd
- https://raslasarslas.medium.com/example-deployment-with-gitlab-ci-cd-with-helm-and-aws-eks-8cc104442ccf
- https://dev.to/stack-labs/securing-access-to-aws-iam-roles-from-gitlab-ci-3an0
- https://aws.amazon.com/blogs/containers/amazon-eks-cluster-automation-with-gitlab-ci-cd/
- https://wahlnetwork.com/2020/09/22/gitlab-ci-runners-on-amazon-eks-using-terraform/
- https://wahlnetwork.com/2020/09/22/gitlab-ci-runners-on-amazon-eks-using-terraform/
- https://aws.amazon.com/blogs/containers/ci-cd-with-amazon-eks-using-aws-app-mesh-and-gitlab-ci/

aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
helm -n ingress-controller repo add aws https://aws.github.io/eks-charts
helm -n ingress-controller install ingress-aws-alb aws/aws-load-balancer-controller --version 1.2.2 --set clusterName=challenge-cluster
