# US-CRM-FUN-016 — Funil por Regional/Filial

## História de Usuário

**Como** gestor regional,  
**Quero** visualizar o funil filtrado por regional/filial,  
**Para** acompanhar o desempenho de cada unidade.

## Prioridade

Desejável

## Estimativa

8 SP

---

## Contexto DDD

### Bounded Context
- **Contexto**: Funil de Vendas (Sales Pipeline)
- **Módulo**: CRM-Funil-Vendas
- **Tipo**: Core Domain

### Aggregate Root
- **Negociação** (com atributo de Regional)

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Regional** | Agrupamento geográfico de filiais |
| **Filial** | Unidade de atendimento |
| **Consolidado** | Visão de todas as unidades |

---

## Contexto de Negócio

Empresas com múltiplas filiais precisam visualizar o funil de forma segmentada para comparar performance e identificar oportunidades regionais.

### Hierarquia

```
Empresa
└── Regional
    └── Filial
        └── Consultor
            └── Negociação
```

---

## Critérios de Aceitação

### Cenário 1 — Filtrar por regional
- **Dado que** sou gestor de regional
- **Quando** acesso o funil
- **Então** vejo apenas negociações da minha regional

### Cenário 2 — Filtrar por filial
- **Dado que** quero ver uma filial específica
- **Quando** seleciono a filial
- **Então** funil mostra apenas negociações dessa filial

### Cenário 3 — Visão consolidada
- **Dado que** sou diretor
- **Quando** seleciono "Todas as unidades"
- **Então** vejo o funil completo da empresa

### Cenário 4 — Comparativo entre filiais
- **Dado que** quero comparar performance
- **Quando** acesso relatório comparativo
- **Então** vejo métricas lado a lado por filial

### Cenário 5 — Permissão por regional
- **Dado que** sou gestor de uma regional
- **Então** não tenho acesso a outras regionais
- **E** apenas Admin vê tudo

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Negociação herda filial do consultor |
| RN-002 | Gestor vê apenas sua regional |
| RN-003 | Diretor vê visão consolidada |
| RN-004 | Filtros respeitam hierarquia |
| RN-005 | Negociação pode ser transferida entre filiais |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  📊 FUNIL POR REGIONAL/FILIAL                                                   │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  Regional: [Sul ▼]     Filial: [Todas ▼]     Período: [Jan 2026 ▼]             │
│                                                                                 │
│  ─────────────────────────────────────────────────────────────────────────────  │
│                                                                                 │
│  FUNIL CONSOLIDADO - REGIONAL SUL                                              │
│  ┌───────────────┬───────────────┬───────────────┬───────────────┐            │
│  │ Novo Lead     │ Contato       │ Proposta      │ Fechado       │            │
│  │      45       │      32       │      18       │      12       │            │
│  │ R$ 67.500     │ R$ 48.000     │ R$ 27.000     │ R$ 18.000     │            │
│  └───────────────┴───────────────┴───────────────┴───────────────┘            │
│                                                                                 │
│  ─────────────────────────────────────────────────────────────────────────────  │
│                                                                                 │
│  COMPARATIVO POR FILIAL                                                        │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │ Filial          │ Pipeline    │ Conversão │ Ticket Médio │ Ranking     │   │
│  │─────────────────│─────────────│───────────│──────────────│─────────────│   │
│  │ Porto Alegre    │ R$ 45.000   │   32%     │ R$ 1.600     │   🥇        │   │
│  │ Florianópolis   │ R$ 38.000   │   28%     │ R$ 1.450     │   🥈        │   │
│  │ Curitiba        │ R$ 35.000   │   25%     │ R$ 1.380     │   🥉        │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Dependências

| Tipo | Módulo | Descrição |
|------|--------|-----------|
| Requer | CRM-AUT | Permissões por regional |
| Requer | Cadastro | Estrutura de filiais |
| Requer | FUN-012 | Métricas do funil |

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 27/01/2026 | 1.0 | PO | Criação inicial com DDD |

---

**Identificador**: US-CRM-FUN-016  
**Módulo**: CRM-Funil-Vendas  
**Fase**: Desejável  
**Status**: ✅ Pronto  
**Versão**: 1.0
