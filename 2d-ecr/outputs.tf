output "ecr" {
  description = "ECR Information"
  value = module.ecr_repository_app.ecr
}