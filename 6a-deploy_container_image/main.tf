module "deploy_container_image" {
  source                   = "../modules/developer/codedeploy/generic_ecr_image_deploy"
  app_repository_url_https = module.data.github_vars.app_repository_url_https
  lb_listeners             = module.data.projects.elb.lb_listeners
  project_bucket_name      = module.data.github_vars.general_project_bucket_name
  region                   = module.data.github_vars.general_region
  target_groups            = module.data.projects.elb.target_groups
  shortname                = module.data.github_vars.general_tag_shortname
}
