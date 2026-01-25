# US-CRM-LEAD-008 — Marcar Lead como Arquivado

## História de Usuário

**Como** consultor de vendas,  
**Quero** arquivar leads que não vão converter,  
**Para** manter minha fila de trabalho limpa e focada em leads ativos.

## Prioridade

Importante

## Estimativa

3 SP

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
| `LeadArchived` | Lead arquivado | Analytics, Relatórios |
| `LeadUnarchived` | Lead reativado | Fila de Atendimento |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Arquivar** | Mover lead para lista inativa |
| **Reativar** | Restaurar lead arquivado para lista ativa |
| **Motivo de Arquivamento** | Razão pela qual o lead foi arquivado |
| **Lead Ativo** | Lead na fila de trabalho do consultor |

---

## Contexto de Negócio

Nem todo lead vai converter. Leads que não têm interesse, já contrataram com concorrente, ou possuem dados inválidos precisam ser removidos da fila ativa para não poluir as métricas e a lista de trabalho do consultor.

### Motivos de Arquivamento

| Código | Motivo | Descrição |
|--------|--------|-----------|
| 1 | `SEM_INTERESSE` | Lead informou que não tem interesse |
| 2 | `CONCORRENTE` | Contratou com outra empresa |
| 3 | `DADOS_INVALIDOS` | Telefone/e-mail não funcionam |
| 4 | `NAO_LOCALIZADO` | Não conseguiu contato após X tentativas |
| 5 | `DUPLICADO` | Lead duplicado (manter outro) |
| 6 | `FORA_PERFIL` | Não se enquadra no perfil de cliente |
| 7 | `OUTROS` | Outro motivo (especificar) |

---

## Fluxo de Arquivamento

```
┌─────────────────────────────────────────────────────────────────┐
│                  FLUXO DE ARQUIVAMENTO                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌───────────────┐                                              │
│  │  LEAD ATIVO   │                                              │
│  │  (qualquer    │                                              │
│  │   status)     │                                              │
│  └───────┬───────┘                                              │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │             MOTIVO DE ARQUIVAMENTO                        │  │
│  │                                                           │  │
│  │  ○ Sem interesse     ○ Concorrente    ○ Dados inválidos   │  │
│  │  ○ Não localizado    ○ Duplicado      ○ Fora do perfil    │  │
│  │  ○ Outros: [__________________________________]           │  │
│  │                                                           │  │
│  └───────────────────────────────────────────────────────────┘  │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────┐                                              │
│  │    LEAD       │                                              │
│  │  ARQUIVADO    │◄──────── Pode ser reativado a qualquer      │
│  │               │          momento pelo consultor              │
│  └───────────────┘                                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Inputs e Outputs

### Inputs

| Campo | Tipo | Obrigatório | Validação |
|-------|------|-------------|-----------|
| lead_id | uuid | Sim | Lead deve existir |
| motivo_arquivamento | select | Sim | Código da tabela de motivos |
| observacao | textarea | Condicional | Obrigatório se motivo = OUTROS |

### Outputs

| Campo | Tipo | Descrição |
|-------|------|-----------|
| status | enum | Atualizado para `ARQUIVADO` |
| data_arquivamento | timestamp | Data/hora do arquivamento |
| arquivado_por | uuid | ID do usuário que arquivou |
| motivo_arquivamento | integer | Código do motivo |

---

## Critérios de Aceitação

### Cenário 1 — Arquivamento com motivo padrão
- **Dado que** visualizo um lead na minha fila
- **Quando** clico em "Arquivar"
- **E** seleciono motivo "Sem interesse"
- **Então** o lead é marcado como `ARQUIVADO`
- **E** desaparece da minha fila de atendimento
- **E** evento `LeadArchived` é disparado

### Cenário 2 — Arquivamento com motivo "Outros"
- **Dado que** seleciono motivo "Outros"
- **Quando** não preencho a observação
- **Então** não consigo confirmar o arquivamento
- **E** vejo mensagem: "Especifique o motivo do arquivamento"

### Cenário 3 — Reativar lead arquivado
- **Dado que** acesso a lista de leads arquivados
- **Quando** localizo o lead e clico em "Reativar"
- **Então** o lead retorna para status anterior ao arquivamento
- **E** volta para a fila de atendimento
- **E** evento `LeadUnarchived` é disparado

### Cenário 4 — Visualizar motivo de arquivamento
- **Dado que** acesso um lead arquivado
- **Quando** visualizo seus detalhes
- **Então** vejo o motivo do arquivamento
- **E** vejo data e usuário que arquivou

### Cenário 5 — Filtrar leads arquivados
- **Dado que** estou na lista de leads
- **Quando** aplico filtro "Arquivados"
- **Então** vejo apenas leads com status `ARQUIVADO`
- **E** posso filtrar por motivo de arquivamento

### Cenário 6 — Arquivamento em massa
- **Dado que** seleciono 10 leads na lista
- **Quando** clico em "Arquivar Selecionados"
- **E** seleciono motivo comum
- **Então** os 10 leads são arquivados
- **E** recebo confirmação: "10 leads arquivados"

### Cenário 7 — Histórico de arquivamento
- **Dado que** um lead foi arquivado e reativado múltiplas vezes
- **Quando** visualizo o histórico do lead
- **Então** vejo todas as ações de arquivamento/reativação
- **E** vejo data, usuário e motivo de cada ação

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Qualquer status de lead pode ser arquivado |
| RN-002 | Motivo de arquivamento é obrigatório |
| RN-003 | Motivo "Outros" requer observação |
| RN-004 | Lead arquivado não aparece na fila padrão |
| RN-005 | Lead arquivado pode ser reativado |
| RN-006 | Reativação restaura status anterior |
| RN-007 | Histórico de arquivamento é mantido |
| RN-008 | Apenas consultor atribuído ou gestor pode arquivar |
| RN-009 | Arquivamento em massa limitado a 100 leads |
| RN-010 | Leads arquivados não contam nas métricas de fila |

---

## Ações Possíveis

| Ação | Trigger | Resultado |
|------|---------|-----------|
| Arquivar | Click "Arquivar" + motivo | Lead arquivado |
| Reativar | Click "Reativar" | Lead volta para fila |
| Arquivar em massa | Seleção + "Arquivar" | Múltiplos arquivados |
| Filtrar arquivados | Seleção de filtro | Lista de arquivados |
| Ver histórico | Click "Histórico" | Timeline de ações |

---

## Wireframe Conceitual

### Modal de Arquivamento

```
┌─────────────────────────────────────────────────────────────────┐
│  📦 ARQUIVAR LEAD                                   [X]         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Lead: João da Silva - (11) 99999-8888                          │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  Por que você está arquivando este lead?                        │
│                                                                 │
│  ○ Sem interesse                                                │
│  ○ Contratou com concorrente                                    │
│  ○ Dados inválidos (telefone/e-mail não funcionam)              │
│  ○ Não localizado (sem retorno após tentativas)                 │
│  ○ Lead duplicado                                               │
│  ○ Fora do perfil de cliente                                    │
│  ● Outros                                                       │
│                                                                 │
│  Especifique: [_________________________________________]       │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  ⚠️ O lead será removido da sua fila de atendimento.            │
│     Você poderá reativá-lo a qualquer momento.                  │
│                                                                 │
│                                [Cancelar]  [Arquivar Lead]      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 25/01/2026 | 1.0 | PO | Criação inicial com DDD |

---

**Identificador**: US-CRM-LEAD-008  
**Módulo**: CRM-Leads  
**Fase**: 3 - Gestão Avançada e Integrações Ads  
**Status**: ✅ Pronto  
**Versão**: 1.0
