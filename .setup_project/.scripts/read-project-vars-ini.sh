#!/bin/bash

# Inicializar variáveis com entradas do usuário
RESOURCE=$(echo "$1" | xargs)
ACTION=$(echo "$2" | xargs)

# Etapa 2: Processa variável 'ACTION'
if [[ "$ACTION" == "d" ]]; then
  SELECTED_ACTION="destroy"
  ACTION_LABEL="Destroy"
else
  SELECTED_ACTION="apply"
  ACTION_LABEL="Create"
fi

# Procurar SUB_PROJECT_NAME nos diretórios que seguem o padrão {RESOURCE}-{SUB_PROJECT_NAME}
SUB_PROJECT_DIR=$(find . -maxdepth 1 -type d -name "${RESOURCE}-*" | head -n 1)

# Verificar se o diretório correspondente foi encontrado
if [ -z "$SUB_PROJECT_DIR" ]; then
  echo "Erro: Diretório correspondente ao recurso '$RESOURCE' não encontrado."
  return 1 2>/dev/null || exit 1
else
  LOCAL_FOLDER=$(basename "$SUB_PROJECT_DIR")
  SUB_PROJECT_NAME=$(echo "$LOCAL_FOLDER" | awk -F'-' '{print $2}')
  echo "Depuração: SUB_PROJECT_NAME encontrado: '$SUB_PROJECT_NAME'"
fi

# Depuração: Verificar se SUB_PROJECT_NAME foi encontrado
if [ -z "$SUB_PROJECT_NAME" ]; then
  echo "Erro: Recurso não cadastrado no arquivo project-id.ini: '$RESOURCE'"
  # exit 1
else
  echo "Depuração: SUB_PROJECT_NAME encontrado: '$SUB_PROJECT_NAME'"
fi

# Etapa 4: Verificar a existência do diretório LOCAL_FOLDER
LOCAL_FOLDER="$RESOURCE-${SUB_PROJECT_NAME}"

# Gravar as saídas processadas para uso no GITHUB Actions
# Primeiro verifica se está rodando no GitHub Actions ou na máquina local
if [ "$GITHUB_ACTIONS" == "true" ]; then
  echo "Executando no GitHub Actions"
  echo "SELECTED_ACTION=$SELECTED_ACTION" >> $GITHUB_OUTPUT
  echo "ACTION_LABEL=$ACTION_LABEL" >> $GITHUB_OUTPUT
  echo "SUB_PROJECT_NAME=$SUB_PROJECT_NAME" >> $GITHUB_OUTPUT
  echo "LOCAL_FOLDER=$LOCAL_FOLDER" >> $GITHUB_OUTPUT
fi

export SELECTED_ACTION=$SELECTED_ACTION
export ACTION_LABEL=$ACTION_LABEL
export SUB_PROJECT_NAME=$SUB_PROJECT_NAME
export LOCAL_FOLDER=$LOCAL_FOLDER