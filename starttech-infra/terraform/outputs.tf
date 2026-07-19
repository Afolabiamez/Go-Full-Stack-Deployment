#######################
# Networking
#######################

output "vpc_id" {
  value = aws_vpc.starttech_vpc.id
}

output "public_subnets" {
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

output "private_subnets" {
  value = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]
}

#######################
# EKS
#######################

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "node_security_group_id" {
  value = module.eks.node_sg_id
}

output "alb_security_group_id" {
  value = module.eks.alb_sg_id
}

output "node_group_name" {
  value = module.eks.node_group_name
}

output "node_role_arn" {
  value = module.eks.node_role_arn
}

output "cluster_role_arn" {
  value = module.eks.cluster_role_arn
}

#######################
# Redis
#######################

output "redis_endpoint" {
  value = module.database.redis_endpoint
}

output "redis_port" {
  value = module.database.redis_port
}

output "redis_security_group_id" {
  value = module.database.redis_sg_id
}
output "cloudfront_domain_name" {
  description = "The live CloudFront CDN endpoint URL"
  value       = "https://${module.cdn.cloudfront_domain}"
}

output "s3_bucket_regional_domain_name" {
  description = "The backend storage S3 domain name"
  value       = module.storage.bucket_domain_name
}

output "kubernetes_backend_alb_endpoint" {
  description = "The DNS entry pointing to your backend cluster services"
  value       = "http://amazonaws.com"
}
