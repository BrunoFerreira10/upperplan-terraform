include "root" {
  path = "${get_repo_root()}/terragrunt.hcl"
  expose = true
}

include "mock" {
  path = "${get_repo_root()}/mock.hcl"
  expose = true
}

terraform {
  source    = "${include.root.locals.module_base_path}/networking/vpc//generic_nat_gateway"
}

dependency "vpc" {
  config_path = "../../vpc"
  
  mock_outputs_allowed_terraform_commands = ["validate","plan","destroy"]
  mock_outputs                            = include.mock.locals.vpc

}

inputs = {
  region        = include.root.locals.region
  shortname     = include.root.locals.github_vars_mock.general_tag_shortname
  vpc           = dependency.vpc.outputs.vpc
  public_subnet = dependency.vpc.outputs.vpc.subnets.public.az_a
}