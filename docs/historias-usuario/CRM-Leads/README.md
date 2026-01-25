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

### Fase 1: CAPTAÇÃO E COMPARAÇÃO ✅
| ID | História | Status | SP |
|----|----------|--------|----|
| [LEAD-001](US-CRM-LEAD-001.md) | Captação de Lead via Landing Page | ✅ Pronto | 13 |
| [LEAD-002](US-CRM-LEAD-002.md) | Comparativo de Planos de Proteção | ✅ Pronto | 13 |
| [LEAD-003](US-CRM-LEAD-003.md) | Dashboard de Leads e Analytics | ✅ Pronto | 13 |

**Subtotal Fase 1**: 39 SP | **Status**: Completa

### Fase 2: CAPTURA AVANÇADA ✅
| ID | História | Status | SP |
|----|----------|--------|----|
| [LEAD-004](US-CRM-LEAD-004.md) | Captura via Formulário Embarcado | ✅ Pronto | 8 |
| [LEAD-005](US-CRM-LEAD-005.md) | Captura via WhatsApp Business | ✅ Pronto | 13 |
| [LEAD-006](US-CRM-LEAD-006.md) | Qualificar Lead (BANT) | ✅ Pronto | 5 |

**Subtotal Fase 2**: 26 SP | **Status**: Completa

### Fase 3: GESTÃO AVANÇADA E INTEGRAÇÕES ADS ⏳
| ID | História | Status | SP | Prioridade |
|----|----------|--------|----|------------|
| LEAD-007 | Importar Leads em Massa (CSV/Excel/API) | 📋 Planejado | 8 | Importante |
| LEAD-008 | Marcar Lead como Arquivado | 📋 Planejado | 3 | Importante |
| LEAD-009 | Exportar Leads | 📋 Planejado | 5 | Importante |
| LEAD-010 | Integração com Facebook Lead Ads | 📋 Planejado | 13 | Importante |
| LEAD-011 | Integração com Google Ads | 📋 Planejado | 13 | Importante |

**Subtotal Fase 3**: 42 SP | **Status**: Aguardando Especificação

### Fase 4: GESTÃO DE LEADS ⏳
| ID | História | Status | SP | Prioridade |
|----|----------|--------|----|------------|
| LEAD-012 | Cadastrar Lead Manualmente | 📋 Planejado | 8 | Essencial |
| LEAD-013 | Visualizar Lista de Leads | 📋 Planejado | 5 | Essencial |
| LEAD-014 | Buscar e Filtrar Leads | 📋 Planejado | 5 | Essencial |
| LEAD-015 | Atribuir Lead a Consultor | 📋 Planejado | 5 | Essencial |
| LEAD-016 | Editar Dados do Lead | 📋 Planejado | 5 | Essencial |
| LEAD-017 | Visualizar Detalhes do Lead | 📋 Planejado | 5 | Essencial |

**Subtotal Fase 4**: 33 SP | **Status**: Aguardando Especificação

### Fase 5: INTELIGÊNCIA E IA ⏳
| ID | História | Status | SP | Prioridade |
|----|----------|--------|----|-----------|
| LEAD-018 | Enriquecimento de Dados (APIs externas) | 📋 Planejado | 8 | Desejável |
| LEAD-019 | Score Automático de Lead | 📋 Planejado | 8 | Desejável |
| LEAD-020 | Detecção de Lead Duplicado | 📋 Planejado | 5 | Desejável |

**Subtotal Fase 5**: 21 SP | **Status**: Backlog Futuro

---

### 📊 Resumo por Fase

| Fase | Nome | Histórias | SP | Status |
|------|------|-----------|----|---------|
| 1 | Captação e Comparação | LEAD-001 a LEAD-003 | 39 | ✅ Completa |
| 2 | Captura Avançada | LEAD-004 a LEAD-006 | 26 | ✅ Completa |
| 3 | Gestão Avançada + Integrações | LEAD-007 a LEAD-011 | 42 | ⏳ Planejado |
| 4 | Gestão de Leads | LEAD-012 a LEAD-017 | 33 | ⏳ Planejado |
| 5 | Inteligência e IA | LEAD-018 a LEAD-020 | 21 | ⏳ Backlog |
| **TOTAL** | | **20 histórias** | **161 SP** | **65 SP prontos** |

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

**Versão**: 2.4  
**Atualizado em**: 25/01/2026

**Histórico:**
| Versão | Data | Alteração |
|--------|------|----------|
| 2.4 | 25/01/2026 | Correção DDD: Fase 3 (LEAD-007 a 011), Fase 4 (LEAD-012 a 017) em ordem sequencial |
| 2.3 | 25/01/2026 | Renumeração: Gestão de Leads (Fase 4: LEAD-012 a 017), Inteligência/IA (Fase 5: LEAD-018 a 020) |
| 2.2 | 25/01/2026 | Padronização IDs: LED-XXX → LEAD-XXX (Ubiquitous Language DDD) |
| 2.1 | 23/01/2026 | Fase 2 especificada: LEAD-004, LEAD-005, LEAD-006 prontos (65 SP totais) |
| 2.0 | 23/01/2026 | Reorganização completa por fases: Gestão de Leads movida para Fase 5, IDs renumerados |
| 1.2 | 21/01/2026 | Renumeração: LEAD-003 (Dashboard) e sequências Essencial/Importante/Desejável |
| 1.1 | 21/01/2026 | Atualizado com `cod_origem`, `cod_colaborador`, métricas por DDD e etapas do formulário |
| 1.0 | 21/01/2026 | Versão inicial |
