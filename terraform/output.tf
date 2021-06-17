output "region" {
  value = var.region
}

output "cluster_name" {
  value = "challenge-cluster"
}

output "ecr_repository_url" {
  value = aws_ecr_repository.challenge.repository_url
}

output "ecr_repository_id" {
  value = aws_ecr_repository.challenge.registry_id
}

output "cluster_endpoint" {
  value = module.challenge_cluster.cluster_endpoint
}


# output "config_map_aws_auth" {
#   value = module.challenge_cluster.config_map_aws_auth 
# }
