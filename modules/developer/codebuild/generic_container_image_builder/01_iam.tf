## ---------------------------------------------------------------------------------------------------------------------
## Codebuild Role
## ---------------------------------------------------------------------------------------------------------------------

## -- Policies ---------------------------------------------------------------------------------------------------------
resource "aws_iam_policy" "connections" {
  name = "CodeBuildCodeConnectionsSourceCredentialsPolicy-${var.shortname}-${var.region}"
  path = "/TerraformManaged/"
  description = "Policy used in trust relationship with CodeBuild and ${var.shortname} application"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "codestar-connections:GetConnectionToken",
          "codestar-connections:GetConnection",
          "codeconnections:GetConnectionToken",
          "codeconnections:GetConnection"
        ],
        "Resource" : [
          data.aws_codestarconnections_connection.github_app_connection.arn
        ]
      }
    ]
  })
}

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
          "ecr:GetAuthorizationToken",
          "ecr:InitiateLayerUpload",
          "logs:*",
          "s3:*"
        ],
        "Resource" : "*"
      }
    ]
  })

  tags = {
    Name = "Prod-ECRPush-${var.shortname}-${var.region}"
  }
}

resource "aws_iam_policy" "start_build" {
  name        = "StartBuild-${var.shortname}-${var.region}"
  description = "Permissão para CodeBuild iniciar outro build via AWS CLI."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = [
          "arn:aws:codebuild:${var.region}:${data.aws_caller_identity.current.account_id}:project/${var.shortname}-app",
          "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/*"
        ]
      }
    ]
  })
}

## -- Role -------------------------------------------------------------------------------------------------------------
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
    Name = "prod-ecr-push-${var.shortname}"
  }
}

## -- Attach policies to roles -----------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "connections_to_codebuild" {
  policy_arn = aws_iam_policy.connections.arn
  role       = aws_iam_role.codebuild.name
}

resource "aws_iam_role_policy_attachment" "ecr_push_to_codebuild" {
  policy_arn = aws_iam_policy.ecr_push.arn
  role       = aws_iam_role.codebuild.name
}

resource "aws_iam_role_policy_attachment" "start_build_to_codebuild" {
  policy_arn = aws_iam_policy.start_build.arn
  role       = aws_iam_role.codebuild.name
}

## ---------------------------------------------------------------------------------------------------------------------