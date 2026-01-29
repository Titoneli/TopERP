# Motor de Regras - Visao do Produto

> **Documento de Visao Acessivel**  
> Este documento explica o Motor de Regras de forma simples e acessivel,  
> para que qualquer pessoa possa entender como funciona.

---

## O que e o Motor de Regras?

Imagine uma **calculadora inteligente** que sabe fazer contas diferentes dependendo da situacao. Em vez de programar cada calculo no sistema, voce **configura regras** que dizem:

- **SE** acontecer isso...
- **ENTAO** faca aquele calculo...
- **E** execute tal acao.

---

## Para que Serve?

O Motor de Regras e como um **cerebro compartilhado** que varios modulos do sistema usam:

```
┌─────────────────────────────────────────────────────────────────┐
│                    MOTOR DE REGRAS                              │
│              (Calculadora Inteligente)                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   Quem usa o Motor?                                             │
│                                                                 │
│   FINANCEIRO (CRM-FIN)                                          │
│   └─ Calcular comissoes, residuais, bonificacoes               │
│                                                                 │
│   COTACOES (CRM-COT)                                            │
│   └─ Calcular descontos, precos especiais                      │
│                                                                 │
│   LEADS (CRM-LEAD)                                              │
│   └─ Dar nota para leads, priorizar atendimento                │
│                                                                 │
│   POS-VENDA (CRM-POS)                                           │
│   └─ Calcular bonus de satisfacao do associado                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Parte 1: Criando uma Regra Simples

### O Conceito

Uma regra tem 4 partes:

1. **VARIAVEIS** - Os dados que voce precisa (valor da venda, tipo do plano, etc.)
2. **CONDICOES** - Quando a regra deve ser aplicada (SE plano = Premium...)
3. **FORMULA** - O calculo a ser feito (valor x 8%)
4. **ACOES** - O que fazer com o resultado (creditar na conta)

### Exemplo Pratico: Comissao de Venda

Joao vendeu um plano Premium por R$ 500,00. Quanto ele ganha de comissao?

**Regra configurada:**

```
┌─────────────────────────────────────────────────────────────────┐
│  REGRA: REG-COM-PREMIUM-001                                     │
│  Nome: Comissao Plano Premium                                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  VARIAVEIS:                                                     │
│  ├─ VALOR_VENDA: quanto o associado pagou                      │
│  ├─ TIPO_PLANO: qual plano foi vendido                         │
│  └─ PERC_COMISSAO: 8% (para Premium)                           │
│                                                                 │
│  CONDICAO:                                                      │
│  └─ SE tipo_plano = "PREMIUM"                                  │
│                                                                 │
│  FORMULA:                                                       │
│  └─ comissao = valor_venda × perc_comissao                     │
│                                                                 │
│  ACAO:                                                          │
│  └─ Creditar resultado na conta do consultor                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Calculo:**
- Valor da venda: R$ 500,00
- Percentual: 8%
- Comissao = R$ 500,00 x 8% = **R$ 40,00**

Joao recebe R$ 40,00 de comissao!

---

## Parte 2: Regras com Condicoes

### Comissao Diferente por Plano

Cada plano pode ter percentual diferente:

```
┌─────────────────────────────────────────────────────────────────┐
│  TABELA DE COMISSOES POR PLANO                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Plano Basico      →  5% de comissao                           │
│  Plano Ouro        →  6% de comissao                           │
│  Plano Premium     →  8% de comissao                           │
│  Plano Platinum    → 10% de comissao                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

O Motor escolhe automaticamente o percentual certo baseado no plano vendido.

### Exemplo com Multiplas Condicoes

```
SE:
  - Plano = Premium
  - E Regiao = Sul
  - E Mes = Dezembro (campanha de fim de ano)
  
ENTAO:
  - Comissao = 12% (ao inves de 8%)
```

---

## Parte 3: Bonus e Metas

### Bonificacao por Meta

Maria tem meta de 10 vendas no mes. Se ela bater, ganha bonus!

```
┌─────────────────────────────────────────────────────────────────┐
│  REGRA DE BONIFICACAO                                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  SE vendas_no_mes >= meta_mensal                                │
│  ENTAO bonus = R$ 500,00                                        │
│                                                                 │
│  EXEMPLO:                                                       │
│  - Maria vendeu 12 (meta era 10)                                │
│  - Meta batida! Bonus de R$ 500,00                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Aceleradores (Multiplicadores)

Quanto mais vende, mais ganha! O percentual aumenta:

