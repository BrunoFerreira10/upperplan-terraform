data "aws_route53_zone" "this" {
  name         = var.email_domain
  private_zone = false
}