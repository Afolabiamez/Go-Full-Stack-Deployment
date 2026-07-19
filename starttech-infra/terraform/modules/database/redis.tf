resource "aws_elasticache_subnet_group" "redis" {

  name = "starttech-redis-subnets"

  subnet_ids = var.private_subnet_ids

}



resource "aws_elasticache_cluster" "redis" {

  cluster_id = var.redis_cluster_id

  engine = "redis"

  engine_version = "7.1"

  node_type = var.redis_node_type

  num_cache_nodes = 1

  port = 6379

  subnet_group_name = aws_elasticache_subnet_group.redis.name

  security_group_ids = [
    aws_security_group.redis_sg.id
  ]
}