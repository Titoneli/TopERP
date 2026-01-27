# US-CRM-LEAD-007 — Importar Leads em Massa (CSV/Excel/API)

## História de Usuário

**Como** gestor comercial,  
**Quero** importar leads de fontes externas em lote,  
**Para** centralizar todos os leads no CRM e aumentar a base de prospecção.

## Prioridade

Importante

## Estimativa

8 SP

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
| `LeadsBatchImported` | Importação concluída | Analytics, Notificações |
| `LeadImportFailed` | Erro na importação | Logs, Alertas |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Importação em Massa** | Upload de múltiplos leads via arquivo |
| **Template de Importação** | Modelo de arquivo com colunas obrigatórias |
| **Validação de Importação** | Verificação de dados antes de persistir |
| **Relatório de Importação** | Resultado com sucessos e falhas |

---

## Contexto de Negócio

A importação em massa permite que leads de campanhas externas, eventos, relatórios ou bases antigas sejam centralizados no CRM. Isso agiliza o processo de prospecção e evita entrada manual de grandes volumes.

### Fontes de Importação

| Fonte | Formato | Cenário de Uso |
|-------|---------|----------------|
| Planilha Excel | .xlsx | Relatórios, eventos, bases legadas |
| CSV | .csv | Exportações de outras ferramentas |
| API | JSON | Integrações automatizadas |

---

## Fluxo de Importação

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLUXO DE IMPORTAÇÃO                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌───────────────┐                                              │
│  │   UPLOAD DO   │                                              │
│  │    ARQUIVO    │                                              │
│  └───────┬───────┘                                              │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              VALIDAÇÃO DO ARQUIVO                         │  │
│  │  • Formato suportado (CSV/XLSX)                           │  │
│  │  • Tamanho máximo (10MB / 5.000 linhas)                   │  │
│  │  • Colunas obrigatórias presentes                         │  │
│  └───────────────────────────────────────────────────────────┘  │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              PREVIEW E MAPEAMENTO                         │  │
│  │  • Exibe primeiras 10 linhas                              │  │
│  │  • Mapeia colunas do arquivo → campos do sistema          │  │
│  │  • Define origem (dom_ind_origem)                         │  │
│  └───────────────────────────────────────────────────────────┘  │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              VALIDAÇÃO DE DADOS                           │  │
│  │  • Telefone: formato válido                               │  │
│  │  • E-mail: formato válido                                 │  │
│  │  • Campos obrigatórios: preenchidos                       │  │
│  │  • Blacklist: telefone não é consultor                    │  │
│  └───────────────────────────────────────────────────────────┘  │
│          │                                                      │
│          ├───────────────────────────────────────┐              │
│          ▼                                       ▼              │
│  ┌───────────────┐                      ┌───────────────┐       │
│  │   VÁLIDOS     │                      │   INVÁLIDOS   │       │
│  │   Importar    │                      │   Rejeitar    │       │
│  └───────┬───────┘                      └───────┬───────┘       │
│          │                                      │               │
│          ▼                                      ▼               │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              RELATÓRIO DE IMPORTAÇÃO                      │  │
│  │  ✅ Importados: 450    ❌ Rejeitados: 50                  │  │
│  │  📥 Download CSV de rejeitados                            │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Template de Importação

### Colunas Obrigatórias

| Coluna | Tipo | Descrição | Exemplo |
|--------|------|-----------|---------|
| nome | text | Nome completo do lead | João da Silva |
| telefone | text | Telefone com DDD | (11) 99999-8888 |
| email | text | E-mail do lead | joao@email.com |

### Colunas Opcionais

| Coluna | Tipo | Descrição | Exemplo |
|--------|------|-----------|---------|
| marca | text | Marca do veículo | Fiat |
| modelo | text | Modelo do veículo | Strada |
| ano | integer | Ano do veículo | 2023 |
| valor_fipe | numeric | Fipe do veículo | 35.000,00 |
| uf | text | Estado | SP |
| cidade | text | Cidade | São Paulo |
| observacoes | text | Notas adicionais | Interessado em plano completo |

### Arquivo Template

```csv
nome,telefone,email,marca,modelo,ano,uf,cidade,observacoes
João da Silva,(11) 99999-8888,joao@email.com,Fiat,Strada,2023,53000,SP,São Paulo,Interessado
Maria Santos,(21) 98888-7777,maria@email.com,Honda,Civic,2022,35000,RJ,Rio de Janeiro,
```

---

## Inputs e Outputs

### Inputs

| Campo | Tipo | Obrigatório | Validação |
|-------|------|-------------|-----------|
| arquivo | file | Sim | .csv ou .xlsx, máx 10MB |
| cod_origem | select | Sim | Código da origem (grava no campo `dom_ind_origem` da tabela `crm_negociacao`) |
| cod_colaborador | select | Não | Consultor para atribuição |
| ignorar_duplicados | checkbox | Não | Se true, pula leads existentes |

### Outputs

| Campo | Tipo | Descrição |
|-------|------|-----------|
| total_processados | integer | Total de linhas processadas |
| total_importados | integer | Leads criados com sucesso |
| total_rejeitados | integer | Leads com erro |
| arquivo_rejeitados | file | CSV com leads rejeitados e motivo |

---

## Critérios de Aceitação

### Cenário 1 — Upload de arquivo válido
- **Dado que** seleciono um arquivo CSV válido com 100 leads
- **Quando** clico em "Carregar"
- **Então** o sistema exibe preview das primeiras 10 linhas
- **E** mapeia automaticamente as colunas reconhecidas

