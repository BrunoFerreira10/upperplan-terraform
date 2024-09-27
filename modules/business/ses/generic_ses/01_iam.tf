## ---------------------------------------------------------------------------------------------------------------------
## IAM Role e Política para Lambda
## ---------------------------------------------------------------------------------------------------------------------

# - Criação da Role para Lambda executar com permissão de acesso ao SES e S3 -------------------------------------------
resource "aws_iam_role" "lambda_ses_role" {
  name = "${var.shortname}-lambda-ses-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# - Definição da Política de Acesso ------------------------------------------------------------------------------------
resource "aws_iam_policy" "lambda_ses_policy" {
  name        = "${var.shortname}-lambda-ses-policy"
  description = "Permite Lambda acessar SES, CloudWatch Logs e S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail",
          "ses:ReceiveEmail"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        Resource = "arn:aws:s3:::${var.project_bucket_name}/*"
      }
    ]
  })
}

# - Vinculação da Política à Role --------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "lambda_ses_policy_attachment" {
  role       = aws_iam_role.lambda_ses_role.name
  policy_arn = aws_iam_policy.lambda_ses_policy.arn
}

## ---------------------------------------------------------------------------------------------------------------------
## IAM - Usuário e Políticas para SES (Envio de E-mails via SMTP)
## ---------------------------------------------------------------------------------------------------------------------

# Criar o usuário IAM para o SES
resource "aws_iam_user" "ses_smtp_user" {
  name          = "ses-smtp-user-${var.shortname}"
  force_destroy = true
}

# Adicionar a política para permitir o envio de e-mails via SES
resource "aws_iam_user_policy" "ses_smtp_user_policy" {
  name = "SES-SMTP-UserPolicy-${var.shortname}-${var.region}"
  user = aws_iam_user.ses_smtp_user.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ],
        Resource = "*"
      }
    ]
  })
}

# Criar as credenciais de acesso (Access Key e Secret Key) para o usuário e salva no ssm.
resource "aws_iam_access_key" "ses_smtp_access_key" {
  user = aws_iam_user.ses_smtp_user.name
}
## ---------------------------------------------------------------------------------------------------------------------
