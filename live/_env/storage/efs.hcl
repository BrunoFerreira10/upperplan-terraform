locals {
  env              = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.env
  mock             = read_terragrunt_config(find_in_parent_folders("mock.hcl")).locals

  config = {
    common = {
      sg_efs_rules = {
        ingress = {
          SSH = { port = 2049, cidr_ipv4 = "0.0.0.0/0" }
        },
        egress = {
          All = { ip_protocol = "-1", cidr_ipv4 = "0.0.0.0/0" }
        }
      }
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
  mount_target_subnets = [
    for subnet in dependency.vpc.outputs.vpc.subnets.private :
      subnet.id // All private subnets
  ]
      
  vpc = dependency.vpc.outputs.vpc

  sg_efs_rules = lookup(local.selected_config, "sg_efs_rules",
                 lookup(local.default_config, "sg_efs_rules", null))
}