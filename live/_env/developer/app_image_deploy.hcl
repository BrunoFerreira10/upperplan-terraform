locals {
  env              = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.env
  github_vars_mock = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.github_vars_mock
  mock             = read_terragrunt_config(find_in_parent_folders("mock.hcl")).locals

  config = {
    common = {
      app_repository_url_https = local.github_vars_mock.app_repository_url_https
    }
  }

default_config  = local.config.common
selected_config = lookup(local.config, local.env, local.default_config)
skip            = lookup(local.selected_config, "skip", lookup(local.default_config, "skip", null))
}

dependency "ecs" {
  config_path = "${get_terragrunt_dir()}/../../container/ecs"

  mock_outputs_allowed_terraform_commands = ["validate","plan","destroy"]
  mock_outputs                            = local.mock.ecs
}

dependency "elb" {
  config_path = "${get_terragrunt_dir()}/../../compute/elb"

  mock_outputs_allowed_terraform_commands = ["validate","plan","destroy"]
  mock_outputs                            = local.mock.elb
}

dependency "s3" {
  config_path = "${get_terragrunt_dir()}/../../storage/s3"

  mock_outputs_allowed_terraform_commands = ["validate","plan","destroy"]
  mock_outputs                            = local.mock.s3
}

inputs = {
  ecs            = dependency.ecs.outputs.ecs
  lb_listeners   = dependency.elb.outputs.lb_listeners
  project_bucket = dependency.s3.outputs.bucket
  target_groups  = dependency.elb.outputs.target_groups

  app_repository_url_https = lookup(local.selected_config, "app_repository_url_https",
                             lookup(local.default_config, "app_repository_url_https", null))
}