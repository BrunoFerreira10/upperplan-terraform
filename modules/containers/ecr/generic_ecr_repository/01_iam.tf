## ---------------------------------------------------------------------------------------------------------------------
## ECR Repository Policy
## ---------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "policy-01"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id] //"arn:aws:iam::************ser/cicdFargate"
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}

# resource "aws_iam_policy" "s3_access" {
#   name = "S3Access-${var.shortname}-${var.repository_name}-${var.region}"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "s3:GetObject",
#           "s3:PutObject",
#           "s3:ListBucket"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }

resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.this.name 
  policy     = data.aws_iam_policy_document.this.json
}