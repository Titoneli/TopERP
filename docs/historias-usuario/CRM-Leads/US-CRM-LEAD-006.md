# US-CRM-LEAD-006 — Qualificar Lead (BANT)

## História de Usuário

**Como** consultor de vendas,  
**Quero** qualificar leads usando a metodologia BANT,  
**Para** priorizar meu atendimento nos leads com maior probabilidade de conversão.

## Prioridade

Importante

## Estimativa

5 SP

---

## Contexto de Negócio

A qualificação BANT (Budget, Authority, Need, Timeline) é uma metodologia consagrada para avaliar a prontidão de um lead para compra. No contexto de proteção veicular:

| Dimensão | Pergunta Central | Adaptação TopBrasil |
|----------|------------------|---------------------|
| **Budget** (Orçamento) | O lead tem capacidade financeira? | Renda compatível com plano desejado |
| **Authority** (Autoridade) | O lead decide a compra? | É o proprietário do veículo? |
| **Need** (Necessidade) | Existe necessidade real? | Veículo está descoberto/seguro vencido? |
| **Timeline** (Prazo) | Quando pretende decidir? | Urgência de proteção |

### Benefícios da Qualificação

| Benefício | Impacto |
|-----------|---------|
| Priorização | Consultores focam em leads quentes |
| Eficiência | Redução de tempo em leads frios |
| Conversão | Aumento da taxa de fechamento |
| Forecast | Previsibilidade de vendas |

---

## Fluxo de Qualificação

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        FLUXO DE QUALIFICAÇÃO BANT                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────────┐                                                           │
│   │    LEAD     │                                                           │
│   │    NOVO     │                                                           │
│   └──────┬──────┘                                                           │
│          │                                                                  │
│          ▼                                                                  │
│   ┌──────────────────────────────────────────────────────────────────────┐  │
│   │                    QUESTIONÁRIO BANT                                 │  │
│   │                                                                      │  │
│   │  ┌───────────┐   ┌───────────┐   ┌───────────┐   ┌───────────┐       │  │
│   │  │  BUDGET   │   │ AUTHORITY │   │   NEED    │   │  TIMELINE │       │  │
│   │  │ Orçamento │   │ Decisor?  │   │Necessidade│   │   Prazo   │       │  │
│   │  │   0-3     │   │   0-3     │   │   0-3     │   │   0-3     │       │  │
│   │  └─────┬─────┘   └─────┬─────┘   └─────┬─────┘   └─────┬─────┘       │  │
│   │        │               │               │               │             │  │
│   │        └───────────────┴───────┬───────┴───────────────┘             │  │
│   │                                │                                     │  │
│   │                                ▼                                     │  │
│   │                    ┌───────────────────────┐                         │  │
│   │                    │   SCORE TOTAL (0-12)  │                         │  │
│   │                    └───────────┬───────────┘                         │  │
│   └──────────────────────────────────────────────────────────────────────┘  │
│                                    │                                        │
│          ┌─────────────────────────┼─────────────────────────┐              │
│          │                         │                         │              │
│          ▼                         ▼                         ▼              │
│   ┌─────────────┐          ┌─────────────┐          ┌─────────────┐         │
│   │    FRIO     │          │    MORNO    │          │   QUENTE    │         │
│   │   (0-4)     │          │   (5-8)     │          │   (9-12)    │         │
│   │             │          │             │          │             │         │
│   │ Nurturing   │          │ Follow-up   │          │ Prioridade  │         │
│   │ Automático  │          │  Regular    │          │   Máxima    │         │
│   └─────────────┘          └─────────────┘          └─────────────┘         │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Critérios BANT Detalhados

### B - Budget (Orçamento)

| Score | Critério | Indicador |
|-------|----------|-----------|
| 0 | Sem orçamento | Sem renda declarada ou incompatível |
| 1 | Orçamento limitado | Renda permite apenas plano básico |
| 2 | Orçamento adequado | Renda permite plano intermediário |
| 3 | Orçamento flexível | Renda permite qualquer plano |

**Perguntas sugeridas:**
- "Qual faixa de valor mensal você considera para proteção?"
- "Você já pesquisou valores de proteção veicular?"

