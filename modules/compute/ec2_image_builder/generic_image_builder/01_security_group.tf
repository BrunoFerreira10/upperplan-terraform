module "sg_image_builder_instance" {
  source    = "../../../networking/vpc/generic_security_group"
  shortname = var.shortname
  vpc       = var.vpc
  security_group_settings = {
    id_name     = "image_builder_instance"
    description = "Security group for Image builder instance"
    rules       = var.sg_image_builder_instance_rules
  }
}