# US-CRM-FUN-002 — Criar Nova Negociação

## História de Usuário

**Como** consultor de vendas,  
**Quero** criar uma nova negociação a partir de um lead qualificado,  
**Para** iniciar o processo de venda e acompanhar a evolução no funil.

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
- **Negociação** (entidade principal)

### Domain Events
| Evento | Trigger | Assinantes |
|--------|---------|------------|
| `NegociacaoCriada` | Nova negociação | Analytics, Notificações |
| `LeadConvertidoEmNegociacao` | Conversão do lead | CRM-Leads |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Negociação** | Oportunidade de venda em andamento |
| **Lead Qualificado** | Lead que passou pelo processo BANT |
| **Valor Estimado** | Previsão de receita da negociação |
| **Data Previsão** | Data esperada de fechamento |

---

## Contexto de Negócio

A criação de negociação é o ponto de entrada do funil de vendas. Todo lead qualificado deve ser convertido em negociação para que o consultor possa acompanhar a evolução da venda.

### Dados Obrigatórios

| Campo | Tipo | Origem |
|-------|------|--------|
| Lead | FK | Seleção (CRM-Leads) |
| Valor Estimado | Moeda | Input do consultor |
| Data Previsão | Date | Input do consultor |
| Consultor | FK | Automático (logado) |

### Dados Opcionais

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Observações | Text | Notas iniciais |
| Etapa Inicial | Enum | Default: "Novo Lead" |

---

## Critérios de Aceitação

### Cenário 1 — Criar negociação a partir de lead
- **Dado que** tenho um lead qualificado
- **Quando** clico em "Criar Negociação"
- **Então** o formulário de nova negociação é exibido
- **E** os dados do lead são pré-carregados

### Cenário 2 — Campos obrigatórios
- **Dado que** estou criando uma negociação
- **Quando** não preencho valor estimado ou data previsão
- **Então** o sistema exibe mensagem de campo obrigatório
- **E** não permite salvar

### Cenário 3 — Negociação criada com sucesso
- **Dado que** preenchi todos os campos obrigatórios
- **Quando** clico em "Salvar"
- **Então** a negociação é criada na primeira etapa do funil
- **E** evento `NegociacaoCriada` é disparado
- **E** sou redirecionado para detalhes da negociação

### Cenário 4 — Número único gerado
- **Dado que** uma negociação é criada
- **Então** um número único é gerado automaticamente
- **E** formato: NEG-YYYYMM-NNNNN

### Cenário 5 — Consultor automático
- **Dado que** estou logado como consultor
- **Quando** crio uma negociação
- **Então** sou automaticamente atribuído como responsável

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Lead é obrigatório para criar negociação |
| RN-002 | Valor estimado deve ser maior que zero |
| RN-003 | Data previsão deve ser futura |
| RN-004 | Consultor logado é o responsável |
| RN-005 | Etapa inicial é "Novo Lead" por padrão |
| RN-006 | Número da negociação é único e sequencial |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────┐
│  📝 NOVA NEGOCIAÇÃO                                    [X]      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Lead Vinculado                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ João da Silva - (11) 99999-1234                         │   │
│  │ Fiat Strada 2024 - R$ 95.000                            │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  Valor Estimado *                                               │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ R$ 1.500,00                                             │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  Data Previsão de Fechamento *                                  │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ 15/02/2026                                    [📅]      │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  Observações                                                    │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Lead interessado no plano Premium                       │   │
│  │                                                         │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│            [Cancelar]                    [✓ Criar Negociação]   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Dependências

| Tipo | Módulo | Descrição |
|------|--------|-----------|
| Requer | CRM-Leads | Lead deve existir |
| Requer | CRM-AUT | Autenticação do consultor |
| Dispara | CRM-FUN | Adiciona ao funil |

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 27/01/2026 | 1.0 | PO | Criação inicial com DDD |

---

**Identificador**: US-CRM-FUN-002  
**Módulo**: CRM-Funil-Vendas  
**Fase**: Essencial  
**Status**: ✅ Pronto  
**Versão**: 1.0
