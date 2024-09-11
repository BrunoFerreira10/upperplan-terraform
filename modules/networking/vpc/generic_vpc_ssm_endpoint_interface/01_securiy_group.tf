module "sg_vpc_endpoint_ssm_rules" {
  source    = "../../../networking/vpc/generic_security_group"
  shortname = var.shortname
  vpc       = var.vpc
  security_group_settings = {
    id_name     = "vpc_endpoint_ssm"
    description = "VPC Endpoint ssm security group"
    rules       = var.sg_vpc_endpoint_ssm_rules
  }
}