### A - Authority (Autoridade)

| Score | Critério | Indicador |
|-------|----------|-----------|
| 0 | Sem autoridade | Não é proprietário, não decide |
| 1 | Influenciador | Pode influenciar, mas não decide |
| 2 | Co-decisor | Decide junto com outra pessoa |
| 3 | Decisor único | Proprietário e único decisor |

**Perguntas sugeridas:**
- "O veículo está em seu nome?"
- "Você é o responsável pela decisão de contratar proteção?"

### N - Need (Necessidade)

| Score | Critério | Indicador |
|-------|----------|-----------|
| 0 | Sem necessidade imediata | Veículo já protegido/segurado |
| 1 | Necessidade baixa | Seguro vence em mais de 3 meses |
| 2 | Necessidade média | Seguro vence em até 3 meses |
| 3 | Necessidade alta | Veículo sem proteção/seguro vencido |

**Perguntas sugeridas:**
- "Seu veículo está protegido atualmente?"
- "Quando vence seu seguro/proteção atual?"

### T - Timeline (Prazo)

| Score | Critério | Indicador |
|-------|----------|-----------|
| 0 | Sem prazo | "Estou apenas pesquisando" |
| 1 | Longo prazo | Pretende decidir em mais de 30 dias |
| 2 | Médio prazo | Pretende decidir em 15-30 dias |
| 3 | Curto prazo | Pretende decidir em até 15 dias |

**Perguntas sugeridas:**
- "Quando você pretende contratar a proteção?"
- "Há alguma urgência para proteger seu veículo?"

---

## Classificação do Lead

### Score Total e Temperatura

| Score | Classificação | Cor | Ação Recomendada |
|-------|---------------|-----|------------------|
| 0-4 | **FRIO** ❄️ | 🔵 Azul | Nurturing automático, e-mail marketing |
| 5-8 | **MORNO** 🌤️ | 🟡 Amarelo | Follow-up semanal, nutrição de conteúdo |
| 9-12 | **QUENTE** 🔥 | 🔴 Vermelho | Contato imediato, prioridade máxima |

### Regra de Desqualificação Automática

| Condição | Ação |
|----------|------|
| Budget = 0 AND Authority = 0 | Lead marcado como FRIO independente do total |
| Telefone blacklist | Lead bloqueado (não entra na qualificação) |

---

## Inputs e Outputs

### Campos de Entrada (Questionário)

| Campo | Tipo | Valores |
|-------|------|---------|
| budget_score | select | 0, 1, 2, 3 |
| authority_score | select | 0, 1, 2, 3 |
| need_score | select | 0, 1, 2, 3 |
| timeline_score | select | 0, 1, 2, 3 |
| observacoes | textarea | Texto livre |

### Campos Calculados (Output)

| Campo | Tipo | Cálculo |
|-------|------|---------|
| bant_score | integer | Soma dos 4 scores (0-12) |
| temperatura | enum | FRIO, MORNO, QUENTE |
| data_qualificacao | timestamp | Momento da qualificação |
| consultor_qualificador | uuid | ID do consultor |

---

## Critérios de Aceitação

### Cenário 1 — Qualificação completa
- **Dado que** acesso um lead com status `QUALIFICADO` (pós-captação)
- **Quando** preencho os 4 critérios BANT
- **E** clico em "Salvar Qualificação"
- **Então** o score BANT é calculado automaticamente
- **E** a temperatura do lead é definida (FRIO/MORNO/QUENTE)
- **E** o lead aparece na fila de prioridade correspondente

### Cenário 2 — Lead quente (score 9-12)
- **Dado que** qualifiquei um lead com score 10
- **Quando** a qualificação é salva
- **Então** o lead recebe temperatura `QUENTE` (dom_ind_temperatura)
- **E** aparece no topo da minha fila de atendimento
- **E** recebo notificação: "Lead quente! Contate imediatamente"

### Cenário 3 — Lead frio (score 0-4)
- **Dado que** qualifiquei um lead com score 3
- **Quando** a qualificação é salva
- **Então** o lead recebe temperatura `FRIO` (dom_ind_temperatura)
- **E** é direcionado para fluxo de nurturing automático
- **E** não aparece na fila de prioridade do consultor

