import json
import requests
import os

def lambda_handler(event, context):
    # URL da API do GLPI
    glpi_api_url = os.getenv('GLPI_API_URL')
    glpi_app_token = os.getenv('GLPI_APP_TOKEN')
    glpi_username = os.getenv('GLPI_USERNAME')  # Defina isso como uma variável de ambiente
    glpi_password = os.getenv('GLPI_PASSWORD')  # Defina isso como uma variável de ambiente
    
    # Iniciar sessão para obter o Session-Token
    session_url = f"{glpi_api_url}/apirest.php/initSession"
    headers = {
        "App-Token": glpi_app_token,
        "Content-Type": "application/json"
    }

    try:
        # Fazer a autenticação com username e password
        session_response = requests.get(session_url, auth=(glpi_username, glpi_password), headers=headers)

        # Verificar se a autenticação foi bem-sucedida
        if session_response.status_code == 200:
            session_token = session_response.json().get('session_token')
        else:
            return {
                'statusCode': session_response.status_code,
                'body': json.dumps(f'Falha na autenticação. Status: {session_response.status_code}')
            }

        # Definir o Session-Token nos cabeçalhos para as próximas requisições
        headers["Session-Token"] = session_token

        # Endpoint da tarefa 'queuednotification'
        cron_task_url = f"{glpi_api_url}/apirest.php/crontask/queuednotification"

        # Fazer a requisição para a API do GLPI
        response = requests.get(cron_task_url, headers=headers)

        # Verificar se a requisição foi bem-sucedida
        if response.status_code == 200:
            return {
                'statusCode': 200,
                'body': json.dumps('Tarefa queuednotification executada com sucesso.')
            }
        else:
            return {
                'statusCode': response.status_code,
                'body': json.dumps(f'Falha ao executar a tarefa. Status: {response.status_code}')
            }
    
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f"Erro ao executar a tarefa: {str(e)}")
        }
