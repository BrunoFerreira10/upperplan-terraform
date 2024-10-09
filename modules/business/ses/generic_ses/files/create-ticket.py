import json
import requests
import os
import time
import boto3
from requests.auth import HTTPBasicAuth
from email import policy
from email.parser import BytesParser

# Inicializar o cliente S3
s3 = boto3.client('s3')

def get_email_from_s3(bucket_name, object_key, max_retries=5, wait_time=5):
    for attempt in range(max_retries):
        try:
            response = s3.get_object(Bucket=bucket_name, Key=object_key)
            return response['Body'].read()
        except s3.exceptions.NoSuchKey:
            print(f"Tentativa {attempt + 1}: Arquivo ainda não disponível no S3, aguardando...")
            time.sleep(wait_time)
    raise Exception("O arquivo não foi encontrado no S3 após várias tentativas")

def extract_message_content(email_content):
    try:
        print("Iniciando o processamento do conteúdo do e-mail...")

        # Utilizar o BytesParser para processar o conteúdo MIME
        msg = BytesParser(policy=policy.default).parsebytes(email_content)
        print("Parser MIME concluído com sucesso.")

        # Verificar se o e-mail é multipart (contém várias partes, como plain text e HTML)
        if msg.is_multipart():
            print("O e-mail é multipart. Iterando pelas partes do e-mail...")

            for part in msg.iter_parts():
                content_type = part.get_content_type()
                print(f"Encontrada parte com tipo de conteúdo: {content_type}")

                # Verificar se a parte é de texto simples
                if content_type == 'text/plain':
                    print("Parte de texto simples encontrada. Extraindo conteúdo...")
                    return part.get_payload(decode=True).decode('utf-8')
                # Opcional: usar o HTML como fallback, se necessário
                elif content_type == 'text/html':
                    print("Parte HTML encontrada. Extraindo conteúdo...")
                    return part.get_payload(decode=True).decode('utf-8')
        else:
            print("O e-mail não é multipart. Extraindo conteúdo diretamente...")
            # Se não for multipart, processar diretamente o payload do e-mail
            return msg.get_payload(decode=True).decode('utf-8')

    except Exception as e:
        # Captura qualquer erro que ocorra durante o processamento do conteúdo do e-mail
        print(f"Erro ao processar o conteúdo do e-mail: {str(e)}")
        return f"Erro ao processar o conteúdo do e-mail: {str(e)}"

    print("Nenhum corpo de mensagem válido encontrado.")
    return "Corpo da mensagem não encontrado."


# Versão 4 com integração S3
def lambda_handler(event, context):

    time.sleep(3)  # Aguardar 3 segundos para garantir que o e-mail foi gravado no S3

    print("Iniciando a execução da função Lambda")

    print(f"Evento recebido\n {event}")
    print(f"Contexto recebido\n {context}")

    # Extrair informações do e-mail recebido pelo SES
    ses_message = event['Records'][0]['ses']
    
    sender = ses_message['mail']['source']
    subject = ses_message['mail']['commonHeaders']['subject']
    message_id = ses_message['mail']['messageId']

    print(f"Remetente: {sender}")
    print(f"Assunto: {subject}")
    print(f"Message ID: {message_id}")

    # Definir o bucket e o objeto no S3 com base no messageId
    bucket_name = os.getenv('S3_BUCKET_NAME')  # Defina o nome do bucket nas variáveis de ambiente
    object_key = f"emails/inbox-suporte/{message_id}"

    try:
        # Baixar o e-mail completo do S3        
        raw_email_content = get_email_from_s3(bucket_name, object_key)
        email_content = extract_message_content(raw_email_content)
        print(f"Conteúdo do e-mail:\n{email_content}")
    except Exception as e:
        print(f"Erro ao recuperar o e-mail do S3: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps(f"Erro ao buscar e-mail no S3: {str(e)}")
        }

    # Informações de autenticação e URL da API do GLPI
    glpi_api_url = os.getenv('GLPI_API_URL')
    glpi_username = os.getenv('GLPI_USERNAME')
    glpi_password = os.getenv('GLPI_PASSWORD')
    glpi_app_token = os.getenv('GLPI_APP_TOKEN')

    print(f"Conectando ao GLPI em: {glpi_api_url}")

    # Iniciar sessão no GLPI para obter o Session-Token
    session_url = f"{glpi_api_url}/initSession"
    headers = {
        "App-Token": glpi_app_token,
        "Content-Type": "application/json"
    }

    session_response = requests.get(session_url, auth=HTTPBasicAuth(glpi_username, glpi_password), headers=headers)
    
    if session_response.status_code != 200:
        print(f"Erro ao iniciar sessão: {session_response.text}")
        return {
            'statusCode': session_response.status_code,
            'body': json.dumps(f"Erro ao iniciar sessão: {session_response.text}")
        }

    print(f"Sessão iniciada com sucesso. Código de resposta: {session_response.status_code}")

    # Obter o session token
    session_token = session_response.json().get('session_token')
    print(f"Session token obtido: {session_token}")

    # Construir o payload para a criação de um chamado no GLPI
    create_ticket_url = f"{glpi_api_url}/Ticket"
    headers["Session-Token"] = session_token

    ticket_content = f"""
    Message ID: {message_id}
    
    Chamado criado a partir via email.
    Email: {sender}. 

    Descrição:
    {email_content}
    """

    payload = {
        "input": {
            "name": subject,
            "content": ticket_content,
            "requesttypes_id": 1,  # Tipo de solicitação
            "type": 1  # Tipo de chamado
        }
    }

    print(f"Enviando requisição para criar o chamado no GLPI")

    # Enviar a requisição POST para criar o ticket no GLPI
    ticket_response = requests.post(create_ticket_url, headers=headers, json=payload)
    
    if ticket_response.status_code == 201:
        print("Chamado criado com sucesso no GLPI")
        return {
            'statusCode': 201,
            'body': json.dumps('Chamado criado com sucesso no GLPI!')
        }
    else:
        print(f"Erro ao criar chamado: {ticket_response.text}")
        return {
            'statusCode': ticket_response.status_code,
            'body': json.dumps(f"Erro ao criar chamado: {ticket_response.text}")
        }
