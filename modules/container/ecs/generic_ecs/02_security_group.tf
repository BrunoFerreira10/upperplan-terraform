module "sg_ecs" {
  source    = "../../../networking/vpc/generic_security_group"
  env = var.env
  security_group_settings = {
    id_name     = "ecs_service"
    description = "Security group for ecs service"
    rules       = var.sg_ecs_service_rules
  }
  shortname = var.shortname
  vpc       = var.vpc
}
