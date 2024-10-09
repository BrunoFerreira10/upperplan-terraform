output "efs" {
  description = "EFS Information"
  value = {
    arn      = aws_efs_file_system.efs.arn
    id       = aws_efs_file_system.efs.id
    dns_name = aws_efs_file_system.efs.dns_name
  }
}
