include {
  path = "${get_repo_root()}/terragrunt.hcl"
  expose = true
}

terraform {
  source    = "${include.locals.module_base_path}/storage/s3//generic_s3"
}

inputs = {
  bucket_name = "${include.locals.env}-${include.locals.github_vars_mock.general_tag_shortname}-${include.locals.profile}"
}