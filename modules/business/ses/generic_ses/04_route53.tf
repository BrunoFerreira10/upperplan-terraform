## ---------------------------------------------------------------------------------------------------------------------
## Route 53 - Configurações DNS para integração do domínio com o SES
## ---------------------------------------------------------------------------------------------------------------------

# - Registro TXT para verificação do domínio SES -----------------------------------------------------------------------
resource "aws_route53_record" "ses_verification" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "_amazonses.${aws_ses_domain_identity.this.domain}"
  type    = "TXT"
  ttl     = 60
  records = [aws_ses_domain_identity.this.verification_token]
}

# - Registros CNAME para configuração DKIM  ----------------------------------------------------------------------------
resource "aws_route53_record" "dkim" {
  count   = 3
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "${element(aws_ses_domain_dkim.this.dkim_tokens, count.index)}._domainkey.${aws_ses_domain_identity.this.domain}"
  type    = "CNAME"
  ttl     = 60
  records = [element(aws_ses_domain_dkim.this.dkim_tokens, count.index)]
}

# - Registro MX para receber e-mails pelo SES --------------------------------------------------------------------------
resource "aws_route53_record" "mx" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = aws_ses_domain_identity.this.domain
  type    = "MX"
  ttl     = 60
  records = ["10 inbound-smtp.${var.region}.amazonaws.com."]
}

# - Registro SPF para permitir envio de e-mails pelo SES ----------------------------------------------------------------
resource "aws_route53_record" "spf" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = aws_ses_domain_identity.this.domain
  type    = "TXT"
  ttl     = 60
  records = ["v=spf1 include:amazonses.com ~all"]
}
