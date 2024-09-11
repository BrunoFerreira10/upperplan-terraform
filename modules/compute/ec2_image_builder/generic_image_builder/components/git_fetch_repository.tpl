phases:
  - name: build
    steps:
      - action: ExecuteBash
        inputs:
          commands: 
            - |
              echo '${NAME}: Iniciando ssh-agent'
              eval $(ssh-agent -s)
            - |
              echo '${NAME}: Adicionando chave privada do github ao ssh-agent'
              PRIVATE_KEY=$(aws ssm get-parameter --name '/github_secrets/ssh_private_key_github' --with-decryption --query 'Parameter.Value' --output text)
              mkdir /tmp/gitkey
              echo "$PRIVATE_KEY" > /tmp/gitkey/github_ssh_key
              chmod 600 /tmp/gitkey/github_ssh_key
              ssh-add /tmp/gitkey/github_ssh_key
              rm -rf /tmp/gitkey
            - |
              echo '${NAME}: Configurando variavel de ambiente HOME'
              export HOME="/root"
            - |
              echo '${NAME}: Configurando /tmp/app com um diretório seguro para o git.'
              mkdir /tmp/app
              git config --global --add safe.directory /tmp/app
            - |
              echo '${NAME}: Inicializando repositório git'
              cd /tmp/app
              git init
            - |
              echo '${NAME}: Adicionando remote 'origin': ${APP_REPOSITORY_URL}'
              git remote add origin ${APP_REPOSITORY_URL}
            - |
              echo '${NAME}: Excutando git fetch.'
              GIT_SSH_COMMAND='ssh -o StrictHostKeyChecking=no' git fetch origin
            - |
              echo '${NAME}: Executando git reset --hard para origin/master'
              git reset --hard origin/master
        name: ${NAME}
        onFailure: "Abort"
schemaVersion: 1.0