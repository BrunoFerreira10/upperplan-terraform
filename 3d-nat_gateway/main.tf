module "nat_gateway_az_1" {
  source                   = "../modules/networking/vpc/generic_nat_gateway"
  region = module.data.github_vars.general_region  
  shortname = module.data.github_vars.general_tag_shortname
  subnet = module.data.projects.vpc_app.vpc.subnets.private.az_a
}