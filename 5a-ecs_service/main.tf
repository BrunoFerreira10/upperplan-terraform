module "ecs_service" {
  source = "../modules/containers/ecs/generic_ecs_service"
  ecr_repository = module.data.projects.container_image_builder.ecr.repository
  region = module.data.github_vars.general_region
  sg_ecs_service_rules = {
    ingress = {
      HTTP  = { port = 80, cidr_ipv4 = "0.0.0.0/0" }
      HTTPS = { port = 443, cidr_ipv4 = "0.0.0.0/0" }
    },
    egress = {
      HTTP  = { port = 80, cidr_ipv4 = "0.0.0.0/0" } // ECR
      HTTPS = { port = 443, cidr_ipv4 = "0.0.0.0/0" } // ECR
      EFS   = { port = 2049 }
      MYSQL = { port = 3306 }
    }
  }
  shortname    = module.data.github_vars.general_tag_shortname
  target_group = module.data.projects.elb.target_groups.blue
  vpc          = module.data.projects.vpc.vpc
}
