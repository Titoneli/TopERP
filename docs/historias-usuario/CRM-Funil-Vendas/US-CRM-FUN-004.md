# US-CRM-FUN-004 — Adicionar Atividade/Tarefa

## História de Usuário

**Como** consultor de vendas,  
**Quero** adicionar atividades e tarefas a uma negociação,  
**Para** organizar meu trabalho e não perder prazos importantes.

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
- **Negociação** (contém Atividades)

### Entidade
- **Atividade** (entidade dentro do agregado)

### Domain Events
| Evento | Trigger | Assinantes |
|--------|---------|------------|
| `AtividadeAdicionada` | Nova atividade | Agenda, Notificações |
| `AtividadeAgendada` | Com data/hora | Lembretes |
| `AtividadeConcluida` | Marcada como feita | Analytics |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Atividade** | Ação a ser realizada na negociação |
| **Tarefa** | Sinônimo de atividade |
| **Follow-up** | Atividade de acompanhamento |
| **Prazo** | Data limite para conclusão |

---

## Contexto de Negócio

Atividades são essenciais para manter o processo de vendas organizado. Cada negociação pode ter múltiplas atividades pendentes ou concluídas.

### Tipos de Atividade

| Tipo | Ícone | Descrição |
|------|-------|-----------|
| Ligação | 📞 | Ligar para o lead |
| E-mail | 📧 | Enviar e-mail |
| WhatsApp | 💬 | Mensagem WhatsApp |
| Reunião | 📅 | Reunião presencial/online |
| Visita | 🏠 | Visita ao cliente |
| Tarefa | ✅ | Tarefa genérica |
| Lembrete | ⏰ | Lembrete simples |

---

## Critérios de Aceitação

### Cenário 1 — Adicionar atividade básica
- **Dado que** estou nos detalhes de uma negociação
- **Quando** clico em "Nova Atividade"
- **Então** formulário de atividade é exibido
- **E** posso preencher tipo, título e descrição

### Cenário 2 — Atividade com agendamento
- **Dado que** estou criando uma atividade
- **Quando** defino data e hora
- **Então** a atividade é agendada
- **E** evento `AtividadeAgendada` é disparado
- **E** lembrete será enviado no momento

### Cenário 3 — Atividade rápida
- **Dado que** quero adicionar atividade rapidamente
- **Quando** uso o atalho de criação rápida
- **Então** apenas título é obrigatório
- **E** tipo padrão é "Tarefa"

### Cenário 4 — Marcar como concluída
- **Dado que** tenho uma atividade pendente
- **Quando** marco como concluída
- **Então** registro de conclusão é salvo
- **E** data/hora de conclusão são registradas
- **E** evento `AtividadeConcluida` é disparado

### Cenário 5 — Lista de atividades
- **Dado que** uma negociação tem atividades
- **Então** vejo lista ordenada por data
- **E** atividades atrasadas são destacadas em vermelho

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Título é obrigatório |
| RN-002 | Tipo é obrigatório |
| RN-003 | Data passada é permitida (registro retroativo) |
| RN-004 | Atividade concluída não pode ser editada |
| RN-005 | Notificação enviada 15min antes do horário |
| RN-006 | Atividades atrasadas são destacadas |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────┐
│  ➕ NOVA ATIVIDADE                                     [X]      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Tipo de Atividade *                                            │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ 📞 Ligação  │ 📧 E-mail │ 💬 WhatsApp │ 📅 Reunião │ ... │   │
│  └─────────────────────────────────────────────────────────┘   │
│       [●]          [ ]          [ ]           [ ]               │
│                                                                 │
│  Título *                                                       │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Ligar para confirmar interesse                          │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  Descrição                                                      │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Verificar se recebeu a cotação e tirar dúvidas          │   │
│  │                                                         │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ☑ Agendar para data/hora específica                            │
│                                                                 │
│  Data                          Hora                             │
│  ┌───────────────────┐        ┌───────────────────┐            │
│  │ 28/01/2026  [📅]  │        │ 14:00             │            │
│  └───────────────────┘        └───────────────────┘            │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│            [Cancelar]                    [✓ Criar Atividade]    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Dependências

| Tipo | Módulo | Descrição |
|------|--------|-----------|
| Requer | FUN-002 | Negociação existente |
| Integra | Notificações | Push e WhatsApp |

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 27/01/2026 | 1.0 | PO | Criação inicial com DDD |

---

**Identificador**: US-CRM-FUN-004  
**Módulo**: CRM-Funil-Vendas  
**Fase**: Essencial  
**Status**: ✅ Pronto  
**Versão**: 1.0
