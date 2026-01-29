# US-CRM-MTR-001: Arquitetura de Data Providers e Definicao de Regras

> **Modulo**: CRM-Motor-Regras  
> **Versao**: 2.0  
> **Data**: 29/01/2026  
> **Status**: Pronto para Desenvolvimento  
> **Story Points**: 55

---

## Historia de Usuario

**Como** gestor do sistema,  
**Quero** cadastrar regras de calculo com alto nivel de abstracao usando Data Providers configuraveis, variaveis dinamicas, condicoes compostas e formulas flexiveis,  
**Para** criar qualquer tipo de regra de negocio sem necessidade de alteracao de codigo, atendendo cenarios complexos como bonus condicionais com multiplos filtros.

---

## Descricao

Esta historia implementa a **arquitetura fundamental do Motor de Regras v2.0**, incluindo:

1. **Data Providers**: Fontes de dados configuraveis (tabelas, views, APIs)
2. **Variaveis Dinamicas**: Agregacoes, formulas, lookups e constantes
3. **Condicoes Compostas**: AND/OR com agrupamento e referencias
4. **Schema JSON v2.0**: Definicao completa da regra em formato estruturado
5. **DSL Textual**: Linguagem legivel para usuarios avancados

### Exemplo de Caso de Uso Complexo

> Adicionar R$ 800,00 para cada 10% a mais de placas fechadas acima da meta do mes,
> desde que as placas sejam de veiculos do tipo **automovel** do estado de **SP**
> e cujo valor do veiculo seja inferior a **R$ 50.000**.

---

## Criterios de Aceitacao

### CA-001: Gerenciar Data Providers

- [ ] Sistema permite cadastrar novos Data Providers
- [ ] Cada Provider tem: codigo, nome, tipo (TABLE/VIEW/API), fonte
- [ ] Sistema permite definir campos disponiveis por Provider
- [ ] Cada campo tem: codigo, nome, tipo_dado, descricao
- [ ] Sistema valida conexao/existencia do Provider ao cadastrar
- [ ] Providers pre-cadastrados: PLACA, BOLETO, META, CONSULTOR, HIERARQUIA, LEAD, INTERACAO

### CA-002: Criar Regra com Schema v2.0

- [ ] Sistema permite criar regra com JSON estruturado (schema v2.0)
- [ ] Estrutura inclui: metadata, data_providers, variaveis, condicoes, acoes
- [ ] Sistema valida schema antes de salvar
- [ ] Sistema gera codigo automatico no formato REG-{CATEGORIA}-{SEQ}
- [ ] Sistema permite upload de arquivo JSON ou edicao inline

### CA-003: Definir Variaveis de Agregacao

- [ ] Sistema permite criar variavel do tipo AGREGACAO
- [ ] Agregacao referencia um Data Provider
- [ ] Funcoes disponiveis: COUNT, SUM, AVG, MIN, MAX, FIRST, LAST, MODE
- [ ] Sistema permite definir filtros na agregacao
- [ ] Filtros suportam: operadores de comparacao, BETWEEN, IN, NOT IN
- [ ] Filtros podem referenciar variaveis de contexto (@consultor_atual, @periodo_inicio, etc)
- [ ] Sistema gera query otimizada para o Provider

**Exemplo de Variavel de Agregacao:**
```json
{
  "nome": "placas_sp_auto_50k",
  "tipo": "AGREGACAO",
  "config": {
    "provider": "PLACA",
    "funcao": "COUNT",
    "campo": "id",
    "filtros": [
      {"campo": "consultor_id", "operador": "=", "valor": "@contexto.consultor_id"},
      {"campo": "tipo_veiculo", "operador": "=", "valor": "AUTOMOVEL"},
      {"campo": "uf_veiculo", "operador": "=", "valor": "SP"},
      {"campo": "valor_veiculo", "operador": "<", "valor": 50000}
    ]
  }
}
```

### CA-004: Definir Variaveis de Formula

- [ ] Sistema permite criar variavel do tipo FORMULA
- [ ] Formula pode referenciar outras variaveis pelo nome
- [ ] Operadores matematicos: +, -, *, /, %, ^
- [ ] Funcoes matematicas: FLOOR, CEIL, ROUND, ABS, GREATEST, LEAST, POWER, SQRT
- [ ] Funcao condicional: CASE WHEN ... THEN ... ELSE ... END
- [ ] Sistema valida sintaxe e referencias antes de salvar
- [ ] Sistema alerta se formula referencia variavel inexistente

**Exemplo de Formula com CASE:**
```json
{
  "nome": "multiplicador",
  "tipo": "FORMULA",
  "config": {
    "expressao": "CASE WHEN pct_atingimento >= 120 THEN 1.5 WHEN pct_atingimento >= 100 THEN 1.2 ELSE 1.0 END"
  }
}
```

