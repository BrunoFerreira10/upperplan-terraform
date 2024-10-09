locals {
  env              = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.env
  github_vars_mock = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.github_vars_mock
  mock             = read_terragrunt_config(find_in_parent_folders("mock.hcl")).locals

  config = {
    common = {
      artifact_file_name     = "${local.env}_app_build.zip"
      buildspec_file_name    = "app-buildspec.yml.tpl"
      github_connection_name = local.github_vars_mock.my_github_connection_name
      project_name           = "app"
      repository_url_https   = local.github_vars_mock.app_repository_url_https
    }

    dev = {
      trigger_branch = "dev"
    }

    prod = {
      trigger_branch = "master"
    }
  }

default_config  = local.config.common
selected_config = lookup(local.config, local.env, local.default_config)
skip            = lookup(local.selected_config, "skip", lookup(local.default_config, "skip", null))
}

dependency "ecr_app" {
  config_path = "${get_terragrunt_dir()}/../../../container/repositories/app_repository"

  mock_outputs_allowed_terraform_commands = ["validate","plan","destroy"]
  mock_outputs                            = local.mock.ecr
}

dependency "ecr_container" {
  config_path = "${get_terragrunt_dir()}/../../../container/repositories/container_repository"

  mock_outputs_allowed_terraform_commands = ["validate","plan","destroy"]
  mock_outputs                            = local.mock.ecr
}

dependency "s3" {
  config_path = "${get_terragrunt_dir()}/../../../storage/s3"

  mock_outputs_allowed_terraform_commands = ["validate","plan","destroy"]
  mock_outputs                            = local.mock.s3
}

inputs = {
  ecr_base_repository = dependency.ecr_container.outputs.repository
  ecr_repository = dependency.ecr_app.outputs.repository
  project_bucket = dependency.s3.outputs.bucket

  artifact_file_name = lookup(local.selected_config, "artifact_file_name",
                       lookup(local.default_config, "artifact_file_name", null))

  buildspec_file_name = lookup(local.selected_config, "buildspec_file_name",
                        lookup(local.default_config, "buildspec_file_name", null))

  github_connection_name = lookup(local.selected_config, "github_connection_name",
                          lookup(local.default_config, "github_connection_name", null))

  project_name = lookup(local.selected_config, "project_name",
                 lookup(local.default_config, "project_name", null))

  repository_url_https = lookup(local.selected_config, "repository_url_https",
                        lookup(local.default_config, "repository_url_https", null))

  trigger_branch = lookup(local.selected_config, "trigger_branch",
                   lookup(local.default_config, "trigger_branch", null))
}