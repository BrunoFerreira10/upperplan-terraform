module "sg_vpc_endpoint_interface_rules" {
  source    = "../../../networking/vpc/generic_security_group"
  shortname = var.shortname
  vpc       = var.vpc
  security_group_settings = {
    id_name     = "vpc_endpoint_${var.service_name_sufix}"
    description = "VPC Endpoint Interface (${var.service_name_sufix}) security group"
    rules       = var.sg_vpc_endpoint_interface_rules
  }
}