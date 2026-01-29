# US-CRM-MTR-002: Regras Avancadas (SplitC)

> **Modulo**: CRM-Motor-Regras  
> **Versao**: 1.0  
> **Data**: 29/01/2026  
> **Status**: Pronto para Desenvolvimento  
> **Story Points**: 55

---

## Historia de Usuario

**Como** gestor do sistema,  
**Quero** cadastrar regras avancadas de remuneracao variavel (SPIFF, Aceleradores, Override, Split, PLR, Escalonada),  
**Para** implementar politicas de comissionamento complexas sem programacao.

---

## Descricao

Esta historia expande o Motor de Regras com funcionalidades avancadas inspiradas na plataforma SplitC. Inclui tipos especializados de regras que atendem cenarios complexos de remuneracao variavel.

---

## Tipos de Regras Avancadas

### 1. SPIFF (Sales Performance Incentive Fund)

Incentivo pontual por venda de produto especifico em periodo limitado.

```
┌─────────────────────────────────────────────────────────────────┐
│  SPIFF - INCENTIVO PONTUAL                                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Caracteristicas:                                               │
│  • Periodo limitado (campanha)                                  │
│  • Produto/servico especifico                                   │
│  • Valor fixo ou percentual adicional                          │
│  • Acumula com comissao normal                                  │
│                                                                 │
│  Exemplo:                                                       │
│  "Venda Plano Platinum em Janeiro = +R$ 50 por venda"          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 2. Acelerador Progressivo

Multiplicador que aumenta conforme atingimento de meta.

```
┌─────────────────────────────────────────────────────────────────┐
│  ACELERADOR PROGRESSIVO                                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Faixas de atingimento:                                         │
│  • < 80%   → 0.8x (penalidade)                                 │
│  • 80-99%  → 1.0x (normal)                                     │
│  • 100-119%→ 1.2x (bonus)                                      │
│  • >= 120% → 1.5x (super bonus)                                │
│                                                                 │
│  Aplicacao: multiplicador sobre comissao base                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 3. Override (Comissao sobre Equipe)

Gestor ganha percentual sobre vendas dos subordinados.

```
┌─────────────────────────────────────────────────────────────────┐
│  OVERRIDE - COMISSAO SOBRE EQUIPE                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Hierarquia:                                                    │
│  • Nivel 1 (direto): 3% sobre vendas da equipe                 │
│  • Nivel 2 (indireto): 1% sobre vendas da equipe do nivel 1    │
│                                                                 │
│  Exemplo:                                                       │
│  Gerente → 5 consultores → R$ 100.000 vendidos                 │
│  Override gerente = R$ 100.000 × 3% = R$ 3.000                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 4. Split (Divisao de Comissao)

Divisao de comissao entre multiplos consultores.

```
┌─────────────────────────────────────────────────────────────────┐
│  SPLIT - DIVISAO DE COMISSAO                                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Cenarios:                                                      │
│  • Captacao x Fechamento (40/60)                               │
│  • Venda em dupla (50/50)                                      │
│  • Indicacao x Venda (30/70)                                   │
│                                                                 │
│  Regras:                                                        │
│  • Soma dos percentuais = 100%                                 │
│  • Minimo 2, maximo 5 participantes                            │
│  • Cada participante identificado                               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 5. Comissao Escalonada

Percentual varia conforme volume de vendas.

```
┌─────────────────────────────────────────────────────────────────┐
│  ESCALONADA - PERCENTUAL POR FAIXA                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Faixas de volume (mensal):                                     │
│  • Ate R$ 10.000      → 5%                                     │
│  • R$ 10.001-30.000   → 7%                                     │
│  • R$ 30.001-50.000   → 9%                                     │
│  • Acima R$ 50.000    → 12%                                    │
│                                                                 │
│  Aplicacao: sobre valor total do periodo                       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 6. PLR (Participacao nos Lucros)

Distribuicao de lucros com formulas complexas.

```
┌─────────────────────────────────────────────────────────────────┐
│  PLR - PARTICIPACAO NOS LUCROS                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Formula base:                                                  │
│  PLR = (lucro_periodo × perc_distribuicao)                     │
│        × peso_individual                                        │
│        × fator_tempo_empresa                                    │
│                                                                 │
│  Variaveis:                                                     │
│  • Lucro do periodo (trimestre/ano)                            │
│  • Percentual de distribuicao (ex: 10%)                        │
│  • Peso individual (baseado em cargo/performance)              │
│  • Fator tempo (proporcional aos meses trabalhados)            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Criterios de Aceitacao

