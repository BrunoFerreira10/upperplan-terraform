output "github_vars" {
  description = "All Gihub variables values."
  value       = nonsensitive(local.github_vars)
}

output "projects" {
  description = "Return requested projects remote states."
  value       = local.projects
}