# Especificacao DSL - Motor de Regras v2.0

> **Documento**: Domain Specific Language (DSL) para Motor de Regras  
> **Versao**: 2.0  
> **Data**: 29/01/2026  
> **Autor**: Product Owner

---

## 1. Visao Geral

### 1.1 O que e a DSL?

A DSL (Domain Specific Language) do Motor de Regras e uma linguagem de alto nivel projetada para permitir que usuarios de negocio (nao-tecnicos) possam criar e manter regras de forma intuitiva, sem necessidade de conhecimentos de programacao.

### 1.2 Formatos Suportados

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                         FORMATOS DE DEFINICAO DE REGRAS                         │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────────┐                                                        │
│  │   EDITOR VISUAL     │  Para usuarios de negocio                              │
│  │   (Drag & Drop)     │  - Interface grafica                                   │
│  └──────────┬──────────┘  - Arrastar blocos                                     │
│             │                                                                   │
│             ▼                                                                   │
│  ┌─────────────────────┐                                                        │
│  │   DSL TEXTUAL       │  Para usuarios avancados                               │
│  │   (Linguagem)       │  - Sintaxe legivel                                     │
│  └──────────┬──────────┘  - Mais controle                                       │
│             │                                                                   │
│             ▼                                                                   │
│  ┌─────────────────────┐                                                        │
│  │   JSON ESTRUTURADO  │  Para integracao / API                                 │
│  │   (Schema v2.0)     │  - Formato tecnico                                     │
│  └──────────┬──────────┘  - Validacao automatica                                │
│             │                                                                   │
│             ▼                                                                   │
│  ┌─────────────────────┐                                                        │
│  │   AST (Abstract     │  Representacao interna                                 │
│  │   Syntax Tree)      │  - Execucao pelo motor                                 │
│  └─────────────────────┘                                                        │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. DSL Textual - Sintaxe

### 2.1 Estrutura Basica

```dsl
REGRA "Nome da Regra"
  CODIGO: REG-XXX-001
  CATEGORIA: COMISSAO | RESIDUAL | BONUS | DESCONTO | SCORE | PREMIACAO
  DESCRICAO: "Descricao detalhada da regra"
  
  ESCOPO: GLOBAL | CONSULTOR(@ids) | EQUIPE(@ids) | FILIAL(@ids)
  VIGENCIA: AAAA-MM-DD ATE AAAA-MM-DD | INDEFINIDO

  -- Secao de Variaveis
  VARIAVEIS:
    nome_variavel := <expressao>

  -- Secao de Condicoes
  QUANDO:
    <condicao1>
    E <condicao2>
    OU <condicao3>

  -- Secao de Acoes
  ENTAO:
    <acao1>
    <acao2>

FIM_REGRA
```

### 2.2 Tipos de Variaveis

#### 2.2.1 Constantes

```dsl
VARIAVEIS:
  percentual := 0.08
  valor_bonus := 800
  limite_maximo := 5000
  descricao := "Texto fixo"
  ativo := VERDADEIRO
```

#### 2.2.2 Inputs (Parametros de Entrada)

```dsl
VARIAVEIS:
  valor_venda := ENTRADA(DECIMAL, obrigatorio)
  tipo_plano := ENTRADA(TEXTO, obrigatorio)
  data_venda := ENTRADA(DATA, opcional, padrao: HOJE)
  indicado := ENTRADA(BOOLEANO, padrao: FALSO)
```

#### 2.2.3 Agregacoes de Data Providers

```dsl
VARIAVEIS:
  -- Contar registros
  qtd_placas := CONTAR(PLACA) 
    ONDE consultor_id = @consultor_atual
      E data_fechamento ENTRE @periodo_inicio E @periodo_fim
      E status = 'FECHADA'
  
  -- Somar valores
  total_vendas := SOMAR(PLACA.valor_plano) 
    ONDE consultor_id = @consultor_atual
      E mes = @mes_atual
  
  -- Media
  ticket_medio := MEDIA(VENDA.valor) 
    ONDE consultor_id = @consultor_atual
  
  -- Primeiro/Ultimo
  meta_mes := PRIMEIRO(META.meta_placas) 
    ONDE consultor_id = @consultor_atual
      E ano = @ano_atual
      E mes = @mes_atual
  
  -- Minimo/Maximo
  menor_venda := MINIMO(VENDA.valor) ONDE ...
  maior_venda := MAXIMO(VENDA.valor) ONDE ...
  
  -- Moda (valor mais frequente)
  plano_mais_vendido := MODA(PLACA.tipo_plano) ONDE ...
```

