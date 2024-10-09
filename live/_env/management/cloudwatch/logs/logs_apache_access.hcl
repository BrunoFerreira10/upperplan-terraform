locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.env

  config = {
    common = {
      name = "/ecs/apache_access"
    }
  }

  default_config  = local.config.common
  selected_config = lookup(local.config, local.env, local.default_config)
  skip            = lookup(local.selected_config, "skip", lookup(local.default_config, "skip", null))
}

inputs = {
  name = lookup(local.selected_config, "name",
         lookup(local.default_config, "name", null))
}