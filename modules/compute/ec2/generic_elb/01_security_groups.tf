module "sg_elb" {
  source    = "../../../networking/vpc/generic_security_group"
  shortname = var.shortname
  vpc       = var.vpc
  security_group_settings = {
    id_name     = "elb"
    description = "Security group for ELB"
    rules       = var.sg_elb_rules
  }
}

module "sg_launch_tpl" {
  source    = "../../../networking/vpc/generic_security_group"
  shortname = var.shortname
  vpc       = var.vpc
  security_group_settings = {
    id_name     = "launch_tpl"
    description = "Security group launch template (instances)"
    rules       = var.sg_launch_tpl_rules
  }
}