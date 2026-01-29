# US-CRM-MTR-003: DSL Textual e Templates Pre-configurados

> **Modulo**: CRM-Motor-Regras  
> **Versao**: 2.0  
> **Data**: 29/01/2026  
> **Status**: Pronto para Desenvolvimento  
> **Story Points**: 34

---

## Historia de Usuario

**Como** usuario de negocio sem conhecimento tecnico,  
**Quero** criar e manter regras usando linguagem textual simples (DSL) e escolher templates pre-configurados,  
**Para** definir regras de comissao, bonus e premiacao de forma autonoma sem depender de desenvolvedores.

---

## Descricao

Esta historia implementa:

1. **DSL Textual**: Linguagem especifica de dominio para definir regras
2. **Parser e Validador**: Conversao DSL <-> JSON Schema v2.0
3. **Templates Pre-configurados**: Modelos de regras comuns
4. **Wizard de Criacao**: Assistente guiado para templates

### Exemplo de DSL

```
REGRA "Bonus SP Automovel ate 50k"
CODIGO "REG-BONUS-SP-AUTO-001"
CATEGORIA BONUS
PRIORIDADE 1

VARIAVEIS
  // Agregacao de placas com filtros
  placas_sp_auto_50k = CONTAR(PLACA) ONDE {
    consultor_id = @consultor_atual,
    tipo_veiculo = "AUTOMOVEL",
    uf_veiculo = "SP",
    valor_veiculo < 50000,
    data_fechamento ENTRE @periodo_inicio E @periodo_fim,
    status = "FECHADA"
  }
  
  // Busca de meta
  meta_mes = PRIMEIRO(META) ONDE {
    consultor_id = @consultor_atual,
    tipo_meta = "MENSAL",
    categoria = "COMISSAO",
    mes_referencia = @mes_atual
  } CAMPO valor_meta
  
  // Calculos
  pct_acima_meta = MAIOR_ENTRE((placas_sp_auto_50k - meta_mes) / meta_mes * 100, 0)
  faixas_10_pct = ARREDONDAR_BAIXO(pct_acima_meta / 10)
  valor_bonus = faixas_10_pct * 800

QUANDO
  placas_sp_auto_50k > meta_mes E
  faixas_10_pct >= 1

ENTAO
  CREDITAR valor_bonus EM BONUS DESCRICAO "Bonus R$ 800 por faixa de 10% acima meta"

FIM_REGRA
```

---

## Criterios de Aceitacao

### CA-001: Parser DSL para JSON

- [ ] Sistema faz parse de DSL textual para JSON Schema v2.0
- [ ] Sistema valida sintaxe durante digitacao
- [ ] Sistema destaca erros com mensagem descritiva
- [ ] Sistema fornece autocomplete de palavras-chave
- [ ] Sistema converte JSON de volta para DSL

