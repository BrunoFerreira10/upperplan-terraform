module "ses" {
  source                   = "../modules/business/ses/generic_ses"
  email_domain             = module.data.github_vars.ses_email_domain
  project_bucket_name      = module.data.github_vars.general_project_bucket_name
  region                   = module.data.github_vars.general_region
  shortname                = module.data.github_vars.general_tag_shortname
}