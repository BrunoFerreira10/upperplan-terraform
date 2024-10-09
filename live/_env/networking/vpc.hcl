locals {
  env              = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.env

  config = {
    common = {
      vpc_settings = {
        cidr_block = "10.1.0.0",
        nacl_rules = {
          public = {
            ingress = {
              HTTP      = { rule_number = 250, port = 80, cidr_block = "0.0.0.0/0" },  # ALB Listener
              HTTPS     = { rule_number = 350, port = 443, cidr_block = "0.0.0.0/0" }, # ALB Listener
              SMTP      = { rule_number = 450, port = 587, cidr_block = "0.0.0.0/0" }, # Confirmação Email
              EPHEMERAL = { rule_number = 9999, from_port = 1024, to_port = 65535, cidr_block = "0.0.0.0/0" }
            },
            egress = {
              HTTP      = { rule_number = 250, port = 80 },                            # ECS (TargetGroups)
              HTTPS     = { rule_number = 350, port = 443, cidr_block = "0.0.0.0/0" }, # Marketplace
              SMTP      = { rule_number = 450, port = 587, cidr_block = "0.0.0.0/0" }, # Envio de email (NATGW > IGW)
              EPHEMERAL = { rule_number = 9999, from_port = 1024, to_port = 65535, cidr_block = "0.0.0.0/0" }
            }
          },
          private = {
            ingress = {
              HTTP      = { rule_number = 250, port = 80 }, # ECS (TargetGroups)
              EPHEMERAL = { rule_number = 9999, from_port = 1024, to_port = 65535, cidr_block = "0.0.0.0/0" }
            },
            egress = {
              HTTPS     = { rule_number = 250, port = 443, cidr_block = "0.0.0.0/0" }, # Marketplace
              HTTP      = { rule_number = 350, port = 80, cidr_block = "0.0.0.0/0" },  # Marketplace
              SMTP      = { rule_number = 450, port = 587, cidr_block = "0.0.0.0/0" }, # Envio de email (ECS > NATGW)
              EPHEMERAL = { rule_number = 9999, from_port = 1024, to_port = 65535 }
            }
          }
        }
      }
    }
  }

  default_config  = local.config.common
  selected_config = lookup(local.config, local.env, local.default_config)
  skip            = lookup(local.selected_config, "skip", lookup(local.default_config, "skip", null))
}

inputs = {
  vpc_settings = lookup(local.selected_config, "vpc_settings",
                 lookup(local.default_config, "vpc_settings", null))
}