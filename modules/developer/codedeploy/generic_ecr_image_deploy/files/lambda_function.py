import boto3
import json
import os

def lambda_handler(event, context):
    codedeploy = boto3.client('codedeploy')
    sns_message = event['Records'][0]['Sns']['Message']
    message_json = json.loads(sns_message)
    bucket = message_json['Records'][0]['s3']['bucket']['name']
    key = message_json['Records'][0]['s3']['object']['key']
    
    application_name = os.environ['APPLICATION_NAME']
    deployment_group_name = os.environ['DEPLOYMENT_GROUP_NAME']
    
    # Iniciar o deployment no CodeDeploy
    response = codedeploy.create_deployment(
        applicationName=application_name,
        deploymentGroupName=deployment_group_name,
        revision={
            'revisionType': 'S3',
            's3Location': {
                'bucket': bucket,
                'key': key,
                'bundleType': 'zip'
            }
        }
    )
    
    print("Deployment initiated:", response)
