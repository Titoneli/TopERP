# US-CRM-MTR-005: Simulacao e Teste de Regras

> **Modulo**: CRM-Motor-Regras  
> **Versao**: 1.0  
> **Data**: 29/01/2026  
> **Status**: Pronto para Desenvolvimento  
> **Story Points**: 21

---

## Historia de Usuario

**Como** gestor do sistema,  
**Quero** simular e testar regras antes de ativa-las,  
**Para** garantir que os calculos estao corretos e evitar erros em producao.

---

## Descricao

Esta historia implementa funcionalidades de simulacao e teste de regras. Permite que o usuario execute calculos com dados fictícios ou reais, compare resultados e valide a logica antes de colocar a regra em producao.

---

## Criterios de Aceitacao

### CA-001: Simulacao Basica

- [ ] Sistema permite simular regra em status RASCUNHO ou ATIVA
- [ ] Sistema solicita valores para todas as variaveis de entrada
- [ ] Sistema executa formula e exibe resultado
- [ ] Sistema nao registra simulacao como execucao real

### CA-002: Detalhamento do Calculo

- [ ] Sistema exibe passo a passo do calculo
- [ ] Sistema mostra valor de cada variavel utilizada
- [ ] Sistema mostra resultado de cada operacao intermediaria
- [ ] Sistema mostra qual condicao foi atendida (quando aplicavel)

### CA-003: Cenarios de Teste

- [ ] Sistema permite salvar cenarios de teste
- [ ] Cenario tem nome, descricao e conjunto de valores de entrada
- [ ] Sistema permite executar todos os cenarios de uma vez
- [ ] Sistema exibe resultado de cada cenario (passou/falhou)

### CA-004: Resultado Esperado

- [ ] Sistema permite definir resultado esperado para cada cenario
- [ ] Sistema compara resultado calculado com esperado
- [ ] Sistema indica se teste passou ou falhou
- [ ] Sistema calcula percentual de testes que passaram

### CA-005: Comparacao de Versoes

- [ ] Sistema permite simular mesmos dados em duas versoes da regra
- [ ] Sistema exibe comparativo lado a lado
- [ ] Sistema destaca diferencas nos resultados
- [ ] Sistema ajuda a validar alteracoes antes de ativar nova versao

### CA-006: Dados Reais para Teste

- [ ] Sistema permite importar dados reais anonimizados
- [ ] Sistema permite selecionar vendas reais para simular
- [ ] Sistema compara resultado simulado com resultado real (se existir)
- [ ] Sistema nao altera dados reais durante simulacao

### CA-007: Validacao Pre-Ativacao

- [ ] Sistema exige pelo menos 1 teste antes de ativar regra
- [ ] Sistema exige que todos os cenarios passem antes de ativar
- [ ] Sistema registra resultados dos testes no historico
- [ ] Sistema permite ativar mesmo com falhas (com justificativa)

---

## Mockups

