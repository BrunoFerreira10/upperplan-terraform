module "sg_bastion" {
  source    = "../../../networking/vpc/generic_security_group"
  shortname = var.shortname
  vpc       = var.vpc
  security_group_settings = {
    id_name     = "bastion"
    description = "Security group for bastion host"
    rules       = var.sg_bastion_rules
  }
}
