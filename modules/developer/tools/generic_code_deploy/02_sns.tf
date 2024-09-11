# Criação do tópico SNS para receber notificações do S3
resource "aws_sns_topic" "s3_deployment_notifications" {
  name = "s3-deployment-notifications"
}

# Adiciona uma política ao tópico SNS para permitir que o S3 publique mensagens nele
resource "aws_sns_topic_policy" "allow_s3_publish" {
  arn    = aws_sns_topic.s3_deployment_notifications.arn
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "s3.amazonaws.com"
        },
        Action = "SNS:Publish",
        Resource = aws_sns_topic.s3_deployment_notifications.arn,
        Condition = {
          ArnLike = {
            "aws:SourceArn": "arn:aws:s3:::${data.aws_s3_bucket.project_bucket_name.id}"
          }
        }
      }
    ]
  })
}

# Configuração de notificações do bucket S3 para enviar mensagens ao SNS
resource "aws_s3_bucket_notification" "s3_bucket_notifications" {
  bucket = data.aws_s3_bucket.project_bucket_name.id  # Corrigido para usar o ID do bucket S3 referenciado

  topic {
    topic_arn = aws_sns_topic.s3_deployment_notifications.arn  # Referencia o tópico SNS criado
    events    = ["s3:ObjectCreated:*"]

    filter_prefix = "code_deploy_outputs/"  # Modifique conforme necessário
    filter_suffix = "build.zip"
  }
}
