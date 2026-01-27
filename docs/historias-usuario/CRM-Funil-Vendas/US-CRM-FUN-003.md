# US-CRM-FUN-003 — Mover Negociação entre Etapas

## História de Usuário

**Como** consultor de vendas,  
**Quero** mover uma negociação entre etapas do funil,  
**Para** refletir o progresso real da venda e manter o pipeline atualizado.

## Prioridade

Essencial

## Estimativa

5 SP

---

## Contexto DDD

### Bounded Context
- **Contexto**: Funil de Vendas (Sales Pipeline)
- **Módulo**: CRM-Funil-Vendas
- **Tipo**: Core Domain

### Aggregate Root
- **Negociação** (entidade principal)

### Domain Events
| Evento | Trigger | Assinantes |
|--------|---------|------------|
| `NegociacaoMovida` | Mudança de etapa | Analytics, Histórico |
| `EtapaAlterada` | Transição concluída | Notificações |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Etapa** | Fase do funil onde a negociação se encontra |
| **Movimentação** | Transição de uma etapa para outra |
| **Pipeline** | Conjunto de negociações organizadas por etapas |
| **Kanban** | Visualização em colunas do funil |

---

## Contexto de Negócio

A movimentação de negociações é a ação mais frequente no funil. O consultor arrasta ou clica para mover a negociação conforme avança nas etapas de vendas.

### Etapas Padrão do Funil

| Ordem | Etapa | Descrição |
|-------|-------|-----------|
| 1 | Novo Lead | Recém-criado, aguardando contato |
| 2 | Contato Inicial | Primeiro contato realizado |
| 3 | Cotação | Cotação em elaboração/enviada |
| 4 | Proposta Enviada | Proposta formal enviada |
| 5 | Em Negociação | Negociando valores/condições |
| 6 | Aguardando Vistoria | Pendente de vistoria |
| 7 | Aguardando Pagamento | Pendente de pagamento |
| 8 | Fechado (Ganho) | Contrato fechado |
| 9 | Perdido | Não convertido |
| 10 | Futuro | Para contato futuro |

---

## Critérios de Aceitação

### Cenário 1 — Mover por drag-and-drop
- **Dado que** visualizo o funil em modo Kanban
- **Quando** arrasto uma negociação para outra coluna
- **Então** a negociação é movida para a nova etapa
- **E** evento `NegociacaoMovida` é disparado

### Cenário 2 — Mover por menu de contexto
- **Dado que** estou nos detalhes de uma negociação
- **Quando** seleciono "Mover para" e escolho uma etapa
- **Então** a negociação é movida
- **E** histórico é registrado

### Cenário 3 — Histórico de movimentações
- **Dado que** uma negociação foi movida
- **Então** registro é criado com:
  - Etapa anterior
  - Nova etapa
  - Data/hora
  - Usuário responsável

### Cenário 4 — Restrição de visibilidade
- **Dado que** sou consultor
- **Quando** tento mover negociação de outro consultor
- **Então** a ação é bloqueada
- **E** mensagem "Sem permissão" é exibida

### Cenário 5 — Feedback visual
- **Dado que** movo uma negociação
- **Então** animação de transição é exibida
- **E** toast de confirmação aparece

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Negociação pode estar em apenas uma etapa |
| RN-002 | Movimentação registra histórico completo |
| RN-003 | Consultor só move suas próprias negociações |
| RN-004 | Supervisor/Admin pode mover qualquer uma |
| RN-005 | Não há restrição de ordem entre etapas |
| RN-006 | Mover para "Ganho" ou "Perdido" requer confirmação |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  📊 FUNIL DE VENDAS                                              [≡] [📊] [📋] │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  │ Novo Lead   │  Contato    │  Cotação   │ Proposta  │ Negociação │  Fechado  │
│  │    (5)      │    (3)      │    (4)     │    (2)    │    (1)     │   (12)    │
│  ├─────────────┼─────────────┼────────────┼───────────┼────────────┼───────────┤
│  │             │             │            │           │            │           │
│  │ ┌─────────┐ │ ┌─────────┐ │ ┌────────┐ │           │            │           │
│  │ │ João    │ │ │ Maria   │ │ │ Pedro  │ │           │            │           │
│  │ │ R$1.500 │◄──│ R$2.000 │ │ │ R$1.8k │ │           │            │           │
│  │ │ 15/02   │ │ │ 20/02   │ │ │ 18/02  │ │           │            │           │
│  │ └─────────┘ │ └─────────┘ │ └────────┘ │           │            │           │
│  │             │      ▲      │            │           │            │           │
│  │ ┌─────────┐ │      │      │            │           │            │           │
│  │ │ Carlos  │─┼──────┘      │            │           │            │           │
│  │ │ R$1.200 │ │  DRAG       │            │           │            │           │
│  │ │ 12/02   │ │             │            │           │            │           │
│  │ └─────────┘ │             │            │           │            │           │
│  │             │             │            │           │            │           │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Dependências

| Tipo | Módulo | Descrição |
|------|--------|-----------|
| Requer | FUN-001 | Visualizar Funil |
| Requer | FUN-002 | Negociação existente |

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 27/01/2026 | 1.0 | PO | Criação inicial com DDD |

---

**Identificador**: US-CRM-FUN-003  
**Módulo**: CRM-Funil-Vendas  
**Fase**: Essencial  
**Status**: ✅ Pronto  
**Versão**: 1.0
