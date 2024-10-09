module "sg_efs" {
  source    = "../../../networking/vpc/generic_security_group"
  env = var.env
  
  security_group_settings = {
    id_name     = "efs"
    description = "EFS security group"
    rules       = var.sg_efs_rules
  }
  
  shortname = var.shortname  
  vpc       = var.vpc
}