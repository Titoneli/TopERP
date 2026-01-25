# US-CRM-LEAD-010 — Integração Facebook Lead Ads

## História de Usuário

**Como** gestor de marketing,  
**Quero** receber automaticamente leads do Facebook Lead Ads,  
**Para** capturar prospects das campanhas Meta sem entrada manual.

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
- **IntegracaoMeta** (configuração da integração)

### Domain Events
| Evento | Trigger | Assinantes |
|--------|---------|------------|
| `LeadReceivedFromMeta` | Webhook recebido | Processador de Leads |
| `LeadCreatedFromMeta` | Lead processado | Analytics, Notificações |
| `MetaWebhookFailed` | Erro no webhook | Alertas, Logs |
| `MetaIntegrationConnected` | Integração configurada | Auditoria |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Lead Ads** | Formato de anúncio do Meta com formulário nativo |
| **Webhook** | Endpoint que recebe dados automaticamente |
| **Page Access Token** | Token de autenticação para a página |
| **Form ID** | Identificador do formulário no Meta |

---

## Contexto de Negócio

O Facebook Lead Ads permite capturar leads diretamente no feed do Facebook/Instagram, sem sair da plataforma. A integração webhook elimina a necessidade de exportar leads manualmente do Gerenciador de Anúncios.

### Benefícios da Integração

| Benefício | Impacto |
|-----------|---------|
| Tempo real | Leads entram no CRM instantaneamente |
| Automação | Elimina exportação manual |
| Rastreabilidade | Origem e campanha registradas |
| Velocidade | Consultor pode contatar lead em minutos |

---

## Fluxo de Integração

