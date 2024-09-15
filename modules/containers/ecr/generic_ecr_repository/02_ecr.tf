## ---------------------------------------------------------------------------------------------------------------------
## ECR Repository
## ---------------------------------------------------------------------------------------------------------------------
resource "aws_ecr_repository" "this" {
  name                 = "${var.shortname}/${var.repository_name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = var.shortname
  }
}

## ---------------------------------------------------------------------------------------------------------------------
## ECR Lifecycle Policy
## ---------------------------------------------------------------------------------------------------------------------
data "aws_ecr_lifecycle_policy_document" "this" {
  rule {
    priority    = 1
    description = "Expire images older than 15 days"

    selection {
      tag_status      = "untagged"
      # tag_prefix_list = ["prod"]
      # count_type      = "sinceImagePushed"
      # count_unit      = "days"
      # count_number    = 15
      count_type = "imageCountMoreThan"
      count_number = 3
    }

    action {
      type = "expire"
    }
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy     = data.aws_ecr_lifecycle_policy_document.this.json
}

## ---------------------------------------------------------------------------------------------------------------------