resource "aws_imagebuilder_distribution_configuration" "installation" {
  name = "installation_${var.shortname}"

  distribution {
    region = var.region
    ami_distribution_configuration {
      name = "ami_installation_${var.shortname}_{{imagebuilder:buildDate}}"
      ami_tags = {
        Name = "ami_installation_${var.shortname}_{{imagebuilder:buildDate}}"
      }
    }
  }

  tags = {
    Name = "installation_${var.shortname}"
  }
}

# resource "aws_imagebuilder_distribution_configuration" "application" {
#   name = "application_${var.shortname}"

#   distribution {
#     region = var.region
#     ami_distribution_configuration {
#       name = "ami_application_${var.shortname}_{{imagebuilder:buildDate}}"
#       ami_tags = {
#         Name = "ami_application_${var.shortname}_{{imagebuilder:buildDate}}"
#       }
#     }
#   }

#   tags = {
#     Name = "application_${var.shortname}"
#   }
# }