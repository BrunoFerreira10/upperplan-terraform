include "root" {
  path = "${get_repo_root()}/terragrunt.hcl"
  expose = true
}

include "mock" {
  path = "${get_repo_root()}/mock.hcl"
  expose = true
}

terraform {
  source    = "${include.root.locals.module_base_path}/business/ses//generic_ses"
}

dependency "s3" {
  config_path  = "../s3"
  // skip_outputs = true

  mock_outputs_allowed_terraform_commands = ["validate","plan","destroy"]
  mock_outputs = include.mock.locals.s3
}

inputs = {
  email_domain        = include.root.locals.github_vars_mock.ses_email_domain
  env                 = include.root.locals.env
  glpi_api_url        = include.root.locals.github_vars_mock.glpi_api_url
  glpi_username       = include.root.locals.github_vars_mock.glpi_username
  project_bucket      = dependency.s3.outputs.bucket
  region              = include.root.locals.region
  shortname           = include.root.locals.github_vars_mock.general_tag_shortname
}