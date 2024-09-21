import json
import requests
import os
from requests.auth import HTTPBasicAuth

def lambda_handler(event, context):
    # Extrair informações do e-mail recebido pelo SES
    ses_message = event['Records'][0]['ses']['mail']
    
    sender = ses_message['source']
    subject = ses_message['commonHeaders']['subject']
    message_id = ses_message['messageId']

    # Informações de autenticação e URL da API do GLPI
    glpi_api_url = os.getenv('GLPI_API_URL')
    glpi_username = os.getenv('GLPI_USERNAME')
    glpi_password = os.getenv('GLPI_PASSWORD')
    glpi_app_token = os.getenv('GLPI_APP_TOKEN')

    # Iniciar sessão no GLPI para obter o Session-Token
    session_url = f"{glpi_api_url}/initSession"
    headers = {
        "App-Token": glpi_app_token,
        "Content-Type": "application/json"
    }

    session_response = requests.get(session_url, auth=HTTPBasicAuth(glpi_username, glpi_password), headers=headers)
    
    if session_response.status_code != 200:
        return {
            'statusCode': session_response.status_code,
            'body': json.dumps(f"Erro ao iniciar sessão: {session_response.text}")
        }

    # Obter o session token
    session_token = session_response.json().get('session_token')

    # Construir o payload para a criação de um chamado no GLPI
    create_ticket_url = f"{glpi_api_url}/Ticket"
    headers["Session-Token"] = session_token

    payload = {
        "input": {
            "name": subject,
            "content": f"Chamado criado a partir do e-mail enviado por {sender}. Message ID: {message_id}",
            "requesttypes_id": 1,  # Tipo de solicitação
            "type": 1  # Tipo de chamado
        }
    }

    # Enviar a requisição POST para criar o ticket no GLPI
    ticket_response = requests.post(create_ticket_url, headers=headers, json=payload)
    
    if ticket_response.status_code == 201:
        return {
            'statusCode': 201,
            'body': json.dumps('Chamado criado com sucesso no GLPI!')
        }
    else:
        return {
            'statusCode': ticket_response.status_code,
            'body': json.dumps(f"Erro ao criar chamado: {ticket_response.text}")
        }
