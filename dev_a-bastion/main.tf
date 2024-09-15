module "bastion" {
  source               = "../modules/compute/ec2/bastion"
  ec2_ssh_keypair_name = module.data.github_vars.ec2_ssh_keypair_name
  region               = module.data.github_vars.general_region
  shortname            = module.data.github_vars.general_tag_shortname
  vpc                  = module.data.projects.vpc_app.vpc
  sg_bastion_rules     = {
    ingress = {
      SSH = {description = "Allow SSH from ${data.aws_ssm_parameter.my_ip.value}"
        port = 22, cidr_ipv4 = "${data.aws_ssm_parameter.my_ip.value}/32"}
    },
    egress = {
      SSH = {port = 22}
      HTTP = {port = 80, cidr_ipv4 = "0.0.0.0/0"}
      HTTPS = {port = 443, cidr_ipv4 = "0.0.0.0/0"}
    }
  }
}

