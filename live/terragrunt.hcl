locals {
  config_path      = "${get_repo_root()}/live/_env"
  live_path        = "${get_repo_root()}/live"
  modules_path     = "${get_repo_root()}/modules"
  relative_path    = path_relative_to_include()
  
  path_components  = split("/", local.relative_path)
  account_folder   = local.path_components[0]
  region           = local.path_components[1]
  env              = local.path_components[2]

  account          = read_terragrunt_config("${local.live_path}/${local.account_folder}/account.hcl").locals.account
  github_vars_mock = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.github_vars_mock
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = templatefile("${get_repo_root()}/live/templates/provider.tf.tmpl", {
    profile            = local.account.profile
    region             = local.region
    env                = local.env
    author             = local.github_vars_mock.general_tag_author
    customer           = local.github_vars_mock.general_tag_customer
    project            = local.github_vars_mock.general_tag_project
  })
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = replace("env_${local.github_vars_mock.general_tag_shortname}_${local.account.sid}", "_", "-")
    key            = "remote_states/${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    profile        = local.account.profile
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

inputs = {
  account   = local.account
  env       = local.env
  region    = local.region
  shortname = local.github_vars_mock.general_tag_shortname
}