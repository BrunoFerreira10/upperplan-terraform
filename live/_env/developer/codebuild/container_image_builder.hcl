locals {
  env              = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.env
  github_vars_mock = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.github_vars_mock
  mock             = read_terragrunt_config(find_in_parent_folders("mock.hcl")).locals

  config = {
    common = {
      buildspec_file_name = "container-buildspec.yml.tpl"
      ecr_base_repository = {
        repository_url = "public.ecr.aws/ubuntu/ubuntu:24.10" # Adaptado para manter padrão do objeto
      }
      github_connection_name = local.github_vars_mock.my_github_connection_name
      project_name           = "container"
      repository_url_https   = local.github_vars_mock.container_repository_url_https
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

dependency "ecr" {
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
  ecr_repository = dependency.ecr.outputs.repository
  project_bucket = dependency.s3.outputs.bucket

  buildspec_file_name = lookup(local.selected_config, "buildspec_file_name",
                        lookup(local.default_config, "buildspec_file_name", null))

  ecr_base_repository = lookup(local.selected_config, "ecr_base_repository",
                        lookup(local.default_config, "ecr_base_repository", null))

  github_connection_name = lookup(local.selected_config, "github_connection_name",
                          lookup(local.default_config, "github_connection_name", null))

  project_name = lookup(local.selected_config, "project_name",
                 lookup(local.default_config, "project_name", null))

  repository_url_https = lookup(local.selected_config, "repository_url_https",
                        lookup(local.default_config, "repository_url_https", null))

  trigger_branch = lookup(local.selected_config, "trigger_branch",
                   lookup(local.default_config, "trigger_branch", null))
}