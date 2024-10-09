locals {
  env              = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.env
  github_vars_mock = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.github_vars_mock
  mock             = read_terragrunt_config(find_in_parent_folders("mock.hcl")).locals

  config = {
    common = {
      param_name = "/${local.env}/${local.github_vars_mock.general_tag_shortname}/app_vars/ses_user/smtp_password_v4"
    }
  }

  default_config  = local.config.common
  selected_config = lookup(local.config, local.env, local.default_config)
  skip            = lookup(local.selected_config, "skip", lookup(local.default_config, "skip", null))
}

dependency "ses" {
  config_path = "${get_terragrunt_dir()}/../../../../business/ses"

  mock_outputs_allowed_terraform_commands = ["validate","plan","destroy"]
  mock_outputs                            = local.mock.ses
}

inputs = {
  param_value = dependency.ses.outputs.ses_user_smtp_password_v4
  param_name  = lookup(local.selected_config, "param_name",
                lookup(local.default_config, "param_name", null))
}