```
┌─────────────────────────────────────────────────────────────────┐
│  ACELERADOR PROGRESSIVO                                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Atingimento da Meta    →   Multiplicador                       │
│                                                                 │
│  Menos de 80%           →   0.8x (penalidade)                   │
│  80% a 99%              →   1.0x (normal)                       │
│  100% a 119%            →   1.2x (bonus)                        │
│  120% ou mais           →   1.5x (super bonus)                  │
│                                                                 │
│  EXEMPLO:                                                       │
│  - Maria atingiu 120% da meta                                   │
│  - Comissao base: R$ 100,00                                     │
│  - Com acelerador: R$ 100,00 × 1.5 = R$ 150,00                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Parte 4: Residuais (Mensalidades)

### O que sao Residuais?

Alem da comissao na venda, o consultor pode ganhar **todo mes** enquanto o associado continuar pagando. Isso se chama **Residual**.

### Calculo por Placas Ativas

O residual e calculado pela **quantidade de placas/veiculos** que o consultor tem na carteira:

```
┌─────────────────────────────────────────────────────────────────┐
│  CALCULO DE RESIDUAL                                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Carlos tem 50 placas ativas na carteira                        │
│  Valor por placa: R$ 2,00                                       │
│                                                                 │
│  Residual mensal = 50 placas × R$ 2,00 = R$ 100,00              │
│                                                                 │
│  IMPORTANTE:                                                    │
│  - Calculo e por QUANTIDADE de placas                           │
│  - NAO e percentual sobre valor da mensalidade                  │
│  - Placa inativa = nao conta                                    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Parte 5: Regras Avancadas

### SPIFF - Incentivo Pontual

Bonus extra por vender produto especifico em periodo limitado:

```
┌─────────────────────────────────────────────────────────────────┐
│  CAMPANHA PERIODO                                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  "Venda o Plano Platinum em Janeiro e ganhe +R$ 50 por venda"   │
│                                                                 │
│  Periodo: 01/01 a 31/01                                         │
│  Produto: Plano Platinum                                        │
│  Bonus: R$ 50,00 por venda                                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Override - Comissao do Gerente

O gerente ganha um percentual sobre as vendas da equipe:

```
┌─────────────────────────────────────────────────────────────────┐
│  COMISSAO SOBRE EQUIPE                                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Paulo e gerente de 5 consultores                               │
│  Sua equipe vendeu R$ 50.000 no mes                             │
│  Override do gerente: 2%                                        │
│                                                                 │
│  Ganho de Paulo = R$ 50.000 × 2% = R$ 1.000,00                  │
│                                                                 │
│  (Paulo ganha ALEM do que ele mesmo vendeu)                     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Split - Divisao de Comissao

Quando dois consultores fazem uma venda juntos:

```
┌─────────────────────────────────────────────────────────────────┐
│  DIVISÃO DE COMISSAO                                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Ana captou o lead, Bruno fechou a venda                        │
│  Comissao total: R$ 100,00                                      │
│  Divisão: 40% captacao, 60% fechamento                          │
│                                                                 │
│  Ana recebe: R$ 40,00                                           │
│  Bruno recebe: R$ 60,00                                         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Comissao Escalonada

Percentual aumenta conforme volume de vendas:

```
┌─────────────────────────────────────────────────────────────────┐
│  COMISSAO ESCALONADA                                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Volume de Vendas        →    Percentual                        │
│                                                                 │
│  Ate 5 placas            →    5%                                │
│  6 a R$ 10               →    7%                                │
│  11 a 20                 →    9%                                │
│  Acima de 20             →   12%                                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Parte 6: Templates (Modelos Prontos)

### O que sao Templates?

Sao **regras pre-configuradas** que facilitam a criacao de novas regras. E como ter formularios prontos para preencher.

### Templates Disponiveis

```
┌─────────────────────────────────────────────────────────────────┐
│  TEMPLATES PRE-CONFIGURADOS                                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. Comissao Simples                                            │
│     └─ Percentual fixo sobre valor da venda                     │
│                                                                 │
│  2. Comissao por Faixa                                          │
│     └─ Percentual varia conforme volume                         │
│                                                                 │
│  3. Bonus por Meta                                              │
│     └─ Valor fixo ao atingir meta                               │
│                                                                 │
│  4. Campanhas                                                   │
│     └─ Bonus por produto/periodo                                │
│                                                                 │
│  5. Equipes.                                                    │
│     └─ Percentual sobre vendas da equipe                        │
│                                                                 │
│  6. Residual por Placa                                          │
│     └─ Valor fixo por placa ativa                               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Como Usar um Template

1. Escolha o template que mais se parece com o que voce precisa
2. Ajuste os valores (percentuais, faixas, etc.)
3. Teste com simulacao
4. Ative a regra

---

## Parte 7: Editor Visual (Arrastar e Soltar)

### Interface Simplificada

Para quem nao e tecnico, o Motor oferece um **editor visual** onde voce monta a regra arrastando blocos:

```
┌─────────────────────────────────────────────────────────────────┐
│  EDITOR VISUAL DE REGRAS                                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐                                                │
│  │  VARIAVEL   │  ←── Arraste para adicionar                   │
│  │ Valor Venda │                                                │
│  └─────────────┘                                                │
│         │                                                       │
│         ▼                                                       │
│  ┌─────────────┐                                                │
│  │  CONDICAO   │                                                │
│  │ Plano = X   │                                                │
│  └─────────────┘                                                │
│         │                                                       │
│         ▼                                                       │
│  ┌─────────────┐                                                │
│  │  FORMULA    │                                                │
│  │ Valor × 8%  │                                                │
│  └─────────────┘                                                │
│         │                                                       │
│         ▼                                                       │
│  ┌─────────────┐                                                │
│  │   ACAO      │                                                │
│  │  Creditar   │                                                │
│  └─────────────┘                                                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Parte 8: Simulacao e Teste

