# module "codedeploy_commands_secure_vpc_endpoint" {
#   source = "../modules/networking/vpc/generic_vpc_endpoint_interface"
#   region = module.data.github_vars.general_region
#   service_name_sufix = "codedeploy-commands-secure"
#   sg_vpc_endpoint_interface_rules = {
#     ingress = {
#       All = { ip_protocol = "-1", cidr_ipv4 = "0.0.0.0/0" }
#     },
#     egress = {
#       All = { ip_protocol = "-1", cidr_ipv4 = "0.0.0.0/0" }
#     }
#   }
#   shortname = module.data.github_vars.general_tag_shortname
#   vpc       = module.data.projects.vpc.vpc
# }

module "ecr_api_vpc_endpoint" {
  source = "../modules/networking/vpc/generic_vpc_endpoint_interface"
  region = module.data.github_vars.general_region
  service_name_sufix = "ecr.api"
  sg_vpc_endpoint_interface_rules = {
    ingress = {
      All = { ip_protocol = "-1", cidr_ipv4 = "0.0.0.0/0" }
    },
    egress = {
      All = { ip_protocol = "-1", cidr_ipv4 = "0.0.0.0/0" }
    }
  }
  shortname = module.data.github_vars.general_tag_shortname
  vpc       = module.data.projects.vpc.vpc
}

module "ecr_dkr_vpc_endpoint" {
  source = "../modules/networking/vpc/generic_vpc_endpoint_interface"
  region = module.data.github_vars.general_region
  service_name_sufix = "ecr.dkr"
  sg_vpc_endpoint_interface_rules = {
    ingress = {
      All = { ip_protocol = "-1", cidr_ipv4 = "0.0.0.0/0" }
    },
    egress = {
      All = { ip_protocol = "-1", cidr_ipv4 = "0.0.0.0/0" }
    }
  }
  shortname = module.data.github_vars.general_tag_shortname
  vpc       = module.data.projects.vpc.vpc
}

module "logs_vpc_endpoint" {
  source = "../modules/networking/vpc/generic_vpc_endpoint_interface"
  region = module.data.github_vars.general_region
  service_name_sufix = "logs"
  sg_vpc_endpoint_interface_rules = {
    ingress = {
      All = { ip_protocol = "-1", cidr_ipv4 = "0.0.0.0/0" }
    },
    egress = {
      All = { ip_protocol = "-1", cidr_ipv4 = "0.0.0.0/0" }
    }
  }
  shortname = module.data.github_vars.general_tag_shortname
  vpc       = module.data.projects.vpc.vpc
}
