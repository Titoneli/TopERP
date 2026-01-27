# US-CRM-FUN-005 — Registrar Interação com Lead

## História de Usuário

**Como** consultor de vendas,  
**Quero** registrar todas as interações com o lead,  
**Para** manter histórico completo e contextualizar próximos contatos.

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
- **Negociação** (contém Interações)

### Entidade
- **Interação** (entidade dentro do agregado)

### Domain Events
| Evento | Trigger | Assinantes |
|--------|---------|------------|
| `InteracaoRegistrada` | Nova interação | Analytics, Timeline |
| `ContatoRealizado` | Interação de contato | Métricas |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Interação** | Qualquer contato ou comunicação com o lead |
| **Canal** | Meio de comunicação usado |
| **Direção** | Entrada (lead→consultor) ou Saída (consultor→lead) |
| **Timeline** | Histórico cronológico de interações |

---

## Contexto de Negócio

O registro de interações é fundamental para contextualizar conversas e não perder informações importantes. Todo contato deve ser documentado.

### Canais de Interação

| Canal | Ícone | Descrição |
|-------|-------|-----------|
| Telefone | 📞 | Ligação telefônica |
| WhatsApp | 💬 | Mensagem WhatsApp |
| E-mail | 📧 | Comunicação por e-mail |
| Presencial | 🏠 | Encontro presencial |
| Videochamada | 📹 | Reunião online |
| SMS | 📱 | Mensagem de texto |
| Chat | 💭 | Chat do site |

### Direção da Interação

| Direção | Descrição |
|---------|-----------|
| Entrada | Lead entrou em contato |
| Saída | Consultor contatou o lead |

---

## Critérios de Aceitação

### Cenário 1 — Registrar interação básica
- **Dado que** estou nos detalhes de uma negociação
- **Quando** clico em "Registrar Interação"
- **Então** formulário é exibido
- **E** posso selecionar canal, direção e resumo

### Cenário 2 — Interação com duração
- **Dado que** registro uma ligação
- **Quando** informo a duração
- **Então** o tempo é salvo para métricas

### Cenário 3 — Timeline de interações
- **Dado que** uma negociação tem interações
- **Então** vejo timeline cronológica
- **E** cada interação mostra canal, direção, data e resumo

### Cenário 4 — Interação rápida
- **Dado que** acabei de falar com o lead
- **Quando** uso registro rápido
- **Então** apenas canal e resumo são obrigatórios
- **E** data/hora é automática (agora)

### Cenário 5 — Filtrar por canal
- **Dado que** quero ver apenas ligações
- **Quando** filtro por canal "Telefone"
- **Então** apenas interações telefônicas são exibidas

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Canal é obrigatório |
| RN-002 | Resumo é obrigatório |
| RN-003 | Data/hora default é "agora" |
| RN-004 | Interação não pode ser excluída, apenas editada |
| RN-005 | Duração é opcional mas recomendada para ligações |
| RN-006 | Histórico ordenado do mais recente ao mais antigo |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────┐
│  📝 REGISTRAR INTERAÇÃO                                [X]      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Canal *                                                        │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ 📞 Telefone │ 💬 WhatsApp │ 📧 E-mail │ 🏠 Presencial  │   │
│  └─────────────────────────────────────────────────────────┘   │
│       [●]           [ ]           [ ]           [ ]             │
│                                                                 │
│  Direção                                                        │
│  ┌───────────────────────┐  ┌───────────────────────┐          │
│  │ ⬅️ Entrada (recebida) │  │ ➡️ Saída (realizada)  │          │
│  └───────────────────────┘  └───────────────────────┘          │
│           [ ]                        [●]                        │
│                                                                 │
│  Resumo *                                                       │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Cliente confirmou interesse no plano Premium. Pediu     │   │
│  │ para enviar proposta formal por e-mail.                 │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  Duração (ligações)                                             │
│  ┌───────────────────┐                                         │
│  │ 00:15:00          │                                         │
│  └───────────────────┘                                         │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│            [Cancelar]                    [✓ Registrar]          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Timeline de Interações

```
┌─────────────────────────────────────────────────────────────────┐
│  📋 HISTÓRICO DE INTERAÇÕES                      [Filtrar ▼]   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  27/01/2026 14:30  📞 Saída                         ⏱️ 15min    │
│  ──────────────────────────────────────────────────────────     │
│  Cliente confirmou interesse no plano Premium. Pediu            │
│  para enviar proposta formal por e-mail.                        │
│                                                                 │
│  27/01/2026 10:15  💬 Entrada                                   │
│  ──────────────────────────────────────────────────────────     │
│  Lead perguntou sobre cobertura para veículo financiado         │
│                                                                 │
│  26/01/2026 16:00  📧 Saída                                     │
│  ──────────────────────────────────────────────────────────     │
│  Enviada cotação completa com 3 opções de planos                │
│                                                                 │
│  25/01/2026 11:30  📞 Saída                         ⏱️ 8min     │
│  ──────────────────────────────────────────────────────────     │
│  Primeiro contato. Lead interessado mas quer pensar.            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Dependências

| Tipo | Módulo | Descrição |
|------|--------|-----------|
| Requer | FUN-002 | Negociação existente |

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 27/01/2026 | 1.0 | PO | Criação inicial com DDD |

---

**Identificador**: US-CRM-FUN-005  
**Módulo**: CRM-Funil-Vendas  
**Fase**: Essencial  
**Status**: ✅ Pronto  
**Versão**: 1.0
