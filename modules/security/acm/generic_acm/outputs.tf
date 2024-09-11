output "certificate" {
  description = "ACM Certificate information"
  value = {
    id          = aws_acm_certificate.certificate.id
    arn         = aws_acm_certificate.certificate.arn
    domain_name = aws_acm_certificate.certificate.domain_name
  }
}
