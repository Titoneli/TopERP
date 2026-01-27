# US-CRM-FUN-012 — Visualizar Métricas do Funil

## História de Usuário

**Como** gestor comercial,  
**Quero** visualizar métricas de performance do funil,  
**Para** acompanhar resultados e tomar decisões baseadas em dados.

## Prioridade

Importante

## Estimativa

8 SP

---

## Contexto DDD

### Bounded Context
- **Contexto**: Funil de Vendas (Sales Pipeline)
- **Módulo**: CRM-Funil-Vendas
- **Tipo**: CQRS Read Model

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Taxa de Conversão** | % de negociações ganhas |
| **Ciclo de Vendas** | Tempo médio até fechamento |
| **Ticket Médio** | Valor médio por venda |
| **Pipeline Value** | Soma de valores em negociação |

---

## Contexto de Negócio

Métricas são essenciais para gestão eficiente do time de vendas. Permitem identificar gargalos, oportunidades e comparar performance entre consultores.

### KPIs do Funil

| KPI | Fórmula | Meta |
|-----|---------|------|
| Taxa de Conversão | Ganhos / Total | > 25% |
| Ciclo de Vendas | Média dias até fechar | < 15 dias |
| Ticket Médio | Receita / Qtd vendas | R$ 1.500 |
| Pipeline Value | Soma valores ativos | Monitorar |
| Tempo por Etapa | Média dias na etapa | < 3 dias |
| Taxa de Perda | Perdidos / Total | < 40% |

---

## Critérios de Aceitação

### Cenário 1 — Dashboard de métricas
- **Dado que** acesso métricas do funil
- **Então** vejo cards com KPIs principais:
  - Taxa de conversão
  - Ciclo de vendas médio
  - Ticket médio
  - Pipeline value total

### Cenário 2 — Filtro por período
- **Dado que** quero analisar um período específico
- **Quando** seleciono intervalo de datas
- **Então** métricas são recalculadas para o período

### Cenário 3 — Comparativo entre consultores
- **Dado que** sou gestor
- **Quando** acesso ranking de consultores
- **Então** vejo performance individual comparada

### Cenário 4 — Gráfico de funil
- **Dado que** visualizo o funil gráfico
- **Então** vejo quantidade por etapa
- **E** taxa de passagem entre etapas
- **E** gargalos são destacados

### Cenário 5 — Exportar relatório
- **Dado que** quero compartilhar métricas
- **Quando** clico em exportar
- **Então** relatório PDF/Excel é gerado

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Métricas calculadas em tempo real |
| RN-002 | Consultor vê apenas suas métricas |
| RN-003 | Gestor vê métricas da equipe |
| RN-004 | Admin vê todas as métricas |
| RN-005 | Histórico de métricas mantido por 2 anos |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  📊 MÉTRICAS DO FUNIL                        Período: [Jan 2026 ▼] [Exportar]  │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌───────────────┐  ┌───────────────┐  ┌───────────────┐  ┌───────────────┐    │
│  │ CONVERSÃO     │  │ CICLO VENDAS  │  │ TICKET MÉDIO  │  │ PIPELINE      │    │
│  │               │  │               │  │               │  │               │    │
│  │    27.5%      │  │   12 dias     │  │  R$ 1.580     │  │  R$ 125.000   │    │
│  │   ▲ 2.3%      │  │   ▼ 1 dia     │  │   ▲ R$ 80     │  │   ▲ 15%       │    │
│  └───────────────┘  └───────────────┘  └───────────────┘  └───────────────┘    │
│                                                                                 │
│  ─────────────────────────────────────────────────────────────────────────────  │
│                                                                                 │
│  FUNIL DE CONVERSÃO                                                            │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                                                                         │   │
│  │  ████████████████████████████████████████████████████  120 Novo Lead   │   │
│  │  ████████████████████████████████████████  95 (79%)   Contato          │   │
│  │  ██████████████████████████████  72 (76%)             Cotação          │   │
│  │  ████████████████████  45 (63%)                       Proposta         │   │
│  │  ██████████████  33 (73%)                             Negociação       │   │
│  │  ████████  25 (76%)                                   Fechado ✓        │   │
│  │                                                                         │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  RANKING CONSULTORES                                                           │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │ #  │ Consultor        │ Conversão │ Vendas │ Receita    │ Ticket       │   │
│  │────│──────────────────│───────────│────────│────────────│──────────────│   │
│  │ 🥇 │ Maria Santos     │   35%     │   12   │ R$ 18.500  │ R$ 1.541     │   │
│  │ 🥈 │ João Silva       │   30%     │   10   │ R$ 16.200  │ R$ 1.620     │   │
│  │ 🥉 │ Pedro Lima       │   28%     │    9   │ R$ 13.800  │ R$ 1.533     │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Dependências

| Tipo | Módulo | Descrição |
|------|--------|-----------|
| Requer | FUN-001 | Dados do funil |
| Requer | FUN-008 | Negociações ganhas |
| Requer | FUN-009 | Negociações perdidas |

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 27/01/2026 | 1.0 | PO | Criação inicial com DDD |

---

**Identificador**: US-CRM-FUN-012  
**Módulo**: CRM-Funil-Vendas  
**Fase**: Importante  
**Status**: ✅ Pronto  
**Versão**: 1.0
