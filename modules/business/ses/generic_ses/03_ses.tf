## ---------------------------------------------------------------------------------------------------------------------
## SES - Configuração do SES para recebimento de e-mails e integração com a Lambda
## ---------------------------------------------------------------------------------------------------------------------

# - Identidade do domínio no SES ---------------------------------------------------------------------------------------
resource "aws_ses_domain_identity" "this" {
  domain = "${var.email_subdomain}${var.email_domain}"
}

# - Autenticação e criptografia segura para o email --------------------------------------------------------------------
resource "aws_ses_domain_dkim" "this" {
  domain = aws_ses_domain_identity.this.domain
}

# - Verificação do domínio SES -----------------------------------------------------------------------------------------
resource "aws_ses_domain_identity_verification" "this" {
  domain     = aws_ses_domain_identity.this.domain
  depends_on = [aws_ses_domain_identity.this]
}

# - Conjunto de regras de recebimento de e-mails -----------------------------------------------------------------------
resource "aws_ses_receipt_rule_set" "this" {
  rule_set_name = "${var.env}-${var.shortname}-rule-set"
}

# - Regra de recebimento de e-mails - Acionando a Lambda ---------------------------------------------------------------
resource "aws_ses_receipt_rule" "this" {
  rule_set_name = aws_ses_receipt_rule_set.this.rule_set_name
  name          = "${var.env}-${var.shortname}-active-receipt-rule"
  recipients    = ["suporte@${aws_ses_domain_identity.this.domain}"]
  enabled       = true
  scan_enabled  = true

  # Ação para acionar a Lambda quando um e-mail for recebido
  lambda_action {
    function_arn    = aws_lambda_function.create_ticket.arn
    invocation_type = "Event"
    position        = 1
  }

  # Armazenar o e-mail recebido no S3 (opcional)
  s3_action {
    bucket_name       = var.project_bucket.bucket
    object_key_prefix = "${var.env}-emails/inbox-suporte/"
    position          = 2
  }

  depends_on = [
    aws_s3_bucket_policy.ses_bucket_policy,
    null_resource.workaround_aws_ses_receipt_rule
  ]
}

# - Ativar o conjunto de regras de recebimento ------------------------------------------------------------------------
resource "aws_ses_active_receipt_rule_set" "this" {
  rule_set_name = aws_ses_receipt_rule_set.this.rule_set_name
}