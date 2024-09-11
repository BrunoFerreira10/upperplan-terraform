module "rds_mysql" {
  source              = "../modules/database/rds/generic_mysql"
  region              = module.data.github_vars.general_region
  project_bucket_name = module.data.github_vars.general_project_bucket_name
  shortname           = module.data.github_vars.general_tag_shortname
  vpc                 = module.data.projects.vpc_app.vpc
  rds_configuration = {
    db_name                   = module.data.github_vars.rds_1_db_name
    db_username               = module.data.github_vars.rds_1_db_username
    ssm_parameter_db_password = "rds_1_db_password",
    instance_class            = "db.t3.micro"
    subnet_ids = [
      module.data.projects.vpc_app.vpc.subnets.private.az_a.id,
      module.data.projects.vpc_app.vpc.subnets.private.az_b.id,
      module.data.projects.vpc_app.vpc.subnets.private.az_c.id
    ]
  }
  sg_rds_rules     = {
    ingress = {
      SSH = {port = 3306, cidr_ipv4 = "0.0.0.0/0"}
    },
    egress = {
      All = {ip_protocol = "-1", cidr_ipv4 = "0.0.0.0/0"}
    }
  }
}

module "save_parameter_rds_1_db_host" {
  source = "../modules/management/ssm/generic_save_parameter"
  is_secure = false
  param_name = "/app_vars/rds_1_db_host"
  param_value = module.rds_mysql.rds.private_ip

  depends_on = [ module.rds_mysql ]
}