### CA-005: Definir Variaveis de Lookup

- [ ] Sistema permite criar variavel do tipo LOOKUP
- [ ] Lookup referencia uma Tabela Auxiliar
- [ ] Tabelas auxiliares armazenam faixas, multiplicadores, etc
- [ ] Sistema permite definir condicao de busca
- [ ] Sistema permite definir campo de retorno
- [ ] Sistema suporta tabelas com ranges (min/max)

### CA-006: Definir Condicoes Compostas

- [ ] Sistema permite criar bloco de condicoes com tipo AND ou OR
- [ ] Cada expressao compara variavel com valor ou outra variavel
- [ ] Sistema suporta referencia a variavel: {"ref": "nome_variavel"}
- [ ] Sistema permite grupos aninhados de condicoes
- [ ] Sistema avalia condicoes na ordem definida

### CA-007: Variaveis de Contexto do Sistema

- [ ] Sistema disponibiliza variaveis de contexto com prefixo @
- [ ] Contexto padrao: @consultor_atual, @periodo_inicio, @periodo_fim
- [ ] Contexto de data: @hoje, @agora, @mes_atual, @ano_atual
- [ ] Contexto customizavel na chamada da API
- [ ] Sistema substitui referencias de contexto durante execucao

### CA-008: Validacao Completa da Regra

- [ ] Sistema valida schema JSON no formato v2.0
- [ ] Sistema valida que todos os Providers referenciados existem
- [ ] Sistema valida que todas as variaveis referenciadas estao declaradas
- [ ] Sistema valida sintaxe de formulas
- [ ] Sistema valida operadores das condicoes
- [ ] Sistema retorna lista de erros e warnings
- [ ] Sistema nao permite salvar regra com erros

### CA-009: Escopo e Vigencia

- [ ] Sistema permite definir escopo: GLOBAL, CONSULTOR, EQUIPE, FILIAL
- [ ] Escopo especifico aceita lista de UUIDs
- [ ] Sistema exige vigencia_inicio para regras ativas
- [ ] Sistema permite vigencia_fim opcional (indefinido)
- [ ] Sistema filtra regras por escopo e vigencia na execucao

### CA-010: DSL Textual (Opcional)

- [ ] Sistema permite escrever regra em DSL textual
- [ ] Sistema converte DSL para JSON automaticamente
- [ ] Sistema exibe DSL para regras criadas via JSON
- [ ] Sintaxe DSL inclui: REGRA, VARIAVEIS, QUANDO, ENTAO, FIM_REGRA
- [ ] Sistema valida sintaxe DSL antes de converter

---

## Mockups

