locals {
  account          = read_terragrunt_config(find_in_parent_folders("account.hcl")).locals.account
  env              = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.env
  github_vars_mock = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.github_vars_mock
  region           = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals.region

  config = {
    common = {
      bucket_name = replace("${local.env}_${local.github_vars_mock.general_tag_shortname}_${local.account.sid}_${local.region}", "_", "-")
    }

    dev = {
      force_destroy = true
    }

    prod = {
      force_destroy = true
    }
  }

  default_config  = local.config.common
  selected_config = lookup(local.config, local.env, local.default_config)
  skip            = lookup(local.selected_config, "skip", lookup(local.default_config, "skip", null))
}

inputs = {
  bucket_name = lookup(local.selected_config, "bucket_name",
                lookup(local.default_config, "bucket_name", null))

  force_destroy = lookup(local.selected_config, "force_destroy",
                  lookup(local.default_config, "force_destroy", null))
}