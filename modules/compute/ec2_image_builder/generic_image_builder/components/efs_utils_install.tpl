phases:
  - name: build
    steps:
      - action: ExecuteBash
        inputs:
          commands:
            - |
              mkdir /tmp/efs
              cd /tmp/efs
              apt-get -y install git binutils rustc cargo pkg-config libssl-dev
              git clone https://github.com/aws/efs-utils
              cd efs-utils
              ./build-deb.sh
              apt-get -y install ./build/amazon-efs-utils*deb
              cd /
              rm -rf /tmp/efs
        name: ${NAME}
        onFailure: "Abort"
schemaVersion: 1.0