```
┌─────────────────────────────────────────────────────────────────┐
│               FLUXO FACEBOOK LEAD ADS                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌───────────────┐                                              │
│  │   FACEBOOK    │                                              │
│  │   LEAD ADS    │                                              │
│  │   (Anúncio)   │                                              │
│  └───────┬───────┘                                              │
│          │                                                      │
│          ▼ Usuário preenche formulário                          │
│                                                                 │
│  ┌───────────────┐                                              │
│  │   META API    │                                              │
│  │   (Webhook)   │                                              │
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
│  │  cod_origem=4 │ (ADS_META)                                   │
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
| Página Facebook | Página do negócio com permissão de anúncios |
| App Meta Business | Aplicativo registrado no Meta Developers |
| Permissões | `pages_manage_ads`, `leads_retrieval` |
| HTTPS | Endpoint webhook deve ser HTTPS |

### Dados de Configuração

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| page_id | string | Sim | ID da página Facebook |
| page_access_token | string | Sim | Token de acesso à página |
| form_ids | array | Não | IDs dos formulários a sincronizar |
| webhook_verify_token | string | Sim | Token para verificação do webhook |
| consultor_padrao | uuid | Não | Consultor para atribuição automática |

---

## Mapeamento de Campos

### Campos do Formulário Meta → TopCRM

| Campo Meta | Campo TopCRM | Transformação |
|------------|--------------|---------------|
| full_name | nome | Direto |
| phone_number | telefone | Formatar para padrão BR |
| email | email | Lowercase |
| city | cidade | Direto |
| state | uf | Mapear para sigla |
| -- | cod_origem | Fixo: 4 (ADS_META) |
| form_id | meta_form_id | Armazenar para rastreio |
| ad_id | meta_ad_id | Armazenar para rastreio |
| campaign_id | meta_campaign_id | Armazenar para rastreio |

### Campos Customizados

| Campo Meta | Campo TopCRM | Descrição |
|------------|--------------|-----------|
| marca_interesse | marca | Campo custom do formulário |
| modelo_interesse | modelo | Campo custom do formulário |

---

## Inputs e Outputs

### Webhook Payload (Input)

```json
{
  "object": "page",
  "entry": [{
    "id": "PAGE_ID",
    "time": 1704067200,
    "changes": [{
      "field": "leadgen",
      "value": {
        "form_id": "FORM_ID",
        "leadgen_id": "LEAD_ID",
        "created_time": 1704067200,
        "page_id": "PAGE_ID",
        "ad_id": "AD_ID",
        "campaign_id": "CAMPAIGN_ID"
      }
    }]
  }]
}
```

### Lead Data (Fetch API)

```json
{
  "id": "LEAD_ID",
  "field_data": [
    { "name": "full_name", "values": ["João da Silva"] },
    { "name": "phone_number", "values": ["+5511999998888"] },
    { "name": "email", "values": ["joao@email.com"] }
  ],
  "created_time": "2026-01-25T10:00:00+0000"
}
```

### Output (Lead Criado)

| Campo | Valor |
|-------|-------|
| status | NOVO |
| cod_origem | 4 |
| origem_detalhe | Facebook Lead Ads |
| meta_form_id | ID do formulário |
| meta_ad_id | ID do anúncio |
| meta_campaign_id | ID da campanha |

---

## Critérios de Aceitação

### Cenário 1 — Receber lead via webhook
- **Dado que** a integração está configurada e ativa
- **Quando** um usuário preenche formulário no Facebook Lead Ads
- **Então** o webhook é recebido pelo TopCRM
- **E** os dados do lead são buscados via Graph API
- **E** um novo lead é criado com cod_origem = 4

### Cenário 2 — Mapeamento de campos
- **Dado que** recebo dados do Meta
- **Quando** o lead é processado
- **Então** nome, telefone e e-mail são mapeados corretamente
- **E** cidade e UF são preenchidos se disponíveis
- **E** IDs de campanha/anúncio são armazenados

### Cenário 3 — Telefone de consultor bloqueado
- **Dado que** o telefone do lead é de um consultor ativo
- **Quando** o webhook é processado
- **Então** o lead é criado com flag `bloqueado_consultor = true`
- **E** não é atribuído automaticamente

### Cenário 4 — Atribuição automática
- **Dado que** configurei consultor padrão para a integração
- **Quando** um lead é criado via webhook
- **Então** é atribuído automaticamente ao consultor configurado

### Cenário 5 — Webhook verification
- **Dado que** o Meta envia GET para verificação do webhook
- **Quando** o verify_token corresponde ao configurado
- **Então** respondo com hub.challenge
- **E** a verificação é bem-sucedida

### Cenário 6 — Erro na API Meta
- **Dado que** o webhook foi recebido
- **Quando** ocorre erro ao buscar dados do lead na Graph API
- **Então** o evento é registrado para retry
- **E** alerta é enviado para administrador

### Cenário 7 — Notificação de novo lead
- **Dado que** um lead foi criado via Meta
- **Quando** há consultor atribuído
- **Então** consultor recebe notificação push
- **E** mensagem: "Novo lead do Facebook: [nome]"

### Cenário 8 — Dashboard de integração
- **Dado que** acesso as configurações de integração
- **Quando** visualizo o painel do Facebook Lead Ads
- **Então** vejo status da conexão (Ativo/Inativo)
- **E** vejo contador de leads recebidos hoje/semana/mês
- **E** vejo últimos leads processados

### Cenário 9 — Reconexão após expiração de token
- **Dado que** o page_access_token expirou
- **Quando** tento processar um webhook
- **Então** recebo erro de autenticação
- **E** alerta é enviado para renovar o token

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Lead criado via Meta recebe cod_origem = 4 |
| RN-002 | IDs de campanha/anúncio/formulário são armazenados |
| RN-003 | Telefone é formatado para padrão brasileiro |
| RN-004 | DDD é extraído automaticamente do telefone |
| RN-005 | Leads duplicados não são bloqueados (criam novo registro) |
| RN-006 | Webhook deve responder em menos de 5 segundos |
| RN-007 | Retry automático em caso de falha (3x com backoff) |
| RN-008 | Token expirado gera alerta para admin |
| RN-009 | Logs de webhook mantidos por 30 dias |
| RN-010 | Permissão necessária para configurar: `integracoes.meta` |

---

## Configuração no Meta

### Endpoint Webhook

```
URL: https://api.topcrm.com.br/webhooks/meta/leads
Método: POST
Verify Token: [token_configurado]
```

### Campos do Webhook

| Campo | Valor |
|-------|-------|
| Object | Page |
| Callback URL | https://api.topcrm.com.br/webhooks/meta/leads |
| Fields | leadgen |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────┐
│  ⚙️ INTEGRAÇÃO FACEBOOK LEAD ADS                                │
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
│  │     12      │  │     87      │  │    342      │              │
│  │   leads     │  │   leads     │  │   leads     │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  🔧 CONFIGURAÇÃO                                                │
│                                                                 │
│  Página Facebook: TopBrasil Proteção Veicular                   │
│  Page ID: 123456789012345                                       │
│                                                                 │
│  Consultor Padrão: [▼ Distribuição Automática  ]                │
│                                                                 │
│  Formulários Sincronizados:                                     │
│  ☑ Cotação Rápida (form_123)                                    │
│  ☑ Proteção Veicular 2026 (form_456)                            │
│  ☐ Teste Campanha (form_789)                                    │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  📋 ÚLTIMOS LEADS                                               │
│                                                                 │
│  │ Nome           │ Telefone      │ Campanha      │ Data       │
│  │────────────────│───────────────│───────────────│────────────│
│  │ João Silva     │ (11) 99999... │ Black Friday  │ 25/01 10:30│
│  │ Maria Santos   │ (21) 98888... │ Verão 2026    │ 25/01 10:15│
│  │ Pedro Oliveira │ (31) 97777... │ Black Friday  │ 25/01 09:45│
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  [🔄 Reconectar]  [⚙️ Configurar Campos]  [📊 Ver Relatório]    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 25/01/2026 | 1.0 | PO | Criação inicial com DDD |

---

**Identificador**: US-CRM-LEAD-010  
**Módulo**: CRM-Leads  
**Fase**: 3 - Gestão Avançada e Integrações Ads  
**Status**: ✅ Pronto  
**Versão**: 1.0
