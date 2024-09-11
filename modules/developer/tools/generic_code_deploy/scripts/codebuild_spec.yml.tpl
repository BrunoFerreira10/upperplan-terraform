version: 0.2

phases:
  install:
    commands:
      - apt update
      - apt install -y zip  # Instalar a ferramenta zip
  build:
    commands:
      - echo "------ Copiar arquivos para a pasta build, exceto a própria pasta build ------"
      - mkdir -p build
      - ls -la
      - rsync -av --exclude='build' ./ build/

artifacts:
  files:
    - "**/*"
  discard-paths: no
  base-directory: "build"
