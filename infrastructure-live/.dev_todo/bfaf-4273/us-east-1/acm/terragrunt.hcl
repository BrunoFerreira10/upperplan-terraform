include {
  path = find_in_parent_folders()
  expose = true
}

terraform {
  source = "${include.locals.module_base_path}/security/acm//generic_acm"
}

inputs = {
  env       = include.locals.env
  shortname = include.locals.github_vars_mock.general_tag_shortname
  acm_configuration = {
    domain     = include.locals.github_vars_mock.rt53_domain
    subdomains = ["www", "test-987fskjhfd9"]
  }
}