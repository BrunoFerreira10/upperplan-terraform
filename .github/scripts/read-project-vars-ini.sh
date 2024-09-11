#!/bin/bash

LOCAL_FOLDER=$(echo "$1" | xargs)  # Remove espaços em branco extras
SUB_PROJECT_NAME=$(echo "$2" | xargs)  # Remove espaços em branco extras
VARS_JSON="$3"

# Usar printf para depuração
printf "Bruto LOCAL_FOLDER: '%s'\n" "$1"
printf "Limpo LOCAL_FOLDER: '%s'\n" "$LOCAL_FOLDER"

# Depuração: Imprimir entrada
echo "LOCAL_FOLDER: -$LOCAL_FOLDER-"
echo "SUB_PROJECT_NAME: -$SUB_PROJECT_NAME-"
echo "VARS_JSON: $VARS_JSON"

#######################################
##### Determinar valor de USE_SSH #####
#######################################

# Variável default para USE_SSH
USE_SSH_DEFAULT='false'

# Capturar e imprimir a seção completa do arquivo project-vars.ini
SECTION=$(awk -v section="$SUB_PROJECT_NAME" '
  $0 ~ "\\[" section "\\]" { in_section=1; next }
  in_section && $0 ~ /^\[/ { exit }
  in_section { print }
' project-vars.ini)

# Depuração: Imprimir a seção lida
echo "Seção lida para $SUB_PROJECT_NAME:"
echo "$SECTION"

# Ler a configuração USE_SSH da seção capturada
USE_SSH=$(echo "$SECTION" | awk -F '=' '
  $1 ~ /USE_SSH/ {
    gsub(/[ \t]+$/, "", $2)
    print $2
  }
' | xargs)

# Depuração: Imprimir valor lido para USE_SSH
echo "Valor lido para USE_SSH: $USE_SSH"

# Usar valor default se USE_SSH não estiver definido
if [ -z "$USE_SSH" ]; then
  USE_SSH=$USE_SSH_DEFAULT
fi

# Converter o valor lido para booleano
if [ "$USE_SSH" = "true" ] || [ "$USE_SSH" = "TRUE" ] || [ "$USE_SSH" = "True" ]; then
  USE_SSH=true
else
  USE_SSH=false
fi

# Definir variável de ambiente e saída
echo "USE_SSH=$USE_SSH" >> $GITHUB_OUTPUT
echo "USE_SSH=$USE_SSH"

###########################################
##### Determinar valor de USE_BACKEND #####
###########################################

# Variável default para USE_BACKEND
USE_BACKEND_DEFAULT='false'

# Capturar e imprimir a seção completa do arquivo project-vars.ini
SECTION=$(awk -v section="$SUB_PROJECT_NAME" '
  $0 ~ "\\[" section "\\]" { in_section=1; next }
  in_section && $0 ~ /^\[/ { exit }
  in_section { print }
' project-vars.ini)

# Depuração: Imprimir a seção lida
echo "Seção lida para $SUB_PROJECT_NAME:"
echo "$SECTION"

# Ler a configuração USE_BACKEND da seção capturada
USE_BACKEND=$(echo "$SECTION" | awk -F '=' '
  $1 ~ /USE_BACKEND/ {
    gsub(/[ \t]+$/, "", $2)
    print $2
  }
' | xargs)

# Depuração: Imprimir valor lido para USE_BACKEND
echo "Valor lido para USE_BACKEND: $USE_BACKEND"

# Usar valor default se USE_BACKEND não estiver definido
if [ -z "$USE_BACKEND" ]; then
  USE_BACKEND=$USE_BACKEND_DEFAULT
fi

# Converter o valor lido para booleano
if [ "$USE_BACKEND" = "true" ] || [ "$USE_BACKEND" = "TRUE" ] || [ "$USE_BACKEND" = "True" ]; then
  USE_BACKEND=true
else
  USE_BACKEND=false
fi

# Definir variável de ambiente e saída
echo "USE_BACKEND=$USE_BACKEND" >> $GITHUB_OUTPUT
echo "USE_BACKEND=$USE_BACKEND"

###############################################################
##### Adicionar variáveis padrão ao variables.tfvars ##########
##### de todos os sub-projetos                       ##########
###############################################################

# Adicionar variáveis GENERAL_ ao variables.tfvars
# echo "Adicionando variáveis GENERAL_ ao variables.tfvars"

# GENERAL_VARS=$(echo "$VARS_JSON" | jq -r 'to_entries | map(select(.key | startswith("GENERAL_"))) | from_entries')

# echo "GENERAL_VARS: $GENERAL_VARS"

# for var in $(echo "$GENERAL_VARS" | jq -r 'keys[]'); do
#   value=$(echo "$GENERAL_VARS" | jq -r --arg var "$var" '.[$var]')
#   echo "Adicionando variável: $var com valor: $value"
#   ./.github/scripts/add-to-variables.sh "$LOCAL_FOLDER" "{\"$var\":\"$value\"}"
# done

###############################################################
##### Adicionar variáveis específicas ao variables.tfvars #####
###############################################################
VARIABLES_FILE="$LOCAL_FOLDER/variables.tfvars"
if [ ! -f "$VARIABLES_FILE" ]; then
  touch "$VARIABLES_FILE"
fi

# Ler variáveis específicas do arquivo project-vars.ini e adicionar ao variables.tfvars
PROJECT_VARS=$(echo "$SECTION" | awk -F '=' '
  $1 ~ /^[a-zA-Z0-9_-]+$/ { gsub(/[ \t]+$/, "", $1); print $1 }
')

echo "PROJECT_VARS: $PROJECT_VARS"

for var in $(echo "$VARS_JSON" | jq -r 'keys[]'); do
  lower_var=$(echo "$var" | tr '[:upper:]' '[:lower:]')
  echo "Checking if $var is in PROJECT_VARS"
  if echo "$PROJECT_VARS" | grep -q "^$var$"; then
    value=$(echo "$VARS_JSON" | jq -r --arg var "$var" '.[$var]')
    echo "Adding variable: $lower_var with value: $value"
    ./.github/scripts/add-to-variables.sh "$LOCAL_FOLDER" "{\"$lower_var\":\"$value\"}"
  else
    echo "$var is not in PROJECT_VARS"
  fi
done