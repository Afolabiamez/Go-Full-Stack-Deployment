resource "aws_vpc" "starttech_vpc" {

  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "starttech-vpc"
  }
}

resource "aws_subnet" "public_a" {

  vpc_id = aws_vpc.starttech_vpc.id

  cidr_block = "10.0.1.0/24"

  availability_zone = data.aws_availability_zones.available.names[0]

  map_public_ip_on_launch = true

  tags = {
    Name = "starttech-public-a"

    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public_b" {

  vpc_id = aws_vpc.starttech_vpc.id

  cidr_block = "10.0.2.0/24"

  availability_zone = data.aws_availability_zones.available.names[1]

  map_public_ip_on_launch = true

  tags = {
    Name = "starttech-public-b"

    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "private_a" {

  vpc_id = aws_vpc.starttech_vpc.id

  cidr_block = "10.0.3.0/24"

  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "starttech-private-a"

    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private_b" {

  vpc_id = aws_vpc.starttech_vpc.id

  cidr_block = "10.0.4.0/24"

  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "starttech-private-b"

    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.starttech_vpc.id

  tags = {
    Name = "starttech-igw"
  }
}

resource "aws_eip" "nat_eip" {

  domain = "vpc"

  tags = {
    Name = "starttech-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat_eip.id

  subnet_id = aws_subnet.public_a.id

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = {
    Name = "starttech-nat"
  }
}

resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.starttech_vpc.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "private_rt" {

  vpc_id = aws_vpc.starttech_vpc.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-rt"
  }
}


resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_rt.id
}

module "eks" {
  source = "./modules/eks"

  cluster_name = var.cluster_name

  node_instance_type = var.node_instance_type

  desired_size = var.desired_size
  min_size     = var.min_size
  max_size     = var.max_size

  vpc_id = aws_vpc.starttech_vpc.id

  private_subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]
  public_subnet_ids = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  my_ip = var.my_ip
}

module "database" {
  source = "./modules/database"

  vpc_id = aws_vpc.starttech_vpc.id

  private_subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  eks_node_sg_id            = module.eks.node_sg_id
  cluster_security_group_id = module.eks.cluster_security_group_id

  redis_cluster_id = var.redis_cluster_id

  redis_node_type = var.redis_node_type
}

module "ecr" {

  source = "./modules/ecr"

}

module "cdn" {

  source = "./modules/cdn"

  bucket_domain_name = module.storage.bucket_domain_name

  alb_dns_name = "k8s-default-muchtodo-a6625479e3-1876725870.eu-west-1.elb.amazonaws.com"

}

module "storage" {

  source = "./modules/storage"

  bucket_name = "starttech-frontend-afolabi"

  cloudfront_arn = module.cdn.cloudfront_arn

}

terraform {
  backend "s3" {
    bucket         = "starttech-terraform-state-afolabi"
    key            = "production/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
  }
}

# 1. Create the IAM User for the grader
resource "aws_iam_user" "grader" {
  name          = "start-tech-grader"
  force_destroy = true
}

# 2. Enable Web Management Console access with a secure password
resource "aws_iam_user_login_profile" "grader_profile" {
  user                    = aws_iam_user.grader.name
  password                = "StartTechGradeMe2026!"
  password_reset_required = false
}

# 3. Create programmatic CLI Access Keys for the automated grading script
resource "aws_iam_access_key" "grader_keys" {
  user = aws_iam_user.grader.name
}

# 4. Attach the exact requested Least Privilege Security Policy
resource "aws_iam_user_policy" "grader_policy" {
  name = "GraderReadOnlyPolicy"
  user = aws_iam_user.grader.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "GraderReadOnlyS3"
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets",
          "s3:GetBucketPublicAccessBlock",
          "s3:ListBucket"
        ]
        Resource = "*"
      },
      {
        Sid    = "GraderReadOnlyCloudFront"
        Effect = "Allow"
        Action = [
          "cloudfront:ListDistributions",
          "cloudfront:GetDistributionConfig"
        ]
        Resource = "*"
      },
      {
        Sid    = "GraderReadOnlyEKS"
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListNodegroups",
          "eks:DescribeNodegroup"
        ]
        Resource = "*"
      },
      {
        Sid    = "GraderReadOnlyElastiCache"
        Effect = "Allow"
        Action = [
          "elasticache:DescribeCacheClusters"
        ]
        Resource = "*"
      }
    ]
  })
}

# 5. Output the Programmatic Access Keys so you can easily copy them for your submission
output "grader_access_key_id" {
  value     = aws_iam_access_key.grader_keys.id
  sensitive = false
}

output "grader_secret_access_key" {
  value     = aws_iam_access_key.grader_keys.secret
  sensitive = true
}