#### 2.2.4 Formulas Calculadas

```dsl
VARIAVEIS:
  -- Aritmeticas
  comissao := valor_venda * percentual
  bonus := (qtd_placas - meta) * valor_unitario
  
  -- Com funcoes
  faixas := ARREDONDAR_BAIXO(percentual_acima / 10)
  valor_final := ARREDONDAR(comissao, 2)
  absoluto := ABSOLUTO(diferenca)
  
  -- Condicionais (CASE WHEN)
  multiplicador := CASO
    QUANDO atingimento >= 120 ENTAO 1.5
    QUANDO atingimento >= 100 ENTAO 1.2
    QUANDO atingimento >= 80 ENTAO 1.0
    SENAO 0.8
  FIM
  
  -- Comparacoes
  maior_valor := MAIOR(valor_a, valor_b, valor_c)
  menor_valor := MENOR(valor_a, valor_b)
  
  -- Datas
  dias_sem_contato := DIAS_ENTRE(@hoje, ultimo_contato)
  mes_atual := EXTRAIR_MES(data_venda)
  ano_atual := EXTRAIR_ANO(data_venda)
```

#### 2.2.5 Lookups em Tabelas Auxiliares

```dsl
TABELAS:
  faixas_comissao:
    | min | max  | percentual |
    | 0   | 5    | 0.05       |
    | 6   | 10   | 0.07       |
    | 11  | 20   | 0.09       |
    | 21  | NULL | 0.12       |

VARIAVEIS:
  percentual_faixa := BUSCAR(faixas_comissao.percentual)
    ONDE qtd_vendas >= min E (max E NULO OU qtd_vendas <= max)
```

### 2.3 Operadores

#### 2.3.1 Comparacao

```dsl
-- Igualdade
tipo_plano = 'PREMIUM'
tipo_plano != 'BRONZE'
tipo_plano <> 'BRONZE'

-- Numericos
valor > 1000
valor < 5000
valor >= 100
valor <= 500

-- Intervalo
valor ENTRE 1000 E 5000
data ENTRE '2026-01-01' E '2026-12-31'
data NAO_ENTRE @inicio E @fim

-- Listas
uf EM ('SP', 'RJ', 'MG')
uf NAO_EM ('AC', 'AP', 'RR')

-- Texto
nome CONTEM 'Silva'
email COMECA_COM 'admin'
telefone TERMINA_COM '0000'
nome COMO 'Jo%'

-- Nulos
gerente_id E NULO
gerente_id NAO_E NULO
```

#### 2.3.2 Logicos

```dsl
-- AND
tipo_plano = 'PREMIUM' E valor > 1000

-- OR
tipo_plano = 'PREMIUM' OU tipo_plano = 'OURO'

-- NOT
NAO (status = 'CANCELADO')

-- Agrupamento
(tipo_plano = 'PREMIUM' OU tipo_plano = 'OURO') E valor > 1000
```

### 2.4 Condicoes

```dsl
QUANDO:
  -- Condicao simples
  qtd_vendas > meta
  
  -- Multiplas condicoes (AND implicito)
  qtd_vendas > meta
  E tipo_plano = 'PREMIUM'
  E uf = 'SP'
  
  -- OR
  tipo_plano = 'PREMIUM'
  OU tipo_plano = 'PLATINUM'
  
  -- Grupos
  (tipo_plano = 'PREMIUM' OU tipo_plano = 'PLATINUM')
  E (uf = 'SP' OU uf = 'RJ')
  E valor > 1000
```

### 2.5 Acoes

