phases:
  - name: build
    steps:
      - action: ExecuteBash
        inputs:
          commands:
            - "systemctl daemon-reload"
        name: ${NAME}
        onFailure: "Abort"
schemaVersion: 1.0