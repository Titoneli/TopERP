# US-CRM-FUN-020 — Visualizar Lista de Leads/Negociações

## História de Usuário

**Como** consultor de vendas,  
**Quero** visualizar minha lista de leads/negociações em uma tabela,  
**Para** ter visão geral do meu pipeline e organizar meu trabalho.

## Prioridade

Essencial

## Estimativa

5 SP

---

## Contexto DDD

### Bounded Context
- **Contexto**: Funil de Vendas (Sales Pipeline)
- **Módulo**: CRM-Funil-Vendas

### Aggregate Root
- **Negociação** (entidade principal)

### Domain Events
| Evento | Trigger | Assinantes |
|--------|---------|------------|
| `LeadListViewed` | Acesso à lista | Analytics |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Lista de Leads** | Visão tabular dos leads do consultor |
| **Fila de Atendimento** | Leads ordenados por prioridade |
| **Pipeline** | Conjunto de leads em negociação |

---

## Contexto de Negócio

A lista de leads é a principal ferramenta de trabalho do consultor. Ela deve mostrar os leads de forma clara, permitindo identificar rapidamente quais precisam de atenção e qual o status de cada negociação.

### Visões Disponíveis

| Visão | Descrição | Usuário |
|-------|-----------|---------|
| Meus Leads | Leads atribuídos ao consultor | Consultor |
| Leads da Equipe | Leads dos subordinados | Supervisor |
| Todos os Leads | Visão completa | Gestor/Admin |
| Sem Atribuição | Leads não atribuídos | Supervisor/Gestor |

---

## Colunas da Lista

### Colunas Padrão

| Coluna | Descrição | Ordenável |
|--------|-----------|-----------|
| Nome | Nome do lead | Sim |
| Telefone | Telefone com DDD | Não |
| Status | Status atual (dom_status_lead) | Sim |
| Temperatura | FRIO/MORNO/QUENTE | Sim |
| Origem | Origem do lead | Sim |
| Data Criação | Data de cadastro | Sim |
| Última Ação | Última interação | Sim |
| Consultor | Nome do consultor (se visão geral) | Sim |

### Colunas Opcionais

| Coluna | Descrição | Padrão |
|--------|-----------|--------|
| E-mail | E-mail do lead | Oculto |
| Veículo | Marca/Modelo | Oculto |
| Cidade/UF | Localização | Oculto |
| Score BANT | Pontuação de qualificação | Oculto |
| Etapa Abandono | Onde abandonou o form | Oculto |

---

## Wireframe da Lista

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  📋 MEUS LEADS                                         [+ Novo Lead]        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  🔍 [Buscar por nome ou telefone...]        [Filtros ▼]   [Exportar 📤]     │
│                                                                             │
│  ─────────────────────────────────────────────────────────────────────────  │
│                                                                             │
│  Mostrando: Meus Leads (127)   |   🔵 Frio: 45   🟡 Morno: 52   🔴 Quente: 30│
│                                                                             │
│  ─────────────────────────────────────────────────────────────────────────  │
│                                                                             │
│  ☐ │ Nome          │ Telefone       │ Status    │ 🌡️ │ Origem     │ Criado  │
│  ──│───────────────│────────────────│───────────│────│────────────│─────────│
│  ☐ │ João Silva    │ (11) 99999-8888│ Qualific. │ 🔴 │ Landing    │ 25/01   │
│  ☐ │ Maria Santos  │ (21) 98888-7777│ Novo      │ 🟡 │ WhatsApp   │ 25/01   │
│  ☐ │ Pedro Oliveira│ (31) 97777-6666│ Contatado │ 🔵 │ Google Ads │ 24/01   │
│  ☐ │ Ana Costa     │ (41) 96666-5555│ Qualific. │ 🔴 │ Indicação  │ 24/01   │
│  ☐ │ Carlos Souza  │ (51) 95555-4444│ Novo      │ 🟡 │ Facebook   │ 23/01   │
│  ☐ │ Julia Lima    │ (61) 94444-3333│ Contatado │ 🔵 │ Landing    │ 23/01   │
│  ☐ │ Lucas Ferreira│ (71) 93333-2222│ Proposta  │ 🔴 │ WhatsApp   │ 22/01   │
│  ☐ │ Fernanda Dias │ (81) 92222-1111│ Novo      │ 🟡 │ Importação │ 22/01   │
│                                                                             │
│  ─────────────────────────────────────────────────────────────────────────  │
│                                                                             │
│  Selecionados: 0    │    [◀ Anterior]  Página 1 de 13  [Próxima ▶]          │
│                                                                             │
│  Ações em lote: [Atribuir ▼]  [Arquivar]  [Exportar Seleção]                │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Critérios de Aceitação