### CA-001: Regra SPIFF

- [ ] Sistema permite criar regra do tipo SPIFF
- [ ] Sistema exige: produto alvo, valor bonus, periodo vigencia
- [ ] Sistema valida que periodo fim > periodo inicio
- [ ] Sistema calcula bonus adicional quando venda corresponde ao criterio
- [ ] Sistema permite SPIFF cumulativo com comissao normal

### CA-002: Regra Acelerador

- [ ] Sistema permite criar regra do tipo ACELERADOR
- [ ] Sistema permite definir faixas de atingimento (min%, max%, multiplicador)
- [ ] Sistema permite ate 10 faixas por regra
- [ ] Sistema aplica multiplicador sobre comissao base
- [ ] Sistema usa faixa mais alta quando atingimento supera todas

### CA-003: Regra Override

- [ ] Sistema permite criar regra do tipo OVERRIDE
- [ ] Sistema exige: nivel hierarquico, percentual
- [ ] Sistema permite ate 3 niveis de profundidade
- [ ] Sistema identifica automaticamente equipe do gestor
- [ ] Sistema soma vendas da equipe para calculo

### CA-004: Regra Split

- [ ] Sistema permite criar regra do tipo SPLIT
- [ ] Sistema permite 2 a 5 participantes por split
- [ ] Sistema valida que soma percentuais = 100%
- [ ] Sistema identifica papel de cada participante (captacao, fechamento, etc.)
- [ ] Sistema divide comissao conforme percentuais definidos

### CA-005: Regra Escalonada

- [ ] Sistema permite criar regra do tipo ESCALONADA
- [ ] Sistema permite definir faixas de valor (de, ate, percentual)
- [ ] Sistema permite ate 10 faixas por regra
- [ ] Sistema aplica percentual da faixa correspondente ao volume
- [ ] Sistema pode usar calculo progressivo ou fixo por faixa

### CA-006: Regra PLR

- [ ] Sistema permite criar regra do tipo PLR
- [ ] Sistema permite definir formula complexa com multiplas variaveis
- [ ] Sistema suporta periodo trimestral ou anual
- [ ] Sistema calcula proporcional ao tempo de empresa
- [ ] Sistema permite pesos diferentes por cargo/nivel

### CA-007: Combinacao de Regras

- [ ] Sistema permite que multiplas regras se apliquem a mesma venda
- [ ] Sistema define ordem de precedencia entre regras
- [ ] Sistema calcula cada regra independentemente
- [ ] Sistema consolida resultados em demonstrativo unico

---

## Mockups

