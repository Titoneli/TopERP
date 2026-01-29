# US-CRM-MTR-006: Versionamento, Auditoria e Performance

> **Modulo**: CRM-Motor-Regras  
> **Versao**: 2.0  
> **Data**: 29/01/2026  
> **Status**: Pronto para Desenvolvimento  
> **Story Points**: 34

---

## Historia de Usuario

**Como** gestor de regras de negocio,  
**Quero** controlar versoes das regras, auditar todas as execucoes e monitorar performance,  
**Para** garantir governanca, rastreabilidade e otimizacao do motor de regras.

---

## Descricao

Esta historia implementa:

1. **Versionamento de Regras**: Controle de versoes com aprovacao
2. **Workflow de Aprovacao**: Fluxo de rascunho -> aprovacao -> publicacao
3. **Auditoria Completa**: Registro de todas as execucoes
4. **Dashboard de Performance**: Metricas e alertas
5. **Cache Inteligente**: Otimizacao de execucao

---

## Criterios de Aceitacao

### CA-001: Ciclo de Vida de Versoes

- [ ] Status: RASCUNHO -> EM_APROVACAO -> ATIVA -> INATIVA
- [ ] Criar nova versao a partir da ativa
- [ ] Multiplas versoes podem existir (apenas uma ativa)
- [ ] Rollback para versao anterior
- [ ] Historico completo de versoes

**Diagrama de Estados:**

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                      CICLO DE VIDA DE VERSAO                                    │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│                          ┌─────────────┐                                        │
│                 Criar    │  RASCUNHO   │                                        │
│               ─────────► │             │                                        │
│                          └──────┬──────┘                                        │
│                                 │ Enviar para aprovacao                         │
│                                 ▼                                               │
│                          ┌─────────────┐                                        │
│                          │ EM_APROVACAO│                                        │
│                          │             │                                        │
│                          └──────┬──────┘                                        │
│                    Rejeitar │   │ Aprovar                                       │
│                    ┌────────┘   └────────┐                                      │
│                    ▼                     ▼                                      │
│             ┌─────────────┐       ┌─────────────┐                               │
│             │  RASCUNHO   │       │    ATIVA    │                               │
│             │ (revisao)   │       │             │                               │
│             └─────────────┘       └──────┬──────┘                               │
│                                          │ Nova versao ou                       │
│                                          │ Desativar                            │
│                                          ▼                                      │
│                                   ┌─────────────┐                               │
│                                   │   INATIVA   │                               │
│                                   │             │                               │
│                                   └─────────────┘                               │
│                                          │                                      │
│                                          ▼                                      │
│                                   Reativar (se permitido)                       │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### CA-002: Workflow de Aprovacao

- [ ] Regra em RASCUNHO pode ser editada livremente
- [ ] Enviar para aprovacao cria snapshot imutavel
- [ ] Aprovador recebe notificacao
- [ ] Aprovador pode: Aprovar, Rejeitar com comentario, Solicitar alteracao
- [ ] Aprovacao ativa a versao automaticamente
- [ ] Versao anterior passa para INATIVA

**Interface de Aprovacao:**

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  APROVACAO DE REGRA                                                             │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  Regra: REG-BONUS-SP-AUTO-001                                                   │
│  Versao: 2 (pendente aprovacao)                                                │
│  Solicitante: Maria Santos                                                      │
│  Data Solicitacao: 29/01/2026 14:30                                             │
│                                                                                 │
│  ALTERACOES EM RELACAO A VERSAO ANTERIOR                                       │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │ + Adicionado filtro: valor_veiculo < 50000                              │   │
│  │ ~ Alterado: bonus de R$ 500 para R$ 800 por faixa                       │   │
│  │ - Removido: filtro por regiao                                           │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  SIMULACOES REALIZADAS                                                         │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │ 6 cenarios testados | 6 passaram | 0 falharam                           │   │
│  │ [Ver Detalhes dos Testes]                                               │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  COMENTARIO DO APROVADOR                                                        │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                                                                         │   │
│  │                                                                         │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  [✓ Aprovar e Ativar] [✗ Rejeitar] [↺ Solicitar Alteracao]                     │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### CA-003: Auditoria de Execucoes

