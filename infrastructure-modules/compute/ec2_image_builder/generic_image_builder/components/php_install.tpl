phases:
  - name: build
    steps:
      - action: ExecuteBash
        inputs:
          commands:
            - |
              apt-get install -y php php-mysql php-gd php-curl php-xml \
                php-mbstring php-zip php-bcmath php-intl php-soap php-cli
              apt-get install -y php-fpm
        name: ${NAME}
        onFailure: "Abort"
schemaVersion: 1.0