### Tela: Editor de Regras v2.0

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  MOTOR DE REGRAS v2.0 - NOVA REGRA                                                 │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  [Metadados] [Variaveis] [Condicoes] [Acoes] [JSON] [DSL] [Preview]                │
│  ─────────────────────────────────────────────────────────────────                  │
│                                                                                     │
│  METADADOS                                                                          │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Codigo: [REG-BONUS-SP-001____]  Categoria: [BONIFICACAO ▼]                  │   │
│  │ Nome: [Bonus SP Automovel ate 50k_______________________________________]   │   │
│  │ Descricao: [R$ 800 para cada 10% acima da meta em automoveis SP ate 50k]    │   │
│  │                                                                             │   │
│  │ Escopo: [CONSULTOR ▼]  IDs: [+ Adicionar]                                   │   │
│  │   ├─ 550e8400-e29b-41d4-a716-446655440000 [x]                               │   │
│  │                                                                             │   │
│  │ Vigencia: [01/01/2026] ate [31/12/2026]  □ Indefinido                       │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  DATA PROVIDERS UTILIZADOS                                                          │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ [✓] PLACA - Placas/Contratos                                                │   │
│  │ [✓] META - Metas dos consultores                                            │   │
│  │ [ ] BOLETO - Boletos                                                        │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│                                    [Cancelar] [Salvar Rascunho] [Proximo →]        │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### Tela: Definicao de Variaveis

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  MOTOR DE REGRAS v2.0 - VARIAVEIS                                                  │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  VARIAVEIS DA REGRA                                           [+ Adicionar]        │
│                                                                                     │
│  ┌───────────────────────────────────────────────────────────────────────────────┐ │
│  │ # │ Nome                │ Tipo       │ Resumo                         │ Acoes │ │
│  ├───────────────────────────────────────────────────────────────────────────────┤ │
│  │ 1 │ placas_sp_auto_50k  │ AGREGACAO  │ COUNT(PLACA) WHERE tipo=AUTO...│ [✎][🗑]│ │
│  │ 2 │ meta_mes            │ AGREGACAO  │ FIRST(META.meta_placas)        │ [✎][🗑]│ │
│  │ 3 │ pct_acima_meta      │ FORMULA    │ (placas-meta)/meta*100         │ [✎][🗑]│ │
│  │ 4 │ faixas_10_pct       │ FORMULA    │ FLOOR(pct_acima_meta/10)       │ [✎][🗑]│ │
│  │ 5 │ valor_bonus         │ FORMULA    │ faixas_10_pct * 800            │ [✎][🗑]│ │
│  └───────────────────────────────────────────────────────────────────────────────┘ │
│                                                                                     │
│  EDITOR DE VARIAVEL                                                                │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Nome: [placas_sp_auto_50k___]  Tipo: [AGREGACAO ▼]                          │   │
│  │                                                                             │   │
│  │ ╔═══════════════════════════════════════════════════════════════════════╗   │   │
│  │ ║ CONFIGURACAO DE AGREGACAO                                             ║   │   │
│  │ ╠═══════════════════════════════════════════════════════════════════════╣   │   │
│  │ ║ Provider: [PLACA ▼]      Funcao: [COUNT ▼]      Campo: [id ▼]         ║   │   │
│  │ ║                                                                       ║   │   │
│  │ ║ FILTROS:                                                [+ Filtro]   ║   │   │
│  │ ║ ┌────────────────────────────────────────────────────────────────┐   ║   │   │
│  │ ║ │ consultor_id    │ =       │ @contexto.consultor_id      │ [x] │   ║   │   │
│  │ ║ │ data_fechamento │ BETWEEN │ @periodo_inicio, @periodo_fim│ [x] │   ║   │   │
│  │ ║ │ tipo_veiculo    │ =       │ AUTOMOVEL                   │ [x] │   ║   │   │
│  │ ║ │ uf_veiculo      │ =       │ SP                          │ [x] │   ║   │   │
│  │ ║ │ valor_veiculo   │ <       │ 50000                       │ [x] │   ║   │   │
│  │ ║ │ status          │ =       │ FECHADA                     │ [x] │   ║   │   │
│  │ ║ └────────────────────────────────────────────────────────────────┘   ║   │   │
│  │ ╚═══════════════════════════════════════════════════════════════════════╝   │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

---

## Cenarios de Teste

### CT-001: Criar Regra Complexa com Multiplos Filtros

**Dado** que estou no editor de regras  
**Quando** crio uma variavel de agregacao com 6 filtros  
**E** os filtros incluem tipo_veiculo, uf_veiculo, valor_veiculo, status  
**E** os filtros usam variaveis de contexto (@consultor_atual, @periodo_inicio)  
**Entao** o sistema valida todos os filtros  
**E** gera a query SQL corretamente  
**E** salva a variavel na regra

### CT-002: Validar Referencias entre Variaveis

**Dado** que tenho variaveis: meta_mes, placas, pct_acima  
**Quando** crio formula: pct_acima = (placas - meta_mes) / meta_mes * 100  
**Entao** sistema identifica referencias a meta_mes e placas  
**E** valida que ambas estao declaradas  
**E** aceita a formula

### CT-003: Rejeitar Formula com Variavel Inexistente

**Dado** que tenho apenas variavel valor_venda  
**Quando** tento criar formula: comissao = valor_venda * taxa  
**Entao** sistema identifica que taxa nao existe  
**E** exibe erro: "Variavel 'taxa' nao declarada"  
**E** nao permite salvar

---

## Regras de Negocio

| Codigo | Regra | Validacao |
|--------|-------|-----------|
| RN-001 | Codigo unico | Nao permite codigos duplicados |
| RN-002 | Provider valido | Provider referenciado deve existir |
| RN-003 | Variavel declarada | Formulas so podem usar variaveis declaradas |
| RN-004 | Tipo compativel | Operacoes devem ter tipos compativeis |
| RN-005 | Schema obrigatorio | versao_schema deve ser "2.0" |

---

## Estimativa Detalhada

| Item | Horas | SP |
|------|-------|-----|
| API CRUD Data Providers | 16h | 8 |
| API CRUD Regras | 24h | 13 |
| Parser de Variaveis | 32h | 13 |
| Parser de Formulas | 24h | 8 |
| Validador de Schema | 16h | 5 |
| Parser DSL (opcional) | 16h | 5 |
| Testes unitarios | 16h | 3 |
| **TOTAL** | **144h** | **55** |

---

## Historico de Alteracoes

| Versao | Data | Autor | Alteracao |
|--------|------|-------|-----------|
| 1.0 | 29/01/2026 | PO | Versao inicial |
| 2.0 | 29/01/2026 | PO | Reescrita completa para arquitetura de alta abstracao |
