data "aws_route53_zone" "this" {
  name         = var.domain
  private_zone = false
}

data "aws_ssm_parameter" "db_password" {
  name = "/github_secrets/${var.rds.ssm_parameter_db_password}"
}