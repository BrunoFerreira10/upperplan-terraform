module "vpc_app" {
  source    = "../modules/networking/vpc/generic_vpc"
  shortname = module.data.github_vars.general_tag_shortname
  region    = module.data.github_vars.general_region
  vpc_settings = {
    cidr_block = "10.2.0.0",
    nacl_rules = {
      public = {
        ingress = {
          SSH       = { rule_number = 150, cidr_block = "${data.aws_ssm_parameter.my_ip.value}/32", port = 22 },
          HTTP      = { rule_number = 250, cidr_block = "0.0.0.0/0", port = 80 },
          HTTPS     = { rule_number = 350, cidr_block = "0.0.0.0/0", port = 443 },
          SMTP      = { rule_number = 450, cidr_block = "0.0.0.0/0", port = 587 },
          EPHEMERAL = { rule_number = 9999, cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 }
        },
        egress = {
          SSH       = { rule_number = 150, port = 22 },
          HTTP      = { rule_number = 250, cidr_block = "0.0.0.0/0", port = 80 },
          HTTPS     = { rule_number = 350, cidr_block = "0.0.0.0/0", port = 443 },
          SMTP      = { rule_number = 450, cidr_block = "0.0.0.0/0", port = 587 },
          EPHEMERAL = { rule_number = 9999, cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 }
        }
      },
      private = {
        ingress = {
          SSH            = { rule_number = 150, port = 22 },
          HTTP           = { rule_number = 250, port = 80 },
          EPHEMERAL      = { rule_number = 9999, from_port = 1024, to_port = 65535, cidr_block = "0.0.0.0/0" }
        },
        egress = {
          SSH       = { rule_number = 150, port = 22, cidr_block = "0.0.0.0/0" },  # USER DATA
          HTTPS     = { rule_number = 250, port = 443, cidr_block = "0.0.0.0/0" }, # USER DATA
          HTTP      = { rule_number = 350, port = 80, cidr_block = "0.0.0.0/0" },  # USER DATA
          SMTP      = { rule_number = 450, cidr_block = "0.0.0.0/0", port = 587 },
          EPHEMERAL = { rule_number = 9999, from_port = 1024, to_port = 65535 }
        }
      }
    }
  }
}
