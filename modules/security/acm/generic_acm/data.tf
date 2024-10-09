# TODO - Verificar melhorias para evitar o data aqui.
data "aws_route53_zone" "zone" {
  name         = var.acm_configuration.hosted_zone
  private_zone = false
}