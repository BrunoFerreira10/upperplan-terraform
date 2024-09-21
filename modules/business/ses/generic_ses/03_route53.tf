## ---------------------------------------------------------------------------------------------------------------------
## Registro DNS para verificação do domínio
## ---------------------------------------------------------------------------------------------------------------------
resource "aws_route53_record" "ses_verification_record" {
  zone_id = aws_route53_zone.this.id
  name = "${aws_ses_domain_identity.this.domain}"
  type    = "TXT"
  ttl     = 60
  records = [aws_ses_domain_identity.this.verification_token]
}

resource "aws_route53_record" "mx_record" {
  zone_id = data.aws_route53_zone.this.id
  name    = "${var.email_domain}"
  type    = "MX"
  ttl     = 60
  records = ["10 inbound-smtp.${var.region}.amazonaws.com."]
}

resource "aws_route53_record" "spf_record" {
  zone_id = data.aws_route53_zone.this.id
  name    = "${var.email_domain}"
  type    = "TXT"
  ttl     = 60
  records = ["v=spf1 include:amazonses.com ~all"]
}

## ---------------------------------------------------------------------------------------------------------------------