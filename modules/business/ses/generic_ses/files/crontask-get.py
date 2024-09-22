import json
import requests
import os
from requests.auth import HTTPBasicAuth

def lambda_handler(event, context):
    # Obtenção de variáveis de ambiente
    glpi_api_url = os.getenv('GLPI_API_URL').rstrip('/apirest.php/')
    glpi_app_token = os.getenv('GLPI_APP_TOKEN')
    glpi_username = os.getenv('GLPI_USERNAME')
    glpi_password = os.getenv('GLPI_PASSWORD')

    # Definir depuração
    debug = event.get('DEBUG', True)

    # Função de depuração condicional
    def log_debug(message):
        if debug:
            print(message)

    # URL para iniciar a sessão
    session_url = f"{glpi_api_url}/apirest.php/initSession"
    headers = {
        "App-Token": glpi_app_token,
        "Content-Type": "application/json"
    }

    log_debug(f"Autenticando no GLPI no endpoint: {session_url}")

    # Iniciar sessão no GLPI
    session_response = requests.get(session_url, auth=HTTPBasicAuth(glpi_username, glpi_password), headers=headers)
    
    if session_response.status_code != 200:
        log_debug(f"Erro na autenticação. Código: {session_response.status_code}")
        log_debug(f"Resposta: {session_response.text}")
        return {
            'statusCode': session_response.status_code,
            'body': json.dumps(f"Falha na autenticação. Status: {session_response.status_code}")
        }

    log_debug(f"Autenticação bem-sucedida. Código de resposta: {session_response.status_code}")

    # Obter o token de sessão
    session_token = session_response.json().get('session_token')
    log_debug(f"Token de sessão obtido: {session_token}")

    # Definir o cabeçalho com o token de sessão
    headers["Session-Token"] = session_token

    # URL para a execução da tarefa 'queuednotification'
    task_url = f"{glpi_api_url}/apirest.php/crontask/queuednotification"
    log_debug(f"Executando a tarefa 'queuednotification' no endpoint: {task_url}")

    # Enviar solicitação para executar a tarefa
    data = {
        'execute': 'queuednotification'
    }
    
    params = {
        id: 22
    }
    
    task_response = requests.get(task_url, headers=headers, params=params)
    
    # Verificar se a execução foi bem-sucedida
    if task_response.status_code == 200:
        log_debug("Tarefa 'queuednotification' executada com sucesso.")
        return {
            'statusCode': 200,
            'body': json.dumps('Tarefa queuednotification executada com sucesso.')
        }
    else:
        log_debug(f"Falha ao executar a tarefa. Código: {task_response.status_code}")
        log_debug(f"Resposta: {task_response.text}")
        return {
            'statusCode': task_response.status_code,
            'body': json.dumps(f"Falha ao executar a tarefa. Status: {task_response.status_code}")
        }