- [ ] Registrar toda execucao em tabela particionada
- [ ] Dados registrados:
  - Regra e versao
  - Contexto de entrada
  - Valores de todas as variaveis
  - Resultado das condicoes
  - Acoes executadas
  - Tempo de execucao
  - Usuario/Sistema que disparou
- [ ] Nao registrar dados sensiveis (mascara)
- [ ] Retencao configuravel (padrao: 12 meses)

**Estrutura de Auditoria:**

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                         REGISTRO DE AUDITORIA                                   │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  execucao_id:     exec-550e8400-e29b-41d4-a716-446655440000                     │
│  regra_codigo:    REG-BONUS-SP-AUTO-001                                         │
│  regra_versao:    1                                                             │
│  data_execucao:   2026-01-29 15:30:45.123                                       │
│  tempo_ms:        45                                                            │
│  status:          APLICADA                                                      │
│                                                                                 │
│  CONTEXTO                                                                       │
│  {                                                                              │
│    "consultor_id": "550e8400-...",                                              │
│    "periodo_inicio": "2026-01-01",                                              │
│    "periodo_fim": "2026-01-31"                                                  │
│  }                                                                              │
│                                                                                 │
│  VARIAVEIS                                                                      │
│  {                                                                              │
│    "placas_sp_auto_50k": { "valor": 15, "tempo_ms": 12 },                       │
│    "meta_mes": { "valor": 10, "tempo_ms": 5 },                                  │
│    "pct_acima_meta": { "valor": 50, "tempo_ms": 1 },                            │
│    "faixas_10_pct": { "valor": 5, "tempo_ms": 1 },                              │
│    "valor_bonus": { "valor": 4000, "tempo_ms": 1 }                              │
│  }                                                                              │
│                                                                                 │
│  CONDICOES                                                                      │
│  {                                                                              │
│    "resultado": true,                                                           │
│    "expressoes": [                                                              │
│      { "expr": "placas_sp_auto_50k > meta_mes", "resultado": true },            │
│      { "expr": "faixas_10_pct >= 1", "resultado": true }                        │
│    ]                                                                            │
│  }                                                                              │
│                                                                                 │
│  ACOES                                                                          │
│  [                                                                              │
│    {                                                                            │
│      "tipo": "ADICIONAR_VALOR",                                                 │
│      "destino": "BONUS",                                                        │
│      "valor": 4000,                                                             │
│      "status": "EXECUTADA"                                                      │
│    }                                                                            │
│  ]                                                                              │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### CA-004: Dashboard de Performance

- [ ] Metricas em tempo real:
  - Execucoes por minuto/hora/dia
  - Tempo medio de execucao
  - Taxa de aplicacao (% regras aplicadas)
  - Taxa de erro
- [ ] Graficos de tendencia
- [ ] Alertas configuraveis
- [ ] Ranking de regras mais executadas
- [ ] Identificacao de gargalos