### Cenário 4 — Requalificação de lead
- **Dado que** um lead já foi qualificado anteriormente
- **Quando** acesso a qualificação do lead
- **Então** vejo o histórico de qualificações anteriores
- **E** posso registrar nova qualificação
- **E** o histórico é mantido para análise

### Cenário 5 — Desqualificação automática
- **Dado que** marquei Budget = 0 e Authority = 0
- **Quando** salvo a qualificação
- **Então** o lead é automaticamente classificado como `FRIO` (dom_ind_temperatura)
- **E** recebo alerta: "Lead desqualificado por falta de orçamento e autoridade"

### Cenário 6 — Visualização de temperatura na lista
- **Dado que** estou na lista de leads
- **Quando** visualizo a coluna de temperatura (dom_ind_temperatura)
- **Então** vejo indicador colorido (🔵🟡🔴)
- **E** posso filtrar por temperatura

### Cenário 7 — Qualificação parcial
- **Dado que** não tenho informação sobre Timeline
- **Quando** preencho apenas Budget, Authority e Need
- **E** deixo Timeline em branco
- **Então** o sistema calcula score parcial (0-9)
- **E** marca "Qualificação incompleta" no lead

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Score BANT é a soma dos 4 critérios (0-12) |
| RN-002 | Temperatura (dom_ind_temperatura): FRIO (0-4), MORNO (5-8), QUENTE (9-12) |
| RN-003 | Budget=0 + Authority=0 = FRIO automático |
| RN-004 | Apenas consultores podem qualificar leads |
| RN-005 | Histórico de qualificações é mantido |
| RN-006 | Lead pode ser requalificado a qualquer momento |
| RN-007 | Qualificação parcial é permitida (mínimo 3 critérios) |
| RN-008 | Data e consultor são registrados automaticamente |
| RN-009 | Lead QUENTE notifica consultor imediatamente |
| RN-010 | Lead FRIO entra em fluxo de nurturing automático |

---

## Ações Possíveis

| Ação | Trigger | Resultado |
|------|---------|-----------|
| Qualificar Lead | Consultor preenche BANT | Score e temperatura calculados |
| Requalificar | Consultor edita BANT | Nova qualificação, histórico mantido |
| Filtrar por Temperatura (dom_ind_temperatura) | Seleção de filtro | Lista filtrada |
| Ordenar por Score | Click no header | Lista ordenada |
| Notificar | Lead QUENTE qualificado | Push para consultor |
| Iniciar Nurturing | Lead FRIO qualificado | Fluxo automático |

---

## Wireframe Conceitual

### Formulário de Qualificação BANT

