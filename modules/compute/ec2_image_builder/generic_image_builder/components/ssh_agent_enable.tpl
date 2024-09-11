phases:
  - name: build
    steps:
      - action: ExecuteBash
        inputs:
          commands:
            - "cat << 'EOF' >> /etc/bash.bashrc"
            - "eval $(ssh-agent -s)"
            - "EOF"
        name: "${NAME}"
        onFailure: "Abort"
schemaVersion: 1.0
