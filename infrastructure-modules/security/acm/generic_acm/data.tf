# TODO - Verificar melhorias para evitar o data aqui.
data "aws_route53_zone" "zone" {
  name         = var.acm_configuration.domain
  private_zone = false
}