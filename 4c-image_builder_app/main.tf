module "image_builder_app" {
  source                    = "../modules/compute/ec2_image_builder/generic_image_builder"
  app_repository_url        = module.data.github_vars.app_repository_url
  ec2_ssh_keypair_name      = module.data.github_vars.ec2_ssh_keypair_name
  region                    = module.data.github_vars.general_region
  shortname                 = module.data.github_vars.general_tag_shortname
  installation_parent_image = module.data.github_vars.image_builder_parent_image
  vpc                       = module.data.projects.vpc_app.vpc  
  sg_image_builder_instance_rules     = {
    ingress = {
      SSH = {port = 22, cidr_ipv4 = "${data.aws_ssm_parameter.my_ip.value}/32"}
      HTTP = {port = 80, cidr_ipv4 = "0.0.0.0/0"}
    },
    egress = {
      SSH = {port = 22, cidr_ipv4 = "0.0.0.0/0"}
      HTTP = {port = 80, cidr_ipv4 = "0.0.0.0/0"}
      HTTPS = {port = 443, cidr_ipv4 = "0.0.0.0/0"}
    }
  }
}
