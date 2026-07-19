resource "aws_security_group" "redis_sg" {
  name        = "starttech-redis-sg"
  description = "Allow Redis traffic from EKS worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "starttech-redis-sg"
  }
}

resource "aws_security_group_rule" "redis_from_nodes" {
  type      = "ingress"
  from_port = 6379
  to_port   = 6379
  protocol  = "tcp"

  security_group_id        = aws_security_group.redis_sg.id
  source_security_group_id = var.eks_node_sg_id
}

resource "aws_security_group_rule" "redis_from_cluster" {
  type      = "ingress"
  from_port = 6379
  to_port   = 6379
  protocol  = "tcp"

  security_group_id        = aws_security_group.redis_sg.id
  source_security_group_id = var.cluster_security_group_id
}