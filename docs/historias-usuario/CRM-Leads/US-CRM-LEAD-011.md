# US-CRM-LEAD-011 — Integração Google Ads (Lead Form Extensions)

## História de Usuário

**Como** gestor de marketing,  
**Quero** receber automaticamente leads do Google Ads Lead Form Extensions,  
**Para** capturar prospects das campanhas Google sem entrada manual.

## Prioridade

Importante

## Estimativa

13 SP

---

## Contexto DDD

### Bounded Context
- **Contexto**: Integrações Externas (External Integrations)
- **Módulo**: CRM-Leads

### Aggregate Root
- **Lead** (entidade principal)
- **IntegracaoGoogle** (configuração da integração)

### Domain Events
| Evento | Trigger | Assinantes |
|--------|---------|------------|
| `LeadReceivedFromGoogle` | Webhook recebido | Processador de Leads |
| `LeadCreatedFromGoogle` | Lead processado | Analytics, Notificações |
| `GoogleWebhookFailed` | Erro no webhook | Alertas, Logs |
| `GoogleIntegrationConnected` | Integração configurada | Auditoria |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Lead Form Extension** | Extensão de formulário no Google Ads |
| **Webhook** | Endpoint que recebe dados automaticamente |
| **OAuth 2.0** | Protocolo de autenticação Google |
| **Customer ID** | ID da conta Google Ads |

---

## Contexto de Negócio

O Google Ads Lead Form Extensions permite capturar leads diretamente nos resultados de busca, sem redirecionar para landing page. A integração via webhook elimina a necessidade de exportar leads manualmente do Google Ads.

### Benefícios da Integração

| Benefício | Impacto |
|-----------|---------|
| Alta intenção | Leads de busca ativa têm maior intenção |
| Tempo real | Leads entram no CRM instantaneamente |
| Automação | Elimina exportação manual |
| Rastreabilidade | Campanha e palavra-chave registradas |

---

## Fluxo de Integração

