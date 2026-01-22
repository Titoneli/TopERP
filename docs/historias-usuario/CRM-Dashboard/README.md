# CRM-Dashboard (CRM-DAS)

| Metadado | Valor |
|----------|-------|
| **Módulo** | Dashboard |
| **Código** | CRM-DAS |
| **Versão** | 1.0 |
| **Data** | 22/01/2026 |
| **Autor** | Product Owner |
| **Status** | Planejado |
| **Tipo DDD** | CQRS Read Model |

---

## 1. Visão Geral

O módulo **CRM-Dashboard** é responsável pela visualização consolidada de dados e métricas do CRM. Este é um **Bounded Context de Leitura (CQRS)** que consome eventos de todos os outros contextos para apresentar informações agregadas.

### 1.1 Responsabilidades

- Consolidação de métricas em tempo real
- Visualização de KPIs de vendas
- Gráficos e indicadores de performance
- Filtros por período, consultor, regional
- Comparativos e tendências
- Alertas e notificações visuais

### 1.2 Padrão Arquitetural

```
┌─────────────────────────────────────────────────────────────────┐
│                         CQRS PATTERN                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐     Events     ┌─────────────────────────────┐│
│  │  CRM-LED    │───────────────►│                             ││
│  │  CRM-COT    │───────────────►│      CRM-DASHBOARD          ││
│  │  CRM-PRO    │───────────────►│       (Read Model)          ││
│  │  CRM-PAG    │───────────────►│                             ││
│  │  CRM-VIS    │───────────────►│  ┌─────────────────────┐    ││
│  │  CRM-ANA    │───────────────►│  │  Materialized Views │    ││
│  │  CRM-*      │───────────────►│  │  Aggregated Data    │    ││
│  └─────────────┘                │  └─────────────────────┘    ││
│                                 │                             ││
│                                 │  Apenas LEITURA             ││
│                                 │  Sem comandos de escrita    ││
│                                 └─────────────────────────────┘│
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Domain-Driven Design

### 2.1 Bounded Context

| Atributo | Descrição |
|----------|-----------|
| **Nome** | Dashboard |
| **Tipo** | CQRS Read Model |
| **Linguagem Ubíqua** | Métrica, KPI, Indicador, Período, Filtro |
| **Característica** | Somente leitura (read-only) |

### 2.2 Read Models (Projeções)

#### Projeção: ResumoFunil

```
┌─────────────────────────────────────────────────────────┐
│                  RESUMO FUNIL (Projeção)                │
├─────────────────────────────────────────────────────────┤
│ - periodo: Periodo                                      │
│ - total_leads: Integer                                  │
│ - leads_por_etapa: Map<Etapa, Integer>                  │
│ - taxa_conversao_geral: Percentual                      │
│ - taxa_conversao_por_etapa: Map<Etapa, Percentual>      │
│ - valor_potencial: Money                                │
│ - valor_concretizado: Money                             │
│ - tempo_medio_ciclo: Duration                           │
└─────────────────────────────────────────────────────────┘
```

#### Projeção: PerformanceConsultor

```
┌─────────────────────────────────────────────────────────┐
│             PERFORMANCE CONSULTOR (Projeção)            │
├─────────────────────────────────────────────────────────┤
│ - consultor_id: UUID                                    │
│ - nome: String                                          │
│ - periodo: Periodo                                      │
│ - leads_captados: Integer                               │
│ - cotacoes_realizadas: Integer                          │
│ - propostas_enviadas: Integer                           │
│ - propostas_aceitas: Integer                            │
│ - vendas_concretizadas: Integer                         │
│ - valor_total_vendido: Money                            │
│ - taxa_conversao: Percentual                            │
│ - ticket_medio: Money                                   │
│ - ranking_posicao: Integer                              │
└─────────────────────────────────────────────────────────┘
```

#### Projeção: MetricasTempo

```
┌─────────────────────────────────────────────────────────┐
│               MÉTRICAS TEMPO (Projeção)                 │
├─────────────────────────────────────────────────────────┤
│ - periodo: Periodo                                      │
│ - tempo_medio_lead_cotacao: Duration                    │
│ - tempo_medio_cotacao_proposta: Duration                │
│ - tempo_medio_proposta_pagamento: Duration              │
│ - tempo_medio_pagamento_vistoria: Duration              │
│ - tempo_medio_vistoria_analise: Duration                │
│ - tempo_medio_ciclo_completo: Duration                  │
│ - leads_parados_por_etapa: Map<Etapa, Integer>          │
└─────────────────────────────────────────────────────────┘
```

### 2.3 Value Objects

| Value Object | Descrição | Atributos |
|--------------|-----------|-----------|
| **Periodo** | Intervalo de tempo | data_inicio, data_fim, tipo |
| **Percentual** | Valor percentual | valor |
| **Money** | Valor monetário | valor, moeda |
| **Duration** | Duração de tempo | dias, horas |
| **Etapa** | Etapa do funil | LEAD, COTACAO, PROPOSTA, PAGAMENTO, VISTORIA, ANALISE, CONCRETIZADA |

### 2.4 Queries Disponíveis

| Query | Parâmetros | Retorno |
|-------|------------|---------|
| `GetResumoFunil` | periodo, regional_id?, consultor_id? | ResumoFunil |
| `GetPerformanceConsultores` | periodo, regional_id?, limit? | List<PerformanceConsultor> |
| `GetMetricasTempo` | periodo, regional_id? | MetricasTempo |
| `GetLeadsPorOrigem` | periodo | Map<Origem, Integer> |
| `GetTendencias` | periodo_comparativo | TendenciasComparativas |
| `GetAlertas` | - | List<Alerta> |

---

## 3. Eventos Consumidos

### 3.1 Mapeamento de Eventos

| Evento Origem | Contexto | Impacto no Dashboard |
|---------------|----------|----------------------|
| `LeadCaptado` | CRM-LED | +1 lead, atualiza origem |
| `CotacaoCriada` | CRM-COT | +1 cotação, tempo lead→cotação |
| `PropostaEnviada` | CRM-PRO | +1 proposta, tempo cotação→proposta |
| `PropostaAceita` | CRM-PRO | +1 aceite, taxa conversão |
| `PropostaRecusada` | CRM-PRO | atualiza taxa perda |
| `PagamentoConfirmado` | CRM-PAG | +1 pagamento, valor |
| `VistoriaRealizada` | CRM-VIS | +1 vistoria, tempo pagamento→vistoria |
| `AnaliseAprovada` | CRM-ANA | +1 aprovação |
| `NegociacaoConcretizada` | CRM-ANA | +1 venda, valor total |
| `NegociacaoPerdida` | CRM-* | +1 perda, motivo |

### 3.2 Event Handlers

```
┌─────────────────────────────────────────────────────────┐
│                   EVENT HANDLERS                        │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────────┐     ┌─────────────────┐           │
│  │ LeadCaptadoHandler │────►│ ResumoFunilProjection │   │
│  └─────────────────┘     └─────────────────┘           │
│                                                         │
│  ┌─────────────────┐     ┌─────────────────┐           │
│  │ PropostaAceitaHandler │──►│ PerformanceProjection │  │
│  └─────────────────┘     └─────────────────┘           │
│                                                         │
│  ┌─────────────────┐     ┌─────────────────┐           │
│  │ VendaConcretizadaHandler │►│ MetricasProjection │   │
│  └─────────────────┘     └─────────────────┘           │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 4. KPIs e Indicadores

