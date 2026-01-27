# US-CRM-LEAD-013 — Atribuir Lead a Consultor

## História de Usuário

**Como** supervisor comercial,  
**Quero** atribuir leads a consultores da minha equipe,  
**Para** distribuir o trabalho de forma equilibrada e eficiente.

## Prioridade

Essencial

## Estimativa

5 SP

---

## Contexto DDD

### Bounded Context
- **Contexto**: Gestão de Leads (Lead Management)
- **Módulo**: CRM-Leads

### Aggregate Root
- **Lead** (entidade principal)

### Domain Events
| Evento | Trigger | Assinantes |
|--------|---------|------------|
| `LeadAssigned` | Lead atribuído | Notificações, Analytics |
| `LeadReassigned` | Lead reatribuído | Notificações, Logs |
| `LeadUnassigned` | Atribuição removida | Analytics |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Atribuição** | Vinculação de lead a um consultor |
| **Reatribuição** | Mudança de consultor responsável |
| **Distribuição** | Processo de atribuir leads |
| **Carga de Trabalho** | Quantidade de leads por consultor |

---

## Contexto de Negócio

A atribuição correta de leads é crucial para garantir que cada prospect seja atendido pelo consultor mais adequado e que a carga de trabalho seja distribuída de forma justa.

### Critérios de Atribuição

| Critério | Descrição |
|----------|-----------|
| Região | Consultor da mesma região do lead |
| Especialidade | Consultor com expertise no tipo de veículo |
| Disponibilidade | Consultor com menos leads ativos |
| Origem | Consultor responsável pela origem/campanha |
| Manual | Supervisor decide caso a caso |

---

## Fluxo de Atribuição

