module "container_image_builder_app" {
  source                   = "../modules/compute/ec2_image_builder/generic_container_image_builder"
  app_repository_url_https = module.data.github_vars.app_repository_url_https
  region                   = module.data.github_vars.general_region
  shortname                = module.data.github_vars.general_tag_shortname
}
