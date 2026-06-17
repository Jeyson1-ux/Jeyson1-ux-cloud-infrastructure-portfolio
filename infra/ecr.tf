resource "aws_ecr_repository" "app" {
  name                 = "bc-app"
  image_tag_mutability = "IMMUTABLE" # tags cannot be overwritten!
  force_delete         = true

  tags = {
    Name = "${var.project_name}-ecr-repo"
  }

}