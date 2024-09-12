## --------------------------------------------------------------------------------------------------------------------
## Codebuild ECR Push Role
## --------------------------------------------------------------------------------------------------------------------

## Policies
resource "aws_iam_policy" "ecr_push" {
  name        = "Prod-ECRPush-${var.shortname}-${var.region}"
  path        = "/TerraformManaged/"
  description = "Allow to push images to ECR"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "logs:*",
          "s3:*"
        ],
        "Resource" : "*"
      }
    ]
  })

  tags = {
    Name = self.name
  }
}

## Role definition
resource "aws_iam_role" "codebuild" {
  name = "prod-ecr-push-${var.shortname}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "codebuild.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })

  tags = {
    Name = self.name
  }
}

## Policies attachments
resource "aws_iam_role_policy_attachment" "ecr_push_to_codebuild" {
  policy_arn = aws_iam_policy.ecr_push.arn
  role       = aws_iam_role.codebuild.name
}

## --------------------------------------------------------------------------------------------------------------------
