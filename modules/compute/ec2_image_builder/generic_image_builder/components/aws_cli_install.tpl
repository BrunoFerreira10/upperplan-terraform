phases:
  - name: build
    steps:
      - action: ExecuteBash
        inputs:
          commands:
            - "apt-get install -y unzip curl"
            - "curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'"
            - "unzip awscliv2.zip"
            - "sudo ./aws/install"
        name: ${NAME}
        onFailure: "Abort"
schemaVersion: 1.0