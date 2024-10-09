phases:
  - name: build
    steps:
      - action: ExecuteBash
        inputs:
          commands:
            - "apt update"
        name: ${NAME}
        onFailure: "Abort"
schemaVersion: 1.0