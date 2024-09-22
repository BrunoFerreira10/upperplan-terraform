import json
import requests
import os

def lambda_handler(event, context):
    # Obtenção de variáveis de ambiente
    glpi_api_url = os.getenv('GLPI_API_URL').rstrip('/')
    glpi_app_token = os.getenv('GLPI_APP_TOKEN')
    glpi_username = os.getenv('GLPI_USERNAME')
    glpi_password = os.getenv('GLPI_PASSWORD')

    # Verificar se o DEBUG foi definido no event
    debug = event.get('DEBUG', True)  # Forçando o debug a ser True para testar

    # Função de depuração condicional
    def log_debug(message):
        if debug:
            print(message)

    # Log de informações de entrada
    log_debug(f"GLPI_API_URL: {glpi_api_url}")
    log_debug(f"GLPI_APP_TOKEN: {glpi_app_token}")
    log_debug(f"GLPI_USERNAME: {glpi_username}")
    log_debug(f"Event: {json.dumps(event)}")
    log_debug(f"Context: {context}")

    # Corrigir duplicidade no endpoint de autenticação
    session_url = f"{glpi_api_url}//initSession"  # Geração correta da URL

    # Definir os cabeçalhos para a autenticação
    headers = {
        "App-Token": glpi_app_token,
        "Content-Type": "application/json"
    }

    # Realizar a autenticação via initSession para obter o session_token
    log_debug(f"Autenticando no endpoint: {session_url}")
    session_response = requests.get(session_url, auth=(glpi_username, glpi_password), headers=headers)

    # Verificar se a autenticação foi bem-sucedida
    if session_response.status_code != 200:
        log_debug(f"Resposta da autenticação: {session_response.status_code}")
        log_debug(f"Conteúdo da resposta: {session_response.text}")
        return {
            'statusCode': session_response.status_code,
            'body': json.dumps(f'Falha na autenticação. Status: {session_response.status_code}')
        }

    # Obter o session_token da resposta
    session_token = session_response.json().get('session_token')
    if not session_token:
        log_debug(f"Erro: o token de sessão não foi obtido. Verifique o conteúdo da resposta.")
        return {
            'statusCode': 500,
            'body': json.dumps('Erro: o token de sessão não foi obtido. Verifique as credenciais e o endpoint.')
        }

    log_debug(f"Session token obtido: {session_token}")

    # Definir o cabeçalho com o session token
    headers["Session-Token"] = session_token

    # Construir o URL para executar a tarefa 'queuednotification' no GLPI
    cron_task_url = f"{glpi_api_url}/crontask/queuednotification"
    

    # Executar a tarefa 'queuednotification'
    try:
        log_debug(f"Executando a tarefa no endpoint: {cron_task_url}")
        response = requests.get(cron_task_url, headers=headers)

        # Verificar se a execução foi bem-sucedida
        if response.status_code == 200 or response.status_code == 206:
            return {
                'statusCode': 200,
                'body': json.dumps('Tarefa queuednotification executada com sucesso.')
            }
        else:
            log_debug(f"Falha ao executar a tarefa. Status: {response.status_code}")
            log_debug(f"Conteúdo da resposta: {response.text}")
            return {
                'statusCode': response.status_code,
                'body': json.dumps(f'Falha ao executar a tarefa. Status: {response.status_code}')
            }
    except Exception as e:
        log_debug(f"Erro ao executar a tarefa: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps(f"Erro ao executar a tarefa: {str(e)}")
        }
