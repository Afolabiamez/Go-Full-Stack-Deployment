variable "redis_cluster_id" {
  description = "Redis cluster name"
  type        = string
}

variable "redis_node_type" {
  description = "Redis instance type"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for Redis"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "eks_node_sg_id" {
  description = "Security Group ID of EKS worker nodes"
  type        = string
}

variable "cluster_security_group_id" {
  type = string
}