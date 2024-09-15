module "container_image_builder" {
  source                   = "../modules/developer/codebuild/generic_container_image_builder"
  app_repository_url_https = module.data.github_vars.app_repository_url_https
  ecr_repository           = module.data.projects.ecr.repository
  github_connection_name   = module.data.github_vars.my_github_connection_name
  project_bucket_name      = module.data.github_vars.general_project_bucket_name
  region                   = module.data.github_vars.general_region
  shortname                = module.data.github_vars.general_tag_shortname
}
