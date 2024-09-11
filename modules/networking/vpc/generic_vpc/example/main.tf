module "vpc_app" {
  source    = "../modules/networking/vpc/my_generic_app_vpc"
  shortname = module.data.github_vars.general_tag_shortname
  region    = module.data.github_vars.general_region
}
