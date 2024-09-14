resource "aws_cloudwatch_log_group" "this" {
  name              = "/${var.shortname}${var.name}"
  retention_in_days = var.retention_in_days

  tags = {
    Name = "/${var.shortname}${var.name}"
  }
}