```dsl
ENTAO:
  -- Adicionar valor a uma conta
  ADICIONAR comissao_final AO COMISSAO
  ADICIONAR bonus_meta AO BONUS
  ADICIONAR valor_residual AO RESIDUAL
  ADICIONAR premio AO PREMIACAO
  
  -- Com descricao
  ADICIONAR valor_bonus AO BONUS COM DESCRICAO "Bonus meta atingida"
  
  -- Adicionar para outro beneficiario
  ADICIONAR override PARA gerente_id AO OVERRIDE
  
  -- Condicional dentro de acao
  SE bonus_meta > 0 ENTAO
    ADICIONAR bonus_meta AO BONUS
  FIM
  
  -- Atualizar campo
  ATUALIZAR LEAD.score COM score_calculado
  ATUALIZAR LEAD.classificacao COM classificacao
  
  -- Notificar
  NOTIFICAR @consultor_atual USANDO TEMPLATE 'BONUS_ATINGIDO'
    COM valor = bonus_total, meta = meta_mes
  
  -- Criar tarefa
  CRIAR_TAREFA "Aprovar comissao especial"
    PARA @gerente_financeiro
    COM PRAZO 3 DIAS
    CONTEXTO venda_id = @venda_id
  
  -- Webhook
  CHAMAR_WEBHOOK "https://api.externa.com/notificar"
    COM DADOS {consultor: @consultor_id, valor: comissao}
```

---

## 3. Contexto e Variaveis do Sistema

### 3.1 Variaveis de Contexto (@)

```dsl
-- Usuario/Consultor
@consultor_atual      -- UUID do consultor da execucao
@usuario_atual        -- UUID do usuario logado
@gerente_atual        -- UUID do gerente do consultor

-- Periodo
@periodo_inicio       -- Data inicio do periodo de calculo
@periodo_fim          -- Data fim do periodo de calculo
@mes_atual            -- Mes corrente (1-12)
@ano_atual            -- Ano corrente (AAAA)

-- Datas
@hoje                 -- Data atual (DATE)
@agora                -- Data/hora atual (TIMESTAMP)

-- Entidades do Contexto
@venda_id             -- UUID da venda sendo processada
@associado_id         -- UUID do associado
@placa_id             -- UUID da placa/veiculo
```

### 3.2 Funcoes do Sistema

```dsl
-- Datas
HOJE()                -- Data atual
AGORA()               -- Timestamp atual
DIAS_ENTRE(d1, d2)    -- Diferenca em dias
MESES_ENTRE(d1, d2)   -- Diferenca em meses
EXTRAIR_DIA(data)     -- Dia do mes (1-31)
EXTRAIR_MES(data)     -- Mes (1-12)
EXTRAIR_ANO(data)     -- Ano (AAAA)
INICIO_MES(data)      -- Primeiro dia do mes
FIM_MES(data)         -- Ultimo dia do mes

-- Matematicas
ARREDONDAR(valor, casas)
ARREDONDAR_BAIXO(valor)    -- FLOOR
ARREDONDAR_CIMA(valor)     -- CEIL
ABSOLUTO(valor)            -- ABS
POTENCIA(base, exp)        -- POWER
RAIZ(valor)                -- SQRT
MAIOR(v1, v2, ...)         -- MAX
MENOR(v1, v2, ...)         -- MIN

-- Texto
CONCATENAR(t1, t2, ...)
MAIUSCULAS(texto)
MINUSCULAS(texto)
TAMANHO(texto)
SUBSTITUIR(texto, de, para)

-- Logicas
SE_NULO(valor, padrao)     -- COALESCE
SE(condicao, verdadeiro, falso)
```

---

## 4. Data Providers

### 4.1 Providers Disponiveis