### Cenário 2 — Importação com sucesso total
- **Dado que** carreguei um arquivo com 50 leads válidos
- **Quando** confirmo a importação
- **Então** os 50 leads são criados com status `NOVO`
- **E** recebo relatório: "50 leads importados com sucesso"
- **E** evento `LeadsBatchImported` é disparado

### Cenário 3 — Importação parcial
- **Dado que** carreguei um arquivo com 100 leads
- **E** 20 leads têm telefone inválido
- **Quando** confirmo a importação
- **Então** 80 leads são importados
- **E** 20 leads são rejeitados
- **E** posso baixar CSV com os 20 rejeitados e motivo

### Cenário 4 — Arquivo inválido
- **Dado que** tento fazer upload de um arquivo .pdf
- **Quando** clico em "Carregar"
- **Então** recebo erro: "Formato não suportado. Use CSV ou XLSX"

### Cenário 5 — Arquivo muito grande
- **Dado que** tento fazer upload de arquivo com 10.000 linhas
- **Quando** clico em "Carregar"
- **Então** recebo erro: "Máximo de 5.000 leads por importação"

### Cenário 6 — Telefone de consultor bloqueado
- **Dado que** o arquivo contém telefone de um consultor ativo
- **Quando** a validação é executada
- **Então** a linha é marcada como rejeitada
- **E** motivo: "Telefone pertence a consultor ativo"

### Cenário 7 — Atribuição em massa
- **Dado que** selecionei cod_colaborador = 1234
- **Quando** a importação é concluída
- **Então** todos os leads importados são atribuídos ao consultor 1234

### Cenário 8 — Download de template
- **Dado que** acesso a tela de importação
- **Quando** clico em "Baixar Template"
- **Então** faço download de arquivo modelo com as colunas corretas

### Cenário 9 — Mapeamento manual de colunas
- **Dado que** meu arquivo tem coluna "Celular" ao invés de "telefone"
- **Quando** chego na etapa de mapeamento
- **Então** posso mapear manualmente "Celular" → "telefone"

### Cenário 10 — Importação via API
- **Dado que** envio POST para `/api/leads/import` com array JSON
- **Quando** o payload é válido
- **Então** os leads são criados
- **E** recebo resposta com total importados/rejeitados

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Formatos aceitos: CSV (UTF-8) e XLSX |
| RN-002 | Limite: 5.000 leads por importação |
| RN-003 | Tamanho máximo do arquivo: 10MB |
| RN-004 | Colunas obrigatórias: nome, telefone, email |
| RN-005 | Leads importados recebem status `NOVO` |
| RN-006 | cod_origem é obrigatório para rastreabilidade |
| RN-007 | Telefone de consultor ativo é rejeitado |
| RN-008 | DDD é extraído automaticamente do telefone |
| RN-009 | Importação gera log de auditoria |
| RN-010 | Relatório de rejeitados disponível por 7 dias |
| RN-011 | Permissão necessária: `leads.importar` |

---

## Ações Possíveis

| Ação | Trigger | Resultado |
|------|---------|-----------|
| Upload arquivo | Seleção de arquivo | Preview e mapeamento |
| Mapear colunas | Drag-and-drop | Associação campo-coluna |
| Validar dados | Click "Validar" | Lista de erros |
| Importar | Click "Importar" | Leads criados |
| Download rejeitados | Click "Baixar" | CSV com erros |
| Download template | Click "Template" | Arquivo modelo |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────┐
│  📥 IMPORTAR LEADS                                [X]           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                                                         │    │
│  │      📁 Arraste o arquivo aqui ou clique para           │    │
│  │              selecionar                                 │    │
│  │                                                         │    │
│  │      Formatos: CSV, XLSX | Máximo: 5.000 leads          │    │
│  │                                                         │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  📋 Origem dos Leads: [▼ Selecione a origem        ]            │
│                                                                 │
│  👤 Atribuir a Consultor: [▼ Nenhum (atribuição manual)  ]      │
│                                                                 │
│  ☐ Ignorar leads duplicados (mesmo telefone)                    │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  📄 [Baixar Template CSV]                                       │
│                                                                 │
│                                [Cancelar]  [Carregar Arquivo]   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Integrações

### API de Importação

```
POST /api/leads/import
Content-Type: application/json

{
  "cod_origem": 11,
  "cod_colaborador": null,
  "leads": [
    {
      "nome": "João da Silva",
      "telefone": "(11) 99999-8888",
      "email": "joao@email.com",
      "marca": "Fiat",
      "modelo": "Strada"
      "ano": "2005"
      "valor_fipe": "50000"            
    }
  ]
}

Response 200:
{
  "total_processados": 100,
  "total_importados": 95,
  "total_rejeitados": 5,
  "rejeitados": [
    { "linha": 23, "motivo": "Telefone inválido" }
  ]
}
```

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 25/01/2026 | 1.0 | PO | Criação inicial com DDD |
| 27/01/2026 | 1.1 | PO | Padronização DDD: cod_origem grava no campo dom_ind_origem da tabela crm_negociacao |

---

**Identificador**: US-CRM-LEAD-007  
**Módulo**: CRM-Leads  
**Fase**: 3 - Gestão Avançada e Integrações Ads  
**Status**: ✅ Pronto  
**Versão**: 1.1
