resource "aws_cloudwatch_log_group" "this" {
  name              = "/${var.env}/${var.shortname}${var.name}"
  retention_in_days = var.retention_in_days

  tags = {
    Name = "/${var.env}/${var.shortname}${var.name}"
  }
}