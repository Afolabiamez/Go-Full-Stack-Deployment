resource "aws_security_group" "eks_cluster_sg" {

  name = "${var.cluster_name}-cluster-sg"

  description = "EKS Control Plane"

  vpc_id = var.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
      var.my_ip
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_security_group" "alb_sg" {

  name = "alb-sg"

  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}


resource "aws_security_group" "eks_nodes_sg" {

  name = "${var.cluster_name}-nodes"

  vpc_id = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
  ingress {
    from_port = 30000
    to_port   = 32767
    protocol  = "tcp"
    security_groups = [
      aws_security_group.alb_sg.id
    ]

  }
  ingress {
    from_port = 1025
    to_port   = 65535
    protocol  = "tcp"
    security_groups = [
      aws_security_group.eks_cluster_sg.id
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_security_group_rule" "alb_to_worker_nodes" {
  type = "ingress"

  security_group_id        = aws_security_group.eks_nodes_sg.id
  source_security_group_id = aws_security_group.alb_sg.id

  protocol  = "tcp"
  from_port = 8080
  to_port   = 8080

  description = "Allow ALB to reach backend pods"
}