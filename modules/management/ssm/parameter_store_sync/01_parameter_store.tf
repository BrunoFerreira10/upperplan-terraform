resource "aws_ssm_parameter" "ssm_secrets" {
  for_each = var.github_secrets
  name     = "/${var.shortname}/prod/github_secrets/${lower(each.key)}"
  type     = "SecureString"
  value    = each.value

}

resource "aws_ssm_parameter" "ssm_vars" {
  for_each = var.github_vars
  name     = "/${var.shortname}/prod/github_vars/${lower(each.key)}"
  type     = "String"
  value    = each.value
}