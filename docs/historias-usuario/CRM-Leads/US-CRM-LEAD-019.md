# US-CRM-LEAD-019 — Score Automático de Lead (Machine Learning)

## História de Usuário

**Como** gestor comercial,  
**Quero** que o sistema calcule automaticamente a probabilidade de conversão de cada lead,  
**Para** priorizar o atendimento de forma inteligente e aumentar a eficiência da equipe.

## Prioridade

Desejável

## Estimativa

8 SP

---

## Contexto DDD

### Bounded Context
- **Contexto**: Integrações e Inteligência (Intelligence & Integrations)
- **Módulo**: CRM-Leads

### Aggregate Root
- **Lead** (entidade principal)
- **ModeloML** (modelo de machine learning)

### Domain Events
| Evento | Trigger | Assinantes |
|--------|---------|------------|
| `LeadScored` | Score calculado | Notificações, Fila |
| `LeadScoreUpdated` | Score recalculado | Analytics |
| `HighProbabilityLeadDetected` | Score > 80% | Alertas |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Score de Conversão** | Probabilidade estimada de fechar negócio |
| **Modelo Preditivo** | Algoritmo que calcula o score |
| **Features** | Características usadas para prever |
| **Score Automático** | Cálculo sem intervenção humana |

---

## Contexto de Negócio

O score automático de conversão usa machine learning para prever quais leads têm maior probabilidade de se tornarem clientes. Isso permite priorização inteligente e alocação eficiente de recursos.

### Diferença entre Score BANT e Score ML

| Aspecto | Score BANT | Score ML |
|---------|------------|----------|
| Origem | Preenchido pelo consultor | Calculado pelo sistema |
| Base | Questionário estruturado | Dados históricos + padrões |
| Subjetividade | Alta (depende do consultor) | Baixa (baseado em dados) |
| Atualização | Manual | Automática |
| Objetivo | Qualificação imediata | Previsão de conversão |

---

## Features do Modelo

### Features de Origem

| Feature | Tipo | Peso Esperado |
|---------|------|---------------|
| cod_origem | categorical | Alto |
| utm_source | categorical | Médio |
| utm_medium | categorical | Médio |
| utm_campaign | categorical | Médio |

### Features de Contato

| Feature | Tipo | Peso Esperado |
|---------|------|---------------|
| ddd_telefone | categorical | Médio |
| tem_email | boolean | Médio |
| uf | categorical | Alto |

### Features do Veículo

| Feature | Tipo | Peso Esperado |
|---------|------|---------------|
| valor_fipe | numerical | Alto |
| idade_veiculo | numerical | Médio |
| tipo_uso | categorical | Médio |

### Features de Engajamento

| Feature | Tipo | Peso Esperado |
|---------|------|---------------|
| etapas_completadas | numerical | Alto |
| tempo_no_form | numerical | Médio |
| hora_cadastro | numerical | Baixo |
| dia_semana | categorical | Baixo |

### Features de Qualificação

| Feature | Tipo | Peso Esperado |
|---------|------|---------------|
| bant_score | numerical | Alto |
| temperatura | categorical | Alto |

---

## Fluxo de Scoring