### Antes de Ativar, Teste!

O Motor permite **simular** o calculo antes de ativar a regra de verdade:

```
┌─────────────────────────────────────────────────────────────────┐
│  SIMULADOR DE REGRAS                                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  "Quanto o consultor ganharia se..."                            │
│                                                                 │
│  Digite os valores:                                             │
│  ├─ Valor da venda: R$ 500,00                                   │
│  ├─ Tipo de plano: Ouro                                         │
│  ├─ Vendas no mes: 15                                           │
│  └─ Meta: 10                                                    │
│                                                                 │
│  [SIMULAR]                                                      │
│                                                                 │
│  RESULTADO:                                                     │
│  ├─ Comissao base: R$ 40,00                                     │
│  ├─ Acelerador (150%): × 1.2                                    │
│  ├─ Subtotal: R$ 48,00                                          │
│  ├─ Bonus meta: R$ 500,00                                       │
│  └─ TOTAL: R$ 548,00                                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Parte 9: Versionamento e Auditoria

### Historico Completo

Toda alteracao em regra fica registrada:

```
┌─────────────────────────────────────────────────────────────────┐
│  HISTORICO DA REGRA REG-COM-001                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Versao 3 (ATIVA) - 15/01/2026                                  │
│  └─ Alterado percentual de 7% para 8%                           │
│  └─ Aprovado por: Gerente Financeiro                            │
│                                                                 │
│  Versao 2 - 01/12/2025                                          │
│  └─ Adicionado bonus por plano Ouro                             │
│                                                                 │
│  Versao 1 - 01/01/2025                                          │
│  └─ Criacao inicial                                             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Rastreabilidade de Calculos

Cada calculo feito pelo Motor fica registrado:

```
┌─────────────────────────────────────────────────────────────────┐
│  LOG DE EXECUCAO                                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Execucao #12345                                                │
│  Data: 29/01/2026 14:35:22                                      │
│  Regra: REG-COM-001 (versao 3)                                  │
│                                                                 │
│  Entrada:                                                       │
│  ├─ valor_venda: 500.00                                         │
│  ├─ tipo_plano: OURO                                            │
│  └─ qtd_vendas: 15                                              │
│                                                                 │
│  Saida:                                                         │
│  └─ comissao: 48.00                                             │
│                                                                 │
│  Contexto:                                                      │
│  ├─ venda_id: id-123                                          │
│  └─ consultor_id: id-456                                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Parte 10: Perguntas Frequentes

### Por que usar o Motor de Regras?

**Sem Motor:**
- Cada calculo e programado no codigo
- Alterar percentual = chamar desenvolvedor
- Dificil rastrear como foi calculado

**Com Motor:**
- Regras configuraveis pela equipe de negocios
- Alterar percentual = editar regra na tela
- Rastreabilidade total de cada calculo

### Quem pode criar/editar regras?

- **Criar**: Gestores com permissao
- **Ativar**: Requer aprovacao
- **Visualizar**: Todos podem ver regras ativas

### E se uma regra der errado?

1. Desative a regra com problema
2. Corrija e crie nova versao
3. Ou volte para versao anterior (rollback)
4. Todo historico fica preservado

### Posso testar antes de ativar?

Sim! O simulador permite testar com dados reais ou fictícios antes de colocar a regra em producao.

---

## Glossario

| Termo | Significado |
|-------|-------------|
| **Regra** | Conjunto de condicoes e formulas para calcular algo |
| **Variavel** | Dado de entrada (valor venda, tipo plano, etc.) |
| **Condicao** | Criterio para aplicar a regra (SE isso ENTAO aquilo) |
| **Formula** | Expressao matematica do calculo |
| **Acao** | O que fazer com o resultado (creditar, notificar, etc.) |
| **Template** | Modelo pre-configurado de regra |
| **Versao** | Numero que identifica alteracoes na regra |
| **Simulacao** | Teste do calculo sem efeito real |
| **SPIFF** | Bonus pontual por produto/periodo |
| **Override** | Comissao do gestor sobre vendas da equipe |
| **Split** | Divisao de comissao entre consultores |
| **Acelerador** | Multiplicador progressivo por meta |

---

## Referencias

- [README.md](README.md) - Especificacao tecnica completa
- [US-CRM-MTR-001.md](US-CRM-MTR-001.md) - Historia: Regras Basicas
- [US-CRM-MTR-002.md](US-CRM-MTR-002.md) - Historia: Regras Avancadas

---

**Versao**: 1.0  
**Data**: 29/01/2026  
**Autor**: Product Owner
