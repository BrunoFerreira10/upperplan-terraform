include {
  path = "${get_repo_root()}/terragrunt.hcl"
  expose = true
}

terraform {
  source    = "${include.locals.module_base_path}/storage/s3//generic_s3"
}

inputs = {
  force_destroy = true
  bucket_name   = replace("${include.locals.env}_${include.locals.github_vars_mock.general_tag_shortname}_${include.locals.profile}_${include.locals.region}", "_", "-")
}