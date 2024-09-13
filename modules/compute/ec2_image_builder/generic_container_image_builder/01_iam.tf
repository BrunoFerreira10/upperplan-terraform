## ---------------------------------------------------------------------------------------------------------------------
## Codebuild ECR Push Role
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

## --------------------------------------------------------------------------------------------------------------------
## Lambda policies and role
## --------------------------------------------------------------------------------------------------------------------
resource "aws_iam_policy" "lambda_codedeploy_policy" {
  name        = "LambdaCodeDeployPolicy-${var.shortname}-${var.region}"
  path        = "/TerraformManaged/"
  description = "Policy to allow Lambda function to trigger CodeDeploy for ${var.shortname}"

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
  name = "LambdaCodeDeployRole-${var.shortname}"

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

## ---------------------------------------------------------------------------------------------------------------------
## Codedeploy ECS Deploy Role
## ---------------------------------------------------------------------------------------------------------------------

## -- Policies ---------------------------------------------------------------------------------------------------------

resource "aws_iam_policy" "ecs_deploy" {

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecs:UpdateService",
          "ecs:RegisterTaskDefinition",
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:ListTasks",
          "ecs:StopTask",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:ModifyListener",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:PutMetricAlarm",
          "iam:PassRole"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "codedeploy:CreateDeployment",
          "codedeploy:GetApplication",
          "codedeploy:GetDeployment",
          "codedeploy:RegisterApplicationRevision"
        ],
        Resource = "*"
      }
    ]
  })
}


## -- Role -------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "codedeploy" {
  name = "codedeploy-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codedeploy.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

## -- Attach policies to roles -----------------------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "ecr_deploy_to_codedeploy" {
  policy_arn = aws_iam_policy.ecs_deploy.arn
  role       = aws_iam_role.codedeploy.name
}

## ---------------------------------------------------------------------------------------------------------------------
