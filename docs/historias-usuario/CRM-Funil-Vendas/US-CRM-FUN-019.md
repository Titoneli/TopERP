# US-CRM-FUN-019 — Comparativo de Performance

## História de Usuário

**Como** gestor comercial,  
**Quero** comparar performance entre consultores e períodos,  
**Para** identificar melhores práticas e oportunidades de coaching.

## Prioridade

Desejável

## Estimativa

8 SP

---

## Contexto DDD

### Bounded Context
- **Contexto**: Funil de Vendas (Sales Pipeline)
- **Módulo**: CRM-Funil-Vendas
- **Tipo**: Supporting Domain (Analytics)

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Performance** | Desempenho medido por KPIs |
| **Benchmark** | Referência de comparação |
| **Ranking** | Classificação por performance |
| **Coaching** | Orientação para melhoria |

---

## Contexto de Negócio

Comparativos permitem:
- Identificar top performers para premiar
- Detectar consultores que precisam de suporte
- Entender melhores práticas
- Estabelecer metas realistas

### KPIs para Comparação

| KPI | Descrição |
|-----|-----------|
| Taxa de Conversão | % de leads convertidos |
| Volume de Vendas | Quantidade de fechamentos |
| Receita | Valor total fechado |
| Ticket Médio | Receita / Vendas |
| Ciclo de Vendas | Tempo médio até fechar |
| Atividades | Quantidade de interações |

---

## Critérios de Aceitação

### Cenário 1 — Ranking de consultores
- **Dado que** acesso comparativo de performance
- **Então** vejo ranking ordenado por KPI selecionado
- **E** posição de cada consultor

### Cenário 2 — Comparar períodos
- **Dado que** quero ver evolução
- **Quando** comparo este mês vs mês anterior
- **Então** vejo variação percentual de cada KPI

### Cenário 3 — Gráfico radar individual
- **Dado que** quero perfil completo de um consultor
- **Quando** seleciono o consultor
- **Então** vejo gráfico radar com todos os KPIs

### Cenário 4 — Benchmark da equipe
- **Dado que** quero estabelecer referência
- **Então** vejo média da equipe para comparação
- **E** mediana e desvio padrão

### Cenário 5 — Exportar relatório
- **Dado que** quero compartilhar resultados
- **Quando** exporto
- **Então** relatório PDF/Excel é gerado

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Consultor vê apenas própria performance |
| RN-002 | Gestor vê performance da equipe |
| RN-003 | Comparativo precisa de período mínimo |
| RN-004 | Métricas calculadas com dados validados |
| RN-005 | Ranking atualizado diariamente |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  📈 COMPARATIVO DE PERFORMANCE                         [Jan 2026 ▼] [Exportar] │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  RANKING GERAL                                         Ordenar: [Conversão ▼]  │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │ #  │ Consultor      │ Conversão │ Vendas │ Receita    │ Ticket │ Ciclo  │   │
│  │────│────────────────│───────────│────────│────────────│────────│────────│   │
│  │ 🥇 │ Maria Santos   │   35%     │   15   │ R$ 24.500  │ R$1.633│ 10 d   │   │
│  │ 🥈 │ João Silva     │   30%     │   12   │ R$ 18.600  │ R$1.550│ 12 d   │   │
│  │ 🥉 │ Pedro Lima     │   28%     │   11   │ R$ 15.400  │ R$1.400│ 13 d   │   │
│  │ 4  │ Ana Costa      │   25%     │    9   │ R$ 12.800  │ R$1.422│ 14 d   │   │
│  │ 5  │ Carlos Rocha   │   22%     │    8   │ R$ 10.500  │ R$1.312│ 15 d   │   │
│  │────│────────────────│───────────│────────│────────────│────────│────────│   │
│  │ 📊 │ MÉDIA EQUIPE   │   28%     │   11   │ R$ 16.360  │ R$1.463│ 13 d   │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  ─────────────────────────────────────────────────────────────────────────────  │
│                                                                                 │
│  COMPARATIVO MÊS A MÊS                     Jan 2026 vs Dez 2025                │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                                                                         │   │
│  │  Conversão    ████████████████████▲ 28% → 30%   (+2pp)                 │   │
│  │  Vendas       ████████████████████▲ 50 → 55     (+10%)                 │   │
│  │  Receita      ████████████████████▲ R$75k → R$82k (+9%)                │   │
│  │  Ticket       ████████████████▼    R$1.500 → R$1.463 (-2%)             │   │
│  │  Ciclo        ████████████████▲    14d → 13d   (-7%) ↓melhor           │   │
│  │                                                                         │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  PERFIL DO CONSULTOR                       Consultor: [Maria Santos ▼]         │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                    Conversão                                            │   │
│  │                        ★                                                │   │
│  │                       /|\                                               │   │
│  │             Ciclo ★───┼───★ Vendas                                     │   │
│  │                       |                                                 │   │
│  │               Ticket ★─★ Receita                                       │   │
│  │                                                                         │   │
│  │   ★ Maria Santos    ○ Média Equipe                                     │   │
│  │                                                                         │   │
│  │   💡 Destaque: Melhor conversão da equipe                              │   │
│  │   🎯 Oportunidade: Aumentar ticket médio                               │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Dependências

| Tipo | Módulo | Descrição |
|------|--------|-----------|
| Requer | FUN-008 | Vendas ganhas |
| Requer | FUN-012 | Métricas |
| Requer | FUN-018 | Análise de tempo |

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 27/01/2026 | 1.0 | PO | Criação inicial com DDD |

---

**Identificador**: US-CRM-FUN-019  
**Módulo**: CRM-Funil-Vendas  
**Fase**: Desejável  
**Status**: ✅ Pronto  
**Versão**: 1.0
