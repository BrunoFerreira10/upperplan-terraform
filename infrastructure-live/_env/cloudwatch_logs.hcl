include {
  path = "${get_repo_root()}/terragrunt.hcl"
  expose = true
}

locals {

  common = {
    env               = include.locals.env
    name              = "/ecs/apache_access"
    shortname         = include.locals.github_vars_mock.general_tag_shortname
  }

}