#!/usr/bin/env bash
set -euEo pipefail
trap 'echo ""; echo "Erro no comando ${0}: ${BASH_COMMAND} na linha: ${LINENO}."' ERR

## ---------------------------------------------------------------------------------------------------------------------
## Definir paths
## ---------------------------------------------------------------------------------------------------------------------
SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TF_HOME_DIR="$(dirname "$SETUP_DIR")"

## ---------------------------------------------------------------------------------------------------------------------
## Includes
## ---------------------------------------------------------------------------------------------------------------------

## Funções do common.sh utilizadas neste script
# exit_with_error
# upsert_github_variable
source "$SETUP_DIR/.scripts/common.sh"

## ---------------------------------------------------------------------------------------------------------------------
## Verificar se jq está instalado
## ---------------------------------------------------------------------------------------------------------------------
if ! command -v jq &> /dev/null; then
  exit_with_error "'jq' não está instalado. Por favor, instale-o para continuar."
fi

## ---------------------------------------------------------------------------------------------------------------------
## Carregar variáveis do arquivo .env
## ---------------------------------------------------------------------------------------------------------------------
ENV_FILE="$SETUP_DIR/.env"
if [ -f "$ENV_FILE" ]; then
  source "$ENV_FILE"
else
  exit_with_error "Arquivo .env não encontrado!"
fi

## ---------------------------------------------------------------------------------------------------------------------
## Carregar variáveis do arquivo .config.json
## ---------------------------------------------------------------------------------------------------------------------
CONFIG_FILE="$SETUP_DIR/.config.json"
if [ -f "$CONFIG_FILE" ]; then
  IGNORED_DIRECTORIES=$(jq -r '.ignored_directories[]' "$CONFIG_FILE")
else
  exit_with_error "Arquivo .config.json não encontrado!"
fi

## ---------------------------------------------------------------------------------------------------------------------
## Configuração do repositório e autenticação
## ---------------------------------------------------------------------------------------------------------------------
GITHUB_REPO_OWNER=$(basename "$(dirname "$GITHUB_REPOSITORY")")
GITHUB_REPO_NAME=$(basename "$GITHUB_REPOSITORY")
GITHUB_TOKEN=$PERSONAL_ACCESS_TOKEN

## ---------------------------------------------------------------------------------------------------------------------
## Iterar sobre as variáveis definidas no .config.json para github_required_vars
## ---------------------------------------------------------------------------------------------------------------------
echo "Atualizando variáveis obrigatórias..."
for row in $(jq -r '.github_required_vars[] | to_entries[] | @base64' "$CONFIG_FILE"); do
  _jq() {
    echo "${row}" | base64 --decode | jq -r "${1}"
  }

  VAR_NAME=$(_jq '.key')
  VAR_VALUE=$(_jq '.value')

  upsert_github_variable "$VAR_NAME" "$VAR_VALUE"
  if [ $? -ne 0 ]; then
    exit_with_error "Erro ao criar ou atualizar a variável obrigatória. Interrompendo o script."
  fi
done

## ---------------------------------------------------------------------------------------------------------------------
## Iterar sobre as variáveis definidas no .config.json para github_project_vars
## ---------------------------------------------------------------------------------------------------------------------
echo ""
echo "Atualizando variáveis do projeto..."
for row in $(jq -r '.github_project_vars[] | to_entries[] | @base64' "$CONFIG_FILE"); do
  _jq() {
    echo "${row}" | base64 --decode | jq -r "${1}"
  }

  VAR_NAME=$(_jq '.key')
  VAR_VALUE=$(_jq '.value')

  upsert_github_variable "$VAR_NAME" "$VAR_VALUE"
  if [ $? -ne 0 ]; then
    exit_with_error "Erro ao criar ou atualizar a variável do projeto. Interrompendo o script."
  fi
done

echo ""
echo "Variáveis atualizadas com sucesso!"
return 0 2>/dev/null || exit 0

## ---------------------------------------------------------------------------------------------------------------------