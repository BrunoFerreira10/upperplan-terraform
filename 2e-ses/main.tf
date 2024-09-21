module "ses" {
  source              = "../modules/business/ses/generic_ses"
  email_domain        = module.data.github_vars.ses_email_domain
  glpi_api_url        = module.data.github_vars.glpi_api_url
  glpi_username       = module.data.github_vars.glpi_username
  project_bucket_name = module.data.github_vars.general_project_bucket_name
  region              = module.data.github_vars.general_region
  shortname           = module.data.github_vars.general_tag_shortname
}

## ---------------------------------------------------------------------------------------------------------------------
## Armazenar Credenciais SMTP no SSM Parameter Store
## ---------------------------------------------------------------------------------------------------------------------

# Armazenar Access Key no SSM Parameter Store
module "save_ses_user_access_key_id" {
  source      = "../modules/management/ssm/generic_save_parameter"
  is_secure   = true
  param_name  = "/${var.general_tag_shortname}/prod/app_vars/ses-user/access-key-id"
  param_value = module.ses.ses_user_access_key_id

  depends_on = [module.ses]
}

# Armazenar Secret Access Key no SSM Parameter Store
module "save_ses_user_secret_access_key" {
  source      = "../modules/management/ssm/generic_save_parameter"
  is_secure   = true
  param_name  = "/${var.general_tag_shortname}/prod/app_vars/ses-user/secret-access-key"
  param_value = module.ses.ses_user_secret_access_key

  depends_on = [module.ses]
}
## ---------------------------------------------------------------------------------------------------------------------
