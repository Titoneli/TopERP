# 🗄️ Acesso DBA ao Banco de Dados - Top Brasil CRM

## 📋 Informações do Banco

**Ambiente:** Produção  
**Provedor:** Google Cloud SQL  
**Engine:** PostgreSQL 16  
**Instância:** topbrasil-sistemas-db  
**Região:** us-central1

## 🔐 Credenciais

```
Host (Público):    130.211.194.51
Host (via Proxy):  localhost
Port:              5432
Database:          topbrasil_crm
User:              topbrasil_admin
Password:          Wxin8tfc7ErTxW1iSX40wGWq2Uj3eT3WAJ/lUd76/kU=
```

**Connection String:**
```
postgresql://topbrasil_admin:Wxin8tfc7ErTxW1iSX40wGWq2Uj3eT3WAJ%2FlUd76%2FkU%3D@130.211.194.51:5432/topbrasil_crm
```

## 🚀 Opção 1: Cloud SQL Proxy (Recomendado)

### Passo 1: Instalar Cloud SQL Proxy

```bash
# macOS
brew install cloud-sql-proxy

# Linux
curl -o cloud-sql-proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.8.0/cloud-sql-proxy.linux.amd64
chmod +x cloud-sql-proxy
sudo mv cloud-sql-proxy /usr/local/bin/

# Windows
# Baixar de: https://cloud.google.com/sql/docs/postgres/sql-proxy
```

### Passo 2: Autenticar no GCP

```bash
# Instalar gcloud CLI (se não tiver)
# macOS: brew install google-cloud-sdk
# Linux: https://cloud.google.com/sdk/docs/install

# Autenticar
gcloud auth login

# Configurar projeto
gcloud config set project topbrasil-sistemas-backend
```

### Passo 3: Iniciar Cloud SQL Proxy

```bash
# Iniciar proxy em foreground
cloud-sql-proxy topbrasil-sistemas-backend:us-central1:topbrasil-sistemas-db

# OU em background
cloud-sql-proxy topbrasil-sistemas-backend:us-central1:topbrasil-sistemas-db &

# Verificar se está rodando
ps aux | grep cloud-sql-proxy
```

O proxy ficará escutando em `localhost:5432`

### Passo 4: Conectar ao Banco

#### Via psql:
```bash
psql "postgresql://topbrasil_admin:Wxin8tfc7ErTxW1iSX40wGWq2Uj3eT3WAJ/lUd76/kU=@localhost:5432/topbrasil_crm"

# OU
PGPASSWORD='Wxin8tfc7ErTxW1iSX40wGWq2Uj3eT3WAJ/lUd76/kU=' psql -h localhost -p 5432 -U topbrasil_admin -d topbrasil_crm
```

#### Via DBeaver:
```
Host:     localhost
Port:     5432
Database: topbrasil_crm
Username: topbrasil_admin
Password: Wxin8tfc7ErTxW1iSX40wGWq2Uj3eT3WAJ/lUd76/kU=
```

#### Via pgAdmin:
```
Host:          localhost
Port:          5432
Database:      topbrasil_crm
Username:      topbrasil_admin
Password:      Wxin8tfc7ErTxW1iSX40wGWq2Uj3eT3WAJ/lUd76/kU=
SSL Mode:      Prefer
```

## 🌐 Opção 2: Conexão Direta (IP Público)

### Passo 1: Liberar seu IP

Solicitar ao administrador para adicionar seu IP à whitelist:

```bash
gcloud sql instances patch topbrasil-sistemas-db \
  --authorized-networks=SEU_IP_AQUI \
  --project=topbrasil-sistemas-backend
```

### Passo 2: Conectar Diretamente

```bash
psql "postgresql://topbrasil_admin:Wxin8tfc7ErTxW1iSX40wGWq2Uj3eT3WAJ%2FlUd76%2FkU%3D@130.211.194.51:5432/topbrasil_crm"
```

**⚠️ Atenção:** Esta opção é menos segura que o Cloud SQL Proxy.

## 📊 Comandos Úteis

### Listar Tabelas
```sql
\dt
```

### Ver Schema de uma Tabela
```sql
\d+ nome_da_tabela
```

### Listar Databases
```sql
\l
```

### Executar Query
```sql
SELECT * FROM "user" LIMIT 10;
```

### Ver Conexões Ativas
```sql
SELECT pid, usename, application_name, client_addr, state 
FROM pg_stat_activity 
WHERE datname = 'topbrasil_crm';
```

### Tamanho do Banco
```sql
SELECT pg_size_pretty(pg_database_size('topbrasil_crm'));
```

### Tamanho das Tabelas
```sql
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

## 🔧 Operações Comuns de DBA

### Backup Manual

```bash
# Via Cloud SQL Proxy
pg_dump -h localhost -U topbrasil_admin -d topbrasil_crm > backup_$(date +%Y%m%d_%H%M%S).sql

# Via IP Público
pg_dump -h 130.211.194.51 -U topbrasil_admin -d topbrasil_crm > backup_$(date +%Y%m%d_%H%M%S).sql
```

### Restore de Backup

```bash
psql -h localhost -U topbrasil_admin -d topbrasil_crm < backup.sql
```

### Analisar Performance

```sql
-- Queries mais lentas
SELECT 
    query,
    calls,
    total_time,
    mean_time,
    max_time
FROM pg_stat_statements 
ORDER BY total_time DESC 
LIMIT 10;

-- Índices não utilizados
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan
FROM pg_stat_user_indexes
WHERE idx_scan = 0
ORDER BY tablename;
```

### Vacuum e Analyze

```sql
-- Analisar tabela
ANALYZE nome_da_tabela;

-- Vacuum completo
VACUUM FULL ANALYZE;
```

## 🔐 Permissões IAM Necessárias

Para usar Cloud SQL Proxy, você precisa das seguintes roles no GCP:

```bash
# Solicitar ao administrador:
gcloud projects add-iam-policy-binding topbrasil-sistemas-backend \
  --member="user:seu-email@example.com" \
  --role="roles/cloudsql.client"
```

## 🆘 Troubleshooting

### Proxy não conecta
```bash
# Verificar autenticação
gcloud auth list

# Re-autenticar
gcloud auth login
```

### Erro de senha
```bash
# Verificar se senha tem caracteres especiais
# Use aspas simples ou escape os caracteres
```

### Timeout de conexão
```bash
# Verificar se Cloud SQL Proxy está rodando
ps aux | grep cloud-sql-proxy

# Verificar logs do proxy
# Executar sem & para ver logs em tempo real
```

### IP não autorizado (conexão direta)
```bash
# Verificar seu IP
curl ifconfig.me

# Solicitar whitelist ao admin
```

## 📞 Contato

Problemas de acesso? Falar com:
- **Kelvy Muniz** - Líder Técnico
- **Email:** kelvy@topbrasil.com.br

---

**Última atualização:** 5 de novembro de 2025
