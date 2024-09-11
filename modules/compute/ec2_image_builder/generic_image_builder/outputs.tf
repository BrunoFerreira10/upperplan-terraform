output "image_builder" {
  description = "Image builder information"
  value       = {
    distribution = aws_imagebuilder_distribution_configuration.installation
    recipe = aws_imagebuilder_image_recipe.installation
    infrastructure = aws_imagebuilder_infrastructure_configuration.this
    workflow = aws_imagebuilder_workflow.build
  }
}