# Processo de Migração com AWS DMS via Site-to-Site VPN

Aqui está o processo de migração em si, com foco nas etapas de execução usando o **AWS DMS** para migrar de um banco on-premises para um **Amazon RDS**:

### 1. **Configuração dos Endpoints no AWS DMS**
   - **Endpoint de Origem (On-premises)**: Este endpoint é configurado com as credenciais e os parâmetros de conexão do banco de dados on-premises. O AWS DMS usará esse endpoint para acessar os dados da origem.
   - **Endpoint de Destino (Amazon RDS)**: O endpoint de destino aponta para a instância do RDS que vai receber os dados migrados. As credenciais de acesso ao RDS também são configuradas neste endpoint.

### 2. **Criação da Tarefa de Replicação (Replication Task)**
   - **Cópia Completa**: A primeira etapa é copiar todos os dados da origem para o destino. Esta fase garante que o banco de dados RDS esteja sincronizado com a base de dados on-premises.
   - **Replicação Contínua (CDC - Change Data Capture)**: Após a cópia completa, a tarefa de replicação pode ser configurada para continuar capturando e replicando as alterações feitas no banco de dados on-premises para o RDS até que a migração seja finalizada.

### 3. **Início da Migração**
   - **Execução da Tarefa de Migração**: A tarefa de replicação é iniciada, e o DMS começa a migrar os dados da origem para o destino. Durante este processo, a **VPN Site-to-Site** estabelece a conexão entre a infraestrutura local e a AWS, garantindo a transferência segura dos dados.
   - **Sincronização Completa**: O DMS monitora a transferência e mantém a sincronização entre os dois bancos de dados até que a migração esteja completa.

### 4. **Monitoramento**
   - **CloudWatch Logs**: Durante a migração, o DMS pode registrar informações e métricas de progresso no CloudWatch. Aqui, é possível acompanhar o status da tarefa de migração, como tempo de execução, registros transferidos, e eventuais erros ou falhas.
   - **Painel do DMS**: O próprio painel do AWS DMS permite visualizar o progresso da migração, ver os logs e verificar possíveis problemas.

### 5. **Finalização**
   - **Replicação Contínua (opcional)**: Se a migração incluir a **replicação contínua**, o DMS continuará sincronizando os dados entre a origem e o destino até que você finalize o processo manualmente.
   - **Desativação do Banco de Origem**: Quando todos os dados estiverem completamente replicados e o RDS estiver operacional, o banco de dados on-premises pode ser desativado.
   - **Desativação do DMS**: A instância de replicação do DMS pode ser removida ou desativada após o término da migração.

Esse é o fluxo principal da migração de dados utilizando o **AWS DMS** com uma conexão VPN segura para comunicação entre o banco on-premises e o Amazon RDS.

Aqui está o contexto de cada recurso que você mencionou, considerando a hierarquia da AWS:

**AWS DMS (Database Migration Service):**

- **Contexto**: Regional.
- **Descrição**: O AWS DMS é um serviço gerenciado pela AWS que opera no contexto da região. Ele permite a migração de bases de dados de uma origem para um destino. O DMS pode se comunicar com recursos em várias VPCs e subnets, mas é um serviço regional, ou seja, está limitado à região onde foi criado.

**VPN Connection:**

- **Contexto**: VPC.
- **Descrição**: A VPN Connection cria um túnel criptografado entre uma VPC na AWS e uma rede local (on-premises). Ela está associada a uma VPC específica e usa componentes como o VPN Gateway e o Customer Gateway para estabelecer a conexão segura.

**VPN Gateway (VGW):**

- **Contexto**: VPC.
- **Descrição**: O VPN Gateway é um recurso dentro da VPC que serve como ponto de término do lado da AWS para uma conexão de VPN. Ele facilita a comunicação entre a rede on-premises e os recursos dentro da VPC.

**Customer Gateway (CGW):**

- **Contexto**: Global, mas com foco no lado on-premises.
- **Descrição**: O Customer Gateway é o ponto de término do lado da rede on-premises. Ele representa o dispositivo ou software VPN que você tem na sua rede local. O recurso AWS "Customer Gateway" é a representação desse dispositivo na AWS.

Esses recursos juntos permitem a comunicação segura entre a infraestrutura on-premises e a AWS, sendo que o DMS depende dessa conexão para realizar migrações de dados entre os ambientes.