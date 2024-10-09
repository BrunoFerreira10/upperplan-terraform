output "golden_image_id" {
  description = "ID da Golden Image Information"
  value       = tolist(aws_imagebuilder_image.installation.output_resources[0].amis)[0].image
}