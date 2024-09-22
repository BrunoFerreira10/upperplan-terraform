import json
import requests
import os

def lambda_handler(event, context):
    # URL da API do GLPI
    
    glpi_api_url = os.getenv('GLPI_API_URL')
    glpi_app_token = os.getenv('GLPI_APP_TOKEN')
    
    # Definir cabeçalhos
    headers = {
        "App-Token": glpi_app_token,
        "Content-Type": "application/json"
    }

    # Endpoint da tarefa 'queuednotification'
    cron_task_url = f"{glpi_api_url}/apirest.php/crontask/queuednotification"

    try:
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
