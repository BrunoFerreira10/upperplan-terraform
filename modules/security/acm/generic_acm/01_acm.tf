resource "aws_acm_certificate" "certificate" {
  domain_name       = var.acm_configuration.domain
  validation_method = "DNS"

  subject_alternative_names = [
    for subdomain in var.acm_configuration.subdomains :
    "${subdomain}.${var.acm_configuration.domain}"
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.env}_acm_certificate_${var.shortname}"
  }
}

## --------------------------------------------------------------------------------------------------------------------
## DNS Record - Certificate validation 
## --------------------------------------------------------------------------------------------------------------------
resource "aws_route53_record" "certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type

      tags = {
        Name = "${var.env}_acm_certificate_${var.shortname}_${dvo.resource_record_name}"
      }
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone.zone_id
}

resource "aws_acm_certificate_validation" "certificate-validation" {
  certificate_arn = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [
    for record in aws_route53_record.certificate_validation : record.fqdn
  ]
}
## --------------------------------------------------------------------------------------------------------------------