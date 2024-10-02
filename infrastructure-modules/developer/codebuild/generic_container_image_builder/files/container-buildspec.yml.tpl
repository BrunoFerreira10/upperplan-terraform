version: 0.2

phases:
  install:
    commands:
      - echo "Install vazio"
  pre_build:
    commands:
      - echo "Logando no Amazon ECR"
      - aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${REPOSITORY_URI}
  build:
    commands:
      - echo "Construindo a imagem Docker"
      - export DOCKER_BUILDKIT=1
      - docker build --build-arg BASE_REPOSITORY_URI=${BASE_REPOSITORY_URI} -t ${REPOSITORY_URI}:latest .
  post_build:
    commands:
      - echo "Taggeando a imagem Docker"
      - docker tag ${REPOSITORY_URI}:latest ${REPOSITORY_URI}:latest

      - echo "Fazendo push da imagem para o Amazon ECR"
      - docker push ${REPOSITORY_URI}:latest --quiet
      
      # - echo "Iniciando o build da segunda imagem"
      # - aws codebuild start-build --project-name ${SHORTNAME}-app --region ${REGION}
      # - echo "Build da segunda imagem iniciado com sucesso"