**Dashboard:**

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  DASHBOARD - MOTOR DE REGRAS                                    [Periodo: 24h ▼]   │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐│
│  │   EXECUCOES     │  │  TEMPO MEDIO    │  │ TAXA APLICACAO  │  │   TAXA ERRO     ││
│  │     12.456      │  │     47ms        │  │      78%        │  │      0.3%       ││
│  │  ↑ 15% vs ontem │  │  ↓ 5ms vs ontem │  │  ↑ 2% vs ontem  │  │  = igual ontem  ││
│  └─────────────────┘  └─────────────────┘  └─────────────────┘  └─────────────────┘│
│                                                                                     │
│  EXECUCOES POR HORA                                                                │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │    ▄                                                                        │   │
│  │    █ ▄                                            ▄                         │   │
│  │  ▄ █ █ ▄                                        ▄ █ ▄                       │   │
│  │  █ █ █ █ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ █ █ █                       │   │
│  │  ─────────────────────────────────────────────────────────────              │   │
│  │  00 02 04 06 08 10 12 14 16 18 20 22                                        │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  TOP 5 REGRAS MAIS EXECUTADAS              │  ALERTAS                              │
│  ┌──────────────────────────────────────┐  │  ┌────────────────────────────────┐  │
│  │ 1. REG-BONUS-SP-AUTO-001    3.245    │  │  │ ⚠ REG-COMISSAO-002 lenta       │  │
│  │ 2. REG-RESIDUAL-001         2.890    │  │  │   Tempo medio: 250ms (>200ms)  │  │
│  │ 3. REG-LEAD-SCORE-001       2.456    │  │  │   [Ver Detalhes]               │  │
│  │ 4. REG-COMISSAO-001         1.987    │  │  │                                │  │
│  │ 5. REG-DESCONTO-001         1.234    │  │  │ ✓ Nenhum erro critico          │  │
│  └──────────────────────────────────────┘  │  └────────────────────────────────┘  │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### CA-005: Cache Inteligente

- [ ] Cache de resultados de agregacao (TTL configuravel)
- [ ] Cache de regras compiladas em memoria
- [ ] Invalidacao automatica quando regra alterada
- [ ] Metricas de hit/miss do cache
- [ ] Configuracao por regra (habilitar/desabilitar)

**Configuracao de Cache:**

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  CONFIGURACAO DE CACHE                                                          │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  CACHE DE REGRAS COMPILADAS                                                     │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │ Status: ✓ Ativo                                                         │   │
│  │ TTL: 3600 segundos (1 hora)                                             │   │
│  │ Tamanho maximo: 100 regras                                              │   │
│  │ Hit rate atual: 94%                                                     │   │
│  │ [Limpar Cache]                                                          │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  CACHE DE AGREGACOES                                                            │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │ Status: ✓ Ativo                                                         │   │
│  │ TTL padrao: 300 segundos (5 minutos)                                    │   │
│  │ Hit rate atual: 67%                                                     │   │
│  │                                                                         │   │
│  │ CONFIGURACAO POR PROVIDER                                               │   │
│  │ ────────────────────────                                                │   │
│  │ PLACA       │ TTL: 300s  │ ✓ Ativo │                                    │   │
│  │ BOLETO      │ TTL: 60s   │ ✓ Ativo │                                    │   │
│  │ META        │ TTL: 3600s │ ✓ Ativo │                                    │   │
│  │ CONSULTOR   │ TTL: 3600s │ ✓ Ativo │                                    │   │
│  │ LEAD        │ TTL: 60s   │ ✓ Ativo │                                    │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### CA-006: Relatorios de Auditoria

- [ ] Relatorio de execucoes por periodo
- [ ] Relatorio de alteracoes de regras
- [ ] Relatorio de aprovacoes
- [ ] Exportacao CSV/PDF
- [ ] Agendamento de relatorios

### CA-007: Permissoes e Papeis

- [ ] Papel: VISUALIZADOR - apenas visualiza
- [ ] Papel: EDITOR - cria e edita regras
- [ ] Papel: APROVADOR - aprova regras
- [ ] Papel: ADMINISTRADOR - configura sistema
- [ ] Escopo por categoria de regra

---

## Mockups

