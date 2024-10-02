## ---------------------------------------------------------------------------------------------------------------------
## Configuração do terraform. Comuns a todos os módulos do projeto
## GERADO AUTOMATICAMENTE baseado no arquivo .setup_project/.common.terraform.tf
## ---------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.40.0"
    }
  }
  backend "s3" {}
}
## ---------------------------------------------------------------------------------------------------------------------