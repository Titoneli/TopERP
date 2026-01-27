# US-CRM-FUN-014 — Alertas de Negociações Paradas

## História de Usuário

**Como** consultor de vendas,  
**Quero** receber alertas sobre negociações paradas,  
**Para** não deixar oportunidades esfriarem.

## Prioridade

Importante

## Estimativa

5 SP

---

## Contexto DDD

### Bounded Context
- **Contexto**: Funil de Vendas (Sales Pipeline)
- **Módulo**: CRM-Funil-Vendas
- **Tipo**: Core Domain

### Domain Events
| Evento | Trigger | Assinantes |
|--------|---------|------------|
| `NegociacaoParada` | Sem atividade há X dias | Alertas |
| `AlertaEnviado` | Notificação disparada | Logs |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Negociação Parada** | Sem interação há dias |
| **Alerta** | Notificação sobre inatividade |
| **Temperatura** | Nível de urgência do lead |

---

## Contexto de Negócio

Leads esfriam rapidamente. Alertas automáticos ajudam a garantir que nenhuma oportunidade seja esquecida no funil.

### Regras de Alerta

| Dias Parado | Nível | Ação |
|-------------|-------|------|
| 3 dias | ⚠️ Atenção | Badge amarelo |
| 5 dias | 🔴 Urgente | Notificação push |
| 7 dias | 🚨 Crítico | E-mail + push |

---

## Critérios de Aceitação

### Cenário 1 — Badge visual na negociação
- **Dado que** uma negociação está sem atividade há 3+ dias
- **Então** badge de alerta é exibido
- **E** cor indica nível de urgência

### Cenário 2 — Notificação push
- **Dado que** negociação está parada há 5+ dias
- **Então** consultor recebe notificação push
- **E** mensagem: "Negociação X está parada há 5 dias"

### Cenário 3 — Lista de negociações paradas
- **Dado que** acesso painel de alertas
- **Então** vejo lista de todas as negociações paradas
- **E** ordenadas por dias sem atividade

### Cenário 4 — Configurar tempo de alerta
- **Dado que** sou administrador
- **Quando** configuro tempo de alerta
- **Então** regras são aplicadas a todas as negociações

### Cenário 5 — Snooze do alerta
- **Dado que** recebi um alerta
- **Quando** clico em "Lembrar depois"
- **Então** alerta é adiado por 24h

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Alerta baseado em última interação ou atividade |
| RN-002 | Negociações ganhas/perdidas não geram alerta |
| RN-003 | Tempo configurável pelo Admin |
| RN-004 | Máximo 1 notificação por dia por negociação |
| RN-005 | Snooze disponível por 24h |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────┐
│  🚨 NEGOCIAÇÕES PARADAS                              [⚙️]       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Você tem 5 negociações que precisam de atenção                │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  🚨 CRÍTICO (7+ dias)                                          │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ João Silva - Fiat Strada                    10 dias     │   │
│  │ R$ 1.500 | Cotação                   [Ver] [⏰ Snooze]  │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  🔴 URGENTE (5-6 dias)                                         │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Maria Santos - VW Polo                       6 dias     │   │
│  │ R$ 1.200 | Proposta                  [Ver] [⏰ Snooze]  │   │
│  └─────────────────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Pedro Lima - Honda Civic                     5 dias     │   │
│  │ R$ 1.800 | Negociação                [Ver] [⏰ Snooze]  │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ⚠️ ATENÇÃO (3-4 dias)                                         │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Ana Costa - Renault Kwid                     4 dias     │   │
│  │ R$ 800 | Contato                     [Ver] [⏰ Snooze]  │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Dependências

| Tipo | Módulo | Descrição |
|------|--------|-----------|
| Requer | FUN-005 | Registro de interações |
| Integra | Notificações | Push e e-mail |

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 27/01/2026 | 1.0 | PO | Criação inicial com DDD |

---

**Identificador**: US-CRM-FUN-014  
**Módulo**: CRM-Funil-Vendas  
**Fase**: Importante  
**Status**: ✅ Pronto  
**Versão**: 1.0
