locals {
  env              = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.env
  github_vars_mock = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.github_vars_mock
  mock             = read_terragrunt_config(find_in_parent_folders("mock.hcl")).locals  

  config = {
    common = {
      
      db_name                   = local.github_vars_mock.rds_1_db_name
      db_username               = local.github_vars_mock.rds_1_db_username
      ssm_parameter_db_password = "rds_1_db_password"
      instance_class            = "db.t3.micro"

      sg_rds_rules = {
        ingress = {
          SSH = { port = 3306, cidr_ipv4 = "0.0.0.0/0" }
        },
        egress = {
          All = { ip_protocol = "-1", cidr_ipv4 = "0.0.0.0/0" }
        }
      }
    }

    dev = {
    }

    prod = {
    }
  }

default_config  = local.config.common
selected_config = lookup(local.config, local.env, local.default_config)
skip            = lookup(local.selected_config, "skip", lookup(local.default_config, "skip", null))
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../../networking/vpc"

  mock_outputs_allowed_terraform_commands = ["validate","plan","destroy"]
  mock_outputs                            = local.mock.vpc
}

inputs = {
  vpc        = dependency.vpc.outputs.vpc
  subnet_ids = [
        for subnet in dependency.vpc.outputs.vpc.subnets.private :
        subnet.id
      ]

  db_name = lookup(local.selected_config, "db_name",
            lookup(local.default_config, "db_name", null))

  db_username = lookup(local.selected_config, "db_username",
                lookup(local.default_config, "db_username", null))

  ssm_parameter_db_password = lookup(local.selected_config, "ssm_parameter_db_password",
                              lookup(local.default_config, "ssm_parameter_db_password", null))

  instance_class = lookup(local.selected_config, "instance_class",
                   lookup(local.default_config, "instance_class", null))

  sg_rds_rules = lookup(local.selected_config, "sg_rds_rules",
                 lookup(local.default_config, "sg_rds_rules", null))
}