#!/usr/bin/env bash
set -euEo pipefail

## ---------------------------------------------------------------------------------------------------------------------
## Funções comuns
## ---------------------------------------------------------------------------------------------------------------------
# Saída com erro
exit_with_error() {
  local message=$1
  
  echo -e "Erro: $message"
  return 1 2>/dev/null || exit 1
}

## ---------------------------------------------------------------------------------------------------------------------
## Função para criar ou atualizar uma variável no GitHub Actions
## ---------------------------------------------------------------------------------------------------------------------
upsert_github_variable() {
  local VAR_NAME=$(echo "$1" | xargs)
  local VAR_VALUE=$(echo "$2" | xargs)

  if [ -z "$VAR_NAME" ] || [ -z "$VAR_VALUE" ]; then
    exit_with_error "Nome e valor da variável são obrigatórios. \n\
      VAR_NAME é '$VAR_NAME' e VAR_VALUE é '$VAR_VALUE'"
  fi

  if [ "$VAR_NAME" == "null" ]; then
    exit_with_error "Nome da variável não pode ser nulo. \n\
      VAR_NAME é '$VAR_NAME' e VAR_VALUE é '$VAR_VALUE'"
  fi

  # Verificar se a variável já existe no repositório
  RESPONSE=$(curl -s \
    -H "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/repos/$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME/actions/variables/$VAR_NAME" \
    | jq -r '.name')

  if [ "$RESPONSE" == "null" ]; then
    echo "Criando variável: $VAR_NAME = $VAR_VALUE"
    response=$(curl -s -w "%{http_code}" -X POST \
      -H "Authorization: token $GITHUB_TOKEN" \
      -H "Accept: application/vnd.github.v3+json" \
      "https://api.github.com/repos/$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME/actions/variables" \
      -d "{\"name\":\"$VAR_NAME\",\"value\":\"$VAR_VALUE\"}")
    http_code=$(tail -n 1 <<< "$response")
    if [ $http_code -ne 201 ]; then
      exit_with_error "Erro ao criar a variável $VAR_NAME."
    fi
  else
    echo "Atualizando variável: $VAR_NAME = $VAR_VALUE"
    response=$(curl -s -w "%{http_code}" -X PATCH \
      -H "Authorization: token $GITHUB_TOKEN" \
      -H "Accept: application/vnd.github.v3+json" \
      "https://api.github.com/repos/$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME/actions/variables/$VAR_NAME" \
      -d "{\"name\":\"$VAR_NAME\",\"value\":\"$VAR_VALUE\"}")
    http_code=$(tail -n 1 <<< "$response")
    if [ $http_code -ne 204 ]; then
      exit_with_error "Erro ao atualizar a variável $VAR_NAME."
    fi
  fi
}
## ---------------------------------------------------------------------------------------------------------------------