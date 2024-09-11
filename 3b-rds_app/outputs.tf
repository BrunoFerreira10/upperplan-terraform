output "rds" {
  description = "RDS MySQL information"
  value       = module.rds_mysql.rds
}

output "rds_full" {
  description = "RDS MySQL information"
  value       = module.rds_mysql.rds_full
  sensitive = true
}