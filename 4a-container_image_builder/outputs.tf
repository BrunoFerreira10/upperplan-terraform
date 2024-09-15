output "ecr" {
  description = "ECR Information"
  value = module.container_image_builder_app.ecr
}