module "rds_mysql" {
  source              = "../modules/database/rds/generic-mysql"
  region              = module.data.github_vars.general_region
  project_bucket_name = module.data.github_vars.general_project_bucket_name
  shortname           = module.data.github_vars.general_tag_shortname
  vpc                 = module.data.projects.vpc_app.vpc
  rds_configuration = {
    db_name                   = module.data.github_vars.rds_1_db_name
    db_username               = module.data.github_vars.rds_1_db_user
    ssm_parameter_db_password = "rds_1_db_password",
    instance_class            = "db.t3.micro"
    subnet_ids = [
      module.data.projects.vpc_app.vpc.subnets.private.az_a.id,
      module.data.projects.vpc_app.vpc.subnets.private.az_b.id,
      module.data.projects.vpc_app.vpc.subnets.private.az_c.id
    ]
  }
}
