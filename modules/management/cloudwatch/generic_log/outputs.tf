output "log_group" {
  description = "Value of the log group"
  value = aws_cloudwatch_log_group.this
}

output "log_stream" {
  description = "Value of the log stream"
  value = aws_cloudwatch_log_stream.this
}