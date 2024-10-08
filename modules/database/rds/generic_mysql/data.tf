data "aws_ssm_parameter" "db_password" {
  name = "/${var.shortname}/prod/github_secrets/${var.ssm_parameter_db_password}"
}

## --------------------------------------------------------------------------------------------------------------------
## Get RDS private IP address
## --------------------------------------------------------------------------------------------------------------------
data "aws_network_interface" "rds_eni" {
  depends_on = [aws_db_instance.rds]
  filter {
    name   = "description"
    values = ["RDSNetworkInterface"]
  }

  filter {
    name   = "vpc-id"
    values = [var.vpc.id]
  }

  filter {
    name = "subnet-id"
    values = [
      for subnet in var.vpc.subnets.private :
      subnet.id
    ]
  }

}