phases:
  - name: build
    steps:
      - action: ExecuteBash
        inputs:
          commands:
            - "eval $(ssh-agent -s)"
            # Recuperar a chave privada do SSM Parameter Store
            - "PRIVATE_KEY=$(aws ssm get-parameter --name 'SSH_PRIVATE_KEY_GITHUB' --with-decryption --query 'Parameter.Value' --output text)"

            # Passar a chave diretamente para o ssh-add
            - "echo \"$PRIVATE_KEY\" | ssh-add -"
            
        name: ${NAME}
        onFailure: "Abort"
schemaVersion: 1.0
