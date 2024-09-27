module "container_repository" {
  source          = "../modules/containers/ecr/generic_ecr_repository"
  region          = module.data.github_vars.general_region
  repository_name = "container"
  shortname       = module.data.github_vars.general_tag_shortname
}

module "app_repository" {
  source          = "../modules/containers/ecr/generic_ecr_repository"
  region          = module.data.github_vars.general_region
  repository_name = "app"
  shortname       = module.data.github_vars.general_tag_shortname
}
