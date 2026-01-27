# US-CRM-FUN-010 — Agendar Follow-up

## História de Usuário

**Como** consultor de vendas,  
**Quero** agendar follow-ups para minhas negociações,  
**Para** não esquecer de fazer contato nos momentos certos.

## Prioridade

Essencial

## Estimativa

3 SP

---

## Contexto DDD

### Bounded Context
- **Contexto**: Funil de Vendas (Sales Pipeline)
- **Módulo**: CRM-Funil-Vendas
- **Tipo**: Core Domain

### Aggregate Root
- **Negociação** (contém agendamentos)

### Domain Events
| Evento | Trigger | Assinantes |
|--------|---------|------------|
| `FollowUpAgendado` | Novo agendamento | Lembretes, Agenda |
| `FollowUpVencido` | Passou do horário | Alertas |
| `FollowUpConcluido` | Marcado como feito | Analytics |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Follow-up** | Contato de acompanhamento |
| **Lembrete** | Notificação antes do horário |
| **Agenda** | Lista de follow-ups do dia |

---

## Contexto de Negócio

Follow-ups são essenciais para manter o lead engajado e não perder oportunidades. O sistema deve lembrar o consultor nos momentos certos.

### Tipos de Follow-up

| Tipo | Descrição | Antecedência |
|------|-----------|--------------|
| Retorno | Ligar de volta | 15 min |
| Verificar | Conferir recebimento | 15 min |
| Enviar | Enviar documento | 30 min |
| Reunião | Encontro agendado | 1 hora |
| Lembrar | Lembrete genérico | 15 min |

---

## Critérios de Aceitação

### Cenário 1 — Agendar follow-up rápido
- **Dado que** estou nos detalhes de uma negociação
- **Quando** clico em "Agendar Follow-up"
- **Então** posso definir data, hora e descrição

### Cenário 2 — Follow-up com horário
- **Dado que** agendo um follow-up para 14:00
- **Então** recebo lembrete às 13:45 (15 min antes)
- **E** notificação push e/ou WhatsApp

### Cenário 3 — Lista de follow-ups do dia
- **Dado que** acesso minha agenda
- **Então** vejo todos os follow-ups do dia
- **E** ordenados por horário

### Cenário 4 — Follow-up atrasado
- **Dado que** um follow-up passou do horário
- **Então** é destacado em vermelho
- **E** contador de atrasados é exibido

### Cenário 5 — Marcar como concluído
- **Dado que** realizei o follow-up
- **Quando** marco como concluído
- **Então** é removido da lista de pendentes
- **E** histórico é atualizado

### Cenário 6 — Reagendar follow-up
- **Dado que** não consegui fazer o follow-up
- **Quando** clico em "Reagendar"
- **Então** posso definir nova data/hora

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Data/hora são obrigatórios |
| RN-002 | Descrição é obrigatória |
| RN-003 | Lembrete 15min antes por padrão |
| RN-004 | Follow-up pode ser reagendado |
| RN-005 | Atrasados são destacados visualmente |
| RN-006 | Notificação por push e WhatsApp |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────┐
│  ⏰ AGENDAR FOLLOW-UP                                  [X]      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Negociação: João da Silva - Fiat Strada 2024                   │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  Tipo                                                           │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ 📞 Retorno │ ✅ Verificar │ 📧 Enviar │ 📅 Reunião │ ⏰  │   │
│  └─────────────────────────────────────────────────────────┘   │
│       [●]          [ ]           [ ]          [ ]               │
│                                                                 │
│  Data                          Hora                             │
│  ┌───────────────────┐        ┌───────────────────┐            │
│  │ 28/01/2026  [📅]  │        │ 14:00             │            │
│  └───────────────────┘        └───────────────────┘            │
│                                                                 │
│  Descrição *                                                    │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Ligar para verificar se recebeu a cotação               │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  Lembrete                                                       │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ 15 minutos antes                                    ▼   │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│            [Cancelar]                    [⏰ Agendar]           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Lista de Follow-ups

```
┌─────────────────────────────────────────────────────────────────┐
│  📋 MEUS FOLLOW-UPS                                  27/01/2026 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  🔴 ATRASADOS (2)                                               │
│  ─────────────────────────────────────────────────────────────  │
│  │ 09:00 │ 📞 João Silva - Retorno pendente      [✓] [🔄]  │   │
│  │ 11:30 │ ✅ Maria Santos - Verificar proposta  [✓] [🔄]  │   │
│                                                                 │
│  📅 HOJE                                                        │
│  ─────────────────────────────────────────────────────────────  │
│  │ 14:00 │ 📞 Pedro Lima - Ligar sobre cotação   [✓] [🔄]  │   │
│  │ 16:30 │ 📧 Ana Costa - Enviar contrato        [✓] [🔄]  │   │
│                                                                 │
│  📅 AMANHÃ                                                      │
│  ─────────────────────────────────────────────────────────────  │
│  │ 10:00 │ 📅 Carlos Souza - Reunião vistoria    [✓] [🔄]  │   │
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

**Identificador**: US-CRM-FUN-010  
**Módulo**: CRM-Funil-Vendas  
**Fase**: Essencial  
**Status**: ✅ Pronto  
**Versão**: 1.0