```
┌─────────────────────────────────────────────────────────────────┐
│                 FLUXO DE SCORE AUTOMÁTICO                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌───────────────┐                                              │
│  │  LEAD CRIADO  │                                              │
│  │  OU ATUALIZADO│                                              │
│  └───────┬───────┘                                              │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              EXTRAÇÃO DE FEATURES                         │  │
│  │                                                           │  │
│  │  • Origem e UTMs                                          │  │
│  │  • Dados do veículo                                       │  │
│  │  • Localização                                            │  │
│  │  • Score BANT (se disponível)                             │  │
│  │  • Histórico de engajamento                               │  │
│  └───────────────────────────────────────────────────────────┘  │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              MODELO DE MACHINE LEARNING                   │  │
│  │                                                           │  │
│  │         ┌─────────────────────────────────────────┐       │  │
│  │         │  Gradient Boosting / Random Forest      │       │  │
│  │         │                                         │       │  │
│  │         │  Input: Features normalizadas           │       │  │
│  │         │  Output: Probabilidade (0-100%)         │       │  │
│  │         └─────────────────────────────────────────┘       │  │
│  │                                                           │  │
│  └───────────────────────────────────────────────────────────┘  │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              CLASSIFICAÇÃO                                │  │
│  │                                                           │  │
│  │   0-30%: 🔵 BAIXA     31-60%: 🟡 MÉDIA     61-100%: 🟢 ALTA │  │
│  │                                                           │  │
│  └───────────────────────────────────────────────────────────┘  │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────┐                                              │
│  │  LEAD COM     │                                              │
│  │  SCORE ML     │                                              │
│  └───────────────┘                                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Faixas de Score

| Faixa | Classificação | Cor | Ação Recomendada |
|-------|---------------|-----|------------------|
| 0-30% | Baixa probabilidade | 🔵 Azul | Nurturing automático |
| 31-60% | Média probabilidade | 🟡 Amarelo | Follow-up regular |
| 61-80% | Alta probabilidade | 🟢 Verde | Prioridade no atendimento |
| 81-100% | Muito alta | ⭐ Dourado | Contato imediato |

---

## Critérios de Aceitação

### Cenário 1 — Score calculado ao criar lead
- **Dado que** um novo lead é criado
- **Quando** as features são coletadas
- **Então** o score de conversão é calculado automaticamente
- **E** o lead recebe classificação (Baixa/Média/Alta)

### Cenário 2 — Score recalculado após qualificação
- **Dado que** um lead é qualificado (BANT preenchido)
- **Quando** o score BANT é registrado
- **Então** o score ML é recalculado com a nova feature
- **E** evento `LeadScoreUpdated` é disparado

### Cenário 3 — Visualizar score na lista
- **Dado que** estou na lista de leads
- **Quando** visualizo a coluna de Score ML
- **Então** vejo a probabilidade em porcentagem
- **E** vejo indicador visual de cor

### Cenário 4 — Ordenar por score
- **Dado que** quero priorizar leads promissores
- **Quando** ordeno a lista por Score ML decrescente
- **Então** leads com maior probabilidade aparecem primeiro

### Cenário 5 — Alerta de lead de alta probabilidade
- **Dado que** um lead recebe score > 80%
- **Quando** o cálculo é concluído
- **Então** o consultor atribuído recebe notificação push e WhatsApp
- **E** mensagem: "Lead de alta conversão detectado!"

### Cenário 6 — Score com dados incompletos
- **Dado que** um lead não tem dados de veículo
- **Quando** o score é calculado
- **Então** features ausentes são tratadas como missing
- **E** o score é calculado com as features disponíveis
- **E** um indicador "Score parcial" é exibido

### Cenário 7 — Comparar Score BANT vs Score ML
- **Dado que** um lead tem ambos os scores
- **Quando** visualizo os detalhes
- **Então** vejo os dois scores lado a lado
- **E** posso entender a diferença de avaliação

### Cenário 8 — Filtrar por faixa de score
- **Dado que** quero leads de alta probabilidade
- **Quando** filtro por Score ML >= 60%
- **Então** a lista exibe apenas leads promissores

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Score calculado automaticamente ao criar lead |
| RN-002 | Score recalculado quando features mudam |
| RN-003 | Score não substitui BANT, complementa |
| RN-004 | Leads sem veículo recebem score parcial |
| RN-005 | Score > 80% gera notificação ao consultor (push e WhatsApp) |
| RN-006 | Modelo retreinado mensalmente com novos dados |
| RN-007 | Score expresso em porcentagem (0-100%) |
| RN-008 | Histórico de scores é mantido |
| RN-009 | Administrador pode ajustar limites de faixas |
| RN-010 | Modelo baseline disponível, personalização futura |

---

## Modelo de Machine Learning

### Algoritmo Recomendado

| Aspecto | Especificação |
|---------|---------------|
| Algoritmo | Gradient Boosting (XGBoost/LightGBM) |
| Target | Conversão binária (converteu/não converteu) |
| Output | Probabilidade (0.0 - 1.0) |
| Retreinamento | Mensal |
| Features | ~15-20 features |

### Métricas de Avaliação

| Métrica | Alvo Mínimo |
|---------|-------------|
| AUC-ROC | > 0.70 |
| Precision @60% | > 0.40 |
| Recall @60% | > 0.50 |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────┐
│  📊 SCORE DE CONVERSÃO                                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Lead: João da Silva - Fiat Strada 2024                         │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                                                         │    │
│  │                    SCORE ML                             │    │
│  │                                                         │    │
│  │           ┌───────────────────────────────┐             │    │
│  │           │         ⭐ 85%                │             │    │
│  │           │    MUITO ALTA PROBABILIDADE   │             │    │
│  │           └───────────────────────────────┘             │    │
│  │                                                         │    │
│  │  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░████████████████████   │    │
│  │  0%                50%                              100%│    │
│  │                                                         │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  COMPARATIVO                                                    │
│                                                                 │
│  │ Métrica      │ Score │ Classificação │                       │
│  │──────────────│───────│───────────────│                       │
│  │ Score ML     │  85%  │ ⭐ Muito Alta  │                       │
│  │ Score BANT   │ 10/12 │ 🔴 Quente      │                       │
│  │ Temperatura  │   -   │ 🔴 Quente      │                       │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  PRINCIPAIS FATORES                                             │
│                                                                 │
│  ✅ Origem: Google Ads (+15%)                                   │
│  ✅ Score BANT: 10/12 (+20%)                                    │
│  ✅ Veículo: Valor FIPE alto (+12%)                             │
│  ✅ Região: SP (+8%)                                            │
│  ⚠️ Etapas form: Apenas 2/3 (-5%)                               │
│                                                                 │
│  Calculado em: 25/01/2026 às 10:45                              │
│  [🔄 Recalcular]                                                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 25/01/2026 | 1.0 | PO | Criação inicial com DDD |
| 27/01/2026 | 1.1 | PO | Notificação consultor: push e WhatsApp |

---

**Identificador**: US-CRM-LEAD-019  
**Módulo**: CRM-Leads  
**Fase**: 5 - Integrações e Inteligência  
**Status**: ✅ Pronto  
**Versão**: 1.1
