output "app_repository" {
  description = "App ECR repository Information"
  value       = module.app_repository.repository
}

output "container_repository" {
  description = "Container ECR repository Information"
  value       = module.container_repository.repository
}