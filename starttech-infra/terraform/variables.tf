variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-1"
}

variable "my_ip" {
  description = "102.69.147.212/32"
  type        = string
}

variable "cluster_name" {
  type = string
}

variable "node_instance_type" {
  type = string
}

variable "desired_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "redis_node_type" {
  default = "cache.t3.micro"
}

variable "redis_cluster_id" {
  default = "starttech-redis"
}




