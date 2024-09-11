module "efs" {
  source = "../modules/storage/efs/generic_efs"
  mount_target_subnets = [
    for subnet in module.data.projects.vpc_app.vpc.subnets.private :
    subnet.id // All private subnets
  ]
  shortname = module.data.github_vars.general_tag_shortname
  vpc       = module.data.projects.vpc_app.vpc
  sg_efs_rules     = {
    ingress = {
      SSH = {port = 2049, cidr_ipv4 = "0.0.0.0/0"}
    },
    egress = {
      All = {ip_protocol = "-1", cidr_ipv4 = "0.0.0.0/0"}
    }
  }
}
