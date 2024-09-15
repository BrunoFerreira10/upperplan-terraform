module "elb" {
  source               = "../modules/compute/ec2/generic_ecs_elb"
  acm_certificate      = module.data.projects.acm.certificate
  domain               = module.data.github_vars.rt53_domain
  app_repository_url   = module.data.github_vars.app_repository_url
  sg_elb_rules = {
    ingress = {
      HTTP = { port = 80, cidr_ipv4 = "0.0.0.0/0" }
      HTTPS = { port = 443, cidr_ipv4 = "0.0.0.0/0" }
    },
    egress = {
      All = { ip_protocol = "-1", cidr_ipv4 = "0.0.0.0/0" }
    }
  }  
  shortname            = module.data.github_vars.general_tag_shortname
  vpc                  = module.data.projects.vpc.vpc
}
