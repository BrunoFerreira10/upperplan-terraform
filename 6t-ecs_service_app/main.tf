module "ecs_service_app" {
  source = "../modules/containers/ecs/generic_ecs_service"
  region = module.data.github_vars.general_region
  sg_ecs_service_rules = {
    ingress = {
      HTTP  = { port = 80, cidr_ipv4 = "0.0.0.0/0" }
      HTTPS = { port = 443, cidr_ipv4 = "0.0.0.0/0" }
    },
    egress = {
      EFS   = { port = 2049 }
      MYSQL = { port = 3306 }
    }
  }
  shortname    = module.data.github_vars.general_tag_shortname
  target_group = module.data.projects.elb_add.target_group
  vpc          = module.data.vpc_app.vpc
}
