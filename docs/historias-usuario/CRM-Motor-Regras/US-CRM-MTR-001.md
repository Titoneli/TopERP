# US-CRM-MTR-001: Cadastro de Regras Basicas

> **Modulo**: CRM-Motor-Regras  
> **Versao**: 1.0  
> **Data**: 29/01/2026  
> **Status**: Pronto para Desenvolvimento  
> **Story Points**: 34

---

## Historia de Usuario

**Como** gestor do sistema,  
**Quero** cadastrar regras de calculo com variaveis, condicoes e formulas configuraveis,  
**Para** automatizar calculos sem necessidade de alteracao de codigo.

---

## Descricao

Esta historia cobre a funcionalidade basica do Motor de Regras: criar, editar, ativar e desativar regras de calculo. Inclui a definicao de variaveis de entrada, condicoes de aplicacao e formulas matematicas.

---

## Criterios de Aceitacao

### CA-001: Criar Nova Regra

- [ ] Sistema permite criar regra com codigo unico (formato REG-XXX-NNN)
- [ ] Sistema exige campos obrigatorios: codigo, nome, tipo, modulo consumidor
- [ ] Sistema permite definir descricao detalhada
- [ ] Sistema salva regra com status RASCUNHO por padrao
- [ ] Sistema registra data/hora e usuario de criacao

### CA-002: Definir Variaveis

- [ ] Sistema permite adicionar variaveis de entrada na regra
- [ ] Cada variavel tem: codigo, nome, tipo de dado, origem
- [ ] Tipos de dado suportados: DECIMAL, INTEGER, BOOLEAN, STRING, DATE
- [ ] Origem pode ser: INPUT (informada), CALCULADA, SISTEMA
- [ ] Sistema permite definir valor padrao para variavel
- [ ] Sistema permite definir validacoes (min, max, obrigatorio)

### CA-003: Definir Condicoes

- [ ] Sistema permite adicionar condicoes de aplicacao
- [ ] Condicao referencia uma variavel e um operador
- [ ] Operadores suportados: IGUAL, DIFERENTE, MAIOR, MENOR, ENTRE, CONTEM
- [ ] Sistema permite agrupar condicoes com AND/OR
- [ ] Sistema permite condicoes aninhadas (grupos)

### CA-004: Definir Formula

- [ ] Sistema permite escrever formula matematica como texto
- [ ] Formula pode referenciar variaveis declaradas pelo codigo
- [ ] Operadores matematicos suportados: +, -, *, /, %, ^
- [ ] Funcoes suportadas: IF, CASE, MIN, MAX, SUM, ROUND
- [ ] Sistema valida sintaxe da formula antes de salvar
- [ ] Sistema alerta se formula usa variavel nao declarada

### CA-005: Ativar/Desativar Regra

- [ ] Sistema permite ativar regra (status RASCUNHO → ATIVA)
- [ ] Ativacao exige data de vigencia inicio
- [ ] Sistema permite desativar regra (status ATIVA → INATIVA)
- [ ] Sistema permite arquivar regra (INATIVA → ARQUIVADA)
- [ ] Regra ARQUIVADA nao pode ser reativada

### CA-006: Listar e Filtrar Regras

- [ ] Sistema lista todas as regras cadastradas
- [ ] Sistema permite filtrar por: tipo, modulo, status
- [ ] Sistema permite buscar por codigo ou nome
- [ ] Sistema exibe total de regras por status

### CA-007: Validacoes de Negocio

- [ ] Sistema nao permite dois codigos de regra iguais
- [ ] Sistema nao permite ativar regra sem formula
- [ ] Sistema nao permite ativar regra sem pelo menos 1 variavel
- [ ] Sistema valida que formula retorna tipo numerico ou booleano

---

## Mockups

### Tela: Listagem de Regras

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  MOTOR DE REGRAS - LISTAGEM                                      [+ Nova Regra]    │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  Filtros: [Tipo: Todos ▼] [Modulo: Todos ▼] [Status: Ativa ▼] [Buscar: ______]     │
│                                                                                     │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Codigo          │ Nome                      │ Tipo      │ Status │ Vigencia │   │
│  ├─────────────────────────────────────────────────────────────────────────────┤   │
│  │ REG-COM-001     │ Comissao Plano Basico     │ COMISSAO  │ ATIVA  │ 01/01/26 │   │
│  │ REG-COM-002     │ Comissao Plano Premium    │ COMISSAO  │ ATIVA  │ 01/01/26 │   │
│  │ REG-RES-001     │ Residual por Placa        │ RESIDUAL  │ ATIVA  │ 01/01/26 │   │
│  │ REG-BON-001     │ Bonus Meta Mensal         │ BONIFICACAO│ RASCUNHO│ -       │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  Mostrando 4 de 4 regras                              [< 1 2 3 >]                  │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### Tela: Cadastro/Edicao de Regra

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  CADASTRO DE REGRA                                               [Salvar] [Cancelar]│
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  DADOS BASICOS                                                                      │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Codigo*: [REG-COM-003    ]   Nome*: [Comissao Plano Platinum            ]  │   │
│  │ Tipo*: [COMISSAO ▼]          Modulo*: [CRM-FIN ▼]                          │   │
│  │ Descricao: [Regra de comissao para vendas do plano Platinum              ] │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  VARIAVEIS                                                        [+ Adicionar]    │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Codigo         │ Nome             │ Tipo    │ Origem  │ Padrao │ Acoes     │   │
│  ├─────────────────────────────────────────────────────────────────────────────┤   │
│  │ VALOR_VENDA    │ Valor da Venda   │ DECIMAL │ INPUT   │ -      │ [Editar]  │   │
│  │ TIPO_PLANO     │ Tipo do Plano    │ STRING  │ INPUT   │ -      │ [Editar]  │   │
│  │ PERC_COMISSAO  │ % Comissao       │ DECIMAL │ SISTEMA │ 0.10   │ [Editar]  │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  CONDICOES                                                        [+ Adicionar]    │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ # │ Variavel      │ Operador │ Valor        │ Logico │ Acoes              │   │
│  ├─────────────────────────────────────────────────────────────────────────────┤   │
│  │ 1 │ TIPO_PLANO    │ IGUAL    │ "PLATINUM"   │ -      │ [Editar] [Excluir] │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  FORMULA                                                                            │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ VALOR_VENDA * PERC_COMISSAO                                                 │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│  [Validar Formula]  Status: Valida                                                 │
│                                                                                     │
│  VIGENCIA                                                                           │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Inicio: [29/01/2026]        Fim: [__/__/____] (opcional)                   │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### Modal: Adicionar Variavel

