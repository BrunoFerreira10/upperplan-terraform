module "container_image_builder_app" {
  source                   = "../modules/compute/ec2_image_builder/generic_container_image_builder"
  app_repository_url_https = module.data.github_vars.app_repository_url_https
  github_connection_name   = module.data.github_vars.my_github_connection_name
  lb_listeners             = module.data.projects.elb_app.lb_listeners
  project_bucket_name      = module.data.github_vars.general_project_bucket_name
  region                   = module.data.github_vars.general_region
  shortname                = module.data.github_vars.general_tag_shortname
  target_groups            = module.data.projects.elb_app.target_groups  
}
