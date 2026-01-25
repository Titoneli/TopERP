# US-CRM-LEAD-014 — Buscar e Filtrar Leads

## História de Usuário

**Como** consultor de vendas,  
**Quero** buscar e filtrar leads por diversos critérios,  
**Para** encontrar rapidamente leads específicos ou segmentar minha base.

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
| `LeadSearchPerformed` | Busca executada | Analytics |
| `LeadFilterApplied` | Filtro aplicado | Analytics |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Busca** | Pesquisa por texto livre |
| **Filtro** | Seleção por critérios específicos |
| **Filtro Combinado** | Múltiplos filtros aplicados |
| **Salvar Filtro** | Persistir combinação de filtros |

---

## Contexto de Negócio

Com uma base de leads crescente, é essencial encontrar leads específicos rapidamente e segmentar a base por diferentes critérios para ações direcionadas.

### Cenários de Uso

| Cenário | Necessidade |
|---------|-------------|
| Busca rápida | Encontrar lead pelo nome ou telefone |
| Priorização | Filtrar leads QUENTES para contato |
| Seguimento | Leads de uma origem específica |
| Regional | Leads de uma cidade/estado |
| Reativação | Leads não contatados há X dias |

---

## Filtros Disponíveis

### Filtros de Texto (Busca)

| Campo | Tipo de Busca |
|-------|---------------|
| Nome | Contém (parcial) |
| Telefone | Contém (parcial ou completo) |
| E-mail | Contém (parcial) |

### Filtros de Seleção

| Filtro | Tipo | Opções |
|--------|------|--------|
| Status | multiselect | NOVO, CONTATADO, QUALIFICADO, PROPOSTA, ARQUIVADO |
| Temperatura | multiselect | FRIO, MORNO, QUENTE |
| Origem | multiselect | Landing, WhatsApp, Google, Facebook, etc. |
| Consultor | select | Lista de consultores (se permissão) |
| UF | multiselect | Estados brasileiros |
| Cidade | multiselect | Filtrada por UF |

### Filtros de Data

| Filtro | Tipo | Descrição |
|--------|------|-----------|
| Data Criação | range | De/Até data de cadastro |
| Última Ação | range | De/Até última interação |

### Filtros Avançados

| Filtro | Tipo | Descrição |
|--------|------|-----------|
| Score BANT | range | Mínimo/Máximo (0-12) |
| Com Veículo | boolean | Tem dados de veículo |
| Com E-mail | boolean | Tem e-mail cadastrado |
| Sem Contato há | number | Dias sem interação |
| Arquivados | boolean | Incluir/Excluir arquivados |

---

## Wireframe de Filtros

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  🔍 FILTROS                                              [Limpar] [Aplicar] │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  BUSCA RÁPIDA                                                               │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │ 🔍 Buscar por nome, telefone ou e-mail...                           │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                                                             │
│  ─────────────────────────────────────────────────────────────────────────  │
│                                                                             │
│  STATUS                           TEMPERATURA                               │
│  ☑ Novo         ☑ Qualificado    ☐ Frio    ☑ Morno    ☑ Quente             │
│  ☑ Contatado    ☐ Proposta                                                  │
│                                                                             │
│  ─────────────────────────────────────────────────────────────────────────  │
│                                                                             │
│  ORIGEM                           PERÍODO                                   │
│  ┌───────────────────────────┐   De: [  /  /    ]  Até: [  /  /    ]        │
│  │ ▼ Todas as origens        │                                              │
│  └───────────────────────────┘                                              │
│                                                                             │
│  LOCALIZAÇÃO                                                                │
│  Estado: [▼ Todos]             Cidade: [▼ Todas]                            │
│                                                                             │
│  ─────────────────────────────────────────────────────────────────────────  │
│                                                                             │
│  ▼ FILTROS AVANÇADOS                                                        │
│                                                                             │
│  Score BANT: [5] até [12]                                                   │
│  Sem contato há: [__] dias                                                  │
│  ☐ Incluir arquivados    ☐ Apenas com veículo    ☐ Apenas com e-mail        │
│                                                                             │
│  ─────────────────────────────────────────────────────────────────────────  │
│                                                                             │
│  💾 FILTROS SALVOS                                                          │
│  [Leads Quentes SP]  [Sem contato 7 dias]  [Facebook Hoje]  [+ Salvar]      │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Critérios de Aceitação

