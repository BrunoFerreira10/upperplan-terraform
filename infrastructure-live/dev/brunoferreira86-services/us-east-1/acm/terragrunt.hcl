include {
  path = find_in_parent_folders()
}

locals {
  module_base_path = read_terragrunt_config(find_in_parent_folders("live.hcl")).locals.module_base_path
  github_vars_mock = read_terragrunt_config(find_in_parent_folders("live.hcl")).locals.github_vars_mock
  env =  read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.env
}

terraform {
  source = "${local.module_base_path}/security/acm//generic_acm"
}

inputs = {
  env       = local.env
  shortname = local.github_vars_mock.general_tag_shortname
  acm_configuration = {
    domain     = local.github_vars_mock.rt53_domain
    subdomains = ["www", "test-987fskjhfd9"]
  }
}