```
┌─────────────────────────────────────────────────────────────────┐
│                   FLUXO DE ATRIBUIÇÃO                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌───────────────┐                                              │
│  │  LEAD SEM     │                                              │
│  │  ATRIBUIÇÃO   │                                              │
│  └───────┬───────┘                                              │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              SELEÇÃO DE CONSULTOR                         │  │
│  │                                                           │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │  │
│  │  │   MANUAL    │  │  POR CARGA  │  │ POR REGIÃO  │        │  │
│  │  │  Supervisor │  │ Menos leads │  │ Mesmo DDD   │        │  │
│  │  │   escolhe   │  │   ativos    │  │  do lead    │        │  │
│  │  └─────────────┘  └─────────────┘  └─────────────┘        │  │
│  │                                                           │  │
│  └───────────────────────────────────────────────────────────┘  │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────┐                                              │
│  │    LEAD       │                                              │
│  │  ATRIBUÍDO    │                                              │
│  └───────┬───────┘                                              │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              NOTIFICAÇÃO                                  │  │
│  │                                                           │  │
│  │  📱 Push: "Novo lead atribuído: João da Silva"            │  │
│  │  📧 E-mail: Resumo diário de novos leads                  │  │
│  │                                                           │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Inputs e Outputs

### Input (Atribuição Individual)

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| lead_id | uuid | Sim | ID do lead a atribuir |
| cod_colaborador | uuid | Sim | ID do consultor |
| motivo_atribuicao | textarea | Não | Justificativa (opcional) |

### Input (Atribuição em Massa)

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| lead_ids | uuid[] | Sim | IDs dos leads |
| cod_colaborador | uuid | Sim | ID do consultor |
| motivo_atribuicao | textarea | Não | Justificativa |

### Output

| Campo | Valor |
|-------|-------|
| cod_colaborador | ID do consultor atribuído |
| data_atribuicao | Timestamp da atribuição |
| atribuido_por | ID do usuário que atribuiu |

---

## Critérios de Aceitação

### Cenário 1 — Atribuição individual
- **Dado que** visualizo um lead sem atribuição
- **Quando** clico em "Atribuir" e seleciono um consultor
- **Então** o lead é atribuído ao consultor
- **E** o consultor recebe notificação push e WhatsApp
- **E** evento `LeadAssigned` é disparado

### Cenário 2 — Atribuição em massa
- **Dado que** seleciono 10 leads sem atribuição
- **Quando** clico em "Atribuir" e seleciono um consultor
- **Então** os 10 leads são atribuídos ao consultor
- **E** o consultor recebe notificação resumida (push e WhatsApp)

### Cenário 3 — Reatribuição de lead
- **Dado que** um lead está atribuído ao consultor A
- **Quando** o reatribuo ao consultor B
- **Então** o consultor B passa a ser responsável
- **E** o consultor B recebe notificação push e WhatsApp
- **E** o consultor A é notificado da remoção (push e WhatsApp)
- **E** histórico de atribuição é mantido

### Cenário 4 — Ver carga de trabalho
- **Dado que** estou atribuindo leads
- **Quando** visualizo a lista de consultores
- **Então** vejo quantos leads cada um possui
- **E** posso ordenar por menor carga

### Cenário 5 — Remover atribuição
- **Dado que** um lead está atribuído
- **Quando** clico em "Remover Atribuição"
- **Então** o lead volta para o pool de não atribuídos
- **E** evento `LeadUnassigned` é disparado

### Cenário 6 — Sugestão por região
- **Dado que** o lead é de SP (DDD 11)
- **Quando** abro o seletor de consultor
- **Então** consultores de SP aparecem primeiro (sugestão)
- **E** vejo indicador "Mesma região"

### Cenário 7 — Consultor inativo
- **Dado que** tento atribuir a um consultor inativo
- **Quando** seleciono o consultor
- **Então** recebo erro: "Consultor inativo. Selecione outro."

### Cenário 8 — Histórico de atribuições
- **Dado que** um lead foi atribuído/reatribuído várias vezes
- **Quando** visualizo o histórico do lead
- **Então** vejo todas as atribuições anteriores
- **E** vejo quem atribuiu e quando

### Cenário 9 — Notificação do consultor
- **Dado que** um lead foi atribuído a mim
- **Quando** recebo a notificação
- **Então** vejo nome do lead e origem
- **E** posso clicar para abrir detalhes

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Apenas supervisor, gestor ou admin pode atribuir |
| RN-002 | Consultor só pode reatribuir com permissão especial |
| RN-003 | Atribuição só para consultores ativos |
| RN-004 | Histórico de atribuições é mantido |
| RN-005 | Notificação push e WhatsApp enviada ao consultor |
| RN-006 | Atribuição em massa limitada a 100 leads |
| RN-007 | Lead pode ter apenas um consultor ativo |
| RN-008 | Remoção de atribuição volta lead para pool |
| RN-009 | Sugestão por região baseada no DDD |
| RN-010 | Carga de trabalho considera apenas leads ativos |

---

## Ações Possíveis

| Ação | Trigger | Resultado |
|------|---------|-----------|
| Atribuir | Click "Atribuir" + seleciona | Lead atribuído |
| Reatribuir | Click "Reatribuir" + seleciona | Muda consultor |
| Remover | Click "Remover Atribuição" | Volta para pool |
| Atribuir massa | Seleção + "Atribuir" | Múltiplos atribuídos |
| Ver carga | Abre seletor | Mostra qtd por consultor |
| Ver histórico | Click "Histórico" | Timeline de atribuições |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────┐
│  👤 ATRIBUIR LEAD                                    [X]        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Lead: João da Silva - (11) 99999-8888                          │
│  Origem: Landing Page | Temperatura: 🔴 Quente                  │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  Selecione o consultor responsável:                             │
│                                                                 │
│  🔍 [Buscar consultor...]                                       │
│                                                                 │
│  SUGERIDOS (Mesma Região - SP)                                  │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ ○ Carlos Silva          │ 23 leads │ SP │ ⭐ Sugerido   │    │
│  │ ○ Ana Oliveira          │ 18 leads │ SP │               │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  OUTROS CONSULTORES                                             │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ ○ Pedro Santos          │ 31 leads │ RJ │               │    │
│  │ ○ Maria Lima            │ 27 leads │ MG │               │    │
│  │ ○ João Costa            │ 15 leads │ RS │               │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  Ordenar por: [▼ Menor carga]                                   │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  Motivo (opcional):                                             │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ Lead solicitou atendimento em português                 │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│                                  [Cancelar]  [Atribuir]         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 25/01/2026 | 1.0 | PO | Criação inicial com DDD |
| 27/01/2026 | 1.1 | PO | Notificação consultor: push e WhatsApp |
| 27/01/2026 | 2.0 | PO | Renumeração: LEAD-015 → LEAD-013 (DDD) |

---

**Identificador**: US-CRM-LEAD-013  
**Módulo**: CRM-Leads  
**Fase**: 4 - Atribuição e Cadastro  
**Status**: ✅ Pronto  
**Versão**: 2.0