```
┌─────────────────────────────────────────────────────────────────┐
│               FLUXO GOOGLE ADS LEAD FORM                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌───────────────┐                                              │
│  │  GOOGLE ADS   │                                              │
│  │  LEAD FORM    │                                              │
│  │  (Anúncio)    │                                              │
│  └───────┬───────┘                                              │
│          │                                                      │
│          ▼ Usuário preenche formulário                          │
│                                                                 │
│  ┌───────────────┐                                              │
│  │  GOOGLE API   │                                              │
│  │  (Webhook)    │                                              │
│  └───────┬───────┘                                              │
│          │                                                      │
│          ▼ POST para endpoint TopCRM                            │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                    TOP CRM                                │  │
│  │                                                           │  │
│  │  ┌─────────────┐   ┌─────────────┐   ┌─────────────┐      │  │
│  │  │  RECEBER    │──►│  VALIDAR    │──►│   CRIAR     │      │  │
│  │  │  WEBHOOK    │   │   DADOS     │   │   LEAD      │      │  │
│  │  └─────────────┘   └─────────────┘   └─────────────┘      │  │
│  │                                                           │  │
│  └───────────────────────────────────────────────────────────┘  │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────┐                                              │
│  │  LEAD CRIADO  │                                              │
│  │  cod_origem   │ (dom_ind_origem) = 3 (ADS_GOOGLE)            │
│  │  Status: NOVO │                                              │
│  └───────────────┘                                              │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────┐                                              │
│  │  NOTIFICAÇÃO  │                                              │
│  │  p/ Consultor │                                              │
│  └───────────────┘                                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Configuração da Integração

### Pré-requisitos

| Requisito | Descrição |
|-----------|-----------|
| Conta Google Ads | Conta com permissão de Lead Form Extensions |
| Google Cloud Project | Projeto com APIs habilitadas |
| OAuth 2.0 | Credenciais de autenticação |
| HTTPS | Endpoint webhook deve ser HTTPS |

### Dados de Configuração

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| customer_id | string | Sim | ID da conta Google Ads |
| client_id | string | Sim | Client ID do OAuth |
| client_secret | string | Sim | Client Secret do OAuth |
| refresh_token | string | Sim | Token para renovação |
| form_ids | array | Não | IDs dos formulários a sincronizar |
| consultor_padrao | uuid | Não | Consultor para atribuição automática |

---

## Mapeamento de Campos

### Campos do Formulário Google → TopCRM

> **Nota DDD:** O campo `cod_origem` é gravado no campo `dom_ind_origem` da tabela `crm_negociacao`.

| Campo Google | Campo TopCRM | Transformação |
|--------------|--------------|---------------|
| user_column_data.nome | nome | Direto |
| user_column_data.whatsapp | telefone | Formatar para padrão BR |
| user_column_data.email | email | Lowercase |
| user_column_data.placa | placa | Direto |
| user_column_data.marca | marca | Direto |
| user_column_data.modelo | modelo | Direto |
| user_column_data.ano_modelo | ano_modelo | Direto |
| user_column_data.city | cidade | Direto |
| user_column_data.region | uf | Mapear para sigla |
| -- | dom_ind_origem | Fixo: 3 (ADS_GOOGLE) |
| form_id | google_form_id | Armazenar para rastreio |
| campaign_id | google_campaign_id | Armazenar para rastreio |
| ad_group_id | google_adgroup_id | Armazenar para rastreio |
| creative_id | google_creative_id | Armazenar para rastreio |
| keyword | google_keyword | Palavra-chave que gerou o lead |
| gclid | google_gclid | Click ID para atribuição |

---

## Inputs e Outputs

### Webhook Payload (Input)

```json
{
  "lead_form_submit_id": "LEAD_FORM_SUBMIT_ID",
  "campaign_id": "CAMPAIGN_ID",
  "ad_group_id": "AD_GROUP_ID",
  "creative_id": "CREATIVE_ID",
  "lead_form_id": "LEAD_FORM_ID",
  "user_column_data": [
    {
      "column_id": "NOME",
      "string_value": "João da Silva"
    },
    {
      "column_id": "WHATSAPP",
      "string_value": "+5511999998888"
    },
    {
      "column_id": "EMAIL",
      "string_value": "joao@email.com"
    }
  ],
  "custom_key_value_data": [
    {
      "key": "marca_interesse",
      "string_value": "Fiat"
    }
  ],
  "submission_date_time": "2026-01-25T10:00:00Z",
  "google_click_id": "GCLID_VALUE"
}
```

### Output (Lead Criado)

| Campo | Valor |
|-------|-------|
| status | NOVO |
| cod_origem | 3 |
| origem_detalhe | Google Ads Lead Form |
| google_form_id | ID do formulário |
| google_campaign_id | ID da campanha |
| google_adgroup_id | ID do grupo de anúncios |
| google_keyword | Palavra-chave |
| google_gclid | Click ID |

---

## Critérios de Aceitação

### Cenário 1 — Receber lead via webhook
- **Dado que** a integração está configurada e ativa
- **Quando** um usuário preenche formulário no Google Ads
- **Então** o webhook é recebido pelo TopCRM
- **E** um novo lead é criado com cod_origem(dom_ind_origem) = 3
- **E** evento `LeadCreatedFromGoogle` é disparado

### Cenário 2 — Mapeamento de campos
- **Dado que** recebo dados do Google
- **Quando** o lead é processado
- **Então** nome, telefone e e-mail são mapeados corretamente
- **E** palavra-chave e GCLID são armazenados para atribuição

### Cenário 3 — Telefone de consultor bloqueado
- **Dado que** o telefone do lead é de um consultor ativo
- **Quando** o webhook é processado
- **Então** o lead é criado com flag `bloqueado_consultor = true`
- **E** não é atribuído automaticamente

### Cenário 4 — Atribuição automática
- **Dado que** configurei consultor padrão para a integração
- **Quando** um lead é criado via webhook
- **Então** é atribuído automaticamente ao consultor configurado

### Cenário 5 — Registro de palavra-chave
- **Dado que** o lead veio de busca por "proteção veicular SP"
- **Quando** o lead é criado
- **Então** o campo google_keyword contém "proteção veicular SP"
- **E** posso filtrar leads por palavra-chave

### Cenário 6 — Erro na autenticação
- **Dado que** o refresh_token expirou
- **Quando** tento processar um webhook
- **Então** recebo erro de autenticação
- **E** alerta é enviado para renovar credenciais

### Cenário 7 — Notificação de novo lead
- **Dado que** um lead foi criado via Google
- **Quando** há consultor atribuído
- **Então** consultor recebe notificação Push(APP CRM/Consultor) e WhatsApp
- **E** mensagem: "Novo lead do Google: [nome]"

### Cenário 8 — Dashboard de integração
- **Dado que** acesso as configurações de integração
- **Quando** visualizo o painel do Google Ads
- **Então** vejo status da conexão (Ativo/Inativo)
- **E** vejo contador de leads recebidos
- **E** vejo top palavras-chave que geraram leads

### Cenário 9 — Sincronização manual
- **Dado que** quero buscar leads não recebidos via webhook
- **Quando** clico em "Sincronizar Leads"
- **Então** o sistema busca leads dos últimos 7 dias via API
- **E** cria leads que não existem no CRM

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Lead criado via Google recebe cod_origem(dom_ind_origem) = 3 |
| RN-002 | IDs de campanha/grupo/formulário são armazenados |
| RN-003 | Palavra-chave e GCLID são registrados |
| RN-004 | Telefone é formatado para padrão brasileiro |
| RN-005 | DDD é extraído automaticamente do telefone |
| RN-006 | Webhook deve responder em menos de 5 segundos |
| RN-007 | Retry automático em caso de falha (3x com backoff) |
| RN-008 | Token expirado gera alerta para admin |
| RN-009 | Logs de webhook mantidos por 30 dias |
| RN-010 | Permissão necessária: `integracoes.google` |

---

## Configuração no Google Ads

### Endpoint Webhook

```
URL: https://api.topcrm.com.br/webhooks/google/leads
Método: POST
Authentication: OAuth 2.0
```

### Permissões API Necessárias

| Scope | Descrição |
|-------|-----------|
| `https://www.googleapis.com/auth/adwords` | Acesso às campanhas |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────┐
│  ⚙️ INTEGRAÇÃO GOOGLE ADS LEAD FORM                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Status: 🟢 Conectado                                           │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  📊 MÉTRICAS                                                    │
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │   HOJE      │  │   SEMANA    │  │    MÊS      │              │
│  │     8       │  │     56      │  │    198      │              │
│  │   leads     │  │   leads     │  │   leads     │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  🔑 TOP PALAVRAS-CHAVE                                          │
│                                                                 │
│  │ Palavra-chave              │ Leads │ Conversão │             │
│  │────────────────────────────│───────│───────────│             │
│  │ proteção veicular sp       │   45  │   12.3%   │             │
│  │ seguro carro barato        │   32  │   8.5%    │             │
│  │ rastreador veicular        │   28  │   15.2%   │             │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  🔧 CONFIGURAÇÃO                                                │
│                                                                 │
│  Conta Google Ads: TopBrasil (123-456-7890)                     │
│                                                                 │
│  Consultor Padrão: [▼ Distribuição Automática  ]                │
│                                                                 │
│  Formulários Sincronizados:                                     │
│  ☑ Cotação Proteção (form_abc123)                               │
│  ☑ Solicitar Orçamento (form_def456)                            │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  [🔄 Sincronizar Leads]  [⚙️ Configurar]  [📊 Relatório]        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 25/01/2026 | 1.0 | PO | Criação inicial com DDD |
| 27/01/2026 | 1.1 | PO | Notificação consultor: push e WhatsApp |
| 27/01/2026 | 1.2 | PO | Padronização DDD: cod_origem → dom_ind_origem (crm_negociacao) |

---

**Identificador**: US-CRM-LEAD-011  
**Módulo**: CRM-Leads  
**Fase**: 3 - Gestão Avançada e Integrações Ads  
**Status**: ✅ Pronto  
**Versão**: 1.2
