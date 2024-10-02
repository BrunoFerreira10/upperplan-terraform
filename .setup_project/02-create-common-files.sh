#!/bin/bash

## ---------------------------------------------------------------------------------------------------------------------
## Caminho base do script
## ---------------------------------------------------------------------------------------------------------------------
## Define o caminho absoluto onde o script está localizado
SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TF_HOME_DIR="$(dirname "$SETUP_DIR")"

## ---------------------------------------------------------------------------------------------------------------------
## Carregar variáveis do arquivo .env
## ---------------------------------------------------------------------------------------------------------------------
## Verificar se o arquivo .env existe
ENV_FILE="$SETUP_DIR/.env"
if [ -f "$ENV_FILE" ]; then
  source "$ENV_FILE"
else
  echo "Arquivo .env não encontrado!"
  return 1 2>/dev/null || exit 1
fi

## Carregar diretórios ignorados do arquivo .config.json
CONFIG_FILE="$SETUP_DIR/.config.json"
if [ -f "$CONFIG_FILE" ]; then
  IGNORED_DIRECTORIES=$(jq -r '.ignored_directories[]' "$CONFIG_FILE")
  echo "Diretórios ignorados:"
  echo "${IGNORED_DIRECTORIES[@]}"
  echo ""
else
  echo "Arquivo .config.json não encontrado!"
  return 1 2>/dev/null || exit 1
fi

## ---------------------------------------------------------------------------------------------------------------------
## Configuração do script
## ---------------------------------------------------------------------------------------------------------------------
## Usar as variáveis carregadas do .env
GITHUB_REPO_OWNER=$(basename "$(dirname "$GITHUB_REPOSITORY")")
GITHUB_REPO_NAME=$(basename "$GITHUB_REPOSITORY")
GITHUB_TOKEN=$PERSONAL_ACCESS_TOKEN

## Função para obter variáveis do GitHub Actions
get_action_variable() {
  VARIABLE_NAME=$1

  if [ "$VARIABLE_NAME" = "REMOTE_STATE_FOLDER" ]; then
    echo "$RESOURCE"
    return 0 2>/dev/null || exit 0
  fi  

  curl -s -H "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/repos/$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME/actions/variables/$VARIABLE_NAME" | \
    jq -r .value
}

## ---------------------------------------------------------------------------------------------------------------------
## Gerar aquivos comuns .project_bucket
## ---------------------------------------------------------------------------------------------------------------------
  
## -- providers.tf ---------------------------------------------------------------------------------------------------
cp $SETUP_DIR/.common.providers.tf $SETUP_DIR/.project_bucket/providers.tf

## Substituir placeholders pelos valores das variáveis no providers.tf
placeholders=$(grep -oP '\[\K[^\]]+' $SETUP_DIR/.project_bucket/providers.tf) 
for var in $placeholders; do
  value=$(get_action_variable "$var")  # Obter o valor da variável correspondente
  if [ -n "$value" ]; then
    sed -i "s/\[$var\]/$value/g" $SETUP_DIR/.project_bucket/providers.tf  # Substituir o placeholder pelo valor
    if [ $? -ne 0 ]; then  # Verifica se o comando sed falhou
      echo "Erro ao substituir a variável $var no arquivo .project_bucket/providers.tf."
      return 1 2>/dev/null || exit 1
    fi
  else
    echo "Falha na criação do arquivo providers.tf."
    echo "A variável $var não foi encontrada."
    return 1 2>/dev/null || exit 1
  fi
done
echo "Arquivo project_bucket/providers.tf gerado com sucesso!"

## ---------------------------------------------------------------------------------------------------------------------
## Gerar aquivos comuns .parameter_store_sync
## ---------------------------------------------------------------------------------------------------------------------
  
## -- terraform.tf ---------------------------------------------------------------------------------------------------
cp $SETUP_DIR/.common.terraform.tf $SETUP_DIR/.parameter_store_sync/terraform.tf  
echo "Arquivo parameter_store_sync/terraform.tf gerado com sucesso!"

## -- providers.tf ---------------------------------------------------------------------------------------------------
cp $SETUP_DIR/.common.providers.tf $SETUP_DIR/.parameter_store_sync/providers.tf

## Substituir placeholders pelos valores das variáveis no providers.tf
placeholders=$(grep -oP '\[\K[^\]]+' $SETUP_DIR/.parameter_store_sync/providers.tf) 
for var in $placeholders; do
  value=$(get_action_variable "$var")  # Obter o valor da variável correspondente
  if [ -n "$value" ]; then
    sed -i "s/\[$var\]/$value/g" $SETUP_DIR/.parameter_store_sync/providers.tf  # Substituir o placeholder pelo valor
    if [ $? -ne 0 ]; then  # Verifica se o comando sed falhou
      echo "Erro ao substituir a variável $var no arquivo .parameter_store_sync/providers.tf."
      return 1 2>/dev/null || exit 1
    fi
  else
    echo "Falha na criação do arquivo providers.tf."
    echo "A variável $var não foi encontrada."
    return 1 2>/dev/null || exit 1
  fi
