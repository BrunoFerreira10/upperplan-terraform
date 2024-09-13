# module "sg_elb" {
#   source    = "../../../networking/vpc/generic_security_group"
#   shortname = var.shortname
#   vpc       = var.vpc
#   security_group_settings = {
#     id_name     = "elb"
#     description = "Security group for ELB"
#     rules       = var.sg_elb_rules
#   }
# }