```
┌─────────────────────────────────────────────────────────────────┐
│  ADICIONAR VARIAVEL                                [X]          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Codigo*: [VALOR_VENDA        ]                                │
│  Nome*:   [Valor da Venda     ]                                │
│  Tipo*:   [DECIMAL ▼]                                          │
│  Origem*: [INPUT ▼]                                            │
│                                                                 │
│  Valor Padrao: [________]                                      │
│                                                                 │
│  Validacoes:                                                   │
│  [ ] Obrigatorio                                               │
│  [ ] Valor minimo: [____]                                      │
│  [ ] Valor maximo: [____]                                      │
│                                                                 │
│                            [Cancelar] [Adicionar]              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Regras de Negocio

| Codigo | Regra | Validacao |
|--------|-------|-----------|
| RN-MTR-001 | Codigo unico | Nao pode existir duas regras com mesmo codigo |
| RN-MTR-002 | Formula obrigatoria para ativar | Regra sem formula nao pode ser ativada |
| RN-MTR-003 | Variavel obrigatoria | Regra deve ter pelo menos 1 variavel |
| RN-MTR-004 | Vigencia obrigatoria | Regra ativa deve ter data inicio |
| RN-MTR-005 | Sintaxe valida | Formula deve ser sintaticamente correta |

---

## Modelo de Dados

### Entidades Envolvidas

- `mtr_regra` - Dados principais da regra
- `mtr_variavel` - Variaveis de entrada
- `mtr_condicao` - Condicoes de aplicacao

### Campos Principais

```sql
mtr_regra:
  - id, codigo, nome, descricao
  - tipo, modulo_consumidor, status
  - versao, vigencia_inicio, vigencia_fim
  - formula_expressao
  - criado_em, criado_por, atualizado_em, atualizado_por

mtr_variavel:
  - id, regra_id, codigo, nome
  - tipo_dado, origem, valor_padrao
  - validacoes_json

mtr_condicao:
  - id, regra_id, variavel_id
  - ordem, operador, valor_comparacao
  - operador_logico, grupo
```

---

## Cenarios de Teste

### CT-001: Criar Regra Simples

```gherkin
Dado que estou na tela de cadastro de regra
Quando preencho codigo "REG-COM-003"
E preencho nome "Comissao Platinum"
E seleciono tipo "COMISSAO"
E seleciono modulo "CRM-FIN"
E clico em Salvar
Entao regra e criada com status RASCUNHO
E sistema exibe mensagem "Regra criada com sucesso"
```

### CT-002: Adicionar Variavel

```gherkin
Dado que tenho uma regra em RASCUNHO
Quando clico em Adicionar Variavel
E preencho codigo "VALOR_VENDA"
E preencho nome "Valor da Venda"
E seleciono tipo "DECIMAL"
E seleciono origem "INPUT"
E clico em Adicionar
Entao variavel e adicionada a regra
```

### CT-003: Validar Formula

```gherkin
Dado que tenho uma regra com variaveis VALOR_VENDA e PERC_COMISSAO
Quando escrevo formula "VALOR_VENDA * PERC_COMISSAO"
E clico em Validar Formula
Entao sistema exibe "Formula valida"
```

### CT-004: Ativar Regra

```gherkin
Dado que tenho uma regra completa em RASCUNHO
E regra tem variaveis e formula valida
Quando defino vigencia inicio "29/01/2026"
E clico em Ativar
Entao regra muda para status ATIVA
E regra pode ser executada pelo Motor
```

---

## Dependencias

- **Depende de**: Sistema de autenticacao (usuario logado)
- **Dependentes**: US-CRM-MTR-002, US-CRM-MTR-003, US-CRM-MTR-005

---

## Estimativa

| Componente | Story Points |
|------------|-------------|
| Backend: CRUD Regras | 8 |
| Backend: CRUD Variaveis | 5 |
| Backend: CRUD Condicoes | 5 |
| Backend: Validador de Formula | 8 |
| Frontend: Telas | 8 |
| **TOTAL** | **34** |

---

## Historico de Alteracoes

| Versao | Data | Autor | Alteracao |
|--------|------|-------|-----------|
| 1.0 | 29/01/2026 | PO | Criacao inicial |
