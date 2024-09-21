module "ses" {
  source              = "../modules/business/ses/generic_ses"
  email_domain        = module.data.github_vars.ses_email_domain
  glpi_api_url        = module.data.github_vars.glpi_api_url
  glpi_app_token      = module.data.github_vars.glpi_app_token
  glpi_password       = module.data.github_vars.glpi_password
  glpi_username       = module.data.github_vars.glpi_username
  project_bucket_name = module.data.github_vars.general_project_bucket_name
  region              = module.data.github_vars.general_region
  shortname           = module.data.github_vars.general_tag_shortname
}
