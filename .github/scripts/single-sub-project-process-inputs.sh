#!/bin/bash

# Inicializar variáveis com entradas do usuário
RESOURCE=$(echo "$1" | xargs) # Remove espaços em branco extras ao redor de RESOURCE
ACTION=$(echo "$2" | xargs)   # Remove espaços em branco extras ao redor de ACTION

# Etapa 1: Depuração da entrada
echo "Depuração: Entrada RESOURCE = '$RESOURCE'"
echo "Depuração: Entrada ACTION = '$ACTION'"

# Etapa 2: Processa variável 'ACTION'
if [[ "$ACTION" == "d" ]]; then
  SELECTED_ACTION="destroy"
  ACTION_LABEL="Destroy"
else
  SELECTED_ACTION="apply"
  ACTION_LABEL="Create"
fi

# Gravar as saídas processadas
echo "SELECTED_ACTION=$SELECTED_ACTION" >> $GITHUB_OUTPUT
echo "ACTION_LABEL=$ACTION_LABEL" >> $GITHUB_OUTPUT


# Procurar SUB_PROJECT_NAME
SUB_PROJECT_NAME=$(awk -F ' *= *' -v resource="$RESOURCE" '
  {
    gsub(/[ \t]/, "", $1) # Remove todos os espaços ao redor da chave
    if ($1 == resource) {
      gsub(/^[ \t]*['\''"]?|['\''"]?[ \t]*$/, "", $2); # Remove espaços e aspas ao redor do valor
      print $2
      exit
    }
  }
' project-id.ini | xargs)

# Depuração: Verificar se SUB_PROJECT_NAME foi encontrado
if [ -z "$SUB_PROJECT_NAME" ]; then
  echo "Erro: Recurso não cadastrado no arquivo project-id.ini: '$RESOURCE'"
  exit 1
else
  echo "Depuração: SUB_PROJECT_NAME encontrado: '$SUB_PROJECT_NAME'"
fi

# Etapa 4: Verificar a existência do diretório LOCAL_FOLDER
LOCAL_FOLDER="$RESOURCE-${SUB_PROJECT_NAME}"

# Gravar as saídas processadas
echo "SUB_PROJECT_NAME=$SUB_PROJECT_NAME" >> $GITHUB_OUTPUT
echo "LOCAL_FOLDER=$LOCAL_FOLDER" >> $GITHUB_OUTPUT

# Depuração: Valores de saída
echo "Depuração: Processamento concluído com sucesso."
echo "Depuração: SELECTED_ACTION = '$SELECTED_ACTION'"
echo "Depuração: ACTION_LABEL = '$ACTION_LABEL'"
echo "Depuração: SUB_PROJECT_NAME = '$SUB_PROJECT_NAME'"
echo "Depuração: LOCAL_FOLDER = '$LOCAL_FOLDER'"