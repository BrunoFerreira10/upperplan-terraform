## ---------------------------------------------------------------------------------------------------------------------
## Codebuild Role
## ---------------------------------------------------------------------------------------------------------------------

## -- Policies ---------------------------------------------------------------------------------------------------------
resource "aws_iam_policy" "connections" {
  name = "Prod-GetConnection-${var.shortname}-${var.project_name}-${var.region}"
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

resource "aws_iam_policy" "ecr_get_and_push" {
  name        = "Prod-ECRPush-${var.shortname}-${var.project_name}-${var.region}"
  path        = "/TerraformManaged/"
  description = "Allow to push images to ECR"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:BatchGetImage",
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
    Name = "Prod-ECRPush-${var.shortname}-${var.project_name}-${var.region}"
  }
}

resource "aws_iam_policy" "start_build" {
  name        = "Prod-StartBuild-${var.shortname}-${var.project_name}-${var.region}"
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

resource "aws_iam_policy" "ssm_read" {
  name        = "Prod-SSMRead-${var.shortname}-${var.project_name}-${var.region}"
  description = "Permissão para CodeBuild ler dados do parameter store."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ],
        Resource = [
          "*"
        ]
      }
    ]
  })
}

## -- Role -------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "codebuild" {
  name = "Prod-CodeBuild-${var.shortname}-${var.project_name}-${var.region}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "codebuild.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "Prod-CodeBuild-${var.shortname}-${var.project_name}-${var.region}"
  }
}

## -- Attach policies to roles -----------------------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "connections_to_codebuild" {
  policy_arn = aws_iam_policy.connections.arn
  role       = aws_iam_role.codebuild.name
}

resource "aws_iam_role_policy_attachment" "ecr_get_and_push_to_codebuild" {
  policy_arn = aws_iam_policy.ecr_get_and_push.arn
  role       = aws_iam_role.codebuild.name
}

resource "aws_iam_role_policy_attachment" "start_build_to_codebuild" {
  policy_arn = aws_iam_policy.start_build.arn
  role       = aws_iam_role.codebuild.name
}

resource "aws_iam_role_policy_attachment" "ssm_read_to_codebuild" {
  policy_arn = aws_iam_policy.ssm_read.arn
  role       = aws_iam_role.codebuild.name
}

## ---------------------------------------------------------------------------------------------------------------------