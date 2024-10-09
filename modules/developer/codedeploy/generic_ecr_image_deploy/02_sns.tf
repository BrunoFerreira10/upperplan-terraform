## ---------------------------------------------------------------------------------------------------------------------
## SNS Topic - Recebe notificações de novo Dockerfile no S3
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_sns_topic" "s3_deployment_notifications" {
  name = "${var.env}_s3_app_image_build_${var.shortname}"
}

resource "aws_sns_topic_policy" "allow_s3_publish" {
  arn = aws_sns_topic.s3_deployment_notifications.arn
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "s3.amazonaws.com"
        },
        Action   = "SNS:Publish",
        Resource = aws_sns_topic.s3_deployment_notifications.arn,
        Condition = {
          ArnLike = {
            "aws:SourceArn" : "arn:aws:s3:::${var.project_bucket.bucket}"
          }
        }
      }
    ]
  })
}

## ---------------------------------------------------------------------------------------------------------------------
## S3 Bucket Notification - Gera notificações de novo Dockerfile no S3
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket_notification" "s3_bucket_notifications" {
  bucket = var.project_bucket.id # Corrigido para usar o ID do bucket S3 referenciado

  topic {
    topic_arn = aws_sns_topic.s3_deployment_notifications.arn # Referencia o tópico SNS criado
    events    = ["s3:ObjectCreated:*"]

    filter_prefix = "code_build_outputs/"
    filter_suffix = "${var.env}_app_build.zip"
  }
}
## ---------------------------------------------------------------------------------------------------------------------