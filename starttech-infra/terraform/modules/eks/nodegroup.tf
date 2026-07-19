resource "aws_eks_node_group" "workers" {

  cluster_name = aws_eks_cluster.cluster.name

  node_group_name = "primary-workers"

  node_role_arn = aws_iam_role.node_role.arn

  subnet_ids = var.private_subnet_ids

  scaling_config {

    desired_size = var.desired_size

    min_size = var.min_size

    max_size = var.max_size

  }

  instance_types = [

    var.node_instance_type

  ]

  capacity_type = "ON_DEMAND"

  ami_type = "AL2023_x86_64_STANDARD"

  depends_on = [

    aws_eks_cluster.cluster,

    aws_iam_role_policy_attachment.worker_policy,

    aws_iam_role_policy_attachment.cni_policy,

    aws_iam_role_policy_attachment.ecr_policy

  ]
}

  