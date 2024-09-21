## ---------------------------------------------------------------------------------------------------------------------
## SES Domain Identity - Identidade de Domínio SES
## ---------------------------------------------------------------------------------------------------------------------
resource "aws_ses_domain_identity" "this" {
  domain = var.email_domain
}

## ---------------------------------------------------------------------------------------------------------------------
## SES Domain DKIM - Politica de autenticação de e-mails
## ---------------------------------------------------------------------------------------------------------------------
resource "aws_ses_domain_dkim" "this" {
  domain = aws_ses_domain_identity.this.domain
}

## ---------------------------------------------------------------------------------------------------------------------
## Configuração de regras de recebimento de e-mails
## ---------------------------------------------------------------------------------------------------------------------
resource "aws_ses_receipt_rule_set" "this" {
  rule_set_name = "${var.shortname}-rule-set"
}

resource "aws_ses_receipt_rule" "this" {
  rule_set_name = aws_ses_receipt_rule_set.this.rule_set_name
  name          = "${var.shortname}-rule-suporte-inbox"
  recipients    = ["suporte@${var.email_domain}"]
  enabled       = true
  scan_enabled  = true
}

## ---------------------------------------------------------------------------------------------------------------------
## Configura SES para enviar e-mails
## ---------------------------------------------------------------------------------------------------------------------
resource "aws_ses_domain_identity_verification" "this" {
  domain = aws_ses_domain_identity.this.domain
}

## ---------------------------------------------------------------------------------------------------------------------