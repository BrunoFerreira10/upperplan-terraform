phases:
  - name: build
    steps:
      - action: ExecuteBash
        inputs:
          commands:
            - "apt remove -y apache2"
        name: ${NAME}
        onFailure: "Abort"
schemaVersion: 1.0