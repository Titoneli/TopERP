# US-CRM-FUN-015 — Duplicar Negociação

## História de Usuário

**Como** consultor de vendas,  
**Quero** duplicar uma negociação existente,  
**Para** criar rapidamente uma nova oportunidade com dados similares.

## Prioridade

Importante

## Estimativa

3 SP

---

## Contexto DDD

### Bounded Context
- **Contexto**: Funil de Vendas (Sales Pipeline)
- **Módulo**: CRM-Funil-Vendas
- **Tipo**: Core Domain

### Aggregate Root
- **Negociação** (operação de clone)

### Domain Events
| Evento | Trigger | Assinantes |
|--------|---------|------------|
| `NegociacaoDuplicada` | Clone criado | Analytics |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Duplicar** | Criar cópia da negociação |
| **Clone** | Nova negociação baseada em existente |

---

## Contexto de Negócio

Duplicar é útil quando:
- Mesmo lead quer cotação para outro veículo
- Lead indica amigo/familiar
- Negociação perdida pode ser retomada

### Dados Copiados vs Não Copiados

| Copiados | Não Copiados |
|----------|--------------|
| Dados do lead | Atividades |
| Valor estimado | Interações |
| Consultor | Histórico de etapas |
| - | Número da negociação |

---

## Critérios de Aceitação

### Cenário 1 — Duplicar negociação
- **Dado que** estou nos detalhes de uma negociação
- **Quando** clico em "Duplicar"
- **Então** nova negociação é criada
- **E** dados básicos são copiados

### Cenário 2 — Escolher dados para copiar
- **Dado que** quero customizar a duplicação
- **Quando** abro opções avançadas
- **Então** posso selecionar quais dados copiar

### Cenário 3 — Nova negociação começa do início
- **Dado que** duplico uma negociação
- **Então** a nova começa na etapa "Novo Lead"
- **E** sem histórico de movimentações

### Cenário 4 — Lead diferente
- **Dado que** quero duplicar para outro lead
- **Quando** seleciono "Alterar lead"
- **Então** posso escolher outro lead
- **E** negociação é criada para ele

### Cenário 5 — Rastreabilidade
- **Dado que** uma negociação foi duplicada
- **Então** referência à origem é mantida
- **E** visível no histórico

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Novo número é gerado |
| RN-002 | Histórico não é copiado |
| RN-003 | Começa na primeira etapa |
| RN-004 | Lead pode ser alterado |
| RN-005 | Referência à origem é mantida |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────┐
│  📋 DUPLICAR NEGOCIAÇÃO                                [X]      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Negociação Original: #NEG-202601-00123                         │
│  Lead: João da Silva - Fiat Strada 2024                         │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  DADOS A COPIAR                                                 │
│                                                                 │
│  ☑ Dados do Lead (nome, telefone, e-mail)                      │
│  ☑ Dados do Veículo                                            │
│  ☑ Valor Estimado (R$ 1.500,00)                                │
│  ☐ Observações                                                 │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  LEAD DA NOVA NEGOCIAÇÃO                                        │
│  ○ Mesmo lead (João da Silva)                                  │
│  ● Selecionar outro lead                                       │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ 🔍 Buscar lead...                                       │   │
│  │ ───────────────────────────────────────────────────────  │   │
│  │ Maria Santos - (11) 98888-2222                          │   │
│  │ Pedro Lima - (21) 97777-3333                            │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│            [Cancelar]                    [📋 Duplicar]          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Dependências

| Tipo | Módulo | Descrição |
|------|--------|-----------|
| Requer | FUN-007 | Detalhes da negociação |
| Requer | CRM-Leads | Busca de leads |

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 27/01/2026 | 1.0 | PO | Criação inicial com DDD |

---

**Identificador**: US-CRM-FUN-015  
**Módulo**: CRM-Funil-Vendas  
**Fase**: Importante  
**Status**: ✅ Pronto  
**Versão**: 1.0
