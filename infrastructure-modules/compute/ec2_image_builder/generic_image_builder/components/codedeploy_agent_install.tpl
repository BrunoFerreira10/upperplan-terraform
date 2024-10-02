phases:
  - name: build
    steps:
      - action: ExecuteBash
        inputs:
          commands:
            - sudo apt install -y ruby-full
            - cd /home/ubuntu
            - wget https://aws-codedeploy-${REGION}.s3.${REGION}.amazonaws.com/latest/install
            - chmod +x ./install
            - ./install auto
            - |
              sudo bash -c 'echo ":enable_auth_policy: true" >> /etc/codedeploy-agent/conf/codedeployagent.yml'
            - sudo systemctl daemon-reload
            - sudo systemctl restart codedeploy-agent.service
        name: ${NAME}
        onFailure: "Abort"
schemaVersion: 1.0