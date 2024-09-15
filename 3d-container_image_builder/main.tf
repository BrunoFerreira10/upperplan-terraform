module "app_image_builder" {
  source                 = "../modules/developer/codebuild/generic_container_image_builder"
  artifact_file_name     = "app-build.zip"
  buildspec_file_name    = "app-buildspec.yml.tpl"
  ecr_repository         = module.data.projects.ecr.app_repository
  github_connection_name = module.data.github_vars.my_github_connection_name
  project_bucket_name    = module.data.github_vars.general_project_bucket_name
  project_name           = "app"
  region                 = module.data.github_vars.general_region
  repository_url_https   = module.data.github_vars.app_repository_url_https
  shortname              = module.data.github_vars.general_tag_shortname
}

module "container_image_builder" {
  source                 = "../modules/developer/codebuild/generic_container_image_builder"
  buildspec_file_name    = "container-buildspec.yml.tpl"
  ecr_repository         = module.data.projects.ecr.container_repository
  github_connection_name = module.data.github_vars.my_github_connection_name
  project_bucket_name    = module.data.github_vars.general_project_bucket_name
  project_name           = "container"
  region                 = module.data.github_vars.general_region
  repository_url_https   = module.data.github_vars.container_repository_url_https
  shortname              = module.data.github_vars.general_tag_shortname
}
