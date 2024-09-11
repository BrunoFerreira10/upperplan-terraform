## --------------------------------------------------------------------------------------------------------------------
## Dynamic components creation.
## --------------------------------------------------------------------------------------------------------------------
locals {
  components_configuration = {
    apache_install = {
      description = "Instalar apache2"
    },
    apache_uninstall = {
      description = "Desinstala apache2"
    },
    apt_update = {
      description = "Atualiza lista de pacotes do apt."
    },
    apt_upgrade = {
      description = "Atualiza pacotes do apt"
    },
    aws_cli_install = {
      description = "Instala o AWS CLI."
    },
    codedeploy_agent_install = {
      description = "Instala o CodeDeploy agent",
      template_payload = {
        REGION = var.region
      }
    },
    composer_install = {
      description = "Instala o composer."
    },
    daemon_reload = {
      description = "Recarrega configurações do gerenciador de serviços systemd."
    },
    efs_utils_install = {
      description = "Instala EFS utils"
    },
    git_fetch_repository = {
      description = "Download do repositorio de '${var.shortname}' para /tmp/app",
      template_payload = {
        APP_REPOSITORY_URL = var.app_repository_url
      }
    },
    nginx_config = {
      description = "Configuração basica do nginx."
    },
    nginx_install = {
      description = "Instala o nginx."
    },
    nginx_restart = {
      description = "Reinicia o nginx."
    },
    node_install = {
      description = "Instala NodeJS",
    },
    php_install = {
      description = "Instala o PHP com extensões comuns para aplicações web.",
    },
    ssh_add_github_key = {
      description = "Adiciona chave privada do github ao ssh_agent."
    },
    ssh_agent_enable = {
      description = "Habilita o ssh_agent no boot da instância."
    },
    ssh_agent_start = {
      description = "Inicia o ssh_agent na instância."
    }
  }
}

resource "aws_imagebuilder_component" "this" {

  for_each = local.components_configuration

  name        = "${var.shortname}_${each.key}"
  version     = "1.0.0"
  platform    = "Linux"
  description = each.value.description

  data = templatefile("${path.module}/components/${each.key}.tpl", merge({
    NAME = upper("${var.shortname}_${each.key}")
  }, lookup(each.value, "template_payload", {})))
}