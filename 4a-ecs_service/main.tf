module "ecs" {
  source         = "../modules/containers/ecs/generic_ecs_service"
  ecr_repository = module.data.projects.ecr.app_repository
  efs            = module.data.projects.efs.efs
  region         = module.data.github_vars.general_region
  sg_ecs_service_rules = {
    ingress = {
      HTTP  = { port = 80} # ECS (Target Group)      
    },
    egress = {
      HTTPS = { port = 443, cidr_ipv4 = "0.0.0.0/0" } # Marketplace
      SMTP  = { port = 587, cidr_ipv4 = "0.0.0.0/0" } # Envio de emails
      EFS   = { port = 2049 }
      MYSQL = { port = 3306 }
    }
  }
  shortname    = module.data.github_vars.general_tag_shortname
  target_group = module.data.projects.elb.target_groups.blue
  vpc          = module.data.projects.vpc.vpc
}