### 4.1 KPIs Principais

| KPI | Fórmula | Meta |
|-----|---------|------|
| Taxa de Conversão Geral | Vendas / Leads × 100 | ≥ 15% |
| Ticket Médio | Valor Total / Vendas | ≥ R$ 150 |
| Tempo Médio de Ciclo | Σ(Tempo Ciclo) / Vendas | ≤ 15 dias |
| Leads Ativos | Leads em aberto | Meta mensal |
| Propostas Pendentes | Propostas enviadas sem resposta | Monitorar |

### 4.2 Indicadores por Etapa

| Etapa | Indicador | Descrição |
|-------|-----------|-----------|
| **Leads** | Volume de entrada | Novos leads no período |
| **Cotações** | Taxa de cotação | Leads que geraram cotação |
| **Propostas** | Taxa de envio | Cotações que viraram proposta |
| **Pagamentos** | Taxa de aceite | Propostas aceitas |
| **Vistorias** | Taxa de realização | Pagamentos que geraram vistoria |
| **Análise** | Taxa de aprovação | Vistorias aprovadas |
| **Concretizada** | Taxa final | Análises que viraram venda |

---

## 5. Widgets do Dashboard

### 5.1 Layout Principal

```
┌─────────────────────────────────────────────────────────────────┐
│                        DASHBOARD CRM                            │
├─────────────────────────────────────────────────────────────────┤
│ [Filtros: Período | Regional | Consultor]              [Atualizar]│
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌─────────┐│
│  │    LEADS     │ │   VENDAS     │ │   RECEITA    │ │CONVERSÃO││
│  │     127      │ │      23      │ │  R$ 34.500   │ │  18,1%  ││
│  │   +12% ▲     │ │    +5% ▲     │ │   +8% ▲      │ │ +2,3% ▲ ││
│  └──────────────┘ └──────────────┘ └──────────────┘ └─────────┘│
│                                                                 │
│  ┌────────────────────────────────┐ ┌──────────────────────────┐│
│  │      FUNIL DE VENDAS           │ │  RANKING CONSULTORES     ││
│  │ ┌─────────────────────────┐    │ │                          ││
│  │ │ Leads          127      │    │ │  1. João Silva   R$ 12k  ││
│  │ │ Cotações        89      │    │ │  2. Maria Costa  R$ 10k  ││
│  │ │ Propostas       45      │    │ │  3. Pedro Santos R$ 8k   ││
│  │ │ Pagamentos      28      │    │ │  4. Ana Lima     R$ 4,5k ││
│  │ │ Vistorias       25      │    │ │                          ││
│  │ │ Análise         24      │    │ │                          ││
│  │ │ Concretizadas   23      │    │ │                          ││
│  │ └─────────────────────────┘    │ │                          ││
│  └────────────────────────────────┘ └──────────────────────────┘│
│                                                                 │
│  ┌────────────────────────────────┐ ┌──────────────────────────┐│
│  │    EVOLUÇÃO MENSAL (Gráfico)   │ │   ORIGEM DOS LEADS       ││
│  │                                │ │  ┌─────────────────────┐ ││
│  │    ▲                           │ │  │ WhatsApp     45%    │ ││
│  │    │    ●──●                   │ │  │ Site         30%    │ ││
│  │    │ ●──     ──●               │ │  │ Indicação    15%    │ ││
│  │    │           │               │ │  │ Outros       10%    │ ││
│  │    └─────────────►             │ │  └─────────────────────┘ ││
│  │      Jan Fev Mar               │ │                          ││
│  └────────────────────────────────┘ └──────────────────────────┘│
│                                                                 │
│  ┌──────────────────────────────────────────────────────────────┐
│  │                     ALERTAS E PENDÊNCIAS                     │
│  │  ⚠️ 5 propostas vencem hoje                                  │
│  │  ⚠️ 3 vistorias atrasadas                                    │
│  │  ⚠️ 8 leads sem contato há 3 dias                            │
│  └──────────────────────────────────────────────────────────────┘
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 6. User Stories Planejadas

| ID | Título | Prioridade | Status |
|----|--------|------------|--------|
| US-CRM-DAS-001 | Visualizar resumo do funil | Must | 📋 Planejado |
| US-CRM-DAS-002 | Filtrar por período | Must | 📋 Planejado |
| US-CRM-DAS-003 | Filtrar por regional | Should | 📋 Planejado |
| US-CRM-DAS-004 | Ver ranking de consultores | Should | 📋 Planejado |
| US-CRM-DAS-005 | Ver origem dos leads | Should | 📋 Planejado |
| US-CRM-DAS-006 | Ver evolução temporal | Should | 📋 Planejado |
| US-CRM-DAS-007 | Receber alertas de pendências | Should | 📋 Planejado |
| US-CRM-DAS-008 | Exportar dados do dashboard | Could | 📋 Planejado |

---

## 7. Critérios de Aceitação Gerais

- [ ] Dados atualizados em tempo real (< 5s delay)
- [ ] Filtros funcionais e combinados
- [ ] Gráficos interativos
- [ ] Responsivo para mobile
- [ ] Exportação para Excel/PDF
- [ ] Alertas configuráveis
- [ ] Cache para performance

---

## 8. Considerações Técnicas

### 8.1 Performance

| Aspecto | Estratégia |
|---------|------------|
| **Cache** | Redis para dados agregados |
| **Atualização** | Event-driven com materialized views |
| **Consultas** | Read replicas do banco |
| **Índices** | Otimizados para filtros comuns |

### 8.2 Escalabilidade

- Dashboard é stateless
- Pode ter múltiplas instâncias
- Consome eventos de forma assíncrona
- Projeções podem ser reconstruídas

---

## 9. Histórico de Alterações

| Data | Versão | Autor | Alteração |
|------|--------|-------|-----------|
| 22/01/2026 | 1.0 | Product Owner | Criação inicial com estrutura DDD/CQRS |

---

## 10. Referências

- [Context Map](../../ddd/context-map.md)
- [CQRS Pattern](https://martinfowler.com/bliki/CQRS.html)
- [Product Backlog](../../backlog/product-backlog.md)
