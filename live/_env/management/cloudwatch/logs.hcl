locals {
  env              = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.env
  github_vars_mock = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.github_vars_mock

  config = {
    common = {
    }

    dev = {
      retention_in_days = 1
    }

    prod = {
      retention_in_days = 7
    }
  }

  default_config  = local.config.common
  selected_config = lookup(local.config, local.env, local.default_config)
  skip            = lookup(local.selected_config, "skip", lookup(local.default_config, "skip", null))
}

inputs = {
  retention_in_days = lookup(local.selected_config, "retention_in_days",
                      lookup(local.default_config, "retention_in_days", null))
}