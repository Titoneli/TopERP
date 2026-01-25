# US-CRM-LEAD-009 — Exportar Leads

## História de Usuário

**Como** gestor comercial,  
**Quero** exportar leads para planilha,  
**Para** analisar dados externamente, gerar relatórios e fazer backup.

## Prioridade

Importante

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
| `LeadsExported` | Exportação concluída | Auditoria, Logs |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Exportação** | Download de leads em formato planilha |
| **Filtros de Exportação** | Critérios para selecionar leads a exportar |
| **Campos de Exportação** | Colunas incluídas no arquivo |

---

## Contexto de Negócio

A exportação de leads permite que gestores analisem dados em ferramentas externas como Excel, Google Sheets ou BI tools. Também serve para backup, auditorias e integrações manuais com outros sistemas.

### Cenários de Uso

| Cenário | Necessidade |
|---------|-------------|
| Análise gerencial | Relatórios customizados em Excel |
| Backup | Cópia de segurança da base |
| Integração | Envio para sistemas externos |
| Auditoria | Verificação de dados e processos |
| Campanhas | Lista para e-mail marketing |

---

## Fluxo de Exportação

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLUXO DE EXPORTAÇÃO                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              SELEÇÃO DE FILTROS                           │  │
│  │                                                           │  │
│  │  Período: [01/01/2026] até [25/01/2026]                   │  │
│  │  Status: [▼ Todos      ]                                  │  │
│  │  Origem: [▼ Todas      ]                                  │  │
│  │  Temperatura: [▼ Todas ]                                  │  │
│  │  Consultor: [▼ Todos   ]                                  │  │
│  │                                                           │  │
│  └───────────────────────────────────────────────────────────┘  │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              SELEÇÃO DE CAMPOS                            │  │
│  │                                                           │  │
│  │  ☑ Nome     ☑ Telefone    ☑ E-mail      ☑ Status         │  │
│  │  ☑ Origem   ☐ Consultor   ☑ Temperatura ☐ Score BANT     │  │
│  │  ☐ Veículo  ☑ Cidade      ☑ UF          ☐ Data Criação   │  │
│  │                                                           │  │
│  └───────────────────────────────────────────────────────────┘  │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              FORMATO DO ARQUIVO                           │  │
│  │                                                           │  │
│  │  ○ CSV (compatível com qualquer sistema)                  │  │
│  │  ● XLSX (Excel com formatação)                            │  │
│  │                                                           │  │
│  └───────────────────────────────────────────────────────────┘  │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────┐                                              │
│  │   DOWNLOAD    │                                              │
│  │   DO ARQUIVO  │                                              │
│  └───────────────┘                                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Campos Disponíveis para Exportação

### Dados do Lead

| Campo | Coluna Excel | Tipo |
|-------|-------------|------|
| nome | Nome | text |
| telefone | Telefone | text |
| email | E-mail | text |
| ddd_telefone | DDD | text |
| status | Status | text |
| temperatura | Temperatura | text |
| bant_score | Score BANT | integer |

### Dados de Origem

| Campo | Coluna Excel | Tipo |
|-------|-------------|------|
| cod_origem | Código Origem | integer |
| origem_descricao | Origem | text |
| utm_source | UTM Source | text |
| utm_medium | UTM Medium | text |
| utm_campaign | UTM Campaign | text |

### Dados do Veículo

| Campo | Coluna Excel | Tipo |
|-------|-------------|------|
| marca | Marca | text |
| modelo | Modelo | text |
| ano_modelo | Ano | integer |
| tipo_uso | Tipo de Uso | text |

### Dados de Localização

| Campo | Coluna Excel | Tipo |
|-------|-------------|------|
| uf | UF | text |
| cidade | Cidade | text |

### Dados de Atribuição

| Campo | Coluna Excel | Tipo |
|-------|-------------|------|
| consultor_nome | Consultor | text |
| consultor_codigo | Cód. Consultor | integer |

### Datas

| Campo | Coluna Excel | Tipo |
|-------|-------------|------|
| data_criacao | Data Criação | datetime |
| data_qualificacao | Data Qualificação | datetime |
| data_atualizacao | Última Atualização | datetime |

---

## Inputs e Outputs

### Inputs (Filtros)

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| data_inicio | date | Não | Filtro por período inicial |
| data_fim | date | Não | Filtro por período final |
| status | multiselect | Não | Filtro por status |
| cod_origem | multiselect | Não | Filtro por origem |
| temperatura | multiselect | Não | Filtro por temperatura |
| cod_colaborador | select | Não | Filtro por consultor |
| campos | checkbox[] | Sim | Campos a incluir |
| formato | radio | Sim | CSV ou XLSX |

