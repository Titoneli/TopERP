# US-CRM-FUN-006 — Filtrar e Buscar Negociações

## História de Usuário

**Como** consultor de vendas,  
**Quero** filtrar e buscar negociações no funil,  
**Para** encontrar rapidamente oportunidades específicas.

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
- **Negociação** (consulta)

### Domain Events
| Evento | Trigger | Assinantes |
|--------|---------|------------|
| `FiltroAplicado` | Busca realizada | Analytics |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Filtro** | Critério para restringir resultados |
| **Busca** | Pesquisa textual livre |
| **Pipeline** | Conjunto filtrado de negociações |

---

## Contexto de Negócio

Com o crescimento do número de negociações, é essencial ter ferramentas de busca e filtro eficientes para localizar oportunidades rapidamente.

### Critérios de Filtro

| Filtro | Tipo | Opções |
|--------|------|--------|
| Etapa | Multi-select | Todas as etapas do funil |
| Consultor | Select | Meus / Todos (Admin) |
| Período | Date Range | Data de criação |
| Valor | Range | Mínimo - Máximo |
| Temperatura | Multi-select | Frio, Morno, Quente |
| Status | Select | Ativo, Ganho, Perdido |

---

## Critérios de Aceitação

### Cenário 1 — Busca por texto
- **Dado que** estou no funil de vendas
- **Quando** digito no campo de busca
- **Então** negociações são filtradas em tempo real
- **E** busca considera nome do lead, telefone, veículo

### Cenário 2 — Filtro por etapa
- **Dado que** quero ver apenas negociações em cotação
- **Quando** seleciono etapa "Cotação"
- **Então** apenas negociações nessa etapa são exibidas

### Cenário 3 — Filtros combinados
- **Dado que** aplico múltiplos filtros
- **Então** resultados atendem TODOS os critérios (AND)
- **E** contador mostra quantidade filtrada

### Cenário 4 — Limpar filtros
- **Dado que** tenho filtros aplicados
- **Quando** clico em "Limpar Filtros"
- **Então** todos os filtros são removidos
- **E** todas as negociações são exibidas

### Cenário 5 — Salvar filtro favorito
- **Dado que** uso um conjunto de filtros frequentemente
- **Quando** clico em "Salvar Filtro"
- **Então** o filtro fica disponível para uso rápido

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Busca é case-insensitive |
| RN-002 | Busca com mínimo 3 caracteres |
| RN-003 | Filtros são combinados com AND |
| RN-004 | Consultor vê apenas suas negociações (exceto Admin) |
| RN-005 | Filtros persistem na sessão |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  📊 FUNIL DE VENDAS                                              [≡] [📊] [📋] │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌──────────────────────────────────────────────────────────────────────────┐  │
│  │ 🔍 Buscar por nome, telefone, veículo...                        [⚙️]    │  │
│  └──────────────────────────────────────────────────────────────────────────┘  │
│                                                                                 │
│  FILTROS RÁPIDOS                                                               │
│  ┌────────────┐ ┌────────────┐ ┌────────────┐ ┌────────────┐ ┌────────────┐   │
│  │ Etapa  ▼   │ │ Período ▼  │ │ Valor  ▼   │ │ Temp.  ▼   │ │ Status ▼   │   │
│  └────────────┘ └────────────┘ └────────────┘ └────────────┘ └────────────┘   │
│                                                                                 │
│  📋 Filtros ativos: Etapa = Cotação | Valor > R$ 1.000     [❌ Limpar tudo]   │
│                                                                                 │
│  ─────────────────────────────────────────────────────────────────────────────  │
│                                                                                 │
│  Exibindo 12 de 45 negociações                                                 │
│                                                                                 │
│  │ Novo Lead   │  Contato    │  Cotação   │ Proposta  │ Negociação │           │
│  │    (0)      │    (0)      │   (12)     │    (0)    │    (0)     │           │
│  ├─────────────┼─────────────┼────────────┼───────────┼────────────┤           │
│  │             │             │ ┌────────┐ │           │            │           │
│  │             │             │ │ João   │ │           │            │           │
│  │             │             │ │ R$1.5k │ │           │            │           │
│  │             │             │ └────────┘ │           │            │           │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Dependências

| Tipo | Módulo | Descrição |
|------|--------|-----------|
| Requer | FUN-001 | Visualizar Funil |

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 27/01/2026 | 1.0 | PO | Criação inicial com DDD |

---

**Identificador**: US-CRM-FUN-006  
**Módulo**: CRM-Funil-Vendas  
**Fase**: Essencial  
**Status**: ✅ Pronto  
**Versão**: 1.0
