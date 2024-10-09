include {
  path = find_in_parent_folders()
}

terraform {
  source    = "${local.root.module_base_path}/management/ssm//generic_save_parameter"
}

locals {
  github_vars_mock = yamldecode(file("${find_in_parent_folders("github_vars_mock.yaml")}"))
}

dependency "ses" {
  config_path = find_in_parent_folders("../../ses")
}

inputs = {
  param_name  = "/${local.github_vars_mock.values.general_tag_shortname}/prod/app_vars/ses-user/access-key-id"
  param_value = dependency.ses.outputs.ses_user_access_key_id
}