done
echo "Arquivo parameter_store_sync/providers.tf gerado com sucesso!"

## -- backend.tfvars -------------------------------------------------------------------------------------------------
RESOURCE="parameter_store_sync"
cp $SETUP_DIR/.common.backend.tfvars $SETUP_DIR/.parameter_store_sync/backend.tfvars

## Substituir placeholders pelos valores das variáveis no backend.tfvars
placeholders=$(grep -oP '\[\K[^\]]+' $SETUP_DIR/.parameter_store_sync/backend.tfvars)
for var in $placeholders; do
  value=$(get_action_variable "$var")  # Obter o valor da variável correspondente
  if [ -n "$value" ]; then
    sed -i "s/\[$var\]/$value/g" $SETUP_DIR/.parameter_store_sync/backend.tfvars  # Substituir o placeholder pelo valor
    if [ $? -ne 0 ]; then  # Verifica se o comando sed falhou
      echo "Erro ao substituir a variável $var no arquivo .parameter_store_sync/backend.tfvars."
      return 1 2>/dev/null || exit 1
    fi
  else
    echo "Falha na criação do arquivo backend.tfvars."
    echo "A variável $var não foi encontrada."
    return 1 2>/dev/null || exit 1
  fi
done
echo "Arquivo parameter_store_sync/backend.tfvars gerado com sucesso!"


return 0 2>/dev/null || exit 0
## ---------------------------------------------------------------------------------------------------------------------
## Gerar aquivos comuns para os subprojetos
## ---------------------------------------------------------------------------------------------------------------------

## Iterar sobre todos os diretórios no diretório superior ao script
for dir in "$TF_HOME_DIR"/*/; do
  LOCAL_FOLDER=$(basename "$dir")
  SUB_PROJECT_NAME=$(echo "$LOCAL_FOLDER" | awk -F'-' '{print $2}')
  
  should_ignore=false
  for ignored_dir in ${IGNORED_DIRECTORIES[@]}; do
    if [ "$ignored_dir" == "$LOCAL_FOLDER" ]; then
      should_ignore=true
      break
    fi
  done

  if [ "$should_ignore" = true ]; then
    echo "----- Ignorando diretório: ${LOCAL_FOLDER} -----"
    continue
  fi

  echo "Processando diretório: ${LOCAL_FOLDER}"

  ## -- terraform.tf ---------------------------------------------------------------------------------------------------
  cp $SETUP_DIR/.common.terraform.tf $dir/terraform.tf  
  echo "Arquivo parameter_store_sync/terraform.tf gerado com sucesso!"


  ## -- providers.tf ---------------------------------------------------------------------------------------------------
  cp $SETUP_DIR/.common.providers.tf $dir/providers.tf

  ## Substituir placeholders pelos valores das variáveis no providers.tf
  placeholders=$(grep -oP '\[\K[^\]]+' $dir/providers.tf) 
  for var in $placeholders; do
    value=$(get_action_variable "$var")  # Obter o valor da variável correspondente
    if [ -n "$value" ]; then
      sed -i "s/\[$var\]/$value/g" $dir/providers.tf  # Substituir o placeholder pelo valor
      if [ $? -ne 0 ]; then  # Verifica se o comando sed falhou
        echo "Erro ao substituir a variável $var no arquivo $SUB_PROJECT_NAME/providers.tf."
        return 1 2>/dev/null || exit 1
      fi
    else
      echo "Falha na criação do arquivo $SUB_PROJECT_NAME/providers.tf."
      echo "A variável $var não foi encontrada."
      return 1 2>/dev/null || exit 1
    fi
  done
  echo "Arquivo $SUB_PROJECT_NAME/providers.tf gerado com sucesso!"

  ## -- backend.tfvars -------------------------------------------------------------------------------------------------
  RESOURCE=$SUB_PROJECT_NAME
  cp $SETUP_DIR/.common.backend.tfvars $dir/backend.tfvars

  ## Substituir placeholders pelos valores das variáveis no backend.tfvars
  placeholders=$(grep -oP '\[\K[^\]]+' $dir/backend.tfvars)
  for var in $placeholders; do
    value=$(get_action_variable "$var")  # Obter o valor da variável correspondente
    if [ -n "$value" ]; then
      sed -i "s/\[$var\]/$value/g" $dir/backend.tfvars  # Substituir o placeholder pelo valor
      if [ $? -ne 0 ]; then  # Verifica se o comando sed falhou
        echo "Erro ao substituir a variável $var no arquivo $dir/backend.tfvars."
        return 1 2>/dev/null || exit 1
      fi
    else
      echo "Falha na criação do arquivo backend.tfvars."
      echo "A variável $var não foi encontrada."
      return 1 2>/dev/null || exit 1
    fi
  done
  echo "Arquivo $dir/backend.tfvars gerado com sucesso!"

done

## ---------------------------------------------------------------------------------------------------------------------

