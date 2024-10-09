locals {
  env              = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.env
  github_vars_mock = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.github_vars_mock
  mock             = read_terragrunt_config(find_in_parent_folders("mock.hcl")).locals

  config = {
    common = {
      sg_ecs_service_rules = {
        ingress = {
          HTTP = { port = 80 } # ECS (Target Group)
        },
        egress = {
          HTTPS = { port = 443, cidr_ipv4 = "0.0.0.0/0" } # Marketplace
          SMTP  = { port = 587, cidr_ipv4 = "0.0.0.0/0" } # Envio de emails
          EFS   = { port = 2049 }
          MYSQL = { port = 3306 }
        }
      }
    }
    dev = {
      aws_ecs_service_desired_count = 0
    }

    prod = {
      aws_ecs_service_desired_count = 0
    }
  }

default_config  = local.config.common
selected_config = lookup(local.config, local.env, local.default_config)
skip            = lookup(local.selected_config, "skip", lookup(local.default_config, "skip", null))
}

dependency "app_repository" {
  config_path = "${get_terragrunt_dir()}/../../container/repositories/app_repository"

  mock_outputs_allowed_terraform_commands = ["validate","plan","destroy"]
  mock_outputs                            = local.mock.ecr
}

dependency "efs" {
  config_path = "${get_terragrunt_dir()}/../../storage/efs"

  mock_outputs_allowed_terraform_commands = ["validate","plan","destroy"]
  mock_outputs                            = local.mock.efs
}

dependency "elb" {
  config_path = "${get_terragrunt_dir()}/../../compute/elb"

  mock_outputs_allowed_terraform_commands = ["validate","plan","destroy"]
  mock_outputs                            = local.mock.elb
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../../networking/vpc"

  mock_outputs_allowed_terraform_commands = ["validate","plan","destroy"]
  mock_outputs                            = local.mock.vpc
}

inputs = {
  ecr_repository = dependency.app_repository.outputs.repository
  efs            = dependency.efs.outputs.efs
  target_group   = dependency.elb.outputs.target_groups.blue
  vpc            = dependency.vpc.outputs.vpc

  aws_ecs_service_desired_count = lookup(local.selected_config, "aws_ecs_service_desired_count",
                                  lookup(local.default_config, "aws_ecs_service_desired_count", null))

  sg_ecs_service_rules = lookup(local.selected_config, "sg_ecs_service_rules",
                         lookup(local.default_config, "sg_ecs_service_rules", null))
}