output "vpc" {
  description = "App VPC information"
  value       = module.vpc_app.vpc
}