# US-CRM-MTR-002: Execucao do Motor e Acoes Configuraveis

> **Modulo**: CRM-Motor-Regras  
> **Versao**: 2.0  
> **Data**: 29/01/2026  
> **Status**: Pronto para Desenvolvimento  
> **Story Points**: 55

---

## Historia de Usuario

**Como** sistema de processamento,  
**Quero** executar regras dinamicamente avaliando variaveis de agregacao, calculando formulas, verificando condicoes e executando acoes configuraveis,  
**Para** processar qualquer cenario de calculo (comissao, bonus, residual, score, desconto) de forma generica e auditavel.

---

## Descricao

Esta historia implementa o **nucleo de execucao do Motor de Regras v2.0**, incluindo:

1. **Expression Evaluator**: Avaliador de expressoes matematicas e logicas
2. **Aggregation Engine**: Motor de agregacao em Data Providers
3. **Condition Evaluator**: Avaliador de condicoes compostas
4. **Action Executor**: Executor de acoes configuraveis
5. **API de Execucao**: Endpoints para executar e simular regras

### Exemplo de Execucao Complexa

Executar regra de bonus que:
- Consulta placas filtradas por tipo, UF e valor
- Compara com meta do consultor
- Calcula percentual acima da meta
- Aplica bonus de R$ 800 por faixa de 10%

---

## Criterios de Aceitacao

### CA-001: Resolver Variaveis de Agregacao

- [ ] Sistema conecta ao Data Provider configurado
- [ ] Sistema aplica filtros com substituicao de contexto
- [ ] Sistema executa funcao de agregacao (COUNT, SUM, AVG, etc)
- [ ] Sistema armazena resultado na variavel
- [ ] Sistema registra query executada para auditoria
- [ ] Sistema trata erros de conexao/query graciosamente

**Exemplo de Resolucao:**
```
Provider: PLACA
Funcao: COUNT
Filtros aplicados:
  - consultor_id = '550e8400-...'
  - tipo_veiculo = 'AUTOMOVEL'
  - uf_veiculo = 'SP'
  - valor_veiculo < 50000
  - data_fechamento BETWEEN '2026-01-01' AND '2026-01-31'
  - status = 'FECHADA'
  
Resultado: 15 placas
```

### CA-002: Calcular Formulas

- [ ] Sistema substitui referencias a variaveis pelo valor resolvido
- [ ] Sistema avalia expressoes matematicas
- [ ] Sistema executa funcoes matematicas (FLOOR, CEIL, ROUND, etc)
- [ ] Sistema executa expressoes condicionais (CASE WHEN)
- [ ] Sistema propaga erros (divisao por zero, variavel nula)
- [ ] Sistema permite config "quando_erro" para tratamento

**Exemplo de Calculo:**
```
Formula: GREATEST((placas_sp_auto_50k - meta_mes) / meta_mes * 100, 0)

Substituicao:
  placas_sp_auto_50k = 15
  meta_mes = 10

Calculo:
  (15 - 10) / 10 * 100 = 50
  GREATEST(50, 0) = 50

Resultado: 50 (percentual acima da meta)
```

### CA-003: Avaliar Condicoes Compostas

- [ ] Sistema avalia expressoes individuais
- [ ] Sistema aplica operador logico (AND/OR) entre expressoes
- [ ] Sistema suporta grupos aninhados de condicoes
- [ ] Sistema avalia na ordem definida
- [ ] Sistema retorna TRUE/FALSE para cada expressao
- [ ] Sistema retorna resultado final da avaliacao

**Exemplo de Avaliacao:**
```
Condicoes:
  (placas_sp_auto_50k > meta_mes) AND (faixas_10_pct >= 1)

Avaliacao:
  15 > 10 = TRUE
  5 >= 1 = TRUE
  TRUE AND TRUE = TRUE

Resultado: Condicao ATENDIDA
```

### CA-004: Executar Acoes

- [ ] Sistema suporta acao ADICIONAR_VALOR (creditar em conta)
- [ ] Sistema suporta acao ATUALIZAR_CAMPO (modificar entidade)
- [ ] Sistema suporta acao NOTIFICAR (enviar notificacao)
- [ ] Sistema suporta acao CRIAR_TAREFA (workflow)
- [ ] Sistema suporta acao WEBHOOK (chamar API externa)
- [ ] Sistema suporta acao RETORNAR_VALOR (apenas retornar)
- [ ] Sistema executa acoes na ordem definida
- [ ] Sistema permite condicao especifica por acao

