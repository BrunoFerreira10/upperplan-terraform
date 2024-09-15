module "nat_gateway_az_1" {
  source        = "../modules/networking/vpc/generic_nat_gateway"
  region        = module.data.github_vars.general_region
  shortname     = module.data.github_vars.general_tag_shortname
  vpc           = module.data.projects.vpc.vpc
  public_subnet = module.data.projects.vpc.vpc.subnets.public.az_a
}
