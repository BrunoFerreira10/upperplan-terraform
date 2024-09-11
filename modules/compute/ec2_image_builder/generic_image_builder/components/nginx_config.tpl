phases:
  - name: build
    steps:
      - action: ExecuteBash
        inputs:
          commands: 
            - |
              echo '${NAME}: Vai para /tmp/app'
              cd /tmp/app
            - |
              echo '${NAME}: Copia configuração padrão do nginx'
              cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
              cp -f ./nginx.conf /etc/nginx/sites-available/default
        name: '${NAME}'
        onFailure: "Abort"
schemaVersion: 1.0