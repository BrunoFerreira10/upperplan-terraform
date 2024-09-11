#!/bin/bash

LOCAL_FOLDER=$(echo "$1" | xargs)
VARIABLES="$2"

# Verifica se o arquivo variables.tfvars existe, se não cria um novo
VARIABLES_FILE="$LOCAL_FOLDER/variables.tfvars"

# Adiciona variáveis ao arquivo
echo "$VARIABLES" | jq -r 'to_entries | .[] | "\(.key) = \"\(.value)\""' >> "$VARIABLES_FILE"