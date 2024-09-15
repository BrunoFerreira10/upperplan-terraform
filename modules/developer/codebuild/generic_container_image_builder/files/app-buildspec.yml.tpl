version: 0.2

phases:
  install:
    commands:
      - echo "Atualizando pacotes e instalando o Docker"
      - apt-get update
      - apt-get install -y docker.io
  pre_build:
    commands:
      - echo "Pre build vazio"
  build:
    commands:
      - echo "Logando no Amazon ECR"
      - aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${REPOSITORY_URI}
      - echo "Construindo a imagem Docker"
      - docker build -t ${REPOSITORY_URI}:latest .
      - docker tag ${REPOSITORY_URI}:latest ${REPOSITORY_URI}:latest
  post_build:
    commands:
      - echo "Fazendo push da imagem para o Amazon ECR"
      - docker push ${REPOSITORY_URI}:latest
      - echo "Build e push da imagem Docker concluídos com sucesso"
      - echo "Gerando aquivo zip do build do container"
      - mkdir -p app-build
      - ls -la
      - rsync -av --exclude='app-build' ./ app-build/
artifacts:
  files:
    - "**/*"
  discard-paths: no
  base-directory: "app-build"
