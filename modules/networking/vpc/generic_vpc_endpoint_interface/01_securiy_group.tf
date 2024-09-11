module "sg_vpc_endpoint_codedeploy_rules" {
  source    = "../../../networking/vpc/generic_security_group"
  shortname = var.shortname
  vpc       = var.vpc
  security_group_settings = {
    id_name     = "vpc_endpoint_codedeploy"
    description = "VPC Endpoint codedeploy security group"
    rules       = var.sg_vpc_endpoint_codedeploy_rules
  }
}