### Tela: Simulador de Regra

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  SIMULADOR DE REGRA - REG-COM-001                                          [X]     │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  VARIAVEIS DE ENTRADA                                                               │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ VALOR_VENDA*:    [R$ 500,00        ]                                       │   │
│  │ TIPO_PLANO*:     [PREMIUM ▼        ]                                       │   │
│  │ QTD_VENDAS_MES:  [15               ]  (meta: 10)                           │   │
│  │ SENIORIDADE:     [24               ]  meses                                │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│                                    [SIMULAR]                                        │
│                                                                                     │
│  ═══════════════════════════════════════════════════════════════════════════════   │
│                                                                                     │
│  RESULTADO DA SIMULACAO                                                             │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │                                                                             │   │
│  │  COMISSAO CALCULADA: R$ 72,00                                              │   │
│  │                                                                             │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  DETALHAMENTO DO CALCULO                                                            │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Passo │ Operacao                              │ Resultado                   │   │
│  ├─────────────────────────────────────────────────────────────────────────────┤   │
│  │ 1     │ Condicao: TIPO_PLANO = "PREMIUM"      │ VERDADEIRO                 │   │
│  │ 2     │ Comissao base: 500,00 × 8%            │ R$ 40,00                   │   │
│  │ 3     │ Bonus plano PREMIUM                    │ R$ 10,00                   │   │
│  │ 4     │ Subtotal                               │ R$ 50,00                   │   │
│  │ 5     │ Atingimento: 15/10 = 150%             │ Acelerador 1.2x            │   │
│  │ 6     │ Acelerador: 50,00 × 1.2               │ R$ 60,00                   │   │
│  │ 7     │ Bonus senioridade (24 meses)          │ R$ 12,00                   │   │
│  │ 8     │ TOTAL FINAL                           │ R$ 72,00                   │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  [Salvar como Cenario]  [Comparar com Versao Anterior]  [Exportar]                 │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### Tela: Gerenciar Cenarios de Teste

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  CENARIOS DE TESTE - REG-COM-001                                   [+ Novo Cenario]│
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  [Executar Todos]                                          Status: 3/4 passaram    │
│                                                                                     │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ # │ Nome                    │ Esperado  │ Calculado │ Status  │ Acoes       │   │
│  ├─────────────────────────────────────────────────────────────────────────────┤   │
│  │ 1 │ Venda Premium normal    │ R$ 40,00  │ R$ 40,00  │ ✓ OK    │ [▶] [✎] [🗑]│   │
│  │ 2 │ Venda Basico            │ R$ 25,00  │ R$ 25,00  │ ✓ OK    │ [▶] [✎] [🗑]│   │
│  │ 3 │ Venda com acelerador    │ R$ 72,00  │ R$ 72,00  │ ✓ OK    │ [▶] [✎] [🗑]│   │
│  │ 4 │ Meta nao atingida       │ R$ 32,00  │ R$ 40,00  │ ✗ FALHA │ [▶] [✎] [🗑]│   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  CENARIO COM FALHA - Detalhes:                                                      │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Cenario: Meta nao atingida                                                  │   │
│  │ Entradas: VALOR_VENDA=500, TIPO_PLANO=PREMIUM, QTD_VENDAS=8, META=10       │   │
│  │                                                                             │   │
│  │ Esperado: R$ 32,00 (com penalidade de 0.8x)                                │   │
│  │ Calculado: R$ 40,00                                                         │   │
│  │                                                                             │   │
│  │ Possivel causa: Acelerador nao esta aplicando penalidade abaixo de 80%     │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  [Aprovar para Ativacao]  (Requer: todos os cenarios passando)                     │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### Modal: Comparar Versoes

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  COMPARAR VERSOES - REG-COM-001                                            [X]     │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  Versao Atual: v3 (ATIVA)          Versao Nova: v4 (RASCUNHO)                      │
│                                                                                     │
│  ENTRADA DE TESTE                                                                   │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ VALOR_VENDA: R$ 500,00 | TIPO_PLANO: PREMIUM | QTD_VENDAS: 15              │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  COMPARATIVO                                                                        │
│  ┌────────────────────────────────┬────────────────────────────────┐               │
│  │         VERSAO 3 (ATIVA)       │       VERSAO 4 (RASCUNHO)      │               │
│  ├────────────────────────────────┼────────────────────────────────┤               │
│  │ Comissao base: R$ 40,00        │ Comissao base: R$ 40,00        │               │
│  │ Bonus plano: R$ 10,00          │ Bonus plano: R$ 15,00  (+5)    │ ← Diferente   │
│  │ Acelerador: 1.2x               │ Acelerador: 1.3x       (+0.1)  │ ← Diferente   │
│  │ TOTAL: R$ 60,00                │ TOTAL: R$ 71,50        (+11,50)│               │
│  └────────────────────────────────┴────────────────────────────────┘               │
│                                                                                     │
│  RESUMO: A nova versao paga R$ 11,50 a mais neste cenario (+19.2%)                 │
│                                                                                     │
│  [Testar outro cenario]  [Aprovar v4]  [Cancelar]                                  │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