**Tipos de Acao:**
```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           TIPOS DE ACOES                                        │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ADICIONAR_VALOR                                                                │
│  ├─ destino_tipo: COMISSAO | BONUS | RESIDUAL | PREMIACAO | OVERRIDE            │
│  ├─ beneficiario: UUID ou @contexto (opcional)                                  │
│  ├─ valor: numero ou {"ref": "variavel"}                                        │
│  └─ descricao: texto para auditoria                                             │
│                                                                                 │
│  ATUALIZAR_CAMPO                                                                │
│  ├─ entidade: LEAD | ASSOCIADO | CONSULTOR                                      │
│  ├─ campo: nome do campo                                                        │
│  └─ valor: novo valor                                                           │
│                                                                                 │
│  NOTIFICAR                                                                      │
│  ├─ destinatario: UUID ou @contexto                                             │
│  ├─ template: codigo do template de notificacao                                 │
│  └─ variaveis: dados para o template                                            │
│                                                                                 │
│  CRIAR_TAREFA                                                                   │
│  ├─ titulo: texto                                                               │
│  ├─ responsavel: UUID                                                           │
│  ├─ prazo_dias: numero                                                          │
│  └─ contexto: dados adicionais                                                  │
│                                                                                 │
│  WEBHOOK                                                                        │
│  ├─ url: endpoint                                                               │
│  ├─ metodo: POST | PUT                                                          │
│  └─ dados: payload                                                              │
│                                                                                 │
│  RETORNAR_VALOR                                                                 │
│  ├─ campo: nome do campo de retorno                                             │
│  └─ valor: valor a retornar                                                     │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### CA-005: API de Execucao

- [ ] Endpoint POST /api/v1/motor/executar
- [ ] Recebe: regra_codigo, contexto, variaveis_input
- [ ] Retorna: resultado, detalhamento, execucao_id, tempo_ms
- [ ] Sistema valida que regra esta ATIVA
- [ ] Sistema valida vigencia da regra
- [ ] Sistema valida escopo (consultor permitido)
- [ ] Sistema registra execucao para auditoria

**Exemplo de Request:**
```json
POST /api/v1/motor/executar
{
  "regra_codigo": "REG-BONUS-SP-AUTO-001",
  "contexto": {
    "consultor_id": "550e8400-e29b-41d4-a716-446655440000",
    "periodo_inicio": "2026-01-01",
    "periodo_fim": "2026-01-31"
  }
}
```

**Exemplo de Response:**
```json
{
  "aplicada": true,
  "resultado": {
    "acoes_executadas": [
      {
        "tipo": "ADICIONAR_VALOR",
        "destino": "BONUS",
        "valor": 4000.00,
        "descricao": "Bonus R$ 800 por faixa de 10% acima meta"
      }
    ]
  },
  "variaveis": {
    "placas_sp_auto_50k": 15,
    "meta_mes": 10,
    "pct_acima_meta": 50,
    "faixas_10_pct": 5,
    "valor_bonus": 4000
  },
  "execucao_id": "exec-uuid-here",
  "tempo_ms": 45,
  "regra_versao": 1
}
```

### CA-006: Tratamento de Erros

- [ ] Sistema captura erros de agregacao (Provider indisponivel)
- [ ] Sistema captura erros de calculo (divisao por zero)
- [ ] Sistema retorna detalhamento do erro
- [ ] Sistema nao executa acoes se houver erro nas variaveis
- [ ] Sistema permite configurar comportamento: ABORTAR | CONTINUAR

### CA-007: Execucao em Lote

- [ ] Sistema permite executar regra para multiplos contextos
- [ ] Endpoint POST /api/v1/motor/executar-lote
- [ ] Sistema processa em paralelo quando possivel
- [ ] Sistema retorna resultados individuais e resumo
- [ ] Sistema registra todas as execucoes

### CA-008: Regras Encadeadas

- [ ] Sistema permite que acao de uma regra dispare outra regra
- [ ] Sistema controla profundidade maxima (evitar loop)
- [ ] Sistema propaga contexto entre regras
- [ ] Sistema registra cadeia de execucao

---

## Mockups

### Tela: Monitor de Execucao

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  MOTOR DE REGRAS - MONITOR DE EXECUCAO                                             │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  EXECUCAO #exec-550e-..                                           [Reprocessar]    │
│                                                                                     │
│  Regra: REG-BONUS-SP-AUTO-001 - Bonus SP Automovel ate 50k                         │
│  Versao: 1 | Status: APLICADA | Tempo: 45ms                                        │
│                                                                                     │
│  CONTEXTO                                                                           │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ consultor_id: 550e8400-e29b-41d4-a716-446655440000                          │   │
│  │ periodo: 2026-01-01 a 2026-01-31                                            │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  RESOLUCAO DE VARIAVEIS                                                            │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Variavel            │ Tipo       │ Valor     │ Tempo   │ Detalhes           │   │
│  ├─────────────────────────────────────────────────────────────────────────────┤   │
│  │ placas_sp_auto_50k  │ AGREGACAO  │ 15        │ 12ms    │ [Ver Query]        │   │
│  │ meta_mes            │ AGREGACAO  │ 10        │ 5ms     │ [Ver Query]        │   │
│  │ pct_acima_meta      │ FORMULA    │ 50        │ <1ms    │ (15-10)/10*100     │   │
│  │ faixas_10_pct       │ FORMULA    │ 5         │ <1ms    │ FLOOR(50/10)       │   │
│  │ valor_bonus         │ FORMULA    │ 4000      │ <1ms    │ 5 * 800            │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  AVALIACAO DE CONDICOES                                                            │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Expressao                              │ Resultado │                        │   │
│  ├─────────────────────────────────────────────────────────────────────────────┤   │
│  │ placas_sp_auto_50k (15) > meta_mes (10)│ ✓ TRUE    │                        │   │
│  │ faixas_10_pct (5) >= 1                 │ ✓ TRUE    │                        │   │
│  │ RESULTADO FINAL (AND)                  │ ✓ TRUE    │                        │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  ACOES EXECUTADAS                                                                  │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ # │ Tipo            │ Destino │ Valor      │ Status  │                      │   │
│  ├─────────────────────────────────────────────────────────────────────────────┤   │
│  │ 1 │ ADICIONAR_VALOR │ BONUS   │ R$ 4.000,00│ ✓ OK    │                      │   │
│  │ 2 │ NOTIFICAR       │ Consultor│ Template   │ ✓ OK    │                      │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

---

## Cenarios de Teste

### CT-001: Executar Regra de Bonus Complexa

**Dado** regra REG-BONUS-SP-AUTO-001 ativa  
**E** consultor com 15 placas SP/Auto/<50k no mes  
**E** meta do consultor = 10 placas  
**Quando** executo a regra via API  
**Entao** variavel placas_sp_auto_50k = 15  
**E** variavel pct_acima_meta = 50  
**E** variavel faixas_10_pct = 5  
**E** variavel valor_bonus = 4000  
**E** condicao = ATENDIDA  
**E** acao ADICIONAR_VALOR executada com R$ 4.000,00

### CT-002: Regra Nao Aplicada (Condicao Falsa)

**Dado** regra REG-BONUS-SP-AUTO-001 ativa  
**E** consultor com 8 placas SP/Auto/<50k no mes  
**E** meta do consultor = 10 placas  
**Quando** executo a regra via API  
**Entao** variavel pct_acima_meta = 0 (GREATEST aplicado)  
**E** variavel faixas_10_pct = 0  
**E** condicao = NAO ATENDIDA  
**E** nenhuma acao executada  
**E** resultado.aplicada = false

### CT-003: Erro de Agregacao (Provider Indisponivel)

**Dado** regra que usa provider PLACA  
**E** view vw_placas_motor esta inacessivel  
**Quando** executo a regra via API  
**Entao** sistema retorna erro  
**E** erro.tipo = "AGGREGATION_ERROR"  
**E** erro.mensagem contem detalhes da falha  
**E** execucao registrada com status ERRO

### CT-004: Execucao em Lote

**Dado** regra REG-BONUS-SP-AUTO-001 ativa  
**E** lista de 50 consultores para processar  
**Quando** executo via /executar-lote  
**Entao** sistema processa todos os consultores  
**E** retorna resultados individuais  
**E** retorna resumo: X aplicadas, Y nao aplicadas, Z erros

---

## Regras de Negocio

| Codigo | Regra | Validacao |
|--------|-------|-----------|
| RN-001 | Regra ativa | So executa regras com status ATIVA |
| RN-002 | Vigencia valida | Data atual dentro da vigencia |
| RN-003 | Escopo valido | Consultor permitido pelo escopo |
| RN-004 | Ordem de variaveis | Variaveis avaliadas na ordem declarada |
| RN-005 | Acoes condicionais | Acao so executa se condicao propria for TRUE |
| RN-006 | Auditoria completa | Toda execucao registrada com detalhes |

---

## Estimativa Detalhada

| Item | Horas | SP |
|------|-------|-----|
| Aggregation Engine | 40h | 13 |
| Expression Evaluator | 32h | 13 |
| Condition Evaluator | 16h | 5 |
| Action Executor | 32h | 13 |
| API de Execucao | 16h | 5 |
| Registro de Auditoria | 16h | 3 |
| Testes | 16h | 3 |
| **TOTAL** | **168h** | **55** |

---

## Historico de Alteracoes

| Versao | Data | Autor | Alteracao |
|--------|------|-------|-----------|
| 1.0 | 29/01/2026 | PO | Versao inicial |
| 2.0 | 29/01/2026 | PO | Reescrita para arquitetura de alta abstracao |
