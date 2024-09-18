# Sobre o projeto
## Descrição
Implementação de sistema GLPI na AWS usando IaC Terraform e repositório no 
Github.<br>
Execução dos scripts Terraform através do Github Actions.

## Estrutura
O projeto conta com vários **'sub-projetos'** Terraform, os quais se comunicam 
usando um **'remote state'** alocado em um S3.<br>
Com isso é possível criar e destruir os recursos de forma individual.

# Passo a passo para reproduzir o projeto
  - 1. No Github Code, fazer o fork desse projeto para sua conta.
  - 2. Na console da AWS, criar usuário 'Terraform' com acesso CLI e politicas de admintração do ambiente. 
  - 3. Na console da AWS. criar par de chaves SSH para conectar nas EC2.
  - 4. Na console da AWS, criar HostedZone (Router 53) com o dominio que será utilizado.
  - 5. No Github Actions, criar Gihub Actions Varibles e Secrets, conforme tabela adiante.
  - 6. No Github Actions, executar workflow 'S2 - Sub-project: Single Run'
    - Input 1 - Resource =  '0'
    - Input 2 - Deixar vazio
    - Input 3 - 'y'
  - 7. No Github Actions, executar workflow 'C1 - Whole project: Create'
    - Input 1 - 'y'
  - 8. No Github Code, fazer o clone **do seu projeto** para sua máquina, agora pode fazer suas edições.

# Variavéis e Secrets configuradas no Github Actions
## Github Vars
| Variável                        | Exemplo                                               | Detalhes |
| :---                            | :---                                                  | :---     |
| APP_REPOSITORY_URL              | git@github.com:BrunoFerreira10/upperplan-app.git            | Link ssh do repositório da aplicação
| APP_REPOSITORY_URL_HTTPS        | https://github.com/BrunoFerreira10/upperplan-app.git        | Link https do repositório da aplicação
| CONTAINER_REPOSITORY_URL        | git@github.com:BrunoFerreira10/upperplan-container.git      | Link ssh do repositório da aplicação
| CONTAINER_REPOSITORY_URL_HTTPS  | https://github.com/BrunoFerreira10/upperplan-container.git  | Link https do repositório da aplicação
| GENERAL_REGION                  | us-east-1                                             | Região da implementação
| GENERAL_PROJECT_BUCKET_NAME     | your-remote-state-bucket-name                         | Nome do bucket para dados da infraestrutura e aplicação
| GENERAL_TAG_AUTHOR              | Bruno Ferreira                                        | Autor das edições - Gera Tag em todos recursos
| GENERAL_TAG_CUSTOMER            | BlogUpper                                             | Ciente do projeto - Gera Tag em todos recursos
| GENERAL_TAG_PROJECT             | blogupper-terraform                                   | Nome do projeto - Gera Tag em todos recursos
| GENERAL_TAG_SHORTNAME           | blogupper                                             | Nome curto para nomeação dos recursos
| IAM_AWS_ACCESS_KEY_ID           | AKHXXDDFFDSDD76JGJJKJ                                 | AWS Access Key Id do usuário 'Terraform'
| MY_GITHUB_CONNECTION_NAME       | github_apss_connection_name                           | Nome da conexão com o GitHub criada na console
| RDS_1_DB_NAME                   | db_blogupper                                          | Nome do banco de dados no RDS
| RDS_1_DB_USERNAME               | blogupper_rootuser                                    | Nome do usuário do RDS
| RT53_DOMAIN                     | brunoferreira86dev.com                                | Dominio da aplicação

## Github Secrets
| Variável                                | Exemplo                   | Detalhes |
| :---                                    | :---------------          | :---     |
| IAM_AWS_SECRET_ACCESS_KEY               |                           | AWS Secret access Key do usuário Terraform
| RDS_1_DB_PASSWORD                       | your-rds-password         | Senha do RDS.