# US-CRM-FUN-018 — Análise de Tempo por Etapa

## História de Usuário

**Como** gestor comercial,  
**Quero** analisar o tempo médio que negociações ficam em cada etapa,  
**Para** identificar gargalos no processo de vendas.

## Prioridade

Desejável

## Estimativa

5 SP

---

## Contexto DDD

### Bounded Context
- **Contexto**: Funil de Vendas (Sales Pipeline)
- **Módulo**: CRM-Funil-Vendas
- **Tipo**: Supporting Domain (Analytics)

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Tempo Médio** | Média de dias na etapa |
| **Gargalo** | Etapa com tempo acima do ideal |
| **SLA** | Tempo máximo esperado |
| **Bottleneck** | Ponto de estrangulamento |

---

## Contexto de Negócio

Entender onde as negociações "travam" é essencial para otimizar o processo. Etapas com tempo excessivo indicam problemas que precisam de atenção.

### Métricas de Tempo

| Métrica | Descrição |
|---------|-----------|
| Tempo Médio por Etapa | Dias médios em cada fase |
| Tempo Total do Ciclo | Dias do início ao fechamento |
| Tempo por Segmento | Análise por tipo de negociação |
| SLA de Etapa | Tempo máximo aceitável |

---

## Critérios de Aceitação

### Cenário 1 — Visualizar tempo por etapa
- **Dado que** acesso análise de tempo
- **Então** vejo tempo médio de cada etapa
- **E** comparativo com SLA definido

### Cenário 2 — Identificar gargalos
- **Dado que** uma etapa está acima do SLA
- **Então** é destacada visualmente
- **E** sugestões de ação são mostradas

### Cenário 3 — Análise histórica
- **Dado que** quero ver evolução
- **Quando** seleciono período
- **Então** vejo tendência do tempo por etapa

### Cenário 4 — Comparar consultores
- **Dado que** sou gestor
- **Quando** comparo tempos entre consultores
- **Então** identifico melhores práticas

### Cenário 5 — Definir SLA por etapa
- **Dado que** sou administrador
- **Quando** configuro SLA
- **Então** alertas são gerados quando excedido

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Tempo calculado da entrada até saída da etapa |
| RN-002 | Finais de semana podem ser excluídos |
| RN-003 | SLA configurável por etapa |
| RN-004 | Alerta visual quando SLA excedido |
| RN-005 | Histórico mantido por 2 anos |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  ⏱️ ANÁLISE DE TEMPO POR ETAPA                      Período: [Últimos 30d ▼]   │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  CICLO DE VENDAS MÉDIO: 12.5 dias                   SLA: 15 dias ✓            │
│                                                                                 │
│  ─────────────────────────────────────────────────────────────────────────────  │
│                                                                                 │
│  TEMPO MÉDIO POR ETAPA                                                         │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                                                                         │   │
│  │  Novo Lead        ████████████  2.5 dias    (SLA: 3d) ✓                │   │
│  │                                                                         │   │
│  │  Contato          ██████████████████  3.8 dias    (SLA: 3d) ⚠️         │   │
│  │                                                                         │   │
│  │  Cotação          ████████  1.5 dias    (SLA: 2d) ✓                    │   │
│  │                                                                         │   │
│  │  Proposta         ██████████████  2.8 dias    (SLA: 3d) ✓              │   │
│  │                                                                         │   │
│  │  Negociação       ██████████████████████████  5.2 dias    (SLA: 4d) 🚨 │   │
│  │                   └─────── GARGALO IDENTIFICADO ───────┘                │   │
│  │                                                                         │   │
│  │  Ag. Pagamento    ████  0.8 dias    (SLA: 2d) ✓                        │   │
│  │                                                                         │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  💡 INSIGHTS                                                                   │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │ 🚨 Etapa "Negociação" 30% acima do SLA                                 │   │
│  │    Sugestão: Revisar processo de aprovação de descontos                │   │
│  │                                                                         │   │
│  │ ⚠️ Etapa "Contato" ligeiramente acima do SLA                           │   │
│  │    Sugestão: Aumentar frequência de follow-ups                         │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  COMPARATIVO POR CONSULTOR                                                     │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │ Consultor        │ Ciclo Médio │ vs SLA  │ Gargalo Principal           │   │
│  │──────────────────│─────────────│─────────│─────────────────────────────│   │
│  │ Maria Santos     │  10.2 dias  │   ✓     │ -                           │   │
│  │ João Silva       │  13.5 dias  │   ✓     │ Proposta (4.1d)             │   │
│  │ Pedro Lima       │  16.8 dias  │   ⚠️    │ Negociação (7.2d)           │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Dependências

| Tipo | Módulo | Descrição |
|------|--------|-----------|
| Requer | FUN-003 | Histórico de movimentação |
| Requer | FUN-012 | Métricas |

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 27/01/2026 | 1.0 | PO | Criação inicial com DDD |

---

**Identificador**: US-CRM-FUN-018  
**Módulo**: CRM-Funil-Vendas  
**Fase**: Desejável  
**Status**: ✅ Pronto  
**Versão**: 1.0
