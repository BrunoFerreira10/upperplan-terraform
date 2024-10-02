// locals {
  // github_vars_mock = read_terragrunt_config(find_in_parent_folders("live.hcl")).locals.github_vars_mock
  // region = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals.region
  // aws_cli_profile =  read_terragrunt_config(find_in_parent_folders("profile.hcl")).locals.aws_cli_profile
  // env =  read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.env
// }

locals {
  module_base_path = "${get_repo_root()}/infrastructure-modules"
  relative_path = path_relative_to_include()
  path_components = split("/", local.relative_path)
  env         = local.path_components[1]
  profile     = local.path_components[2]
  region      = local.path_components[3]

  github_vars_mock = {
    general_my_ip = "192.1.1.1",
    general_project_bucket_name = "",
    general_region = "us-east-1",
    general_tag_author = "Bruno Ferreira",
    general_tag_customer = "Upper Plan",
    general_tag_project = "GLPI",
    general_tag_shortname = "upperplan-glpi",
    app_repository_url = "git@github.com =BrunoFerreira10/upperplan-app.git",
    app_repository_url_https = "https =//github.com/BrunoFerreira10/upperplan-app.git",
    container_repository_url = "git@github.com =BrunoFerreira10/upperplan-container.git",
    container_repository_url_https = "https =//github.com/BrunoFerreira10/upperplan-container.git",
    ec2_ssh_keypair_name = "aws-services-ec2-ssh",
    glpi_api_url = "https =//brunoferreira86dev.com/apirest.php/",
    glpi_username = "glpi",
    iam_aws_access_key_id = "AKIAU6GDX3JYXEQH2VNM",
    image_builder_parent_image = "ami-04b70fa74e45c3917",
    my_github_connection_name = "github_app_connection",
    rds_1_db_name = "db_upperplan_glpi",
    rds_1_db_username = "glpi_rootuser",
    rt53_domain = "brunoferreira86dev.com",
    ses_email_domain = "brunoferreira86dev.com"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = templatefile("${get_repo_root()}/templates/provider.tf.tmpl", {
    region     = local.region
    author     = local.github_vars_mock.general_tag_author
    customer   = local.github_vars_mock.general_tag_customer
    project    = local.github_vars_mock.general_tag_project
    env        = local.env
  })
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "env-${local.github_vars_mock.general_tag_shortname}-bfaf86"
    key            = "remote-states/${local.env}/${local.region}/${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
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