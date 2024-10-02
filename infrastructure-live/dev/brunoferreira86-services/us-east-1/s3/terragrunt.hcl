include {
  path = find_in_parent_folders()
  expose = true
}

// locals {
  // module_base_path = read_terragrunt_config(find_in_parent_folders("live.hcl")).locals.module_base_path
  // github_vars_mock = read_terragrunt_config(find_in_parent_folders("live.hcl")).locals.github_vars_mock
  // env              = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.env
// }

terraform {
  source    = "${include.locals.module_base_path}/storage/s3//generic_s3"
}

inputs = {
  bucket_name = "${include.locals.env}-${include.locals.github_vars_mock.general_tag_shortname}-bfaf86"
}