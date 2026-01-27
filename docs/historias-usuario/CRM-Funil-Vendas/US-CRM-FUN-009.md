# US-CRM-FUN-009 — Marcar Negociação como Perdida

## História de Usuário

**Como** consultor de vendas,  
**Quero** marcar uma negociação como perdida,  
**Para** registrar o motivo e manter o funil organizado.

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
- **Negociação** (transição de estado)

### Domain Events
| Evento | Trigger | Assinantes |
|--------|---------|------------|
| `NegociacaoPerdida` | Marcação de perda | Analytics, CRM-Leads |
| `MotivoPerda Registrado` | Motivo informado | Relatórios |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Negociação Perdida** | Venda não concretizada |
| **Motivo de Perda** | Razão do não fechamento |
| **Loss** | Resultado negativo |
| **Churn Reason** | Motivo da desistência |

---

## Contexto de Negócio

Registrar perdas com motivos claros é essencial para análise e melhoria contínua do processo de vendas. Os motivos ajudam a identificar padrões e oportunidades de melhoria.

### Motivos de Perda

| Código | Motivo | Categoria |
|--------|--------|-----------|
| 01 | Preço alto | Comercial |
| 02 | Optou pela concorrência | Comercial |
| 03 | Desistiu da compra | Cliente |
| 04 | Não conseguimos contato | Operacional |
| 05 | Veículo não elegível | Técnico |
| 06 | Região não atendida | Técnico |
| 07 | Sem interesse no momento | Cliente |
| 08 | Lead duplicado | Operacional |
| 09 | Dados inválidos | Operacional |
| 10 | Outro | - |

---

## Critérios de Aceitação

### Cenário 1 — Marcar como perdida
- **Dado que** estou nos detalhes de uma negociação
- **Quando** clico em "Marcar como Perdida"
- **Então** modal solicita motivo da perda

### Cenário 2 — Motivo obrigatório
- **Dado que** estou marcando como perdida
- **Quando** não seleciono um motivo
- **Então** não é possível confirmar
- **E** mensagem de erro é exibida

### Cenário 3 — Detalhamento do motivo
- **Dado que** selecionei motivo "Outro" ou "Optou pela concorrência"
- **Então** campo de detalhamento é habilitado
- **E** posso especificar qual concorrente

### Cenário 4 — Confirmação de perda
- **Dado que** preenchi o motivo
- **Quando** confirmo
- **Então** negociação é movida para "Perdido"
- **E** evento `NegociacaoPerdida` é disparado
- **E** lead volta para status "Inativo"

### Cenário 5 — Reagendar para futuro
- **Dado que** motivo é "Sem interesse no momento"
- **Então** opção de agendar recontato é oferecida
- **E** se aceita, lead vai para etapa "Futuro"

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Motivo é obrigatório |
| RN-002 | Detalhamento obrigatório para "Outro" |
| RN-003 | Concorrente pode ser informado |
| RN-004 | Negociação perdida pode ser reativada |
| RN-005 | Histórico de motivos é mantido para análise |
| RN-006 | Lead pode ser reagendado para contato futuro |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────┐
│  ❌ MARCAR COMO PERDIDA                                [X]      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Lead: João da Silva                                            │
│  Veículo: Fiat Strada 2024                                      │
│  Valor: R$ 1.500,00                                            │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  Motivo da Perda *                                              │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ ○ Preço alto                                            │   │
│  │ ○ Optou pela concorrência                               │   │
│  │ ○ Desistiu da compra                                    │   │
│  │ ○ Não conseguimos contato                               │   │
│  │ ○ Veículo não elegível                                  │   │
│  │ ○ Região não atendida                                   │   │
│  │ ● Sem interesse no momento                              │   │
│  │ ○ Lead duplicado                                        │   │
│  │ ○ Dados inválidos                                       │   │
│  │ ○ Outro                                                 │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  Concorrente (se aplicável)                                    │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Porto Seguro                                            │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  Observações                                                    │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Cliente vai viajar, pediu para ligar em março           │   │
│  │                                                         │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ☑ Agendar recontato para o futuro                             │
│    Data: [01/03/2026   ]                                       │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│            [Cancelar]                    [❌ Confirmar Perda]   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Dependências

| Tipo | Módulo | Descrição |
|------|--------|-----------|
| Requer | FUN-007 | Detalhes da negociação |
| Atualiza | CRM-Leads | Status do lead |

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 27/01/2026 | 1.0 | PO | Criação inicial com DDD |

---

**Identificador**: US-CRM-FUN-009  
**Módulo**: CRM-Funil-Vendas  
**Fase**: Essencial  
**Status**: ✅ Pronto  
**Versão**: 1.0
