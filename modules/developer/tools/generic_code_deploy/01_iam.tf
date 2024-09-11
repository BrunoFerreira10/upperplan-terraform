## --------------------------------------------------------------------------------------------------------------------
## Lambda policies and role
## --------------------------------------------------------------------------------------------------------------------
resource "aws_iam_policy" "lambda_codedeploy_policy" {
  name        = "LambdaCodeDeployPolicy-${var.codedeploy_settings.application_name}-${var.region}"
  path        = "/TerraformManaged/"
  description = "Policy to allow Lambda function to trigger CodeDeploy for ${var.codedeploy_settings.application_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Action": [
          "codedeploy:GetDeploymentConfig",
          "codedeploy:GetApplicationRevision",
          "codedeploy:CreateDeployment",
          "codedeploy:RegisterApplicationRevision"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject"
        ],
        "Resource": "arn:aws:s3:::${var.project_bucket_name}/*"
      }
    ]
  })
}

## Lamda role
resource "aws_iam_role" "lambda_codedeploy_role" {
  name = "${var.codedeploy_settings.application_name}LambdaRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_codedeploy_attach_policy" {
  role       = aws_iam_role.lambda_codedeploy_role.name
  policy_arn = aws_iam_policy.lambda_codedeploy_policy.arn
}

## --------------------------------------------------------------------------------------------------------------------
## SNS 
## --------------------------------------------------------------------------------------------------------------------
# Documento de política IAM para permitir que o S3 publique mensagens no SNS
data "aws_iam_policy_document" "topic" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions   = ["SNS:Publish"]
    resources = [aws_sns_topic.s3_deployment_notifications.arn]  # Corrigido para referenciar o tópico SNS criado

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [data.aws_s3_bucket.project_bucket_name.arn]  # Corrigido para usar o ARN do bucket S3 referenciado
    }
  }
}

## --------------------------------------------------------------------------------------------------------------------
## CodeBuild Policies
## --------------------------------------------------------------------------------------------------------------------
resource "aws_iam_policy" "base" {
  name = "CodeBuildBasePolicy-${var.codebuild_settings.project_name}-${var.region}"
  path = "/TerraformManaged/"
  description = "Policy used in trust relationship with CodeBuild and ${var.shortname} application"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.codebuild_settings.project_name}",
          "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.codebuild_settings.project_name}:*"
        ],
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      },
      {
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:s3:::${var.project_bucket_name}",
          "arn:aws:s3:::${var.project_bucket_name}/*"
        ],
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation",
          "s3:ListBucket"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages"
        ],
        "Resource" : [
          "arn:aws:codebuild:us-east-1:${data.aws_caller_identity.current.account_id}:report-group/${var.codebuild_settings.project_name}-*"
        ]
      }
    ]
  })
}

## CodeBuildCodeConnectionsSourceCredentialsPolicy-TesteBuild-us-east-1
## Policy used in trust relationship with CodeBuild
resource "aws_iam_policy" "connections" {
  name = "CodeBuildCodeConnectionsSourceCredentialsPolicy-${var.codebuild_settings.project_name}-${var.region}"
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
          # "arn:aws:codestar-connections:us-east-1:${data.aws_caller_identity.current.account_id}:connection/48875c7b-6fdb-45e6-9bb2-74bd01d296d9",
          # "arn:aws:codeconnections:us-east-1:${data.aws_caller_identity.current.account_id}:connection/48875c7b-6fdb-45e6-9bb2-74bd01d296d9"
          data.aws_codestarconnections_connection.github_app_connection.arn
        ]
      }
    ]
  })
}


## --------------------------------------------------------------------------------------------------------------------
## CodeBuild Role
## --------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "codebuild" {
  name = "${var.codebuild_settings.project_name}RoleForCodeBuild"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_attach_base" {
  role       = aws_iam_role.codebuild.name
  policy_arn = aws_iam_policy.base.arn
}

resource "aws_iam_role_policy_attachment" "codebuild_attach_connections" {
  role       = aws_iam_role.codebuild.name
  policy_arn = aws_iam_policy.connections.arn
}

# resource "aws_iam_role_policy_attachment" "codebuild_attach_developer_access" {
#   role       = aws_iam_role.codebuild.name
#   policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
# }

## --------------------------------------------------------------------------------------------------------------------
## CodeDeploy Role
## --------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "codedeploy" {
  name = "${var.codedeploy_settings.application_name}RoleForCodeDeploy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_attach_base" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.codedeploy.name
}