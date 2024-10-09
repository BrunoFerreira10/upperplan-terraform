resource "aws_imagebuilder_image" "installation" {
  distribution_configuration_arn   = var.image_builder.distribution.arn
  image_recipe_arn                 = var.image_builder.recipe.arn
  infrastructure_configuration_arn = var.image_builder.infrastructure.arn

  ## TODO - Criar role local no IAM
  execution_role = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/imagebuilder.amazonaws.com/AWSServiceRoleForImageBuilder"
  workflow {
    workflow_arn = var.image_builder.workflow.arn
  }

  tags = {
    Name = "installation_${var.shortname}"
  }
}