### Outputs

| Campo | Tipo | Descrição |
|-------|------|-----------|
| arquivo | file | Arquivo CSV ou XLSX |
| total_registros | integer | Quantidade exportada |

---

## Critérios de Aceitação

### Cenário 1 — Exportação básica
- **Dado que** estou na lista de leads
- **Quando** clico em "Exportar"
- **E** seleciono campos e formato
- **Então** faço download do arquivo com os leads filtrados

### Cenário 2 — Exportação com filtros
- **Dado que** apliquei filtro de temperatura = QUENTE
- **Quando** clico em "Exportar"
- **Então** o arquivo contém apenas leads quentes

### Cenário 3 — Exportação da seleção
- **Dado que** selecionei 50 leads na lista
- **Quando** clico em "Exportar Selecionados"
- **Então** o arquivo contém apenas os 50 leads selecionados

### Cenário 4 — Limite de registros
- **Dado que** tento exportar mais de 50.000 leads
- **Quando** clico em "Exportar"
- **Então** recebo alerta: "Máximo 50.000 registros. Aplique filtros."

### Cenário 5 — Exportação em CSV
- **Dado que** seleciono formato CSV
- **Quando** o download é concluído
- **Então** o arquivo está codificado em UTF-8
- **E** separador é ponto-e-vírgula (;) para compatibilidade BR

### Cenário 6 — Exportação em XLSX
- **Dado que** seleciono formato XLSX
- **Quando** o download é concluído
- **Então** o arquivo possui cabeçalho formatado
- **E** colunas têm largura ajustada automaticamente

### Cenário 7 — Auditoria de exportação
- **Dado que** realizei uma exportação
- **Quando** o gestor visualiza o log de auditoria
- **Então** vê registro da exportação com data, usuário e quantidade

### Cenário 8 — Seleção de todos os campos
- **Dado que** marco "Selecionar todos os campos"
- **Quando** confirmo a exportação
- **Então** todas as colunas disponíveis são incluídas no arquivo

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Formatos disponíveis: CSV e XLSX |
| RN-002 | Limite máximo: 50.000 registros por exportação |
| RN-003 | Mínimo 1 campo selecionado |
| RN-004 | CSV usa encoding UTF-8 com BOM |
| RN-005 | Separador CSV: ponto-e-vírgula (;) |
| RN-006 | Exportação gera log de auditoria |
| RN-007 | Permissão necessária: `leads.exportar` |
| RN-008 | Exportação de leads arquivados requer flag específico |
| RN-009 | Telefones são exportados formatados |
| RN-010 | Datas são exportadas em formato BR (dd/mm/yyyy) |

---

## Ações Possíveis

| Ação | Trigger | Resultado |
|------|---------|-----------|
| Exportar lista | Click "Exportar" | Download de todos (filtrados) |
| Exportar seleção | Seleção + "Exportar" | Download dos selecionados |
| Selecionar campos | Checkbox | Personalização de colunas |
| Escolher formato | Radio | CSV ou XLSX |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────┐
│  📤 EXPORTAR LEADS                                   [X]        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  📊 Total de leads selecionados: 1.234                          │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  📋 CAMPOS A EXPORTAR                                           │
│                                                                 │
│  Dados do Lead:                                                 │
│  ☑ Nome  ☑ Telefone  ☑ E-mail  ☑ Status  ☑ Temperatura         │
│                                                                 │
│  Dados de Origem:                                               │
│  ☑ Origem  ☐ UTM Source  ☐ UTM Medium  ☐ UTM Campaign           │
│                                                                 │
│  Dados do Veículo:                                              │
│  ☐ Marca  ☐ Modelo  ☐ Ano  ☐ Tipo de Uso                        │
│                                                                 │
│  Localização:                                                   │
│  ☑ UF  ☑ Cidade                                                 │
│                                                                 │
│  Outros:                                                        │
│  ☐ Consultor  ☑ Data Criação  ☐ Score BANT                      │
│                                                                 │
│  [Selecionar todos]  [Limpar seleção]                           │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  📁 FORMATO DO ARQUIVO                                          │
│                                                                 │
│  ○ CSV (Universal, compatível com qualquer sistema)             │
│  ● XLSX (Excel com formatação)                                  │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│                              [Cancelar]  [📥 Exportar]          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 25/01/2026 | 1.0 | PO | Criação inicial com DDD |

---

**Identificador**: US-CRM-LEAD-009  
**Módulo**: CRM-Leads  
**Fase**: 3 - Gestão Avançada e Integrações Ads  
**Status**: ✅ Pronto  
**Versão**: 1.0
