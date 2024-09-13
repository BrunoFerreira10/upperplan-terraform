resource "aws_cloudwatch_log_group" "this" {
  name              = "${var.shortname}_${var.name}"
  retention_in_days = var.retention_in_days

  tags = {
    Name = "log_group_${var.shortname}_${var.name}"
  }
}

resource "aws_cloudwatch_log_stream" "this" {
  name           = "${var.shortname}_${var.name}"
  log_group_name = aws_cloudwatch_log_group.this.name
}