```dsl
-- Placas/Contratos
PROVIDER PLACA:
  CAMPOS:
    id, consultor_id, associado_id, data_fechamento, valor_veiculo,
    tipo_veiculo, uf_veiculo, tipo_plano, valor_plano, status,
    mes_fechamento, ano_fechamento

-- Boletos
PROVIDER BOLETO:
  CAMPOS:
    id, consultor_id, associado_id, valor_nominal, valor_recebido,
    data_vencimento, data_pagamento, status

-- Metas
PROVIDER META:
  CAMPOS:
    consultor_id, ano, mes, meta_placas, meta_valor, meta_ativacoes

-- Consultores
PROVIDER CONSULTOR:
  CAMPOS:
    id, nome, email, data_admissao, gerente_id, equipe_id, 
    filial_id, regiao, status

-- Hierarquia
PROVIDER HIERARQUIA:
  CAMPOS:
    consultor_id, gerente_id, diretor_id, nivel

-- Leads
PROVIDER LEAD:
  CAMPOS:
    id, consultor_id, nome, valor_veiculo, uf, tipo_veiculo,
    origem, score, classificacao, ultimo_contato, status

-- Interacoes
PROVIDER INTERACAO:
  CAMPOS:
    id, lead_id, tipo, data, descricao

-- Rankings
PROVIDER RANKING:
  CAMPOS:
    consultor_id, mes, ano, tipo, posicao, pontuacao

-- Indicacoes
PROVIDER INDICACAO:
  CAMPOS:
    id, indicador_id, indicado_id, data, status
```

### 4.2 Registrando Novos Providers

```sql
INSERT INTO mtr_data_provider (codigo, nome, tipo, fonte, schema_json) VALUES
('SINISTRO', 'Sinistros', 'VIEW', 'vw_sinistros', '{
  "campos": [
    {"nome": "id", "tipo": "UUID"},
    {"nome": "associado_id", "tipo": "UUID"},
    {"nome": "data_ocorrencia", "tipo": "DATE"},
    {"nome": "tipo", "tipo": "STRING"},
    {"nome": "valor", "tipo": "DECIMAL"},
    {"nome": "status", "tipo": "STRING"}
  ]
}');
```

---

## 5. Exemplos Completos em DSL

### 5.1 Bonus SP Automovel

```dsl
REGRA "Bonus SP Automovel ate 50k"
  CODIGO: REG-BONUS-SP-AUTO-001
  CATEGORIA: BONIFICACAO
  DESCRICAO: "R$ 800 para cada 10% acima da meta em automoveis SP ate 50k"
  
  ESCOPO: CONSULTOR('550e8400-e29b-41d4-a716-446655440000')
  VIGENCIA: 2026-01-01 ATE 2026-12-31

  VARIAVEIS:
    placas_sp_auto_50k := CONTAR(PLACA)
      ONDE consultor_id = @consultor_atual
        E data_fechamento ENTRE @periodo_inicio E @periodo_fim
        E tipo_veiculo = 'AUTOMOVEL'
        E uf_veiculo = 'SP'
        E valor_veiculo < 50000
        E status = 'FECHADA'
    
    meta_mes := PRIMEIRO(META.meta_placas)
      ONDE consultor_id = @consultor_atual
        E ano = @ano_atual
        E mes = @mes_atual
    
    pct_acima_meta := MAIOR((placas_sp_auto_50k - meta_mes) / meta_mes * 100, 0)
    faixas_10_pct := ARREDONDAR_BAIXO(pct_acima_meta / 10)
    valor_bonus := faixas_10_pct * 800

  QUANDO:
    placas_sp_auto_50k > meta_mes
    E faixas_10_pct >= 1

  ENTAO:
    ADICIONAR valor_bonus AO BONUS 
      COM DESCRICAO "R$ 800 por faixa de 10% acima meta (SP Auto <50k)"
    
    NOTIFICAR @consultor_atual USANDO TEMPLATE 'BONUS_META_ATINGIDA'
      COM valor = valor_bonus, percentual = pct_acima_meta, faixas = faixas_10_pct

FIM_REGRA
```

### 5.2 Residual sobre Boletos

```dsl
REGRA "Residual 15% sobre Boletos acima de 100k"
  CODIGO: REG-RES-BOLETOS-001
  CATEGORIA: RESIDUAL
  DESCRICAO: "15% de residual extra quando boletos recebidos ultrapassam 100k no mes"
  
  ESCOPO: GLOBAL
  VIGENCIA: 2026-01-01 ATE INDEFINIDO

  VARIAVEIS:
    total_boletos := SOMAR(BOLETO.valor_recebido)
      ONDE consultor_id = @consultor_atual
        E data_pagamento ENTRE @periodo_inicio E @periodo_fim
        E status = 'PAGO'
    
    valor_residual := total_boletos * 0.15

  QUANDO:
    total_boletos > 100000

  ENTAO:
    ADICIONAR valor_residual AO RESIDUAL
      COM DESCRICAO "Residual 15% sobre boletos >100k"

FIM_REGRA
```

