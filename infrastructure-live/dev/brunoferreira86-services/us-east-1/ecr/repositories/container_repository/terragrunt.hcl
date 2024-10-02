include {
  path = find_in_parent_folders()
}

include "ecr"{
  path = "../ecr.hcl"
}

locals {
  module_base_path = read_terragrunt_config(find_in_parent_folders("live.hcl")).locals.module_base_path
}

terraform {
  source    = "${local.module_base_path}/containers/ecr//generic_ecr_repository"
}

inputs = {
  repository_name = "container"
}