---

## Regras de Negocio

| Codigo | Regra | Validacao |
|--------|-------|-----------|
| RN-MTR-040 | Simulacao nao registra | Simulacao nao cria registro em mtr_execucao |
| RN-MTR-041 | Teste obrigatorio | Regra precisa de pelo menos 1 cenario antes de ativar |
| RN-MTR-042 | Cenarios devem passar | Todos os cenarios devem passar para ativar |
| RN-MTR-043 | Bypass com justificativa | Permite ativar com falhas se houver justificativa |
| RN-MTR-044 | Historico de testes | Resultados dos testes sao arquivados |

---

## Modelo de Dados

```sql
-- Cenarios de Teste
CREATE TABLE mtr_cenario_teste (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    regra_id UUID NOT NULL REFERENCES mtr_regra(id) ON DELETE CASCADE,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    entradas_json JSONB NOT NULL,
    resultado_esperado DECIMAL(15,2),
    ativo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP NOT NULL DEFAULT NOW(),
    criado_por UUID NOT NULL
);

-- Execucoes de Teste
CREATE TABLE mtr_execucao_teste (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cenario_id UUID NOT NULL REFERENCES mtr_cenario_teste(id),
    regra_versao INTEGER NOT NULL,
    resultado_calculado DECIMAL(15,2),
    detalhamento_json JSONB,
    passou BOOLEAN,
    executado_em TIMESTAMP NOT NULL DEFAULT NOW(),
    executado_por UUID NOT NULL
);

-- Aprovacao para Ativacao
CREATE TABLE mtr_aprovacao_ativacao (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    regra_id UUID NOT NULL REFERENCES mtr_regra(id),
    versao INTEGER NOT NULL,
    total_cenarios INTEGER,
    cenarios_passaram INTEGER,
    aprovado BOOLEAN,
    justificativa TEXT, -- Se aprovado com falhas
    aprovado_em TIMESTAMP NOT NULL DEFAULT NOW(),
    aprovado_por UUID NOT NULL
);
```

---

## Cenarios de Teste

### CT-001: Simular Regra

```gherkin
Dado que tenho regra REG-COM-001 em rascunho
Quando acesso o simulador
E preencho VALOR_VENDA = 500, TIPO_PLANO = "PREMIUM"
E clico em Simular
Entao sistema exibe resultado calculado
E sistema exibe detalhamento passo a passo
E nenhum registro e criado em mtr_execucao
```

### CT-002: Criar Cenario de Teste

```gherkin
Dado que executei simulacao com sucesso
Quando clico em "Salvar como Cenario"
E preencho nome "Venda Premium normal"
E defino resultado esperado "R$ 40,00"
E clico em Salvar
Entao cenario e criado e associado a regra
```

### CT-003: Executar Todos os Cenarios

```gherkin
Dado que regra tem 4 cenarios de teste
Quando clico em "Executar Todos"
Entao sistema executa cada cenario
E sistema compara resultado com esperado
E sistema exibe status (passou/falhou) para cada um
```

---

## Dependencias

- **Depende de**: US-CRM-MTR-001 (estrutura de regras)
- **Dependentes**: Processo de ativacao de regras

---

## Estimativa

| Componente | Story Points |
|------------|-------------|
| Backend: Motor de simulacao | 5 |
| Backend: Cenarios de teste | 5 |
| Backend: Comparador versoes | 3 |
| Frontend: Simulador | 5 |
| Frontend: Tela cenarios | 3 |
| **TOTAL** | **21** |

---

## Historico de Alteracoes

| Versao | Data | Autor | Alteracao |
|--------|------|-------|-----------|
| 1.0 | 29/01/2026 | PO | Criacao inicial |
