include {
  path = find_in_parent_folders()
}

locals {
  module_base_path = read_terragrunt_config(find_in_parent_folders("live.hcl")).locals.module_base_path
  github_vars_mock = read_terragrunt_config(find_in_parent_folders("live.hcl")).locals.github_vars_mock
  env              = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.env
}

terraform {
  source    = "${local.module_base_path}/business/ses//generic_ses"
}

inputs = {
  email_domain        = local.github_vars_mock.ses_email_domain
  env                 = local.env
  glpi_api_url        = local.github_vars_mock.glpi_api_url
  glpi_username       = local.github_vars_mock.glpi_username
  project_bucket_name = local.github_vars_mock.general_project_bucket_name
  region              = local.github_vars_mock.general_region
  shortname           = local.github_vars_mock.general_tag_shortname
}