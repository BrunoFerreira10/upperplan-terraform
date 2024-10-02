#!/usr/bin/env bash
set -euEo pipefail
trap 'echo ""; echo "Erro no comando ${0}: ${BASH_COMMAND} na linha: ${LINENO}."' ERR

## ---------------------------------------------------------------------------------------------------------------------
## Captura os recursos passados como parâmetros
## ---------------------------------------------------------------------------------------------------------------------
WORKFLOW=$(echo "$1" | xargs)

# Verifica se $2 foi passado e não está vazio
if [ -n "${2-}" ]; then
  INPUT_1=$(echo "$2" | xargs)
fi

# Verifica se $3 foi passado e não está vazio
if [ -n "${3-}" ]; then
  INPUT_2=$(echo "$3" | xargs)
fi

## ---------------------------------------------------------------------------------------------------------------------
## Uso do script e verificação dos parâmetros
## ---------------------------------------------------------------------------------------------------------------------
usage() {
  echo ""
  echo "Uso: $0 <WORKFLOU> <INPUT-1:OPTIONAL> <INPUT-2:OPTIONAL>"
  echo "Exemplos:"
  echo "$0 project_bucket
  echo "$0 parameter_store_sync a"
  echo "$0 single-sub-project-run 01a a y
  echo "$0 whole-project-run a y"
  echo ""
  exit 1 
}

if [ -z "$1" ]; then
  echo ""
  echo "Erro: Nenhum workflow."
  usage
fi

## ---------------------------------------------------------------------------------------------------------------------
## Definir paths
## ---------------------------------------------------------------------------------------------------------------------
SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETUP_DIR="$(dirname "$SCRIPTS_DIR")"
TF_HOME_DIR="$(dirname "$SETUP_DIR")"

## ---------------------------------------------------------------------------------------------------------------------
## Includes
## ---------------------------------------------------------------------------------------------------------------------
source "$SCRIPTS_DIR/common.sh"

## ---------------------------------------------------------------------------------------------------------------------
## Carregar variáveis do arquivo .env
## ---------------------------------------------------------------------------------------------------------------------
ENV_FILE="$SETUP_DIR/.env"
if [ -f "$ENV_FILE" ]; then
  source "$ENV_FILE"
else
  echo "Arquivo .env não encontrado!"
  return 1 2>/dev/null || exit 1  # Usar return se possível, ou exit 1
fi

## ---------------------------------------------------------------------------------------------------------------------
## Extrair o dono e o nome do repositório a partir da variável GITHUB_REPOSITORY
## Estas variáveis são carregadas diretamente do arquivo .env
## ---------------------------------------------------------------------------------------------------------------------
GITHUB_REPO_OWNER=$(basename "$(dirname "$GITHUB_REPOSITORY")")
GITHUB_REPO_NAME=$(basename "$GITHUB_REPOSITORY")

# Token de acesso para a API do GitHub (carregado do .env)
GITHUB_TOKEN=$PERSONAL_ACCESS_TOKEN

## ---------------------------------------------------------------------------------------------------------------------
## Definir os parâmetros de entrada que serão passados para o workflow
## Os parâmetros podem ser configurados ou alterados conforme a necessidade
## ---------------------------------------------------------------------------------------------------------------------
WORKFLOW_FILE_NAME="$WORKFLOW.yml"
BRANCH="refs/heads/master"

## ---------------------------------------------------------------------------------------------------------------------
## Disparar o workflow via API do GitHub usando curl e monitorar execução
## ---------------------------------------------------------------------------------------------------------------------

## Função para recuperar o check_suite_id do workflow em execução
get_check_suite_id() {
  local workflow_run_id=$1
  response=$(curl -s -L \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
       "https://api.github.com/repos/$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME/actions/runs?status=in_progress")
  # Extrair o check_suite_id do primeiro workflow em progresso
  check_suite_id=$(echo "$response" | jq -r '.workflow_runs[0].check_suite_id')
  echo "$check_suite_id"
}

## Função para recuperar o status do workflow em execução
get_status() {
  local check_suite_id=$1
  response=$(curl -s -L \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
       "https://api.github.com/repos/$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME/actions/runs?check_suite_id=$check_suite_id")
  # Extrair o check_suite_id do primeiro workflow em progresso
  status=$(echo "$response" | jq -r '.workflow_runs[0].status')
  echo "$status"
}

## Função para recuperar a conclusão do workflow em execução
get_conclusion() {
  local check_suite_id=$1
  response=$(curl -s -L \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
       "https://api.github.com/repos/$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME/actions/runs?check_suite_id=$check_suite_id")
  # Extrair o check_suite_id do primeiro workflow em progresso
  conclusion=$(echo "$response" | jq -r '.workflow_runs[0].conclusion')
  echo "$conclusion"
}

