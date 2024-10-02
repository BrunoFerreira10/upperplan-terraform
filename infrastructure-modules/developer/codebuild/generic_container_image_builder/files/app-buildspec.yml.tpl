version: 0.2

phases:
  install:
    commands:
      - echo "Install vazio"
  pre_build:
    commands:
      - echo "Logando no Amazon ECR"
      - aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${REPOSITORY_URI}

      - echo "Fazendo pull da imagem base com menos verbosidade"
      - docker pull ${BASE_REPOSITORY_URI}:latest --quiet
  build:
    commands:
      - echo "Dados para configuração do banco de dados"

      - echo "Definindo variáveis de ambiente para diminuir o tamanho das linhas"
      - export SSM_HOST="/upperplan-glpi/prod/app_vars/rds_1_db_host"
      - export SSM_NAME="/upperplan-glpi/prod/github_vars/rds_1_db_name"
      - export SSM_USER="/upperplan-glpi/prod/github_vars/rds_1_db_username"
      - export SSM_PASSWORD="/upperplan-glpi/prod/github_secrets/rds_1_db_password"
      - COMMON_SSM_ARGS="--region us-east-1 --query Parameter.Value --output text"

      - echo "Recuperando valores do AWS SSM"
      - DB_HOST=$(aws ssm get-parameter --name $SSM_HOST $COMMON_SSM_ARGS)
      - DB_NAME=$(aws ssm get-parameter --name $SSM_NAME $COMMON_SSM_ARGS)
      - DB_USER=$(aws ssm get-parameter --name $SSM_USER $COMMON_SSM_ARGS)
      - DB_PASSWORD=$(aws ssm get-parameter --name $SSM_PASSWORD $COMMON_SSM_ARGS --with-decryption)

      - echo "Construindo a imagem Docker"
      - export DOCKER_BUILDKIT=1
      - docker build 
        --build-arg BASE_REPOSITORY_URI=${BASE_REPOSITORY_URI}:latest
        --build-arg DB_HOST="$DB_HOST"
        --build-arg DB_NAME="$DB_NAME"
        --build-arg DB_USER="$DB_USER"
        --build-arg DB_PASSWORD="$DB_PASSWORD"
        -t ${REPOSITORY_URI}:latest .
  post_build:
    commands:
      - echo "Taggeando a imagem Docker"
      - docker tag ${REPOSITORY_URI}:latest ${REPOSITORY_URI}:latest

      - echo "Fazendo push da imagem para o Amazon ECR"
      - docker push ${REPOSITORY_URI}:latest --quiet
      
      - echo "Movendo arquivos para a pasta de build (inicia o deploy)"
      - mkdir -p app-build
      - cp appspec.yml app-build/
artifacts:
  files:
    - "**/*"
  discard-paths: no
  base-directory: "app-build"