### Tela: Cadastro SPIFF

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  CADASTRO DE REGRA SPIFF                                         [Salvar] [Cancelar]│
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  DADOS BASICOS                                                                      │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Codigo*: [REG-SPIFF-001  ]   Nome*: [Campanha Platinum Janeiro         ]   │   │
│  │ Tipo: SPIFF (fixo)           Modulo*: [CRM-FIN ▼]                          │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  CRITERIOS DO SPIFF                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Produto/Plano Alvo*: [Plano Platinum ▼]                                    │   │
│  │                                                                             │   │
│  │ Tipo de Bonus*: (•) Valor Fixo  ( ) Percentual Adicional                   │   │
│  │ Valor do Bonus*: [R$ 50,00    ]                                            │   │
│  │                                                                             │   │
│  │ [ ] Limite maximo de bonus por consultor: [____] vendas                    │   │
│  │ [ ] Acumula com comissao normal                                            │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  PERIODO DA CAMPANHA                                                                │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Inicio*: [01/01/2026]        Fim*: [31/01/2026]                            │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### Tela: Cadastro Acelerador

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  CADASTRO DE REGRA ACELERADOR                                    [Salvar] [Cancelar]│
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  DADOS BASICOS                                                                      │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Codigo*: [REG-ACEL-001   ]   Nome*: [Acelerador Meta Mensal            ]   │   │
│  │ Tipo: ACELERADOR (fixo)      Modulo*: [CRM-FIN ▼]                          │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  FAIXAS DE ATINGIMENTO                                            [+ Adicionar]    │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ # │ De (%)  │ Ate (%) │ Multiplicador │ Acoes                              │   │
│  ├─────────────────────────────────────────────────────────────────────────────┤   │
│  │ 1 │ 0       │ 79      │ 0.8x          │ [Editar] [Excluir]                 │   │
│  │ 2 │ 80      │ 99      │ 1.0x          │ [Editar] [Excluir]                 │   │
│  │ 3 │ 100     │ 119     │ 1.2x          │ [Editar] [Excluir]                 │   │
│  │ 4 │ 120     │ ∞       │ 1.5x          │ [Editar] [Excluir]                 │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  APLICACAO                                                                          │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Aplica sobre: (•) Comissao Base  ( ) Comissao Total  ( ) Valor Fixo        │   │
│  │ Meta referencia: [Meta Individual Mensal ▼]                                │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### Tela: Cadastro Override

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  CADASTRO DE REGRA OVERRIDE                                      [Salvar] [Cancelar]│
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  DADOS BASICOS                                                                      │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Codigo*: [REG-OVER-001   ]   Nome*: [Override Gerente Regional         ]   │   │
│  │ Tipo: OVERRIDE (fixo)        Modulo*: [CRM-FIN ▼]                          │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  NIVEIS DE OVERRIDE                                               [+ Adicionar]    │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Nivel │ Cargo/Funcao      │ Percentual │ Base de Calculo │ Acoes           │   │
│  ├─────────────────────────────────────────────────────────────────────────────┤   │
│  │ 1     │ Gerente           │ 3.0%       │ Vendas Equipe   │ [Editar]        │   │
│  │ 2     │ Coordenador       │ 1.0%       │ Vendas Nivel 1  │ [Editar]        │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  CONFIGURACOES                                                                      │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ [ ] Inclui vendas proprias do gestor na base                               │   │
│  │ [ ] Aplica apenas se equipe atingir meta                                   │   │
│  │ [ ] Limite maximo de override: R$ [________]                               │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### Tela: Cadastro Split

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  CADASTRO DE REGRA SPLIT                                         [Salvar] [Cancelar]│
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  DADOS BASICOS                                                                      │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Codigo*: [REG-SPLIT-001  ]   Nome*: [Split Captacao/Fechamento         ]   │   │
│  │ Tipo: SPLIT (fixo)           Modulo*: [CRM-FIN ▼]                          │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  PARTICIPANTES DO SPLIT                                           [+ Adicionar]    │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ # │ Papel             │ Percentual │ Acoes                                 │   │
│  ├─────────────────────────────────────────────────────────────────────────────┤   │
│  │ 1 │ Captacao (Lead)   │ 40%        │ [Editar] [Excluir]                    │   │
│  │ 2 │ Fechamento        │ 60%        │ [Editar] [Excluir]                    │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  Total: 100%  [Status: OK]                                                         │
│                                                                                     │
│  REGRAS ADICIONAIS                                                                  │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ [ ] Permite mesmo consultor em multiplos papeis                            │   │
│  │ [ ] Exige aprovacao do gestor para splits                                  │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

---

## Regras de Negocio

| Codigo | Regra | Validacao |
|--------|-------|-----------|
| RN-MTR-011 | SPIFF periodo valido | Data fim deve ser maior que data inicio |
| RN-MTR-012 | Acelerador faixas continuas | Nao pode haver gaps entre faixas |
| RN-MTR-013 | Override niveis limitados | Maximo 3 niveis de profundidade |
| RN-MTR-014 | Split soma 100% | Soma dos percentuais deve ser exatamente 100% |
| RN-MTR-015 | Split minimo 2 | Minimo 2 participantes por split |
| RN-MTR-016 | Escalonada faixas ordenadas | Faixas devem estar em ordem crescente |
| RN-MTR-017 | PLR proporcional | Calculo considera tempo de empresa |
| RN-MTR-018 | Combinacao permitida | Multiplas regras podem se aplicar a mesma venda |

