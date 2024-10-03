include "root" {
  path = "${get_repo_root()}/terragrunt.hcl"
  expose = true
}

include "mock" {
  path = "${get_repo_root()}/mock.hcl"
  expose = true
}

terraform {
  source    = "${include.root.locals.module_base_path}/management/ssm//generic_save_parameter"
}

dependency "ses" {
  config_path  = "../../../ses"

  mock_outputs_allowed_terraform_commands = ["validate","plan","destroy"]
  mock_outputs = include.mock.locals.ses
}

inputs = {
  is_secure   = false
  param_name  = "/${include.root.locals.env}/${include.root.locals.github_vars_mock.general_tag_shortname}/app_vars/ses_user/smtp_password"
  param_value = dependency.ses.outputs.ses_user_access_key_id
}