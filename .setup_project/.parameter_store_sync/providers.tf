## ---------------------------------------------------------------------------------------------------------------------
## Arquivo de configuração de provedores. Comuns a todos os módulos do projeto
## GERADO AUTOMATICAMENTE baseado no arquivo .setup_project/.common.providers.tf
## ---------------------------------------------------------------------------------------------------------------------
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      "author"     = "Bruno Ferreira"
      "customer"   = "Upper Plan"
      "project"    = "GLPI"
      "managed-by" = "terraform"
    }
  }
}
## ---------------------------------------------------------------------------------------------------------------------