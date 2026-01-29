# Exemplos de Regras Complexas - Motor de Regras v2.0

> **Documento**: Exemplos Praticos de Regras com Alta Abstracao  
> **Versao**: 2.0  
> **Data**: 29/01/2026  
> **Autor**: Product Owner

---

## Sumario

1. [Exemplo 1: Bonus por Meta com Filtros Compostos](#exemplo-1)
2. [Exemplo 2: Residual Condicional sobre Boletos](#exemplo-2)
3. [Exemplo 3: Combinacao de Regras (Bonus + Residual)](#exemplo-3)
4. [Exemplo 4: Score Dinamico de Leads](#exemplo-4)
5. [Exemplo 5: Comissao Escalonada Multi-Criterio](#exemplo-5)
6. [Exemplo 6: Split com Override Hierarquico](#exemplo-6)
7. [Exemplo 7: Campanha Temporal com Gatilhos](#exemplo-7)
8. [Exemplo 8: Desconto Progressivo por Perfil](#exemplo-8)

---

## Exemplo 1: Bonus por Meta com Filtros Compostos {#exemplo-1}

### Requisito de Negocio

> Adicionar R$ 800,00 para cada 10% a mais de placas fechadas acima da meta do mes,
> desde que as placas sejam de veiculos do tipo **automovel** do estado de **Sao Paulo**
> e cujo valor do veiculo seja inferior a **R$ 50.000**.

### Definicao JSON da Regra

```json
{
  "versao_schema": "2.0",
  "metadata": {
    "codigo": "REG-BONUS-SP-AUTO-001",
    "nome": "Bonus SP Automovel ate 50k",
    "categoria": "BONIFICACAO",
    "descricao": "R$ 800 para cada 10% acima da meta em automoveis SP ate 50k",
    "escopo": {
      "tipo": "CONSULTOR",
      "ids": ["uuid-consultor-especifico"]
    },
    "vigencia": {
      "inicio": "2026-01-01",
      "fim": "2026-12-31"
    }
  },
  
  "data_providers": ["PLACA", "META"],
  
  "variaveis": [
    {
      "nome": "placas_sp_auto_50k",
      "descricao": "Quantidade de placas SP automovel ate 50k no periodo",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "PLACA",
        "funcao": "COUNT",
        "campo": "id",
        "filtros": [
          {"campo": "consultor_id", "operador": "=", "valor": "@contexto.consultor_id"},
          {"campo": "data_fechamento", "operador": "BETWEEN", "valor": ["@periodo.inicio", "@periodo.fim"]},
          {"campo": "tipo_veiculo", "operador": "=", "valor": "AUTOMOVEL"},
          {"campo": "uf_veiculo", "operador": "=", "valor": "SP"},
          {"campo": "valor_veiculo", "operador": "<", "valor": 50000},
          {"campo": "status", "operador": "=", "valor": "FECHADA"}
        ]
      }
    },
    {
      "nome": "meta_mes",
      "descricao": "Meta de placas do consultor no mes",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "META",
        "funcao": "FIRST",
        "campo": "meta_placas",
        "filtros": [
          {"campo": "consultor_id", "operador": "=", "valor": "@contexto.consultor_id"},
          {"campo": "ano", "operador": "=", "valor": "@periodo.ano"},
          {"campo": "mes", "operador": "=", "valor": "@periodo.mes"}
        ]
      }
    },
    {
      "nome": "percentual_acima_meta",
      "descricao": "Percentual acima da meta (0 se nao atingiu)",
      "tipo": "FORMULA",
      "config": {
        "expressao": "GREATEST((placas_sp_auto_50k - meta_mes) / meta_mes * 100, 0)",
        "quando_erro": 0
      }
    },
    {
      "nome": "faixas_10_porcento",
      "descricao": "Quantidade de faixas de 10% acima da meta",
      "tipo": "FORMULA",
      "config": {
        "expressao": "FLOOR(percentual_acima_meta / 10)"
      }
    },
    {
      "nome": "valor_bonus",
      "descricao": "Valor total do bonus",
      "tipo": "FORMULA",
      "config": {
        "expressao": "faixas_10_porcento * 800"
      }
    }
  ],
  
  "condicoes": {
    "tipo": "AND",
    "expressoes": [
      {"variavel": "placas_sp_auto_50k", "operador": ">", "valor": {"ref": "meta_mes"}},
      {"variavel": "faixas_10_porcento", "operador": ">=", "valor": 1}
    ]
  },
  
  "acoes": [
    {
      "ordem": 1,
      "tipo": "ADICIONAR_VALOR",
      "config": {
        "destino_tipo": "BONUS",
        "valor": {"ref": "valor_bonus"},
        "descricao": "Bonus R$ 800 por faixa de 10% acima da meta (SP Auto <50k)"
      }
    },
    {
      "ordem": 2,
      "tipo": "NOTIFICAR",
      "config": {
        "destinatario": "@contexto.consultor_id",
        "template": "BONUS_META_ATINGIDA",
        "variaveis": {
          "valor": "valor_bonus",
          "percentual": "percentual_acima_meta",
          "faixas": "faixas_10_porcento"
        }
      }
    }
  ]
}
```

### Fluxo de Execucao

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  EXECUCAO DA REGRA: REG-BONUS-SP-AUTO-001                                       │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  1. RESOLUCAO DE VARIAVEIS                                                      │
│     ├── placas_sp_auto_50k = COUNT(PLACA) com filtros = 15                      │
│     ├── meta_mes = FIRST(META.meta_placas) = 10                                 │
│     ├── percentual_acima_meta = (15-10)/10*100 = 50%                            │
│     ├── faixas_10_porcento = FLOOR(50/10) = 5                                   │
│     └── valor_bonus = 5 * 800 = R$ 4.000,00                                     │
│                                                                                 │
│  2. AVALIACAO DE CONDICOES                                                      │
│     ├── 15 > 10? ✅ SIM                                                         │
│     ├── 5 >= 1? ✅ SIM                                                          │
│     └── RESULTADO: APLICAR REGRA                                                │
│                                                                                 │
│  3. EXECUCAO DE ACOES                                                           │
│     ├── [1] ADICIONAR R$ 4.000,00 ao BONUS                                      │
│     └── [2] NOTIFICAR consultor sobre bonus                                     │
│                                                                                 │
│  RESULTADO FINAL: R$ 4.000,00 de bonus                                          │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Exemplo 2: Residual Condicional sobre Boletos {#exemplo-2}

### Requisito de Negocio

> Caso o valor total de boletos recebidos de 01 a 31 de um certo mes seja superior
> a R$ 100.000, sera adicionado ao valor a receber de residual o valor de **15%**
> sobre o valor recebido no periodo.

### Definicao JSON da Regra

```json
{
  "versao_schema": "2.0",
  "metadata": {
    "codigo": "REG-RES-BOLETOS-001",
    "nome": "Residual 15% sobre Boletos >100k",
    "categoria": "RESIDUAL",
    "descricao": "15% de residual extra quando boletos recebidos ultrapassam 100k no mes",
    "escopo": {
      "tipo": "GLOBAL"
    },
    "vigencia": {
      "inicio": "2026-01-01",
      "fim": null
    }
  },
  
  "data_providers": ["BOLETO"],
  
  "variaveis": [
    {
      "nome": "total_boletos_recebidos",
      "descricao": "Soma dos boletos pagos no periodo",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "BOLETO",
        "funcao": "SUM",
        "campo": "valor_recebido",
        "filtros": [
          {"campo": "consultor_id", "operador": "=", "valor": "@contexto.consultor_id"},
          {"campo": "data_pagamento", "operador": "BETWEEN", "valor": ["@periodo.inicio", "@periodo.fim"]},
          {"campo": "status", "operador": "=", "valor": "PAGO"}
        ]
      }
    },
    {
      "nome": "percentual_residual",
      "descricao": "Percentual de residual a aplicar",
      "tipo": "CONSTANTE",
      "config": {
        "valor": 0.15
      }
    },
    {
      "nome": "valor_residual_extra",
      "descricao": "Valor do residual extra",
      "tipo": "FORMULA",
      "config": {
        "expressao": "total_boletos_recebidos * percentual_residual"
      }
    }
  ],
  
  "condicoes": {
    "tipo": "AND",
    "expressoes": [
      {"variavel": "total_boletos_recebidos", "operador": ">", "valor": 100000}
    ]
  },
  
  "acoes": [
    {
      "ordem": 1,
      "tipo": "ADICIONAR_VALOR",
      "config": {
        "destino_tipo": "RESIDUAL",
        "valor": {"ref": "valor_residual_extra"},
        "descricao": "Residual extra 15% sobre boletos recebidos no periodo"
      }
    }
  ]
}
```

### Cenarios de Teste

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  CENARIOS DE TESTE: REG-RES-BOLETOS-001                                         │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  CENARIO 1: Abaixo do limite                                                    │
│  ├── total_boletos_recebidos = R$ 80.000,00                                     │
│  ├── Condicao: 80.000 > 100.000? ❌ NAO                                         │
│  └── Resultado: Regra NAO aplicada, residual extra = R$ 0,00                    │
│                                                                                 │
│  CENARIO 2: Exatamente no limite                                                │
│  ├── total_boletos_recebidos = R$ 100.000,00                                    │
│  ├── Condicao: 100.000 > 100.000? ❌ NAO                                        │
│  └── Resultado: Regra NAO aplicada, residual extra = R$ 0,00                    │
│                                                                                 │
│  CENARIO 3: Acima do limite                                                     │
│  ├── total_boletos_recebidos = R$ 150.000,00                                    │
│  ├── Condicao: 150.000 > 100.000? ✅ SIM                                        │
│  ├── valor_residual_extra = 150.000 * 0.15 = R$ 22.500,00                       │
│  └── Resultado: Regra APLICADA, residual extra = R$ 22.500,00                   │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Exemplo 3: Combinacao de Regras (Bonus + Residual) {#exemplo-3}

### Requisito de Negocio

> Combinar as duas regras anteriores para um consultor especifico:
> - Bonus por meta com filtros (SP, Automovel, <50k)
> - Residual extra sobre boletos >100k
> 
> Ambas devem ser avaliadas independentemente no fechamento mensal.

### Definicao JSON - Regra Combinada

```json
{
  "versao_schema": "2.0",
  "metadata": {
    "codigo": "REG-COMBO-CONSULTOR-001",
    "nome": "Pacote Especial Consultor X",
    "categoria": "COMPOSTA",
    "descricao": "Bonus SP + Residual Boletos para consultor especifico",
    "escopo": {
      "tipo": "CONSULTOR",
      "ids": ["550e8400-e29b-41d4-a716-446655440000"]
    },
    "vigencia": {
      "inicio": "2026-01-01",
      "fim": "2026-12-31"
    }
  },
  
  "data_providers": ["PLACA", "META", "BOLETO"],
  
  "variaveis": [
    {
      "nome": "placas_sp_auto_50k",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "PLACA",
        "funcao": "COUNT",
        "campo": "id",
        "filtros": [
          {"campo": "consultor_id", "operador": "=", "valor": "@contexto.consultor_id"},
          {"campo": "data_fechamento", "operador": "BETWEEN", "valor": ["@periodo.inicio", "@periodo.fim"]},
          {"campo": "tipo_veiculo", "operador": "=", "valor": "AUTOMOVEL"},
          {"campo": "uf_veiculo", "operador": "=", "valor": "SP"},
          {"campo": "valor_veiculo", "operador": "<", "valor": 50000},
          {"campo": "status", "operador": "=", "valor": "FECHADA"}
        ]
      }
    },
    {
      "nome": "meta_mes",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "META",
        "funcao": "FIRST",
        "campo": "meta_placas",
        "filtros": [
          {"campo": "consultor_id", "operador": "=", "valor": "@contexto.consultor_id"},
          {"campo": "ano", "operador": "=", "valor": "@periodo.ano"},
          {"campo": "mes", "operador": "=", "valor": "@periodo.mes"}
        ]
      }
    },
    {
      "nome": "total_boletos",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "BOLETO",
        "funcao": "SUM",
        "campo": "valor_recebido",
        "filtros": [
          {"campo": "consultor_id", "operador": "=", "valor": "@contexto.consultor_id"},
          {"campo": "data_pagamento", "operador": "BETWEEN", "valor": ["@periodo.inicio", "@periodo.fim"]},
          {"campo": "status", "operador": "=", "valor": "PAGO"}
        ]
      }
    },
    {
      "nome": "pct_acima_meta",
      "tipo": "FORMULA",
      "config": {
        "expressao": "GREATEST((placas_sp_auto_50k - meta_mes) / meta_mes * 100, 0)"
      }
    },
    {
      "nome": "faixas_bonus",
      "tipo": "FORMULA",
      "config": {
        "expressao": "FLOOR(pct_acima_meta / 10)"
      }
    },
    {
      "nome": "valor_bonus_meta",
      "tipo": "FORMULA",
      "config": {
        "expressao": "faixas_bonus * 800"
      }
    },
    {
      "nome": "valor_residual_extra",
      "tipo": "FORMULA",
      "config": {
        "expressao": "CASE WHEN total_boletos > 100000 THEN total_boletos * 0.15 ELSE 0 END"
      }
    },
    {
      "nome": "valor_total",
      "tipo": "FORMULA",
      "config": {
        "expressao": "valor_bonus_meta + valor_residual_extra"
      }
    }
  ],
  
  "condicoes": {
    "tipo": "OR",
    "expressoes": [
      {"variavel": "faixas_bonus", "operador": ">=", "valor": 1},
      {"variavel": "total_boletos", "operador": ">", "valor": 100000}
    ]
  },
  
  "acoes": [
    {
      "ordem": 1,
      "tipo": "ADICIONAR_VALOR",
      "condicao": {"variavel": "valor_bonus_meta", "operador": ">", "valor": 0},
      "config": {
        "destino_tipo": "BONUS",
        "valor": {"ref": "valor_bonus_meta"},
        "descricao": "Bonus meta SP Auto <50k"
      }
    },
    {
      "ordem": 2,
      "tipo": "ADICIONAR_VALOR",
      "condicao": {"variavel": "valor_residual_extra", "operador": ">", "valor": 0},
      "config": {
        "destino_tipo": "RESIDUAL",
        "valor": {"ref": "valor_residual_extra"},
        "descricao": "Residual 15% boletos >100k"
      }
    },
    {
      "ordem": 3,
      "tipo": "NOTIFICAR",
      "config": {
        "destinatario": "@contexto.consultor_id",
        "template": "FECHAMENTO_ESPECIAL",
        "variaveis": {
          "bonus": "valor_bonus_meta",
          "residual": "valor_residual_extra",
          "total": "valor_total"
        }
      }
    }
  ]
}
```

---

## Exemplo 4: Score Dinamico de Leads {#exemplo-4}

### Requisito de Negocio

> Calcular score de priorizacao de leads baseado em multiplos criterios:
> - Valor estimado do veiculo: +1 ponto para cada R$ 10.000
> - UF do lead: SP/RJ = +20 pontos, Sul = +15, outros = +5
> - Tempo desde ultimo contato: -2 pontos por dia sem contato
> - Quantidade de interacoes: +5 pontos por interacao
> - Lead indicado: +25 pontos bonus

### Definicao JSON da Regra

```json
{
  "versao_schema": "2.0",
  "metadata": {
    "codigo": "REG-SCORE-LEAD-001",
    "nome": "Score Dinamico de Leads",
    "categoria": "SCORE",
    "descricao": "Calcula pontuacao de priorizacao de leads",
    "escopo": {
      "tipo": "GLOBAL"
    },
    "vigencia": {
      "inicio": "2026-01-01",
      "fim": null
    }
  },
  
  "data_providers": ["LEAD", "INTERACAO"],
  
  "variaveis": [
    {
      "nome": "valor_veiculo",
      "tipo": "INPUT",
      "config": {
        "tipo_dado": "DECIMAL",
        "obrigatorio": true
      }
    },
    {
      "nome": "uf_lead",
      "tipo": "INPUT",
      "config": {
        "tipo_dado": "STRING",
        "obrigatorio": true
      }
    },
    {
      "nome": "dias_sem_contato",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "LEAD",
        "funcao": "CUSTOM",
        "expressao": "EXTRACT(DAY FROM NOW() - ultimo_contato)"
      }
    },
    {
      "nome": "qtd_interacoes",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "INTERACAO",
        "funcao": "COUNT",
        "campo": "id",
        "filtros": [
          {"campo": "lead_id", "operador": "=", "valor": "@contexto.lead_id"}
        ]
      }
    },
    {
      "nome": "lead_indicado",
      "tipo": "INPUT",
      "config": {
        "tipo_dado": "BOOLEAN",
        "valor_padrao": false
      }
    },
    {
      "nome": "pontos_valor",
      "tipo": "FORMULA",
      "config": {
        "expressao": "FLOOR(valor_veiculo / 10000)"
      }
    },
    {
      "nome": "pontos_uf",
      "tipo": "FORMULA",
      "config": {
        "expressao": "CASE WHEN uf_lead IN ('SP', 'RJ') THEN 20 WHEN uf_lead IN ('PR', 'SC', 'RS') THEN 15 ELSE 5 END"
      }
    },
    {
      "nome": "pontos_tempo",
      "tipo": "FORMULA",
      "config": {
        "expressao": "GREATEST(-dias_sem_contato * 2, -50)"
      }
    },
    {
      "nome": "pontos_interacoes",
      "tipo": "FORMULA",
      "config": {
        "expressao": "qtd_interacoes * 5"
      }
    },
    {
      "nome": "pontos_indicacao",
      "tipo": "FORMULA",
      "config": {
        "expressao": "CASE WHEN lead_indicado = true THEN 25 ELSE 0 END"
      }
    },
    {
      "nome": "score_final",
      "tipo": "FORMULA",
      "config": {
        "expressao": "pontos_valor + pontos_uf + pontos_tempo + pontos_interacoes + pontos_indicacao"
      }
    },
    {
      "nome": "classificacao",
      "tipo": "FORMULA",
      "config": {
        "expressao": "CASE WHEN score_final >= 80 THEN 'HOT' WHEN score_final >= 50 THEN 'WARM' WHEN score_final >= 20 THEN 'COLD' ELSE 'FROZEN' END"
      }
    }
  ],
  
  "condicoes": {
    "tipo": "AND",
    "expressoes": [
      {"constante": true}
    ]
  },
  
  "acoes": [
    {
      "ordem": 1,
      "tipo": "ATUALIZAR_CAMPO",
      "config": {
        "entidade": "LEAD",
        "campo": "score",
        "valor": {"ref": "score_final"}
      }
    },
    {
      "ordem": 2,
      "tipo": "ATUALIZAR_CAMPO",
      "config": {
        "entidade": "LEAD",
        "campo": "classificacao",
        "valor": {"ref": "classificacao"}
      }
    }
  ],
  
  "retorno": {
    "campos": ["score_final", "classificacao", "pontos_valor", "pontos_uf", "pontos_tempo", "pontos_interacoes", "pontos_indicacao"]
  }
}
```

---

## Exemplo 5: Comissao Escalonada Multi-Criterio {#exemplo-5}

### Requisito de Negocio

> Comissao variavel baseada em:
> - Faixa de quantidade vendida (escalonada)
> - Tipo de plano (multiplicador)
> - Antiguidade do consultor (bonus adicional)
> - Regiao de atuacao (ajuste regional)

### Definicao JSON da Regra

```json
{
  "versao_schema": "2.0",
  "metadata": {
    "codigo": "REG-COM-ESCALONADA-001",
    "nome": "Comissao Escalonada Multi-Criterio",
    "categoria": "COMISSAO",
    "escopo": {"tipo": "GLOBAL"}
  },
  
  "data_providers": ["PLACA", "CONSULTOR"],
  
  "tabelas_auxiliares": {
    "faixas_comissao": [
      {"min": 0, "max": 5, "percentual": 0.05},
      {"min": 6, "max": 10, "percentual": 0.07},
      {"min": 11, "max": 20, "percentual": 0.09},
      {"min": 21, "max": null, "percentual": 0.12}
    ],
    "multiplicador_plano": {
      "BRONZE": 1.0,
      "PRATA": 1.1,
      "OURO": 1.2,
      "PLATINUM": 1.4
    },
    "ajuste_regional": {
      "SP": 1.0,
      "RJ": 0.95,
      "MG": 0.90,
      "SUL": 0.85,
      "OUTROS": 0.80
    }
  },
  
  "variaveis": [
    {
      "nome": "qtd_vendas_mes",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "PLACA",
        "funcao": "COUNT",
        "campo": "id",
        "filtros": [
          {"campo": "consultor_id", "operador": "=", "valor": "@contexto.consultor_id"},
          {"campo": "data_fechamento", "operador": "BETWEEN", "valor": ["@periodo.inicio", "@periodo.fim"]}
        ]
      }
    },
    {
      "nome": "valor_total_vendas",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "PLACA",
        "funcao": "SUM",
        "campo": "valor_plano",
        "filtros": [
          {"campo": "consultor_id", "operador": "=", "valor": "@contexto.consultor_id"},
          {"campo": "data_fechamento", "operador": "BETWEEN", "valor": ["@periodo.inicio", "@periodo.fim"]}
        ]
      }
    },
    {
      "nome": "tipo_plano_predominante",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "PLACA",
        "funcao": "MODE",
        "campo": "tipo_plano",
        "filtros": [
          {"campo": "consultor_id", "operador": "=", "valor": "@contexto.consultor_id"},
          {"campo": "data_fechamento", "operador": "BETWEEN", "valor": ["@periodo.inicio", "@periodo.fim"]}
        ]
      }
    },
    {
      "nome": "meses_atuacao",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "CONSULTOR",
        "funcao": "CUSTOM",
        "expressao": "EXTRACT(MONTH FROM AGE(NOW(), data_admissao))"
      }
    },
    {
      "nome": "regiao_consultor",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "CONSULTOR",
        "funcao": "FIRST",
        "campo": "regiao"
      }
    },
    {
      "nome": "percentual_faixa",
      "tipo": "LOOKUP",
      "config": {
        "tabela": "faixas_comissao",
        "condicao": "qtd_vendas_mes >= min AND (max IS NULL OR qtd_vendas_mes <= max)",
        "retorno": "percentual"
      }
    },
    {
      "nome": "multiplicador_tipo",
      "tipo": "LOOKUP",
      "config": {
        "tabela": "multiplicador_plano",
        "chave": "tipo_plano_predominante"
      }
    },
    {
      "nome": "ajuste_regiao",
      "tipo": "LOOKUP",
      "config": {
        "tabela": "ajuste_regional",
        "chave": "regiao_consultor"
      }
    },
    {
      "nome": "bonus_antiguidade",
      "tipo": "FORMULA",
      "config": {
        "expressao": "CASE WHEN meses_atuacao >= 24 THEN 0.02 WHEN meses_atuacao >= 12 THEN 0.01 ELSE 0 END"
      }
    },
    {
      "nome": "comissao_base",
      "tipo": "FORMULA",
      "config": {
        "expressao": "valor_total_vendas * percentual_faixa"
      }
    },
    {
      "nome": "comissao_ajustada",
      "tipo": "FORMULA",
      "config": {
        "expressao": "comissao_base * multiplicador_tipo * ajuste_regiao"
      }
    },
    {
      "nome": "comissao_final",
      "tipo": "FORMULA",
      "config": {
        "expressao": "comissao_ajustada + (valor_total_vendas * bonus_antiguidade)"
      }
    }
  ],
  
  "condicoes": {
    "tipo": "AND",
    "expressoes": [
      {"variavel": "qtd_vendas_mes", "operador": ">=", "valor": 1}
    ]
  },
  
  "acoes": [
    {
      "tipo": "ADICIONAR_VALOR",
      "config": {
        "destino_tipo": "COMISSAO",
        "valor": {"ref": "comissao_final"}
      }
    }
  ]
}
```

---

## Exemplo 6: Split com Override Hierarquico {#exemplo-6}

### Requisito de Negocio

> Venda realizada em parceria:
> - Consultor A (captacao): 40% da comissao
> - Consultor B (fechamento): 60% da comissao
> - Gerente de A: 2% override sobre parte de A
> - Gerente de B: 2% override sobre parte de B
> - Diretor regional: 1% sobre total

### Definicao JSON da Regra

```json
{
  "versao_schema": "2.0",
  "metadata": {
    "codigo": "REG-SPLIT-OVERRIDE-001",
    "nome": "Split com Override Hierarquico",
    "categoria": "SPLIT",
    "escopo": {"tipo": "GLOBAL"}
  },
  
  "data_providers": ["VENDA", "CONSULTOR", "HIERARQUIA"],
  
  "parametros_entrada": {
    "venda_id": {"tipo": "UUID", "obrigatorio": true},
    "consultor_captacao_id": {"tipo": "UUID", "obrigatorio": true},
    "consultor_fechamento_id": {"tipo": "UUID", "obrigatorio": true}
  },
  
  "variaveis": [
    {
      "nome": "valor_venda",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "VENDA",
        "funcao": "FIRST",
        "campo": "valor_total"
      }
    },
    {
      "nome": "comissao_total",
      "tipo": "FORMULA",
      "config": {
        "expressao": "valor_venda * 0.08"
      }
    },
    {
      "nome": "parte_captacao",
      "tipo": "FORMULA",
      "config": {
        "expressao": "comissao_total * 0.40"
      }
    },
    {
      "nome": "parte_fechamento",
      "tipo": "FORMULA",
      "config": {
        "expressao": "comissao_total * 0.60"
      }
    },
    {
      "nome": "gerente_captacao",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "HIERARQUIA",
        "funcao": "FIRST",
        "campo": "gerente_id",
        "filtros": [
          {"campo": "consultor_id", "operador": "=", "valor": "@params.consultor_captacao_id"}
        ]
      }
    },
    {
      "nome": "gerente_fechamento",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "HIERARQUIA",
        "funcao": "FIRST",
        "campo": "gerente_id",
        "filtros": [
          {"campo": "consultor_id", "operador": "=", "valor": "@params.consultor_fechamento_id"}
        ]
      }
    },
    {
      "nome": "diretor_regional",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "HIERARQUIA",
        "funcao": "FIRST",
        "campo": "diretor_id",
        "filtros": [
          {"campo": "consultor_id", "operador": "=", "valor": "@params.consultor_captacao_id"}
        ]
      }
    },
    {
      "nome": "override_gerente_capt",
      "tipo": "FORMULA",
      "config": {
        "expressao": "parte_captacao * 0.02"
      }
    },
    {
      "nome": "override_gerente_fech",
      "tipo": "FORMULA",
      "config": {
        "expressao": "parte_fechamento * 0.02"
      }
    },
    {
      "nome": "override_diretor",
      "tipo": "FORMULA",
      "config": {
        "expressao": "comissao_total * 0.01"
      }
    }
  ],
  
  "condicoes": {
    "tipo": "AND",
    "expressoes": [
      {"variavel": "valor_venda", "operador": ">", "valor": 0}
    ]
  },
  
  "acoes": [
    {
      "ordem": 1,
      "tipo": "ADICIONAR_VALOR",
      "config": {
        "beneficiario": "@params.consultor_captacao_id",
        "destino_tipo": "COMISSAO",
        "valor": {"ref": "parte_captacao"},
        "descricao": "Split 40% - Captacao"
      }
    },
    {
      "ordem": 2,
      "tipo": "ADICIONAR_VALOR",
      "config": {
        "beneficiario": "@params.consultor_fechamento_id",
        "destino_tipo": "COMISSAO",
        "valor": {"ref": "parte_fechamento"},
        "descricao": "Split 60% - Fechamento"
      }
    },
    {
      "ordem": 3,
      "tipo": "ADICIONAR_VALOR",
      "condicao": {"variavel": "gerente_captacao", "operador": "IS_NOT_NULL"},
      "config": {
        "beneficiario": {"ref": "gerente_captacao"},
        "destino_tipo": "OVERRIDE",
        "valor": {"ref": "override_gerente_capt"},
        "descricao": "Override 2% Gerente Captacao"
      }
    },
    {
      "ordem": 4,
      "tipo": "ADICIONAR_VALOR",
      "condicao": {"variavel": "gerente_fechamento", "operador": "IS_NOT_NULL"},
      "config": {
        "beneficiario": {"ref": "gerente_fechamento"},
        "destino_tipo": "OVERRIDE",
        "valor": {"ref": "override_gerente_fech"},
        "descricao": "Override 2% Gerente Fechamento"
      }
    },
    {
      "ordem": 5,
      "tipo": "ADICIONAR_VALOR",
      "condicao": {"variavel": "diretor_regional", "operador": "IS_NOT_NULL"},
      "config": {
        "beneficiario": {"ref": "diretor_regional"},
        "destino_tipo": "OVERRIDE",
        "valor": {"ref": "override_diretor"},
        "descricao": "Override 1% Diretor Regional"
      }
    }
  ]
}
```

---

## Exemplo 7: Campanha Temporal com Gatilhos {#exemplo-7}

### Requisito de Negocio

> Campanha de fim de ano (Dezembro):
> - 1 a 15/12: Bonus de R$ 100 por plano PLATINUM
> - 16 a 25/12: Bonus de R$ 150 por plano PLATINUM (sprint final)
> - Se atingir 20 vendas no mes: Bonus extra de R$ 2.000
> - Se for top 3 vendedor da regional: +R$ 1.000

### Definicao JSON da Regra

```json
{
  "versao_schema": "2.0",
  "metadata": {
    "codigo": "REG-CAMP-FIMANO-001",
    "nome": "Campanha Fim de Ano 2026",
    "categoria": "PREMIACAO",
    "escopo": {"tipo": "GLOBAL"},
    "vigencia": {
      "inicio": "2026-12-01",
      "fim": "2026-12-25"
    }
  },
  
  "data_providers": ["PLACA", "RANKING"],
  
  "variaveis": [
    {
      "nome": "data_venda",
      "tipo": "INPUT",
      "config": {"tipo_dado": "DATE"}
    },
    {
      "nome": "tipo_plano",
      "tipo": "INPUT",
      "config": {"tipo_dado": "STRING"}
    },
    {
      "nome": "dia_mes",
      "tipo": "FORMULA",
      "config": {
        "expressao": "EXTRACT(DAY FROM data_venda)"
      }
    },
    {
      "nome": "bonus_unitario",
      "tipo": "FORMULA",
      "config": {
        "expressao": "CASE WHEN dia_mes BETWEEN 1 AND 15 THEN 100 WHEN dia_mes BETWEEN 16 AND 25 THEN 150 ELSE 0 END"
      }
    },
    {
      "nome": "qtd_platinum_mes",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "PLACA",
        "funcao": "COUNT",
        "campo": "id",
        "filtros": [
          {"campo": "consultor_id", "operador": "=", "valor": "@contexto.consultor_id"},
          {"campo": "mes_fechamento", "operador": "=", "valor": 12},
          {"campo": "ano_fechamento", "operador": "=", "valor": 2026},
          {"campo": "tipo_plano", "operador": "=", "valor": "PLATINUM"}
        ]
      }
    },
    {
      "nome": "qtd_total_mes",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "PLACA",
        "funcao": "COUNT",
        "campo": "id",
        "filtros": [
          {"campo": "consultor_id", "operador": "=", "valor": "@contexto.consultor_id"},
          {"campo": "mes_fechamento", "operador": "=", "valor": 12},
          {"campo": "ano_fechamento", "operador": "=", "valor": 2026}
        ]
      }
    },
    {
      "nome": "posicao_ranking",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "RANKING",
        "funcao": "FIRST",
        "campo": "posicao",
        "filtros": [
          {"campo": "consultor_id", "operador": "=", "valor": "@contexto.consultor_id"},
          {"campo": "mes", "operador": "=", "valor": 12},
          {"campo": "ano", "operador": "=", "valor": 2026},
          {"campo": "tipo", "operador": "=", "valor": "REGIONAL"}
        ]
      }
    },
    {
      "nome": "bonus_platinum",
      "tipo": "FORMULA",
      "config": {
        "expressao": "CASE WHEN tipo_plano = 'PLATINUM' THEN bonus_unitario ELSE 0 END"
      }
    },
    {
      "nome": "bonus_meta_20",
      "tipo": "FORMULA",
      "config": {
        "expressao": "CASE WHEN qtd_total_mes >= 20 THEN 2000 ELSE 0 END"
      }
    },
    {
      "nome": "bonus_top3",
      "tipo": "FORMULA",
      "config": {
        "expressao": "CASE WHEN posicao_ranking <= 3 THEN 1000 ELSE 0 END"
      }
    },
    {
      "nome": "total_premios",
      "tipo": "FORMULA",
      "config": {
        "expressao": "bonus_platinum + bonus_meta_20 + bonus_top3"
      }
    }
  ],
  
  "condicoes": {
    "tipo": "AND",
    "expressoes": [
      {"variavel": "total_premios", "operador": ">", "valor": 0}
    ]
  },
  
  "acoes": [
    {
      "ordem": 1,
      "tipo": "ADICIONAR_VALOR",
      "condicao": {"variavel": "bonus_platinum", "operador": ">", "valor": 0},
      "config": {
        "destino_tipo": "PREMIACAO",
        "valor": {"ref": "bonus_platinum"},
        "descricao": "Campanha Fim de Ano - Bonus Platinum"
      }
    },
    {
      "ordem": 2,
      "tipo": "ADICIONAR_VALOR",
      "condicao": {"variavel": "bonus_meta_20", "operador": ">", "valor": 0},
      "config": {
        "destino_tipo": "PREMIACAO",
        "valor": {"ref": "bonus_meta_20"},
        "descricao": "Campanha Fim de Ano - Meta 20 vendas"
      }
    },
    {
      "ordem": 3,
      "tipo": "ADICIONAR_VALOR",
      "condicao": {"variavel": "bonus_top3", "operador": ">", "valor": 0},
      "config": {
        "destino_tipo": "PREMIACAO",
        "valor": {"ref": "bonus_top3"},
        "descricao": "Campanha Fim de Ano - Top 3 Regional"
      }
    }
  ]
}
```

---

## Exemplo 8: Desconto Progressivo por Perfil {#exemplo-8}

### Requisito de Negocio

> Calcular desconto maximo permitido em cotacao:
> - Base pelo tempo de relacionamento do associado
> - Ajuste por historico de sinistros
> - Bonus por indicacao de outros clientes
> - Limite maximo por perfil de risco

### Definicao JSON da Regra

```json
{
  "versao_schema": "2.0",
  "metadata": {
    "codigo": "REG-DESC-PERFIL-001",
    "nome": "Desconto Progressivo por Perfil",
    "categoria": "DESCONTO",
    "escopo": {"tipo": "GLOBAL"}
  },
  
  "data_providers": ["ASSOCIADO", "SINISTRO", "INDICACAO"],
  
  "variaveis": [
    {
      "nome": "tempo_relacionamento_meses",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "ASSOCIADO",
        "funcao": "CUSTOM",
        "expressao": "EXTRACT(MONTH FROM AGE(NOW(), data_adesao))"
      }
    },
    {
      "nome": "qtd_sinistros_12m",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "SINISTRO",
        "funcao": "COUNT",
        "campo": "id",
        "filtros": [
          {"campo": "associado_id", "operador": "=", "valor": "@contexto.associado_id"},
          {"campo": "data_ocorrencia", "operador": ">=", "valor": "@hoje - 12 MONTHS"}
        ]
      }
    },
    {
      "nome": "qtd_indicacoes",
      "tipo": "AGREGACAO",
      "config": {
        "provider": "INDICACAO",
        "funcao": "COUNT",
        "campo": "id",
        "filtros": [
          {"campo": "indicador_id", "operador": "=", "valor": "@contexto.associado_id"},
          {"campo": "status", "operador": "=", "valor": "CONVERTIDO"}
        ]
      }
    },
    {
      "nome": "perfil_risco",
      "tipo": "INPUT",
      "config": {
        "tipo_dado": "STRING",
        "valores_permitidos": ["BAIXO", "MEDIO", "ALTO"]
      }
    },
    {
      "nome": "desconto_tempo",
      "tipo": "FORMULA",
      "config": {
        "expressao": "LEAST(FLOOR(tempo_relacionamento_meses / 12) * 2, 10)"
      }
    },
    {
      "nome": "ajuste_sinistro",
      "tipo": "FORMULA",
      "config": {
        "expressao": "CASE WHEN qtd_sinistros_12m = 0 THEN 3 WHEN qtd_sinistros_12m = 1 THEN 0 ELSE -5 END"
      }
    },
    {
      "nome": "bonus_indicacao",
      "tipo": "FORMULA",
      "config": {
        "expressao": "LEAST(qtd_indicacoes * 1, 5)"
      }
    },
    {
      "nome": "limite_perfil",
      "tipo": "FORMULA",
      "config": {
        "expressao": "CASE WHEN perfil_risco = 'BAIXO' THEN 20 WHEN perfil_risco = 'MEDIO' THEN 15 ELSE 10 END"
      }
    },
    {
      "nome": "desconto_calculado",
      "tipo": "FORMULA",
      "config": {
        "expressao": "desconto_tempo + ajuste_sinistro + bonus_indicacao"
      }
    },
    {
      "nome": "desconto_final",
      "tipo": "FORMULA",
      "config": {
        "expressao": "LEAST(GREATEST(desconto_calculado, 0), limite_perfil)"
      }
    }
  ],
  
  "condicoes": {
    "tipo": "AND",
    "expressoes": [
      {"constante": true}
    ]
  },
  
  "acoes": [
    {
      "tipo": "RETORNAR_VALOR",
      "config": {
        "campo": "desconto_maximo_percentual",
        "valor": {"ref": "desconto_final"}
      }
    }
  ],
  
  "retorno": {
    "campos": ["desconto_final", "desconto_tempo", "ajuste_sinistro", "bonus_indicacao", "limite_perfil"],
    "formato": {
      "desconto_final": "PERCENTUAL"
    }
  }
}
```

---

## Resumo de Capacidades

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                    CAPACIDADES DO MOTOR DE REGRAS v2.0                          │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  TIPOS DE VARIAVEIS                                                             │
│  ├── INPUT: Dados fornecidos na chamada                                         │
│  ├── CONSTANTE: Valores fixos na regra                                          │
│  ├── AGREGACAO: Consulta a Data Providers (COUNT, SUM, AVG, MIN, MAX, etc)      │
│  ├── FORMULA: Expressoes matematicas e logicas                                  │
│  └── LOOKUP: Consulta a tabelas auxiliares                                      │
│                                                                                 │
│  OPERADORES SUPORTADOS                                                          │
│  ├── Comparacao: =, !=, >, <, >=, <=, BETWEEN, IN, NOT IN                       │
│  ├── Texto: LIKE, STARTS_WITH, ENDS_WITH, CONTAINS                              │
│  ├── Nulos: IS_NULL, IS_NOT_NULL                                                │
│  └── Logicos: AND, OR, NOT                                                      │
│                                                                                 │
│  FUNCOES DE AGREGACAO                                                           │
│  ├── COUNT, SUM, AVG, MIN, MAX                                                  │
│  ├── FIRST, LAST, MODE                                                          │
│  └── CUSTOM (expressao SQL customizada)                                         │
│                                                                                 │
│  FUNCOES MATEMATICAS                                                            │
│  ├── FLOOR, CEIL, ROUND, ABS                                                    │
│  ├── GREATEST, LEAST, POWER, SQRT                                               │
│  └── CASE WHEN / THEN / ELSE / END                                              │
│                                                                                 │
│  TIPOS DE ACOES                                                                 │
│  ├── ADICIONAR_VALOR: Creditar em conta (COMISSAO, BONUS, RESIDUAL, etc)        │
│  ├── ATUALIZAR_CAMPO: Modificar campo de entidade                               │
│  ├── NOTIFICAR: Enviar notificacao                                              │
│  ├── CRIAR_TAREFA: Criar tarefa no workflow                                     │
│  ├── WEBHOOK: Chamar servico externo                                            │
│  └── RETORNAR_VALOR: Retornar resultado sem persistir                           │
│                                                                                 │
│  CONTEXTO DISPONIVEL                                                            │
│  ├── @contexto.consultor_id, @contexto.associado_id, etc                        │
│  ├── @periodo.inicio, @periodo.fim, @periodo.ano, @periodo.mes                  │
│  ├── @params.* (parametros de entrada)                                          │
│  └── @hoje, @agora                                                              │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Historico de Alteracoes

| Versao | Data | Autor | Alteracao |
|--------|------|-------|-----------|
| 2.0 | 29/01/2026 | PO | Criacao com arquitetura de alta abstracao |