**Mapeamento DSL -> JSON:**
```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                      MAPEAMENTO DSL -> JSON                                     │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  REGRA "nome"                  ->  metadata.nome                                │
│  CODIGO "cod"                  ->  metadata.codigo                              │
│  CATEGORIA XXX                 ->  metadata.categoria                           │
│  PRIORIDADE N                  ->  metadata.prioridade                          │
│                                                                                 │
│  VARIAVEIS                                                                      │
│    nome = CONTAR(PROV)         ->  variaveis[].tipo: "AGREGACAO"                │
│           ONDE {filtros}            variaveis[].provider: "PROV"                │
│                                     variaveis[].funcao: "COUNT"                 │
│                                     variaveis[].filtros: [...]                  │
│                                                                                 │
│    nome = expressao            ->  variaveis[].tipo: "FORMULA"                  │
│                                    variaveis[].formula.expressao: "..."         │
│                                                                                 │
│  QUANDO expr1 E expr2          ->  condicoes.operador: "AND"                    │
│                                    condicoes.expressoes: [...]                  │
│                                                                                 │
│  ENTAO                                                                          │
│    CREDITAR v EM dest          ->  acoes[].tipo: "ADICIONAR_VALOR"              │
│                                    acoes[].destino_tipo: dest                   │
│                                    acoes[].valor: {"ref": "v"}                  │
│                                                                                 │
│  @contexto                     ->  variaveis de contexto do executor            │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### CA-002: Palavras-Chave DSL em Portugues

| Palavra-Chave | Funcao |
|---------------|--------|
| REGRA | Inicio da definicao |
| CODIGO | Identificador unico |
| CATEGORIA | Tipo da regra |
| PRIORIDADE | Ordem de execucao |
| VARIAVEIS | Bloco de variaveis |
| QUANDO | Bloco de condicoes |
| ENTAO | Bloco de acoes |
| FIM_REGRA | Fim da definicao |
| CONTAR | COUNT |
| SOMAR | SUM |
| MEDIA | AVG |
| MINIMO | MIN |
| MAXIMO | MAX |
| PRIMEIRO | FIRST |
| ONDE | Filtros |
| E | AND |
| OU | OR |
| ENTRE | BETWEEN |
| MAIOR_ENTRE | GREATEST |
| MENOR_ENTRE | LEAST |
| ARREDONDAR | ROUND |
| ARREDONDAR_BAIXO | FLOOR |
| ARREDONDAR_CIMA | CEIL |
| CREDITAR | ADICIONAR_VALOR |
| ATUALIZAR | ATUALIZAR_CAMPO |
| NOTIFICAR | NOTIFICAR |
| CAMPO | Campo de retorno |

### CA-003: Templates Pre-configurados

- [ ] Sistema oferece biblioteca de templates
- [ ] Template inclui DSL pre-preenchido
- [ ] Template inclui descricao e casos de uso
- [ ] Usuario pode customizar template
- [ ] Sistema valida customizacao

**Templates Disponiveis:**

| Template | Categoria | Descricao |
|----------|-----------|-----------|
| TPL-BONUS-META | BONUS | Bonus por percentual acima da meta |
| TPL-RESIDUAL-BOLETOS | RESIDUAL | Residual baseado em pagamentos |
| TPL-COMISSAO-FAIXA | COMISSAO | Comissao com faixas de valor |
| TPL-LEAD-SCORE | LEAD_SCORE | Calculo de pontuacao de leads |
| TPL-DESCONTO-VOLUME | DESCONTO | Desconto progressivo por volume |
| TPL-INDICACAO | INDICACAO | Bonus por indicacao convertida |
| TPL-OVERRIDE | OVERRIDE | Comissao de lideranca |
| TPL-CAMPANHA | CAMPANHA | Regras de campanha promocional |

### CA-004: Wizard de Criacao

- [ ] Passo 1: Selecionar template ou criar do zero
- [ ] Passo 2: Definir metadados (nome, codigo, categoria)
- [ ] Passo 3: Configurar variaveis (interface grafica)
- [ ] Passo 4: Definir condicoes (construtor visual)
- [ ] Passo 5: Configurar acoes (formulario guiado)
- [ ] Passo 6: Revisar DSL gerado
- [ ] Passo 7: Testar com dados de exemplo
- [ ] Passo 8: Salvar e ativar

### CA-005: Validacao de DSL

- [ ] Sistema valida sintaxe em tempo real
- [ ] Sistema destaca linha com erro
- [ ] Sistema sugere correcoes
- [ ] Sistema valida referencias a variaveis
- [ ] Sistema valida Data Providers existentes
- [ ] Sistema valida campos dos Providers

**Tipos de Erro:**
```
Linha 15: Erro de sintaxe - esperado "E" ou "OU" apos expressao
Linha 20: Provider "PLACA" nao possui campo "tipo_auto" - voce quis dizer "tipo_veiculo"?
Linha 25: Variavel "meta" nao definida - defina em VARIAVEIS antes de usar
```

### CA-006: Editor DSL

- [ ] Editor com destaque de sintaxe
- [ ] Autocomplete de palavras-chave
- [ ] Autocomplete de Providers e campos
- [ ] Autocomplete de variaveis de contexto
- [ ] Minimap do codigo
- [ ] Numeracao de linhas
- [ ] Painel de erros/avisos

---

## Mockups

### Tela: Editor DSL

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  EDITOR DE REGRAS DSL                          [Templates] [Validar] [Salvar]      │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │   1 │ REGRA "Bonus SP Automovel ate 50k"                                    │   │
│  │   2 │ CODIGO "REG-BONUS-SP-AUTO-001"                                        │   │
│  │   3 │ CATEGORIA BONUS                                                       │   │
│  │   4 │ PRIORIDADE 1                                                          │   │
│  │   5 │                                                                       │   │
│  │   6 │ VARIAVEIS                                                             │   │
│  │   7 │   // Agregacao de placas com filtros                                  │   │
│  │   8 │   placas_sp_auto_50k = CONTAR(PLACA) ONDE {                          │   │
│  │   9 │     consultor_id = @consultor_atual,                                  │   │
│  │  10 │     tipo_veiculo = "AUTOMOVEL",                                       │   │
│  │  11 │     uf_veiculo = "SP",                                                │   │
│  │  12 │     valor_veiculo < 50000,                                            │   │
│  │  13 │     data_fechamento ENTRE @periodo_inicio E @periodo_fim,             │   │
│  │  14 │     status = "FECHADA"                                                │   │
│  │  15 │   }                                                                   │   │
│  │  ... │                                                                       │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  PAINEL DE VALIDACAO                                                               │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ ✓ Sintaxe valida                                                            │   │
│  │ ✓ Todos os Providers existem                                                │   │
│  │ ✓ Todas as variaveis referenciadas estao definidas                          │   │
│  │ ✓ Acoes configuradas corretamente                                           │   │
│  │                                                                             │   │
│  │ [Gerar JSON] [Testar] [Visualizar Fluxo]                                    │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### Tela: Selecao de Template

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  TEMPLATES DE REGRAS                                       [Filtrar] [Buscar]      │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  Categoria: [Todos ▼]                                                              │
│                                                                                     │
│  ┌────────────────────────────────┐  ┌────────────────────────────────┐            │
│  │ TPL-BONUS-META                 │  │ TPL-RESIDUAL-BOLETOS           │            │
│  │ ─────────────────────────────  │  │ ─────────────────────────────  │            │
│  │ Bonus por % acima da meta      │  │ Residual sobre pagamentos      │            │
│  │                                │  │                                │            │
│  │ Categoria: BONUS               │  │ Categoria: RESIDUAL            │            │
│  │ Complexidade: Media            │  │ Complexidade: Media            │            │
│  │                                │  │                                │            │
│  │ Providers: PLACA, META         │  │ Providers: BOLETO              │            │
│  │                                │  │                                │            │
│  │ [Usar Template] [Visualizar]   │  │ [Usar Template] [Visualizar]   │            │
│  └────────────────────────────────┘  └────────────────────────────────┘            │
│                                                                                     │
│  ┌────────────────────────────────┐  ┌────────────────────────────────┐            │
│  │ TPL-COMISSAO-FAIXA             │  │ TPL-LEAD-SCORE                 │            │
│  │ ─────────────────────────────  │  │ ─────────────────────────────  │            │
│  │ Comissao escalonada por faixa  │  │ Pontuacao automatica de leads  │            │
│  │                                │  │                                │            │
│  │ Categoria: COMISSAO            │  │ Categoria: LEAD_SCORE          │            │
│  │ Complexidade: Alta             │  │ Complexidade: Baixa            │            │
│  │                                │  │                                │            │
│  │ [Usar Template] [Visualizar]   │  │ [Usar Template] [Visualizar]   │            │
│  └────────────────────────────────┘  └────────────────────────────────┘            │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

---

## Cenarios de Teste

### CT-001: Parse DSL Valido

**Dado** DSL textual completo e valido  
**Quando** parser processa o DSL  
**Entao** JSON Schema v2.0 gerado corretamente  
**E** todos os campos mapeados  
**E** nenhum erro reportado

### CT-002: Parse DSL com Erros

**Dado** DSL com erro de sintaxe na linha 15  
**Quando** parser processa o DSL  
**Entao** erro identificado na linha 15  
**E** mensagem descritiva do erro  
**E** sugestao de correcao quando possivel

### CT-003: Usar Template

**Dado** usuario seleciona template TPL-BONUS-META  
**Quando** usuario clica em "Usar Template"  
**Entao** editor abre com DSL pre-preenchido  
**E** placeholders para customizacao destacados  
**E** usuario pode editar livremente

### CT-004: Conversao Bidirecional

**Dado** regra existente em JSON Schema v2.0  
**Quando** usuario abre no editor DSL  
**Entao** DSL textual gerado corretamente  
**E** usuario pode editar e salvar  
**E** JSON atualizado corretamente

---

## Regras de Negocio

| Codigo | Regra | Validacao |
|--------|-------|-----------|
| RN-001 | DSL unico | Codigo da regra deve ser unico |
| RN-002 | Variaveis ordenadas | Variaveis devem ser definidas antes de usar |
| RN-003 | Provider valido | Providers referenciados devem existir |
| RN-004 | Campos validos | Campos devem existir no Provider |
| RN-005 | Template imutavel | Templates padrao nao podem ser editados |

---

## Estimativa Detalhada

| Item | Horas | SP |
|------|-------|-----|
| Parser DSL | 32h | 8 |
| Gerador JSON -> DSL | 16h | 5 |
| Templates Pre-configurados | 24h | 8 |
| Editor com Syntax Highlight | 24h | 8 |
| Validacao em Tempo Real | 16h | 3 |
| Testes | 8h | 2 |
| **TOTAL** | **120h** | **34** |

---

## Historico de Alteracoes

| Versao | Data | Autor | Alteracao |
|--------|------|-------|-----------|
| 1.0 | 29/01/2026 | PO | Versao inicial |
| 2.0 | 29/01/2026 | PO | Reescrita para arquitetura de alta abstracao |
