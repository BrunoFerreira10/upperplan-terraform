#!/usr/bin/env bash
trap 'echo ""; echo "Erro no comando ${0}: ${BASH_COMMAND} na linha: ${LINENO}."' ERR

## ---------------------------------------------------------------------------------------------------------------------
## Captura os recursos passados como parâmetros
## ---------------------------------------------------------------------------------------------------------------------
RESOURCE=$(echo "$1" | xargs)
ACTION=$(echo "$2" | xargs)

## ---------------------------------------------------------------------------------------------------------------------
## Caminho base do script
## ---------------------------------------------------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETUP_DIR="$(dirname "$SCRIPT_DIR")"
TF_HOME_DIR="$(dirname "$SETUP_DIR")"

## ---------------------------------------------------------------------------------------------------------------------
## Uso do script e verificação dos parâmetros
## ---------------------------------------------------------------------------------------------------------------------
usage() {
  echo ""
  echo "Uso: $0 <RESOURCE> <ACTION>"
  echo "Exemplos:"
  echo "$0 0 apply"
  echo "$0 01a destroy"
  echo "$0 dev_a apply"
  echo ""
  exit 1 
}

if [ -z "$1" ]; then
  echo ""
  echo "Erro: Nenhum recurso foi especificado."
  usage
fi

if [ -z "$2" ]; then
  echo ""
  echo "Erro: Nenhuma ação foi especificada."
  usage
fi

## ---------------------------------------------------------------------------------------------------------------------
## Define variáveis do sub-projeto
## ---------------------------------------------------------------------------------------------------------------------
. $SCRIPT_DIR/read-project-vars-ini.sh $RESOURCE $ACTION

## ---------------------------------------------------------------------------------------------------------------------
## Executa o terraform init
## ---------------------------------------------------------------------------------------------------------------------

# Executa o init somente se o arquivo .terraform.locl.hcl não existir
if [ ! -f "$LOCAL_FOLDER/.terraform.lock.hcl" ]; then
  # Utiliza o arquivo backend.tfvars se existir
  if [ -f "$LOCAL_FOLDER/backend.tfvars" ]; then
    terraform -chdir="$LOCAL_FOLDER" init -backend-config=./backend.tfvars
  else
    terraform -chdir="$LOCAL_FOLDER" init
  fi
fi

## ---------------------------------------------------------------------------------------------------------------------
## Executa o terraform apply ou destroy. Conforme valor de $ACTION
## ---------------------------------------------------------------------------------------------------------------------

# Caso seja o sub-projeto github_sync, executa o script Workflow no GitHub Actions
if [ "$SUB_PROJECT_NAME" == "github_sync" ]; then
  echo "Executar Workflow no GitHub Actions"
  echo ""
  . $SCRIPT_DIR/run-workflow.sh $RESOURCE $ACTION
else
  # Para os outros sub-projetos
  echo "Executar Terraform localmente"
  echo ""
  terraform -chdir="$LOCAL_FOLDER" $SELECTED_ACTION -auto-approve \
    -var-file=./variables.tfvars
fi

## ---------------------------------------------------------------------------------------------------------------------
## Limpa o diretório .terraform e o arquivo l (se necessário)
## ---------------------------------------------------------------------------------------------------------------------

## ---------------------------------------------------------------------------------------------------------------------
## Imprime o resumo da operação
## ---------------------------------------------------------------------------------------------------------------------
if [ -z "$GITHUB_ACTIONS" ]; then
  echo ""
  echo "-- RESUMO DA OPERAÇÃO --------------------------------------------------"
  echo "-- SELECTED_ACTION  = '$SELECTED_ACTION'"
  echo "-- ACTION_LABEL     = '$ACTION_LABEL'"
  echo "-- SUB_PROJECT_NAME = '$SUB_PROJECT_NAME'"
  echo "-- LOCAL_FOLDER     = '$LOCAL_FOLDER'"
  echo "------------------------------------------------------------------------"
  echo ""
fi
