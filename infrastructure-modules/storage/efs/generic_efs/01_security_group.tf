module "sg_efs" {
  source    = "../../../networking/vpc/generic_security_group"
  shortname = var.shortname
  vpc       = var.vpc
  security_group_settings = {
    id_name     = "efs"
    description = "EFS security group"
    rules       = var.sg_efs_rules
  }
}