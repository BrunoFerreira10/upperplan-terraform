include {
  path = find_in_parent_folders()
}

include "cloudwatch"{
  path = "../cloudwatch.hcl"
}

locals {
  module_base_path = read_terragrunt_config(find_in_parent_folders("live.hcl")).locals.module_base_path
}

terraform {
  source    = "${local.module_base_path}/management/cloudwatch//generic_log_group"
}

inputs = {
  name              = "/ecs/php-error"
}