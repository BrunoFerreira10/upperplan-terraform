## ---------------------------------------------------------------------------------------------------------------------
## Arquivo de configuração de provedores. Comuns a todos os módulos do projeto
## GERADO AUTOMATICAMENTE baseado no arquivo .setup_project/.common.providers.tf
## ---------------------------------------------------------------------------------------------------------------------
provider "aws" {
  region = "[GENERAL_REGION]"
  default_tags {
    tags = {
      "author"     = "[GENERAL_TAG_AUTHOR]"
      "customer"   = "[GENERAL_TAG_CUSTOMER]"
      "project"    = "[GENERAL_TAG_PROJECT]"
      "managed-by" = "terraform"
    }
  }
}
## ---------------------------------------------------------------------------------------------------------------------