---

## Modelo de Dados Adicional

### Tabelas Especificas

```sql
-- Faixas para Acelerador e Escalonada
CREATE TABLE mtr_faixa (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    regra_id UUID NOT NULL REFERENCES mtr_regra(id) ON DELETE CASCADE,
    ordem INTEGER NOT NULL,
    valor_minimo DECIMAL(15,2) NOT NULL,
    valor_maximo DECIMAL(15,2),
    resultado DECIMAL(15,4) NOT NULL, -- multiplicador ou percentual
    UNIQUE(regra_id, ordem)
);

-- Niveis para Override
CREATE TABLE mtr_override_nivel (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    regra_id UUID NOT NULL REFERENCES mtr_regra(id) ON DELETE CASCADE,
    nivel INTEGER NOT NULL,
    cargo_funcao VARCHAR(50),
    percentual DECIMAL(5,4) NOT NULL,
    base_calculo VARCHAR(50) NOT NULL,
    UNIQUE(regra_id, nivel)
);

-- Participantes para Split
CREATE TABLE mtr_split_participante (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    regra_id UUID NOT NULL REFERENCES mtr_regra(id) ON DELETE CASCADE,
    papel VARCHAR(50) NOT NULL,
    percentual DECIMAL(5,4) NOT NULL,
    ordem INTEGER NOT NULL,
    UNIQUE(regra_id, ordem)
);

-- Configuracoes SPIFF
CREATE TABLE mtr_spiff_config (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    regra_id UUID NOT NULL REFERENCES mtr_regra(id) ON DELETE CASCADE,
    produto_id UUID,
    tipo_bonus VARCHAR(20) NOT NULL, -- FIXO, PERCENTUAL
    valor_bonus DECIMAL(15,2) NOT NULL,
    limite_por_consultor INTEGER,
    acumula_comissao BOOLEAN DEFAULT TRUE,
    UNIQUE(regra_id)
);
```

---

## Cenarios de Teste

### CT-001: Criar SPIFF

```gherkin
Dado que estou na tela de cadastro de regra
Quando seleciono tipo SPIFF
E preencho produto "Plano Platinum"
E preencho valor bonus "R$ 50,00"
E defino periodo "01/01/2026" a "31/01/2026"
E clico em Salvar
Entao regra SPIFF e criada com sucesso
```

### CT-002: Calcular Acelerador

```gherkin
Dado que existe regra acelerador com faixas
E consultor atingiu 115% da meta
Quando sistema calcula comissao
Entao aplica multiplicador 1.2x (faixa 100-119%)
E comissao final = comissao_base × 1.2
```

### CT-003: Calcular Override

```gherkin
Dado que gerente tem equipe de 5 consultores
E equipe vendeu R$ 100.000 no mes
E regra override define 3% nivel 1
Quando sistema calcula override
Entao gerente recebe R$ 3.000 de override
```

### CT-004: Validar Split

```gherkin
Dado que estou cadastrando split
Quando adiciono participante 1 com 40%
E adiciono participante 2 com 50%
Entao sistema exibe "Total: 90% - Faltam 10%"
E botao Salvar permanece desabilitado
```

---

## Dependencias

- **Depende de**: US-CRM-MTR-001 (Regras Basicas)
- **Dependentes**: US-CRM-MTR-005 (Simulacao)

---

## Estimativa

| Componente | Story Points |
|------------|-------------|
| Backend: SPIFF | 8 |
| Backend: Acelerador | 8 |
| Backend: Override | 13 |
| Backend: Split | 8 |
| Backend: Escalonada | 5 |
| Backend: PLR | 8 |
| Frontend: Telas especificas | 5 |
| **TOTAL** | **55** |

---

## Historico de Alteracoes

| Versao | Data | Autor | Alteracao |
|--------|------|-------|-----------|
| 1.0 | 29/01/2026 | PO | Criacao inicial |
