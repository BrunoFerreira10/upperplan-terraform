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
1. No Github Code, fazer o fork desse projeto para sua conta.
2. Na console da AWS, criar usuário 'Terraform' com acesso CLI e politicas de admintração do ambiente. 
3. Na console da AWS. criar par de chaves SSH para conectar nas EC2.
4. Na console da AWS, criar HostedZone (Router 53) com o dominio que será utilizado.
5. No Github Actions, criar Gihub Actions Varibles e Secrets, conforme tabela adiante.
6. No Github Actions, executar workflow 'S2 - Sub-project: Single Run'
  - Input 1 - Resource =  '0'
  - Input 2 - Deixar vazio
  - Input 3 - 'y'
7. No Github Actions, executar workflow 'C1 - Whole project: Create'
  - Input 1 - 'y'
8. No Github Code, fazer o clone **do seu projeto** para sua máquina, agora pode fazer suas edições.

# Repositorios adicionais
Os repositorios abaixo complementam esse projeto, também faço o fork/clone deles e os configure nas 'Variables' do Github Actions.
Imagem 'Server': https://github.com/BrunoFerreira10/upperplan-container.git
Imabem 'Aplicação': https://github.com/BrunoFerreira10/upperplan-app.git

# Variavéis e Secrets configuradas no Github Actions
## Github Vars

<table>
  <tr>
    <th colspan="2">APP_REPOSITORY_URL</th>
  </tr>
  <tr>
    <td>git@github.com:BrunoFerreira10/upperplan-app.git</td>
    <td>Link ssh do repositório da aplicação</td>
  </tr>
  <tr>
    <th colspan="2">APP_REPOSITORY_URL_HTTPS</th>
  </tr>
  <tr>
    <td>https://github.com/BrunoFerreira10/upperplan-app.git</td>
    <td>Link https do repositório da aplicação</td>
  </tr>
  <tr>
    <th colspan="2">CONTAINER_REPOSITORY_URL</th>
  </tr>
  <tr>
    <td>git@github.com:BrunoFerreira10/upperplan-container.git</td>
    <td>Link ssh do repositório do container</td>
  </tr>
  <tr>
    <th colspan="2">CONTAINER_REPOSITORY_URL_HTTPS</th>
  </tr>
  <tr>
    <td>https://github.com/BrunoFerreira10/upperplan-container.git</td>
    <td>Link https do repositório do container</td>
  </tr>
  <tr>
    <th colspan="2">GENERAL_REGION</th>
  </tr>
  <tr>
    <td>us-east-1</td>
    <td>Região da implementação</td>
  </tr>
  <tr>
    <th colspan="2">GENERAL_PROJECT_BUCKET_NAME</th>
  </tr>
  <tr>
    <td>your-remote-state-bucket-name</td>
    <td>Nome do bucket para dados da infraestrutura e aplicação</td>
  </tr>
  <tr>
    <th colspan="2">GENERAL_TAG_AUTHOR</th>
  </tr>
  <tr>
    <td>Bruno Ferreira</td>
    <td>Autor das edições - Gera Tag em todos recursos</td>
  </tr>
  <tr>
    <th colspan="2">GENERAL_TAG_CUSTOMER</th>
  </tr>
  <tr>
    <td>BlogUpper</td>
    <td>Cliente do projeto - Gera Tag em todos recursos</td>
  </tr>
  <tr>
    <th colspan="2">GENERAL_TAG_PROJECT</th>
  </tr>
  <tr>
    <td>blogupper-terraform</td>
    <td>Nome do projeto - Gera Tag em todos recursos</td>
  </tr>
  <tr>
    <th colspan="2">GENERAL_TAG_SHORTNAME</th>
  </tr>
  <tr>
    <td>blogupper</td>
    <td>Nome curto para nomeação dos recursos</td>
  </tr>
  <tr>
    <th colspan="2">IAM_AWS_ACCESS_KEY_ID</th>
  </tr>
  <tr>
    <td>AKHXXDDFFDSDD76JGJJKJ</td>
    <td>AWS Access Key Id do usuário 'Terraform'</td>
  </tr>
  <tr>
    <th colspan="2">MY_GITHUB_CONNECTION_NAME</th>
  </tr>
  <tr>
    <td>github_apss_connection_name</td>
    <td>Nome da conexão com o GitHub criada na console</td>
  </tr>
  <tr>
    <th colspan="2">RDS_1_DB_NAME</th>
  </tr>
  <tr>
    <td>db_blogupper</td>
    <td>Nome do banco de dados no RDS</td>
  </tr>
  <tr>
    <th colspan="2">RDS_1_DB_USERNAME</th>
  </tr>
  <tr>
    <td>blogupper_rootuser</td>
    <td>Nome do usuário do RDS</td>
  </tr>
  <tr>
    <th colspan="2">RT53_DOMAIN</th>
  </tr>
  <tr>
    <td>brunoferreira86dev.com</td>
    <td>Domínio da aplicação</td>
  </tr>
</table>


## Github Secrets
<table>
  <tr>
    <th colspan="2">IAM_AWS_SECRET_ACCESS_KEY</th>
  </tr>
  <tr>
    <td></td>
    <td>AWS Secret access Key do usuário Terraform</td>
  </tr>
  <tr>
    <th colspan="2">RDS_1_DB_PASSWORD</th>
  </tr>
  <tr>
    <td>your-rds-password</td>
    <td>Senha do RDS</td>
  </tr>
</table>
