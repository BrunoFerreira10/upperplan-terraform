module "deploy_app" {
  source                   = "../modules/developer/tools/generic_code_deploy"
  app_repository_url_https = module.data.github_vars.app_repository_url_https
  codebuild_settings = { # TODO - Rever essa divisão
    project_name = module.data.github_vars.general_tag_shortname
    github_connection_name = module.data.github_vars.my_github_connection_name
  }
  codedeploy_settings = { # TODO - Rever essa divisão
    application_name = module.data.github_vars.general_tag_shortname
    target_group = module.data.projects.elb_app.target_group
    elb = module.data.projects.elb_app.elb
    asg = module.data.projects.elb_app.asg
  }
  domain              = module.data.github_vars.rt53_domain
  project_bucket_name = module.data.github_vars.general_project_bucket_name
  region              = module.data.github_vars.general_region
  rds                 = module.data.projects.rds_app.rds
  shortname           = module.data.github_vars.general_tag_shortname
}
