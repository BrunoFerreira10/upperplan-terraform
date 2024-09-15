data "aws_ssm_parameter" "my_ip" {
  name = "/${var.general_tag_shortname}/prod/github_vars/general_my_ip"
}

module "data" {
  source = "../modules/data"
  shortname = var.general_tag_shortname
  requested_data = [
    "ecr"
  ]
}