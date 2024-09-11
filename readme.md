# Sobre o projeto
## Descrição
Implementação de sistema Wordpress na AWS usando IaC Terraform e repositório no 
Github.<br>
Execução dos scripts Terraform através do Github Actions.

## Estrutura
O projeto conta com vários **'sub-projetos'** Terraform, os quais se comunicam 
usando um **'remote state'** alocado em um S3.<br>
Com isso é possível criar e destruir os recursos de forma individual.

# Requisitos

## Requisitos da AWS
  - Usuário 'Terraform' com acesso CLI e politicas de admintração do ambiente. 
  - Chave ssh criada para acesso via ssh.
  - Dominio e HostedZone (Router 53) previamente criados.

## Variavéis e Secrets configuradas no Github Actions
### Github Vars
| Variável                        | Exemplo                                               | Detalhes |
| :---                            | :---                                                  | :---     |
| APP_REPOSITORY_URL              | git@github.com:BrunoFerreira10/blogupper-app.git      | Link ssh do repositório da aplicação
| APP_REPOSITORY_URL              | https://github.com/BrunoFerreira10/blogupper-app.git  | Link https do repositório da aplicação
| EC2_SSH_KEYPAIR_NAME            | your-key-pair-name                                    | Nome do par de chaves usado para acesso aos Bastion Host
| GENERAL_REGION                  | us-east-1                                             | Região da implementação
| GENERAL_PROJECT_BUCKET_NAME     | your-remote-state-bucket-name                         | Nome do bucket para dados da infraestrutura e aplicação
| GENERAL_TAG_AUTHOR              | Bruno Ferreira                                        | Autor das edições - Gera Tag em todos recursos
| GENERAL_TAG_CUSTOMER            | BlogUpper                                             | Ciente do projeto - Gera Tag em todos recursos
| GENERAL_TAG_PROJECT             | blogupper-terraform                                   | Nome do projeto - Gera Tag em todos recursos
| GENERAL_TAG_SHORTNAME           | blogupper                                             | Nome curto para nomeação dos recursos
| IAM_AWS_ACCESS_KEY_ID           | AKHXXDDFFDSDD76JGJJKJ                                 | AWS Access Key Id do usuário 'Terraform'
| IMAGE_BUILDER_PARENT_IMAGE      | ami-04b70fa74e45c3917                                 | Imagem base para geração da AMI
| MY_GITHUB_CONNECTION_NAME       | github_apss_connection_name                           | Nome da conexão com o GitHub criada na console
| RDS_1_DB_NAME                   | db_blogupper                                          | Nome do banco de dados no RDS
| RDS_1_DB_USERNAME               | blogupper_rootuser                                    | Nome do usuário do RDS
| RT53_DOMAIN                     | brunoferreira86dev.com                                | Dominio da aplicação


### Github Secrets
| Variável                                | Exemplo                   | Detalhes |
| :---                                    | :---------------          | :---     |
| EC2_SSH_PRIVATE_KEY                     |                           | Sua chave SSH para acesso ao Bastion host
| GENERAL_MY_IP                           | 199.99.99.999             | Ip para acesso aos Bastion hosts
| IAM_AWS_SECRET_ACCESS_KEY               |                           | AWS Secret access Key do usuário Terraform
| RDS_1_DB_PASSWORD                       | your-rds-password         | Senha do RDS.