# CRM-Leads — Módulo de Captação e Gestão de Leads

## Bounded Context (DDD)

O módulo **CRM-Leads** representa o contexto de **Captação e Qualificação de Prospects**, sendo a porta de entrada do funil comercial. Este contexto é responsável por gerenciar todo o ciclo de vida do lead desde a captura inicial até sua qualificação para negociação.

### Agregados
- **Lead** (Aggregate Root)
- **Veículo de Interesse**
- **Histórico de Interações**

### Entidades
- Lead
- Contato
- Origem

### Value Objects
- Telefone
- Email
- Localização (UF/Cidade)
- UTM Parameters
- **DDD** (extraído do telefone para analytics)
- **Código de Origem** (`cod_origem`)
- **Código de Colaborador** (`cod_colaborador`)

---

## Visão Geral

O módulo gerencia a captação, armazenamento e qualificação de leads (potenciais clientes) interessados em proteção veicular, garantindo rastreabilidade completa desde a origem até a conversão.

---

## Histórias de Usuário

### Essencial — Fluxo de Captação e Comparativo
- [US-CRM-LED-001](US-CRM-LED-001.md) - Captação de Lead via Landing Page (Multi-Step Form com rastreio de origem e DDD)
- [US-CRM-LED-002](US-CRM-LED-002.md) - Comparativo de Planos de Proteção Veicular (Após Etapa 3 de LED-001)
- [US-CRM-LED-003](US-CRM-LED-003.md) - Dashboard de Leads e Analytics (Etapa 3)

### Essencial — Gestão de Leads
- US-CRM-LED-004 - Cadastrar Lead Manualmente
- US-CRM-LED-005 - Visualizar Lista de Leads
- US-CRM-LED-006 - Buscar e Filtrar Leads
- US-CRM-LED-007 - Atribuir Lead a Consultor
- US-CRM-LED-008 - Editar Dados do Lead
- US-CRM-LED-009 - Visualizar Detalhes do Lead

### Importante
- US-CRM-LED-010 - Importar Leads em Massa (CSV/Excel)
- US-CRM-LED-011 - Captura via Formulário Embarcado
- US-CRM-LED-012 - Captura via WhatsApp Business
- US-CRM-LED-013 - Qualificar Lead (BANT)
- US-CRM-LED-014 - Marcar Lead como Inativo
- US-CRM-LED-015 - Exportar Leads

### Desejável
- US-CRM-LED-016 - Integração com Facebook Lead Ads
- US-CRM-LED-017 - Integração com Google Ads
- US-CRM-LED-018 - Score Automático de Lead
- US-CRM-LED-019 - Enriquecimento de Dados (APIs externas)

---

## Fontes de Captação

| Fonte | Identificador | `cod_origem` | Prioridade |
|-------|---------------|--------------|------------|
| Link Direto | `LINK_DIRETO` | 1 | Essencial |
| Influencer Instagram | `INFLUENCER_INSTAGRAM` | 2 | Importante |
| Google Ads | `ADS_GOOGLE` | 3 | Importante |
| Meta Ads (FB/IG) | `ADS_META` | 4 | Importante |
| WhatsApp | `WHATSAPP` | 5 | Importante |
| Indicação | `INDICACAO` | 6 | Essencial |
| Consultor Próprio | `CONSULTOR_PROPRIO` | 7 | Essencial |
| Outros | `OUTROS` | 99 | - |

---

## Ciclo de Vida do Lead

```
                    CAPTAÇÃO (Landing Page)
                           │
┌──────────────────────────┼───────────────────────────┐
│                          ▼                           │
│  ┌─────────────┐   ┌─────────────┐   ┌───────────┐   │
│  │FORM_PROSPECT│──▶│FORM_VEICULO │──▶│FORM_LOCAL │   │
│  │  (Etapa 1)  │   │  (Etapa 2)  │   │ (Etapa 3) │   │
│  └─────────────┘   └─────────────┘   └───────────┘   │
│         │                                    │       │
│         ▼                                    ▼       │
│    [Abandono]                          [Qualificado] │
└──────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  NOVO   │───▶│ QUALIFICADO │───▶│ NEGOCIAÇÃO  │───▶│ CONVERTIDO  │
└─────────┘    └─────────────┘    └─────────────┘    └─────────────┘
     │               │                   │                   
     ▼               ▼                   ▼                   
┌─────────┐    ┌─────────────┐    ┌─────────────┐    
│ INATIVO │◀───│ ARQUIVADO   │◀───│   PERDIDO   │    
└─────────┘    └─────────────┘    └─────────────┘    
```

---

## Integrações

| Sistema | Tipo | Propósito |
|---------|------|-----------|
| API FIPE | REST | Dados de veículos |
| IBGE | REST | Lista de UFs e cidades |
| WhatsApp Business | Webhook | Captura de mensagens |
| Meta Lead Ads | Webhook | Leads do Facebook/Instagram |
| Google Analytics | SDK | Rastreamento de conversão |

---

## Métricas do Módulo

| KPI | Descrição | Meta |
|-----|-----------|------|
| Volume de Leads/Dia | Leads captados por dia | Monitorar |
| Taxa de Qualificação | % leads qualificados | > 30% |
| Tempo até 1º Contato | Tempo entre captura e contato | < 5 min |
| Taxa de Conversão | % leads que viram clientes | > 15% |
| **Leads por DDD** | Distribuição regional por DDD | Monitorar |
| **Leads por Origem** | Distribuição por `cod_origem` | Monitorar |
| **Taxa de Bloqueio** | % telefones de consultores bloqueados | < 1% |

---

**Versão**: 1.2  
**Atualizado em**: 21/01/2026

**Histórico:**
| Versão | Data | Alteração |
|--------|------|----------|
| 1.2 | 21/01/2026 | Renumeração: LED-003 (Dashboard) e sequências Essencial/Importante/Desejável |
| 1.1 | 21/01/2026 | Atualizado com `cod_origem`, `cod_colaborador`, métricas por DDD e etapas do formulário |
| 1.0 | 21/01/2026 | Versão inicial |
