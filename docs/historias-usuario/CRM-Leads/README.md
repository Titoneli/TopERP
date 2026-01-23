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
| [LED-001](US-CRM-LEAD-001.md) | Captação de Lead via Landing Page | ✅ Pronto | 13 |
| [LED-002](US-CRM-LEAD-002.md) | Comparativo de Planos de Proteção | ✅ Pronto | 13 |
| [LED-003](US-CRM-LEAD-003.md) | Dashboard de Leads e Analytics | ✅ Pronto | 13 |

**Subtotal Fase 1**: 39 SP | **Status**: Completa

### Fase 2: CAPTURA AVANÇADA ✅
| ID | História | Status | SP |
|----|----------|--------|----|
| [LED-004](US-CRM-LEAD-004.md) | Captura via Formulário Embarcado | ✅ Pronto | 8 |
| [LED-005](US-CRM-LEAD-005.md) | Captura via WhatsApp Business | ✅ Pronto | 13 |
| [LED-006](US-CRM-LEAD-006.md) | Qualificar Lead (BANT) | ✅ Pronto | 5 |

**Subtotal Fase 2**: 26 SP | **Status**: Completa

### Fase 3: GESTÃO AVANÇADA ⏳
| ID | História | Status | SP | Prioridade |
|----|----------|--------|----|-----------|
| LED-007 | Importar Leads em Massa (CSV/Excel) | 📋 Planejado | 8 | Importante |
| LED-008 | Marcar Lead como Inativo | 📋 Planejado | 3 | Importante |
| LED-009 | Exportar Leads | 📋 Planejado | 5 | Importante |

**Subtotal Fase 3**: 16 SP | **Status**: Aguardando Especificação

### Fase 4: INTEGRAÇÕES EXTERNAS ⏳
| ID | História | Status | SP | Prioridade |
|----|----------|--------|----|-----------|
| LED-010 | Integração com Facebook Lead Ads | 📋 Planejado | 13 | Desejável |
| LED-011 | Integração com Google Ads | 📋 Planejado | 13 | Desejável |
| LED-012 | Score Automático de Lead | 📋 Planejado | 8 | Desejável |
| LED-013 | Detecção de Lead Duplicado | 📋 Planejado | 5 | Desejável |
| LED-014 | Enriquecimento de Dados (APIs externas) | 📋 Planejado | 8 | Desejável |

**Subtotal Fase 4**: 47 SP | **Status**: Backlog Futuro

### Fase 5: GESTÃO DE LEADS ⏳
| ID | História | Status | SP | Prioridade |
|----|----------|--------|----|-----------|
| LED-015 | Cadastrar Lead Manualmente | 📋 Planejado | 8 | Essencial |
| LED-016 | Visualizar Lista de Leads | 📋 Planejado | 5 | Essencial |
| LED-017 | Buscar e Filtrar Leads | 📋 Planejado | 5 | Essencial |
| LED-018 | Atribuir Lead a Consultor | 📋 Planejado | 5 | Essencial |
| LED-019 | Editar Dados do Lead | 📋 Planejado | 5 | Essencial |
| LED-020 | Visualizar Detalhes do Lead | 📋 Planejado | 5 | Essencial |

**Subtotal Fase 5**: 33 SP | **Status**: Aguardando Especificação

---

### 📊 Resumo por Fase

| Fase | Nome | Histórias | SP | Status |
|------|------|-----------|----|---------|
| 1 | Captação e Comparação | LED-001 a LED-003 | 39 | ✅ Completa |
| 2 | Captura Avançada | LED-004 a LED-006 | 26 | ✅ Completa |
| 3 | Gestão Avançada | LED-007 a LED-009 | 16 | ⏳ Planejado |
| 4 | Integrações Externas | LED-010 a LED-014 | 47 | ⏳ Backlog |
| 5 | Gestão de Leads | LED-015 a LED-020 | 33 | ⏳ Planejado |
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

**Versão**: 2.1  
**Atualizado em**: 23/01/2026

**Histórico:**
| Versão | Data | Alteração |
|--------|------|----------|
| 2.1 | 23/01/2026 | Fase 2 especificada: LED-004, LED-005, LED-006 prontos (65 SP totais) |
| 2.0 | 23/01/2026 | Reorganização completa por fases: Gestão de Leads movida para Fase 5, IDs renumerados |
| 1.2 | 21/01/2026 | Renumeração: LED-003 (Dashboard) e sequências Essencial/Importante/Desejável |
| 1.1 | 21/01/2026 | Atualizado com `cod_origem`, `cod_colaborador`, métricas por DDD e etapas do formulário |
| 1.0 | 21/01/2026 | Versão inicial |
