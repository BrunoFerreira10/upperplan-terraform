locals {
  env              = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.env
  mock             = read_terragrunt_config(find_in_parent_folders("mock.hcl")).locals

  config = {
    common = {
    }
    dev = {
      skip = false
    }

    prod = {
      skip = false
    }
  }

  default_config  = local.config.common
  selected_config = lookup(local.config, local.env, local.default_config)
  skip            = lookup(local.selected_config, "skip", lookup(local.default_config, "skip", null))
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../vpc"
  
  mock_outputs_allowed_terraform_commands = ["validate","plan","destroy"]
  mock_outputs                            = local.mock.vpc
}

inputs = {
  vpc           = dependency.vpc.outputs.vpc
  public_subnet = dependency.vpc.outputs.vpc.subnets.public.az_a
}