data "aws_ssm_parameter" "my_ip" {
  name = "/github_vars/general_my_ip"
}

module "data" {
  source = "../modules/data"
  requested_data = [
    "vpc_app"
  ]
}