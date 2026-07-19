output "cluster_name" {
  value = aws_eks_cluster.cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "cluster_security_group_id" {
  description = "AWS-managed EKS cluster security group"
  value       = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
}


output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "node_group_name" {
  value = aws_eks_node_group.workers.node_group_name
}

output "node_role_arn" {
  value = aws_iam_role.node_role.arn
}

output "cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "node_sg_id" {
  description = "Security Group ID of the EKS worker nodes"
  value       = aws_security_group.eks_nodes_sg.id
}