### Cenário 1 — Visualizar meus leads
- **Dado que** sou consultor de vendas
- **Quando** acesso a lista de leads
- **Então** vejo apenas os leads atribuídos a mim
- **E** a lista está ordenada por data de criação (mais recentes primeiro)

### Cenário 2 — Visualizar todos os leads (gestor)
- **Dado que** sou gestor comercial
- **Quando** acesso a lista de leads
- **Então** posso alternar entre "Meus Leads" e "Todos os Leads"
- **E** vejo coluna adicional "Consultor"

### Cenário 3 — Identificar temperatura visual
- **Dado que** visualizo a lista de leads
- **Quando** observo a coluna de temperatura
- **Então** vejo indicadores coloridos: 🔵 Frio, 🟡 Morno, 🔴 Quente
- **E** leads quentes ficam destacados

### Cenário 4 — Ordenar por coluna
- **Dado que** estou na lista de leads
- **Quando** clico no cabeçalho de uma coluna
- **Então** a lista é ordenada por essa coluna
- **E** posso alternar entre ascendente e descendente

### Cenário 5 — Paginação
- **Dado que** tenho mais de 10 leads
- **Quando** a lista é exibida
- **Então** vejo paginação com 10 leads por página
- **E** posso navegar entre páginas

### Cenário 6 — Contador de leads
- **Dado que** visualizo a lista
- **Quando** a página carrega
- **Então** vejo contador total de leads
- **E** vejo contadores por temperatura (Frio/Morno/Quente)

### Cenário 7 — Acessar detalhes do lead
- **Dado que** visualizo um lead na lista
- **Quando** clico no nome do lead
- **Então** sou redirecionado para a página de detalhes

### Cenário 8 — Selecionar múltiplos leads
- **Dado que** marco checkbox de vários leads
- **Quando** tenho leads selecionados
- **Então** vejo contador de selecionados
- **E** ações em lote ficam disponíveis

### Cenário 9 — Lista vazia
- **Dado que** não tenho leads atribuídos
- **Quando** acesso a lista
- **Então** vejo mensagem: "Você ainda não tem leads"
- **E** vejo botão "Cadastrar Lead" ou "Aguardar Distribuição"

### Cenário 10 — Personalizar colunas
- **Dado que** quero ver mais informações
- **Quando** clico em "Configurar Colunas"
- **Então** posso adicionar/remover colunas da visualização
- **E** a configuração é salva para próximos acessos

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Consultor vê apenas seus leads por padrão |
| RN-002 | Supervisor vê leads da sua equipe |
| RN-003 | Gestor/Admin vê todos os leads |
| RN-004 | Leads arquivados não aparecem por padrão |
| RN-005 | Ordenação padrão: data criação DESC |
| RN-006 | Paginação: 10 leads por página |
| RN-007 | Temperatura exibida com cor (visual) |
| RN-008 | Click no lead abre detalhes |
| RN-009 | Seleção múltipla habilita ações em lote |
| RN-010 | Colunas personalizáveis por usuário |

---

## Ações Possíveis

| Ação | Trigger | Resultado |
|------|---------|-----------|
| Ver lista | Acesso à página | Lista carregada |
| Ordenar | Click no cabeçalho | Reordena lista |
| Paginar | Click em página | Carrega página |
| Selecionar | Click no checkbox | Marca para ação em lote |
| Ver detalhes | Click no nome | Abre página do lead |
| Exportar | Click "Exportar" | Abre modal de exportação |
| Novo Lead | Click "+ Novo" | Abre formulário de cadastro |
| Personalizar | Click "Colunas" | Abre configuração |

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 25/01/2026 | 1.0 | PO | Criação inicial com DDD (como LEAD-013) |
| 27/01/2026 | 2.0 | PO | Movido de CRM-Leads para CRM-Funil-Vendas |

---

**Identificador**: US-CRM-FUN-020  
**Módulo**: CRM-Funil-Vendas  
**Fase**: Pipeline de Vendas  
**Status**: ✅ Pronto  
**Versão**: 2.0
