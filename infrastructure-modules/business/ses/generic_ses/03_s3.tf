## ---------------------------------------------------------------------------------------------------------------------
## Politica do bucket S3 para permitir que o SES envie e-mails para o bucket
## ---------------------------------------------------------------------------------------------------------------------

locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket_policy" "ses_bucket_policy" {
  bucket = var.project_bucket.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AllowSESPuts",
        "Effect": "Allow",
        "Principal": {
          "Service": "ses.amazonaws.com"
        },
        "Action": "s3:PutObject",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.ses_bucket.id}/*",
        "Condition": {
          "StringEquals": {
            "AWS:SourceAccount": "${local.account_id}"
            # "AWS:SourceArn": "arn:aws:ses:${var.region}:${local.account_id}:receipt-rule-set/${var.rule_set_name}:receipt-rule/${var.receipt_rule_name}"
          }
        }
      }
    ]
  })
}

## ---------------------------------------------------------------------------------------------------------------------
