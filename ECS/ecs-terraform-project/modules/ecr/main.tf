resource "aws_ecr_repository" "repo" {

  name = "flask-app"

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"

  tags = {
    Name = "flask-app"
  }
}