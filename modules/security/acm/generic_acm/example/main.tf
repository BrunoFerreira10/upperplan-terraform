module "acm_ssl" {
  source    = "../modules/security/acm/generic_domain_acm"
  shortname = module.data.github_vars.general_tag_shortname
  acm_configuration = {
    domain     = module.data.github_vars.rt53_domain
    subdomains = ["www", "test-987fskjhfd9"]
  }
}
