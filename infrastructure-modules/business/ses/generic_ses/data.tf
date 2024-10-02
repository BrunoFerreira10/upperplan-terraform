# - Busca do ID da conta AWS atual -------------------------------------------------------------------------------------
data "aws_caller_identity" "current" {}

# - Busca da zona DNS no Route 53 --------------------------------------------------------------------------------------
data "aws_route53_zone" "this" {
  name         = var.email_domain
  private_zone = false
}

# - Busca senha e APP_TOKEN do GLPI no SSM -----------------------------------------------------------------------------
data "aws_ssm_parameter" "glpi_password" {
  name = "/${var.shortname}/prod/github_secrets/glpi_password"
}
data "aws_ssm_parameter" "glpi_app_token" {
  name = "/${var.shortname}/prod/github_secrets/glpi_app_token"
}