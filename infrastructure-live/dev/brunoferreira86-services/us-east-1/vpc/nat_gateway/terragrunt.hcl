include {
  path = find_in_parent_folders()
}

terraform {
  source    = "${local.root.module_base_path}/networking/vpc//generic_nat_gateway"
}

locals {
  github_vars_mock = yamldecode(file("${find_in_parent_folders("github_vars_mock.yaml")}"))
}

dependency "vpc" {
  config_path = "../../vpc"
}

inputs = {
  region        = local.github_vars_mock.values.general_region
  shortname     = local.github_vars_mock.values.general_tag_shortname
  vpc           = dependency.vpc.outputs.vpc
  public_subnet = dependency.vpc.outputs.vpc.subnets.public.az_a
}

