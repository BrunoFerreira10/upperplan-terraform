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
      - docker pull 339712924273.dkr.ecr.us-east-1.amazonaws.com/upperplan-glpi/container:latest --quiet
  build:
    commands:
      - echo "Construindo a imagem Docker"
      - export DOCKER_BUILDKIT=1
      - docker build -t ${REPOSITORY_URI}:latest .
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
