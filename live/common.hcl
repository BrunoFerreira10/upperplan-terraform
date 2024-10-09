locals {
  github_vars_mock = {
    general_my_ip = "192.1.1.1",
    general_project_bucket_name = "",
    general_tag_author = "BrunoFerreira",
    general_tag_customer = "UpperPlan",
    general_tag_project = "glpi",
    general_tag_shortname = "upperplan_glpi",
    app_repository_url = "git@github.com:BrunoFerreira10/upperplan-app.git",
    app_repository_url_https = "https://github.com/BrunoFerreira10/upperplan-app.git",
    container_repository_url = "git@github.com:BrunoFerreira10/upperplan-container.git",
    container_repository_url_https = "https://github.com/BrunoFerreira10/upperplan-container.git",
    ec2_ssh_keypair_name = "aws-services-ec2-ssh",
    glpi_api_url = "https://brunoferreira86dev.com/apirest.php/",
    glpi_username = "glpi",
    iam_aws_access_key_id = "AKIAU6GDX3JYXEQH2VNM",
    image_builder_parent_image = "ami-04b70fa74e45c3917",
    my_github_connection_name = "github_app_connection",
    rds_1_db_name = "db_upperplan_glpi",
    rds_1_db_username = "glpi_rootuser",
    rt53_domain = "brunoferreira86dev.com",
    ses_email_domain = "brunoferreira86dev.com"
  }
}