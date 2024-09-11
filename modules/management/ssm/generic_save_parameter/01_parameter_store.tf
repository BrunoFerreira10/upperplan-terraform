resource "aws_ssm_parameter" "ssm_secrets" {
  count    = var.is_secure ? 1 : 0
  name     = var.param_name
  type     = "SecureString"
  value    = var.param_name
}

resource "aws_ssm_parameter" "ssm_vars" {  
  count    = !var.is_secure ? 1 : 0
  name     = var.param_name
  type     = "String"
  value    = var.param_value
}