### Tela: Historico de Versoes

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  HISTORICO DE VERSOES - REG-BONUS-SP-AUTO-001                                      │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  ┌──────────────────────────────────────────────────────────────────────────────┐  │
│  │ Versao │ Status  │ Criado Por      │ Data        │ Aprovado Por   │ Acoes    │  │
│  ├──────────────────────────────────────────────────────────────────────────────┤  │
│  │ v3     │ RASCUNHO│ Maria Santos    │ 29/01/2026  │ -              │ [Editar] │  │
│  │ v2     │ ATIVA   │ Maria Santos    │ 28/01/2026  │ Joao Gestor    │ [Ver]    │  │
│  │ v1     │ INATIVA │ Carlos Silva    │ 15/01/2026  │ Joao Gestor    │ [Ver]    │  │
│  └──────────────────────────────────────────────────────────────────────────────┘  │
│                                                                                     │
│  [Comparar v2 com v1] [Rollback para v1]                                           │
│                                                                                     │
│  ALTERACOES v1 -> v2                                                               │
│  ┌──────────────────────────────────────────────────────────────────────────────┐  │
│  │ + Adicionado filtro valor_veiculo < 50000                                    │  │
│  │ ~ Alterado valor bonus de R$ 500 para R$ 800 por faixa                       │  │
│  │ ~ Alterado nome de "Bonus SP Auto" para "Bonus SP Automovel ate 50k"         │  │
│  └──────────────────────────────────────────────────────────────────────────────┘  │
│                                                                                     │
│  JUSTIFICATIVA DA ALTERACAO                                                        │
│  ┌──────────────────────────────────────────────────────────────────────────────┐  │
│  │ "Ajuste para focar em veiculos de menor valor e aumentar incentivo           │  │
│  │  para superar meta." - Maria Santos                                          │  │
│  └──────────────────────────────────────────────────────────────────────────────┘  │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

---

## Cenarios de Teste

### CT-001: Fluxo de Aprovacao

**Dado** regra em status RASCUNHO  
**E** usuario com papel EDITOR  
**Quando** envia para aprovacao  
**Entao** status muda para EM_APROVACAO  
**E** aprovador recebe notificacao  
**E** regra fica imutavel

### CT-002: Aprovacao e Ativacao

**Dado** regra em EM_APROVACAO  
**E** usuario com papel APROVADOR  
**Quando** aprova a regra  
**Entao** nova versao fica ATIVA  
**E** versao anterior fica INATIVA  
**E** cache invalidado

### CT-003: Auditoria de Execucao

**Dado** regra ATIVA executada  
**Quando** execucao completa  
**Entao** registro criado em mtr.execucao  
**E** todos os campos preenchidos  
**E** particao correta selecionada

### CT-004: Alerta de Performance

**Dado** regra com tempo medio configurado em 100ms  
**E** execucao levando 250ms consistentemente  
**Quando** monitoramento verifica  
**Entao** alerta gerado  
**E** notificacao enviada ao administrador

---

## Regras de Negocio

| Codigo | Regra | Validacao |
|--------|-------|-----------|
| RN-001 | Versao unica ativa | Apenas uma versao ATIVA por regra |
| RN-002 | Aprovacao obrigatoria | Regra so ativa apos aprovacao |
| RN-003 | Auto-aprovacao bloqueada | Editor nao pode aprovar propria regra |
| RN-004 | Auditoria imutavel | Registros de auditoria nao podem ser alterados |
| RN-005 | Retencao minima | Auditoria mantida por no minimo 12 meses |

---

## Estimativa Detalhada

| Item | Horas | SP |
|------|-------|-----|
| Versionamento de Regras | 24h | 8 |
| Workflow de Aprovacao | 24h | 5 |
| Auditoria de Execucoes | 24h | 8 |
| Dashboard de Performance | 24h | 5 |
| Cache Inteligente | 24h | 5 |
| Permissoes e Papeis | 8h | 2 |
| Testes | 4h | 1 |
| **TOTAL** | **132h** | **34** |

---

## Historico de Alteracoes

| Versao | Data | Autor | Alteracao |
|--------|------|-------|-----------|
| 1.0 | 29/01/2026 | PO | Versao inicial |
| 2.0 | 29/01/2026 | PO | Reescrita para arquitetura de alta abstracao |
