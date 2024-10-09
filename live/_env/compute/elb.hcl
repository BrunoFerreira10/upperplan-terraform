locals {
  env              = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.env
  github_vars_mock = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals.github_vars_mock
  mock             = read_terragrunt_config(find_in_parent_folders("mock.hcl")).locals

  config = {
    common = {
      app_repository_url = local.github_vars_mock.app_repository_url
      hosted_zone        = local.github_vars_mock.rt53_domain
      sg_elb_rules       = {
        ingress = {
          HTTP  = { port = 80, cidr_ipv4 = "0.0.0.0/0" }
          HTTPS = { port = 443, cidr_ipv4 = "0.0.0.0/0" }
        },
        egress = {
          All = { ip_protocol = "-1", cidr_ipv4 = "0.0.0.0/0" }
        }
      }
    }

    dev = {
      domain = "dev-n0001.${local.github_vars_mock.rt53_domain}"
    }

    prod = {
      domain = local.github_vars_mock.rt53_domain
    }
  }

default_config  = local.config.common
selected_config = lookup(local.config, local.env, local.default_config)
skip            = lookup(local.selected_config, "skip", lookup(local.default_config, "skip", null))
}

dependency "acm" {
  config_path = "${get_terragrunt_dir()}/../../security/acm"

  mock_outputs_allowed_terraform_commands = ["validate","plan","destroy"]
  mock_outputs                            = local.mock.acm
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../../networking/vpc"

  mock_outputs_allowed_terraform_commands = ["validate","plan","destroy"]
  mock_outputs                            = local.mock.vpc
}

inputs = {
  acm_certificate = dependency.acm.outputs.certificate
  vpc             = dependency.vpc.outputs.vpc

  app_repository_url = lookup(local.selected_config, "app_repository_url",
                       lookup(local.default_config, "app_repository_url", null))

  domain = lookup(local.selected_config, "domain",
           lookup(local.default_config, "domain", null))

  hosted_zone = lookup(local.selected_config, "hosted_zone",
                lookup(local.default_config, "hosted_zone", null))

  sg_elb_rules = lookup(local.selected_config, "sg_elb_rules",
                 lookup(local.default_config, "sg_elb_rules", null))
}