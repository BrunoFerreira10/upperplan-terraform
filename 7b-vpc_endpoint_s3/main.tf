module "s3_vpc_endpoint" {
  source                   = "../modules/networking/vpc/generic_vpc_endpoint_gateway"
  region = module.data.github_vars.general_region
  shortname = module.data.github_vars.general_tag_shortname
  vpc = module.data.projects.vpc_app.vpc
}