### 5.3 Score de Lead

```dsl
REGRA "Score Dinamico de Leads"
  CODIGO: REG-SCORE-LEAD-001
  CATEGORIA: SCORE
  DESCRICAO: "Calcula pontuacao de priorizacao de leads"
  
  ESCOPO: GLOBAL
  VIGENCIA: 2026-01-01 ATE INDEFINIDO

  VARIAVEIS:
    valor_veiculo := ENTRADA(DECIMAL, obrigatorio)
    uf_lead := ENTRADA(TEXTO, obrigatorio)
    lead_indicado := ENTRADA(BOOLEANO, padrao: FALSO)
    
    dias_sem_contato := DIAS_ENTRE(
      PRIMEIRO(LEAD.ultimo_contato) ONDE id = @lead_id, 
      @hoje
    )
    
    qtd_interacoes := CONTAR(INTERACAO)
      ONDE lead_id = @lead_id
    
    pontos_valor := ARREDONDAR_BAIXO(valor_veiculo / 10000)
    
    pontos_uf := CASO
      QUANDO uf_lead EM ('SP', 'RJ') ENTAO 20
      QUANDO uf_lead EM ('PR', 'SC', 'RS') ENTAO 15
      SENAO 5
    FIM
    
    pontos_tempo := MAIOR(-dias_sem_contato * 2, -50)
    pontos_interacoes := qtd_interacoes * 5
    pontos_indicacao := SE(lead_indicado, 25, 0)
    
    score_final := pontos_valor + pontos_uf + pontos_tempo + pontos_interacoes + pontos_indicacao
    
    classificacao := CASO
      QUANDO score_final >= 80 ENTAO 'HOT'
      QUANDO score_final >= 50 ENTAO 'WARM'
      QUANDO score_final >= 20 ENTAO 'COLD'
      SENAO 'FROZEN'
    FIM

  QUANDO:
    VERDADEIRO

  ENTAO:
    ATUALIZAR LEAD.score COM score_final
    ATUALIZAR LEAD.classificacao COM classificacao

FIM_REGRA
```

### 5.4 Comissao Escalonada

```dsl
REGRA "Comissao Escalonada Multi-Criterio"
  CODIGO: REG-COM-ESCALONADA-001
  CATEGORIA: COMISSAO
  DESCRICAO: "Comissao variavel por faixa, plano, antiguidade e regiao"
  
  ESCOPO: GLOBAL
  VIGENCIA: 2026-01-01 ATE INDEFINIDO

  TABELAS:
    faixas_comissao:
      | min | max  | percentual |
      | 0   | 5    | 0.05       |
      | 6   | 10   | 0.07       |
      | 11  | 20   | 0.09       |
      | 21  | NULL | 0.12       |
    
    multiplicador_plano:
      | plano    | mult |
      | BRONZE   | 1.0  |
      | PRATA    | 1.1  |
      | OURO     | 1.2  |
      | PLATINUM | 1.4  |
    
    ajuste_regional:
      | regiao | ajuste |
      | SP     | 1.00   |
      | RJ     | 0.95   |
      | MG     | 0.90   |
      | SUL    | 0.85   |
      | OUTROS | 0.80   |

  VARIAVEIS:
    qtd_vendas := CONTAR(PLACA)
      ONDE consultor_id = @consultor_atual
        E data_fechamento ENTRE @periodo_inicio E @periodo_fim
    
    valor_total := SOMAR(PLACA.valor_plano)
      ONDE consultor_id = @consultor_atual
        E data_fechamento ENTRE @periodo_inicio E @periodo_fim
    
    plano_principal := MODA(PLACA.tipo_plano)
      ONDE consultor_id = @consultor_atual
        E data_fechamento ENTRE @periodo_inicio E @periodo_fim
    
    meses_atuacao := MESES_ENTRE(
      PRIMEIRO(CONSULTOR.data_admissao) ONDE id = @consultor_atual,
      @hoje
    )
    
    regiao := PRIMEIRO(CONSULTOR.regiao) ONDE id = @consultor_atual
    
    pct_faixa := BUSCAR(faixas_comissao.percentual)
      ONDE qtd_vendas >= min E (max E NULO OU qtd_vendas <= max)
    
    mult_plano := BUSCAR(multiplicador_plano.mult)
      ONDE plano = plano_principal
    
    ajuste_reg := BUSCAR(ajuste_regional.ajuste)
      ONDE regiao = regiao
    
    bonus_antiguidade := CASO
      QUANDO meses_atuacao >= 24 ENTAO 0.02
      QUANDO meses_atuacao >= 12 ENTAO 0.01
      SENAO 0
    FIM
    
    comissao_base := valor_total * pct_faixa
    comissao_ajustada := comissao_base * mult_plano * ajuste_reg
    comissao_final := comissao_ajustada + (valor_total * bonus_antiguidade)

  QUANDO:
    qtd_vendas >= 1

  ENTAO:
    ADICIONAR comissao_final AO COMISSAO
      COM DESCRICAO "Comissao escalonada multi-criterio"

FIM_REGRA
```

