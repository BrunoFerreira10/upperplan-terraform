module "ecr_repository_app" {
  source                   = "../modules/containers/ecr/generic_ecr_repository"
  region                   = module.data.github_vars.general_region
  shortname                = module.data.github_vars.general_tag_shortname
}
