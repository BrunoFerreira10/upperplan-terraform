resource "aws_ecr_repository" "this" {
  name                 = "${var.shortname}/ubuntu-apache"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

# resource "aws_ecr_lifecycle_policy" "this" {
#   repository = aws_ecr_repository.this.name
#   policy     = file("${path.module}/lifecycle-policy.json")
# }