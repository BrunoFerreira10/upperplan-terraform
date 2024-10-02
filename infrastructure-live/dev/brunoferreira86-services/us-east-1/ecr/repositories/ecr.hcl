locals {
  github_vars_mock = read_terragrunt_config(find_in_parent_folders("live.hcl")).locals.github_vars_mock
  env =  read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.env
}

inputs = {
  env             = local.env
  region          = local.github_vars_mock.general_region  
  shortname       = local.github_vars_mock.general_tag_shortname
}