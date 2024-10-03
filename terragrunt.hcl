locals {
  module_base_path = "${get_repo_root()}/infrastructure-modules"
  relative_path = path_relative_to_include()
  path_components = split("/", local.relative_path)
  env         = local.path_components[1]
  profile     = local.path_components[2]
  region      = local.path_components[3]

  # Path sem o 'infrastructure-live' e sem o profile
  adjusted_path_arr = concat([local.env], slice(local.path_components, 3, length(local.path_components)))
  adjusted_path     = join("/", local.adjusted_path_arr)

  github_vars_mock = read_terragrunt_config("${get_repo_root()}/root.hcl").locals.github_vars_mock
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = templatefile("${get_repo_root()}/templates/provider.tf.tmpl", {
    region             = local.region
    profile            = local.profile
    author             = local.github_vars_mock.general_tag_author
    customer           = local.github_vars_mock.general_tag_customer
    project            = local.github_vars_mock.general_tag_project
    env                = local.env
  })
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = replace("env_${local.github_vars_mock.general_tag_shortname}_${local.profile}", "_", "-")
    key            = "remote_states/${local.adjusted_path}/terraform.tfstate"
    region         = local.region
    profile        = local.profile
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

terraform {
  extra_arguments "vars" {
    commands = [
      "plan",
      "apply",
      "destroy",
    ]

    optional_var_files = [
      "${get_terragrunt_dir()}/local_vars.tfvars",
    ]    
  }
}