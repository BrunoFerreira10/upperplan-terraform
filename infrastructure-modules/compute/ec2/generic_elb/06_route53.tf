resource "aws_route53_record" "A" {

  allow_overwrite = true
  zone_id         = data.aws_route53_zone.this.zone_id
  name            = var.domain
  type            = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {

  allow_overwrite = true
  zone_id         = data.aws_route53_zone.this.zone_id
  name            = "www.${var.domain}"
  type            = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}