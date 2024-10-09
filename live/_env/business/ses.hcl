locals {
  env              = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.env
  github_vars_mock = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.github_vars_mock
  mock             = read_terragrunt_config(find_in_parent_folders("mock.hcl")).locals

  config = {
    common = {
      email_domain    = local.github_vars_mock.ses_email_domain
      glpi_api_url    = local.github_vars_mock.glpi_api_url
      glpi_username   = local.github_vars_mock.glpi_username
    }

    dev = {
      email_subdomain = "dev."
    }

    prod = {
      email_subdomain = ""
      skip            = false
    }
  }

  default_config  = local.config.common
  selected_config = lookup(local.config, local.env, local.default_config)
  skip            = lookup(local.selected_config, "skip", lookup(local.default_config, "skip", null))
}

dependency "s3" {
  config_path = "${get_terragrunt_dir()}/../../storage/s3"

  mock_outputs_allowed_terraform_commands = ["validate","plan","destroy"]
  mock_outputs                            = local.mock.s3
}

inputs = {
  project_bucket  = dependency.s3.outputs.bucket

  email_domain = lookup(local.selected_config, "email_domain",
                 lookup(local.default_config, "email_domain", null))

  email_subdomain = lookup(local.selected_config, "email_subdomain",
                    lookup(local.default_config, "email_subdomain", null))

  glpi_api_url = lookup(local.selected_config, "glpi_api_url",
                 lookup(local.default_config, "glpi_api_url", null))

  glpi_username = lookup(local.selected_config, "glpi_username",
                  lookup(local.default_config, "glpi_username", null))
}