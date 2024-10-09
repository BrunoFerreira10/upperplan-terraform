locals {
  env              = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.env
  github_vars_mock = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.github_vars_mock

  config = {
    common = {
    }

    dev = {
      acm_configuration = {
        domain      = "dev-n0001.${local.github_vars_mock.rt53_domain}"
        hosted_zone = "${local.github_vars_mock.rt53_domain}"
      }
    }

    prod = {
      acm_configuration = {
        domain      = "${local.github_vars_mock.rt53_domain}"
        hosted_zone = "${local.github_vars_mock.rt53_domain}"
        subdomains  = ["www"]
      }
    }
  }

default_config  = local.config.common
selected_config = lookup(local.config, local.env, local.default_config)
skip            = lookup(local.selected_config, "skip", lookup(local.default_config, "skip", null))
}

inputs = {
  acm_configuration = lookup(local.selected_config, "acm_configuration",
                      lookup(local.default_config, "acm_configuration", null))
}