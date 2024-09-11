resource "aws_db_subnet_group" "rds" {
  name       = "rds_${var.shortname}"
  subnet_ids = var.rds_configuration.subnet_ids

  tags = {
    Name = "rds_${var.shortname}"
  }
}

resource "aws_db_instance" "rds" {
  identifier           = lower(replace("rds-${var.shortname}", "_", "-"))
  db_name              = var.rds_configuration.db_name
  username             = var.rds_configuration.db_username
  password             = data.aws_ssm_parameter.db_password.value
  allocated_storage    = var.rds_configuration.allocated_storage
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = var.rds_configuration.instance_class
  parameter_group_name = "default.mysql8.0"
  db_subnet_group_name = aws_db_subnet_group.rds.name
  skip_final_snapshot  = true
  multi_az             = false
  availability_zone    = var.rds_configuration.availability_zone

  publicly_accessible = var.rds_configuration.publicly_accessible

  vpc_security_group_ids = [
    module.sg_rds.security_group.id
  ]

  tags = {
    Name = "rds_${var.shortname}"
  }
}