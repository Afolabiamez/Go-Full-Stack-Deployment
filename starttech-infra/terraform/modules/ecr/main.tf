resource "aws_ecr_repository" "backend" {

  name = "muchtodo-api"

  force_delete = true

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "muchtodo-api"
  }

}