### Cenário 1 — Busca por nome
- **Dado que** digito "João" no campo de busca
- **Quando** pressiono Enter ou aguardo 500ms
- **Então** a lista exibe apenas leads cujo nome contém "João"

### Cenário 2 — Busca por telefone
- **Dado que** digito "99999" no campo de busca
- **Quando** a busca é executada
- **Então** a lista exibe leads cujo telefone contém "99999"

### Cenário 3 — Filtrar por temperatura
- **Dado que** marco apenas "Quente" no filtro de temperatura
- **Quando** clico em "Aplicar"
- **Então** a lista exibe apenas leads com temperatura QUENTE

### Cenário 4 — Filtros combinados
- **Dado que** marco temperatura "Quente" e origem "Landing Page"
- **Quando** aplico os filtros
- **Então** a lista exibe leads QUENTES vindos da Landing Page
- **E** os filtros ativos são exibidos como tags

### Cenário 5 — Filtro por período
- **Dado que** seleciono período de 01/01/2026 a 15/01/2026
- **Quando** aplico o filtro
- **Então** a lista exibe apenas leads criados nesse período

### Cenário 6 — Filtro por localização
- **Dado que** seleciono UF = "SP" e Cidade = "São Paulo"
- **Quando** aplico o filtro
- **Então** a lista exibe apenas leads de São Paulo/SP

### Cenário 7 — Salvar filtro
- **Dado que** configurei uma combinação de filtros útil
- **Quando** clico em "Salvar Filtro" e dou um nome
- **Então** o filtro é salvo e aparece nos "Filtros Salvos"
- **E** posso aplicá-lo com um clique

### Cenário 8 — Limpar filtros
- **Dado que** tenho filtros aplicados
- **Quando** clico em "Limpar"
- **Então** todos os filtros são removidos
- **E** a lista volta ao estado padrão

### Cenário 9 — Filtro sem resultados
- **Dado que** aplico filtros que não correspondem a nenhum lead
- **Quando** a busca é executada
- **Então** vejo mensagem: "Nenhum lead encontrado com esses filtros"
- **E** vejo sugestão para ajustar os critérios

### Cenário 10 — Filtros avançados
- **Dado que** expando "Filtros Avançados"
- **Quando** filtro por Score BANT >= 9 e sem contato há 3 dias
- **Então** vejo leads quentes que precisam de follow-up

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Busca por texto é case-insensitive |
| RN-002 | Busca por texto aceita parciais |
| RN-003 | Múltiplos filtros são combinados com AND |
| RN-004 | Valores de um mesmo filtro são combinados com OR |
| RN-005 | Busca é executada após 500ms ou Enter |
| RN-006 | Filtros aplicados são exibidos como tags |
| RN-007 | Filtros salvos são por usuário |
| RN-008 | Máximo de 10 filtros salvos por usuário |
| RN-009 | Arquivados excluídos por padrão |
| RN-010 | URL reflete filtros aplicados (compartilhável) |

---

## Ações Possíveis

| Ação | Trigger | Resultado |
|------|---------|-----------|
| Buscar | Digitar + Enter/500ms | Lista filtrada |
| Filtrar | Seleção + "Aplicar" | Lista filtrada |
| Limpar | Click "Limpar" | Remove filtros |
| Salvar filtro | Click "Salvar" | Persiste combinação |
| Aplicar salvo | Click no filtro salvo | Aplica combinação |
| Excluir salvo | Click X no filtro | Remove filtro salvo |
| Expandir avançados | Click "Avançados" | Mostra mais filtros |

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 25/01/2026 | 1.0 | PO | Criação inicial com DDD |

---

**Identificador**: US-CRM-LEAD-014  
**Módulo**: CRM-Leads  
**Fase**: 4 - Gestão de Leads  
**Status**: ✅ Pronto  
**Versão**: 1.0