```
┌─────────────────────────────────────────────────────────────────┐
│  📋 QUALIFICAÇÃO BANT                      Lead: João da Silva  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  💰 BUDGET (Orçamento)                                          │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  ○ 0 - Sem orçamento                                    │    │
│  │  ○ 1 - Orçamento limitado (apenas básico)               │    │
│  │  ● 2 - Orçamento adequado (intermediário)               │    │
│  │  ○ 3 - Orçamento flexível (qualquer plano)              │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  👤 AUTHORITY (Autoridade)                                      │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  ○ 0 - Não é proprietário, não decide                   │    │
│  │  ○ 1 - Influenciador                                    │    │
│  │  ○ 2 - Co-decisor                                       │    │
│  │  ● 3 - Decisor único / Proprietário                     │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  🎯 NEED (Necessidade)                                          │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  ○ 0 - Veículo já protegido                             │    │
│  │  ○ 1 - Seguro vence em +3 meses                         │    │
│  │  ● 2 - Seguro vence em até 3 meses                      │    │
│  │  ○ 3 - Sem proteção / Seguro vencido                    │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ⏰ TIMELINE (Prazo)                                            │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  ○ 0 - Apenas pesquisando                               │    │
│  │  ○ 1 - Decisão em +30 dias                              │    │
│  │  ● 2 - Decisão em 15-30 dias                            │    │
│  │  ○ 3 - Decisão em até 15 dias                           │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  📝 Observações                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ Cliente demonstrou interesse em plano OURO. Ligou       │    │
│  │ porque o seguro atual está caro.                        │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ════════════════════════════════════════════════════════════   │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  SCORE BANT: 9/12          Temperatura: 🔥 QUENTE       │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ┌────────────────┐  ┌─────────────────────────────────────┐    │
│  │    CANCELAR    │  │         💾 SALVAR QUALIFICAÇÃO      │    │
│  └────────────────┘  └─────────────────────────────────────┘    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Indicador de Temperatura na Lista

```
┌───────────────────────────────────────────────────────────────────────────┐
│  📋 MEUS LEADS                                   Filtro: [Todos ▼]        │
├───────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│  │ Nome           │ Telefone       │ BANT │ Temp  │ Status    │ Ações  │  │
│  │────────────────│────────────────│──────│───────│───────────│────────│  │
│  │ João da Silva  │ (11) 99999-9999│ 10   │ 🔥    │ Qualific. │ [Ver]  │  │
│  │ Maria Santos   │ (21) 88888-8888│ 7    │ 🌤️    │ Qualific. │ [Ver]  │  │
│  │ Pedro Oliveira │ (31) 77777-7777│ 3    │ ❄️    │ Nurturing │ [Ver]  │  │
│  │ Ana Costa      │ (11) 66666-6666│ 11   │ 🔥    │ Qualific. │ [Ver]  │  │
│  │ Carlos Lima    │ (41) 55555-5555│ -    │ ⚪    │ Pendente  │ [Qual] │  │
│                                                                           │
│  ⚪ Não qualificado  ❄️ Frio (0-4)  🌤️ Morno (5-8)  🔥 Quente (9-12)       │
│                                                                           │
└───────────────────────────────────────────────────────────────────────────┘
```

---

## Métricas Capturadas

| Métrica | Descrição | KPI |
|---------|-----------|-----|
| % Leads Qualificados | Leads com BANT preenchido | > 80% |
| Distribuição de Temperatura | % FRIO / MORNO / QUENTE | Monitorar |
| Tempo para Qualificação | Horas entre captação e BANT | < 24h |
| Taxa Conversão por Temp. | Conversões por temperatura | QUENTE > 30% |
| Score Médio | Média de BANT dos leads | Monitorar |

---

## Definição de Pronto

- [ ] Formulário BANT com 4 critérios implementado
- [ ] Cálculo automático de score (0-12)
- [ ] Classificação de temperatura (FRIO/MORNO/QUENTE)
- [ ] Indicador visual na lista de leads
- [ ] Filtro por temperatura funcionando
- [ ] Histórico de qualificações implementado
- [ ] Notificação para lead QUENTE
- [ ] Regra de desqualificação automática
- [ ] Testes de aceitação realizados

---

## Dependências

| Dependência | Tipo | Status |
|-------------|------|--------|
| US-CRM-LEAD-001 | Interna | ✅ Disponível |
| Lista de Leads | Interna | Pendente (LEAD-016) |
| Sistema de Notificações | Interna | Pendente |

---

## Integração com Funil

```
┌─────────────────────────────────────────────────────────────────┐
│                     INTEGRAÇÃO COM FUNIL                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  CAPTAÇÃO ──► QUALIFICAÇÃO (BANT) ──► NEGOCIAÇÃO ──► CONVERSÃO  │
│     │              │                      │              │      │
│     │              ├─ QUENTE ────────────►│              │      │
│     │              │                      │              │      │
│     │              ├─ MORNO ► Aquecimento►│              │      │
│     │              │                      │              │      │
│     │              └─ FRIO ──► E-mail ───►│              │      │
│     │                                     │              │      │
└─────────────────────────────────────────────────────────────────┘
```

---

**Criado por**: Gustavo Titoneli (Product Owner)  
**Data**: 23/01/2026  
**Versão**: 1.0

**Histórico de Alterações:**
| Versão | Data | Alteração |
|--------|------|----------|
| 1.0 | 23/01/2026 | Versão inicial |