---

## 6. Validacao e Erros

### 6.1 Erros de Sintaxe

```
ERRO: Variavel 'meta_mes' nao declarada na linha 15
ERRO: Operador 'ENTRE' requer dois valores separados por 'E' na linha 8
ERRO: Funcao 'SOMAR' requer um campo especificado na linha 12
ERRO: Provider 'VENDAS' nao encontrado - voce quis dizer 'VENDA'?
```

### 6.2 Erros Semanticos

```
AVISO: Variavel 'bonus' declarada mas nunca utilizada
AVISO: Divisao por zero possivel na variavel 'percentual' - considere usar SE_NULO
ERRO: Acao 'ADICIONAR' requer destino (COMISSAO, BONUS, RESIDUAL, etc)
ERRO: Campo 'data_venda' nao existe no provider 'PLACA' - campos disponiveis: data_fechamento
```

### 6.3 Validacao de Tipos

```
ERRO: Operacao '+' invalida entre TEXTO e DECIMAL
ERRO: Funcao 'ARREDONDAR_BAIXO' requer valor numerico, recebeu TEXTO
AVISO: Comparacao entre tipos diferentes: DECIMAL e INTEGER (conversao automatica)
```

---

## 7. Conversao entre Formatos

### 7.1 DSL para JSON

```dsl
-- DSL Input:
valor_bonus := faixas * 800

-- JSON Output:
{
  "nome": "valor_bonus",
  "tipo": "FORMULA",
  "config": {
    "expressao": "faixas * 800"
  }
}
```

### 7.2 JSON para DSL

O sistema permite exportar regras JSON para formato DSL legivel para revisao humana.

---

## 8. Boas Praticas

### 8.1 Nomenclatura

```dsl
-- BOM: Nomes descritivos em snake_case
qtd_placas_fechadas
valor_comissao_base
percentual_atingimento_meta

-- RUIM: Abreviacoes confusas
q_pf
vcb
pam
```

### 8.2 Organizacao

```dsl
-- BOM: Variaveis ordenadas logicamente
VARIAVEIS:
  -- 1. Inputs/Constantes
  percentual_base := 0.08
  
  -- 2. Agregacoes
  qtd_vendas := CONTAR(PLACA) ONDE ...
  
  -- 3. Calculos intermediarios
  comissao_bruta := valor * percentual_base
  
  -- 4. Resultado final
  comissao_final := comissao_bruta * multiplicador
```

### 8.3 Comentarios

```dsl
REGRA "Minha Regra"
  -- Este e um comentario de linha
  
  VARIAVEIS:
    -- Busca placas do mes atual
    qtd_placas := CONTAR(PLACA) ONDE ...
    
    /* 
     * Comentario de bloco
     * para explicacoes mais longas
     */
    calculo_complexo := ...
```

---

## Historico de Alteracoes

| Versao | Data | Autor | Alteracao |
|--------|------|-------|-----------|
| 2.0 | 29/01/2026 | PO | Criacao da especificacao DSL completa |
