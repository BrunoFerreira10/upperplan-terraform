resource "aws_db_subnet_group" "rds" {
  name       = "${var.env}_rds_${var.shortname}"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.env}_rds_${var.shortname}"
  }
}

resource "aws_db_instance" "rds" {
  identifier           = lower(replace("${var.env}-rds-${var.shortname}", "_", "-"))
  db_name              = var.db_name
  username             = var.db_username
  password             = data.aws_ssm_parameter.db_password.value
  allocated_storage    = var.allocated_storage
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = var.instance_class
  parameter_group_name = "default.mysql8.0"
  db_subnet_group_name = aws_db_subnet_group.rds.name
  skip_final_snapshot  = true
  multi_az             = false
  availability_zone    = var.availability_zone
  apply_immediately    = true

  publicly_accessible = var.publicly_accessible

  vpc_security_group_ids = [
    module.sg_rds.security_group.id
  ]

  tags = {
    Name = "${var.env}_rds_${var.shortname}"
  }
}