resource "aws_ecr_repository" "this" {
  name                 = "${var.shortname}/ubuntu-apache"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "my_lifecycle_policy" {
  repository = aws_ecr_repository.this.name
  policy     = file("lifecycle-policy.json")
}