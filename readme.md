## Sobre o projeto
### Descrição
Implementação de sistema GLPI na AWS usando IaC Terraform e repositório no 
Github.<br>
Execução dos scripts Terraform através do Github Actions.

### Estrutura
O projeto conta com vários **'sub-projetos'** Terraform, os quais se comunicam 
usando um **'remote state'** alocado em um S3.<br>
Com isso é possível criar e destruir os recursos de forma individual.

## Passo a passo para reproduzir o projeto
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

## Repositorios adicionais
Os repositorios abaixo complementam esse projeto, também faço o fork/clone deles e os configure nas 'Variables' do Github Actions.<br>
Imagem 'Server': https://github.com/BrunoFerreira10/upperplan-container.git<br>
Imabem 'Aplicação': https://github.com/BrunoFerreira10/upperplan-app.git<br>

## Variavéis e Secrets configuradas no Github Actions
### Github Vars

<table>
  <tr>
    <td colspan="2" style="text-align: right;">APP_REPOSITORY_URL</td>
  </tr>
  <tr>
    <td style="text-align: right;">git@github.com:BrunoFerreira10/upperplan-app.git</td>
    <td style="text-align: right;">Link ssh do repositório da aplicação</td>
  </tr>
  <tr>
    <td colspan="2" style="text-align: right;">APP_REPOSITORY_URL_HTTPS</td>
  </tr>
  <tr>
    <td style="text-align: right;">https://github.com/BrunoFerreira10/upperplan-app.git</td>
    <td style="text-align: right;">Link https do repositório da aplicação</td>
  </tr>
  <tr>
    <td colspan="2" style="text-align: right;">CONTAINER_REPOSITORY_URL</td>
  </tr>
  <tr>
    <td style="text-align: right;">git@github.com:BrunoFerreira10/upperplan-container.git</td>
    <td style="text-align: right;">Link ssh do repositório do container</td>
  </tr>
  <tr>
    <td colspan="2" style="text-align: right;">CONTAINER_REPOSITORY_URL_HTTPS</td>
  </tr>
  <tr>
    <td style="text-align: right;">https://github.com/BrunoFerreira10/upperplan-container.git</td>
    <td style="text-align: right;">Link https do repositório do container</td>
  </tr>
  <tr>
    <td colspan="2" style="text-align: right;">GENERAL_REGION</td>
  </tr>
  <tr>
    <td style="text-align: right;">us-east-1</td>
    <td style="text-align: right;">Região da implementação</td>
  </tr>
  <tr>
    <td colspan="2" style="text-align: right;">GENERAL_PROJECT_BUCKET_NAME</td>
  </tr>
  <tr>
    <td style="text-align: right;">your-remote-state-bucket-name</td>
    <td style="text-align: right;">Nome do bucket para dados da infraestrutura e aplicação</td>
  </tr>
  <tr>
    <td colspan="2" style="text-align: right;">GENERAL_TAG_AUTHOR</td>
  </tr>
  <tr>
    <td style="text-align: right;">Bruno Ferreira</td>
    <td style="text-align: right;">Autor das edições - Gera Tag em todos recursos</td>
  </tr>
  <tr>
    <td colspan="2" style="text-align: right;">GENERAL_TAG_CUSTOMER</td>
  </tr>
  <tr>
    <td style="text-align: right;">BlogUpper</td>
    <td style="text-align: right;">Cliente do projeto - Gera Tag em todos recursos</td>
  </tr>
  <tr>
    <td colspan="2" style="text-align: right;">GENERAL_TAG_PROJECT</td>
  </tr>
  <tr>
    <td style="text-align: right;">blogupper-terraform</td>
    <td style="text-align: right;">Nome do projeto - Gera Tag em todos recursos</td>
  </tr>
  <tr>
    <td colspan="2" style="text-align: right;">GENERAL_TAG_SHORTNAME</td>
  </tr>
  <tr>
    <td style="text-align: right;">blogupper</td>
    <td style="text-align: right;">Nome curto para nomeação dos recursos</td>
  </tr>
  <tr>
    <td colspan="2" style="text-align: right;">IAM_AWS_ACCESS_KEY_ID</td>
  </tr>
  <tr>
    <td style="text-align: right;">AKHXXDDFFDSDD76JGJJKJ</td>
    <td style="text-align: right;">AWS Access Key Id do usuário 'Terraform'</td>
  </tr>
  <tr>
    <td colspan="2" style="text-align: right;">MY_GITHUB_CONNECTION_NAME</td>
  </tr>
  <tr>
    <td style="text-align: right;">github_apss_connection_name</td>
    <td style="text-align: right;">Nome da conexão com o GitHub criada na console</td>
  </tr>
  <tr>
    <td colspan="2" style="text-align: right;">RDS_1_DB_NAME</td>
  </tr>
  <tr>
    <td style="text-align: right;">db_blogupper</td>
    <td style="text-align: right;">Nome do banco de dados no RDS</td>
  </tr>
  <tr>
    <td colspan="2" style="text-align: right;">RDS_1_DB_USERNAME</td>
  </tr>
  <tr>
    <td style="text-align: right;">blogupper_rootuser</td>
    <td style="text-align: right;">Nome do usuário do RDS</td>
  </tr>
  <tr>
    <td colspan="2" style="text-align: right;">RT53_DOMAIN</td>
  </tr>
  <tr>
    <td style="text-align: right;">brunoferreira86dev.com</td>
    <td style="text-align: right;">Domínio da aplicação</td>
  </tr>
</table>



### Github Secrets
<table>
  <tr>
    <td colspan="2" style="text-align: right;">IAM_AWS_SECRET_ACCESS_KEY</td>
  </tr>
  <tr>
    <td style="text-align: right;"></td>
    <td style="text-align: right;">AWS Secret access Key do usuário Terraform</td>
  </tr>
  <tr>
    <td colspan="2" style="text-align: right;">RDS_1_DB_PASSWORD</td>
  </tr>
  <tr>
    <td style="text-align: right;">your-rds-password</td>
    <td style="text-align: right;">Senha do RDS</td>
  </tr>
</table>
