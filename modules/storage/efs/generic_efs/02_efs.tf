## --------------------------------------------------------------------------------------------------------------------
## EFS File System definition
## --------------------------------------------------------------------------------------------------------------------
resource "aws_efs_file_system" "efs" {
  creation_token  = "efs_${var.shortname}_token"
  encrypted       = true
  throughput_mode = "elastic"

  tags = {
    Name = "efs_${var.shortname}"
  }
}

## --------------------------------------------------------------------------------------------------------------------
## EFS mount targets
## --------------------------------------------------------------------------------------------------------------------
resource "aws_efs_mount_target" "mount_target" {
  for_each = toset(var.mount_target_subnets)

  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = each.value
  security_groups = [module.sg_efs.security_group.id]
}

## --------------------------------------------------------------------------------------------------------------------
## EFS Backup
## --------------------------------------------------------------------------------------------------------------------
resource "aws_efs_backup_policy" "efs-backup-policy" {
  file_system_id = aws_efs_file_system.efs.id

  backup_policy {
    status = "DISABLED"
  }
}
## --------------------------------------------------------------------------------------------------------------------