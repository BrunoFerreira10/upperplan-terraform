module "sg_rds" {
  source    = "../../../networking/vpc/generic_security_group"
  shortname = var.shortname
  vpc       = var.vpc
  security_group_settings = {
    id_name     = "rds"
    description = "RDS security group"
    rules       = var.sg_rds_rules
  }
}
