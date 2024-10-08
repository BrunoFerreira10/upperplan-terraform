module "sg_elb" {
  source    = "../../../networking/vpc/generic_security_group"

  env = var.env
  security_group_settings = {
    id_name     = "elb"
    description = "Security group for ELB"
    rules       = var.sg_elb_rules
  }
  shortname = var.shortname
  vpc       = var.vpc
}