## ---------------------------------------------------------------------------------------------------------------------
## ECS TaskEcecutionRole
## ---------------------------------------------------------------------------------------------------------------------

## -- Policy -----------------------------------------------------------------------------------------------------------

resource "aws_iam_policy" "ecs_task_execution" {
  name        = "ECSTaskExecution-${var.shortname}-${var.region}"
  description = "Política para execução da task ECS com permissões de ECR e CloudWatch"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups"
        ]
        Resource = "*"
      }
    ]
  })
}

## -- Role -------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "ecs_task_execution" {
  name               = "ECSTaskExecution-${var.shortname}-${var.region}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ecs_task_execution.arn
}

## ---------------------------------------------------------------------------------------------------------------------
## ECS TaskRole
## ---------------------------------------------------------------------------------------------------------------------

## -- Policy -----------------------------------------------------------------------------------------------------------

resource "aws_iam_policy" "ecs_task" {
  name        = "ECSTask-${var.shortname}-${var.region}"
  description = "Política para execução da task ECS com permissões de ssm"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogGroups"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
  })
}

resource "aws_iam_policy" "ecs_s3_access" {
  name = "ECSS3Access-${var.shortname}-${var.region}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      }
    ]
  })
}

## -- Role -------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "ecs_task" {
  name               = "ECSTask-${var.shortname}-${var.region}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = aws_iam_policy.ecs_s3_access.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_attachment" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = aws_iam_policy.ecs_task.arn
}

## ---------------------------------------------------------------------------------------------------------------------