## ---------------------------------------------------------------------------------------------------------------------
## Configuração do payload para disparar o workflow
## ---------------------------------------------------------------------------------------------------------------------
PAYLOAD=""

if [ "$WORKFLOW" = "create-project-bucket" ]; then
  PAYLOAD=$(cat <<EOF
{
  "ref": "$BRANCH"
}
EOF
)
fi

if [ "$WORKFLOW" = "sync-parameter-store" ]; then
  ACTION=$INPUT_1
  PAYLOAD=$(cat <<EOF
{
  "ref": "$BRANCH",
   "inputs": {
    "ACTION": "$ACTION",
    "CONFIRMATION": "YES"
  }
}
EOF
)
fi

if [ "$WORKFLOW" = "single-sub-project-run" ]; then
  $PAYLOAD = <<EOF
{
  "ref": "$BRANCH",
  "inputs": {
    "RESOURCE": "$RESOURCE",
    "ACTION": "$ACTION",
    "CONFIRMATION": "YES"
  }
}
EOF
fi

if [ "$WORKFLOW" = "whole-project-run" ]; then
  $PAYLOAD = <<EOF
{
  "ref": "$BRANCH",
  "inputs": {
    "RESOURCE": "$RESOURCE",
    "ACTION": "$ACTION",
    "CONFIRMATION": "YES"
  }
}
EOF
fi

## ---------------------------------------------------------------------------------------------------------------------
## Disparar o workflow via API do GitHub usando curl e monitorar execução
## ---------------------------------------------------------------------------------------------------------------------
echo "Disparando workflow no GitHub Actions..."
response=$(curl -s -w "%{http_code}" -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME/actions/workflows/$WORKFLOW_FILE_NAME/dispatches \
  -d  "$PAYLOAD"
)
if [ $? -ne 0 ]; then
  echo "Erro: Falha ao disparar o workflow."
  return 1 2>/dev/null || exit 1
fi

http_code=$(tail -n 1 <<< "$response")
if [ $http_code -ne 204 ]; then
  echo "Erro: Falha ao disparar o workflow. HTTP code: $http_code"
  return 1 2>/dev/null || exit 1
fi

## ---------------------------------------------------------------------------------------------------------------------
## Obter o ID do workflow e monitorar a execução
## ---------------------------------------------------------------------------------------------------------------------
echo "Obtendo ID do workflow..."
response=$(curl -s -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME/actions/workflows/$WORKFLOW_FILE_NAME")
# Extrair o ID do workflow
workflow_id=$(echo "$response" | jq -r '.id')
# Exibir o ID do workflow
echo "ID do workflow: $workflow_id"
echo ""

## ---------------------------------------------------------------------------------------------------------------------
## Recuperar o check_suite_id do workflow em execução
## ---------------------------------------------------------------------------------------------------------------------

## Aguardar alguns segundos para garantir que o workflow tenha tempo de iniciar
echo "Aguardando o workflow iniciar..."
sleep 5

## Aguardar e recuperar o check_suite_id, até 15 segundos
attempt=0
max_attempts=15
while [ $attempt -lt $max_attempts ]; do
  check_suite_id=$(get_check_suite_id "$workflow_id")

  # Verifica se check_suite_id não está vazio e não é "null"
  if [ -n "$check_suite_id" ] && [ "$check_suite_id" != "null" ]; then
    echo "Workflow iniciado com check_suite_id: $check_suite_id"
    echo ""
    break
  fi

  attempt=$((attempt + 1))
  echo "Tentativa $attempt de $max_attempts falhou, aguardando 2 segundos..."
  sleep 2
done

if [ $attempt -ge $max_attempts ]; then
  echo "Erro: Número máximo de tentativas atingido. Não foi possível obter o check_suite_id."
  return 1 2>/dev/null || exit 1
fi


## ---------------------------------------------------------------------------------------------------------------------
## Verificar o status do workflow e aguardar a conclusão
## ---------------------------------------------------------------------------------------------------------------------
echo "Aguardando conclusão do workflow..."
while true; do
  status=$(get_status "$check_suite_id")
  echo "Status atual: $status"
  
  if [ "$status" == "completed" ]; then
    conclusion=$(get_conclusion "$check_suite_id")
    
    if [ "$conclusion" == "success" ]; then
      echo ""
      echo "Workflow concluído com sucesso!"
      echo ""
      return 0 2>/dev/null || exit 0
    else
      echo ""
      echo "Erro: O workflow falhou com a conclusão: $conclusion"
      echo ""
      return 1 2>/dev/null || exit 1
    fi
  fi
  sleep 3
done

## ---------------------------------------------------------------------------------------------------------------------


