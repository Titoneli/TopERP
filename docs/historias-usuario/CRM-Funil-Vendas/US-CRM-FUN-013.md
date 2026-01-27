# US-CRM-FUN-013 — Automação de Movimentação

## História de Usuário

**Como** administrador do CRM,  
**Quero** configurar automações de movimentação no funil,  
**Para** reduzir trabalho manual e padronizar o processo.

## Prioridade

Importante

## Estimativa

13 SP

---

## Contexto DDD

### Bounded Context
- **Contexto**: Funil de Vendas (Sales Pipeline)
- **Módulo**: CRM-Funil-Vendas
- **Tipo**: Core Domain

### Aggregate Root
- **AutomacaoFunil** (regras de automação)

### Domain Events
| Evento | Trigger | Assinantes |
|--------|---------|------------|
| `AutomacaoExecutada` | Regra disparada | Logs, Analytics |
| `NegociacaoMovidaAuto` | Move automático | Timeline |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Automação** | Ação executada automaticamente |
| **Trigger** | Evento que dispara a automação |
| **Regra** | Condição para execução |
| **Workflow** | Fluxo automatizado |

---

## Contexto de Negócio

Automações reduzem trabalho repetitivo e garantem que o processo seja seguido corretamente. Exemplos: mover automaticamente após cotação enviada, criar atividade ao entrar em etapa.

### Tipos de Automação

| Tipo | Descrição | Exemplo |
|------|-----------|---------|
| Mover Etapa | Move para próxima etapa | Cotação enviada → Proposta |
| Criar Atividade | Cria tarefa automática | Entrou em Negociação → Agendar follow-up |
| Enviar Notificação | Alerta para usuário | Lead parado há 3 dias → Notificar |
| Enviar E-mail | E-mail automático | Proposta enviada → E-mail ao lead |
| Atribuir | Distribui automaticamente | Novo lead → Próximo consultor disponível |

---

## Critérios de Aceitação

### Cenário 1 — Criar automação de movimentação
- **Dado que** sou administrador
- **Quando** configuro automação "Cotação enviada → mover para Proposta"
- **Então** ao enviar cotação, negociação é movida automaticamente

### Cenário 2 — Automação condicional
- **Dado que** configuro automação com condição
- **Quando** condição é atendida
- **Então** automação é executada
- **E** se não atendida, nada acontece

### Cenário 3 — Criar atividade automática
- **Dado que** configuro "Ao entrar em Negociação → criar follow-up"
- **Quando** negociação entra nessa etapa
- **Então** atividade é criada automaticamente

### Cenário 4 — Log de automações
- **Dado que** uma automação é executada
- **Então** registro é criado no log
- **E** inclui timestamp, negociação, ação

### Cenário 5 — Desativar automação
- **Dado que** quero pausar uma automação
- **Quando** desativo
- **Então** não é mais executada
- **E** pode ser reativada

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Apenas Admin configura automações |
| RN-002 | Automação pode ser ativada/desativada |
| RN-003 | Log completo de execuções |
| RN-004 | Máximo 20 automações ativas |
| RN-005 | Automação não pode criar loop infinito |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────┐
│  ⚡ CONFIGURAR AUTOMAÇÃO                               [X]      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Nome da Automação *                                            │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Cotação enviada → Mover para Proposta                   │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  TRIGGER (Quando)                                               │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Evento: [Cotação Enviada           ▼]                   │   │
│  │                                                         │   │
│  │ Condições:                                              │   │
│  │ [+ Adicionar condição]                                  │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  AÇÃO (Então)                                                   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Tipo: [Mover para Etapa            ▼]                   │   │
│  │ Etapa: [Proposta Enviada           ▼]                   │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ☑ Automação Ativa                                             │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│            [Cancelar]                    [💾 Salvar]            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Dependências

| Tipo | Módulo | Descrição |
|------|--------|-----------|
| Requer | FUN-011 | Configuração do funil |
| Requer | CRM-AUT | Permissão de Admin |

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 27/01/2026 | 1.0 | PO | Criação inicial com DDD |

---

**Identificador**: US-CRM-FUN-013  
**Módulo**: CRM-Funil-Vendas  
**Fase**: Importante  
**Status**: ✅ Pronto  
**Versão**: 1.0
