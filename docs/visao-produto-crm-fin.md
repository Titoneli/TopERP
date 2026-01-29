# Visão do Produto - CRM-Financeiro (CRM-FIN)

| Metadado | Valor |
|----------|-------|
| **Módulo** | CRM-Financeiro |
| **Código** | CRM-FIN |
| **Versão** | 2.1 |
| **Data** | 29/01/2026 |
| **Responsável** | Product Owner - CRM |
| **Tipo DDD** | Core Domain |
| **Total de User Stories** | 63 |
| **Total de Story Points** | 617 SP |

---

## 1. Propósito

O módulo **CRM-Financeiro** gerencia o ciclo financeiro completo dos consultores: acumulação de comissões, saques, emissão de NF, lançamentos contábeis, pagamento via PIX e distribuição hierárquica de valores.

### 1.1 Fluxo Principal

```
Venda → Comissão → Saque → NF → Contábil → MGF/Sankhya → PIX → Extrato
```

---

## 2. Resumo de User Stories por Categoria

### 2.1 Conta e Saldo (6 US | 58 SP) — Essencial

| ID | User Story | SP |
|----|------------|-----|
| FIN-001 | Visualizar saldo disponível para saque | 8 |
| FIN-002 | Visualizar extrato de movimentações | 8 |
| FIN-003 | Solicitar saque total do saldo | 13 |
| FIN-004 | Solicitar saque parcial (valor específico) | 8 |
| FIN-005 | Solicitar saque por período | 8 |
| FIN-006 | Creditar comissões automaticamente na venda | 13 |

---

### 2.2 Emissão de NF (4 US | 44 SP) — Essencial

| ID | User Story | SP |
|----|------------|-----|
| FIN-007 | Emitir NF-e/NFS-e automaticamente ao aprovar saque | 21 |
| FIN-008 | Arquivar XML e PDF das notas fiscais | 5 |
| FIN-009 | Visualizar notas fiscais emitidas | 5 |
| FIN-010 | Cancelar nota fiscal quando necessário | 13 |

---

### 2.3 Pagamento (4 US | 47 SP) — Essencial

| ID | User Story | SP |
|----|------------|-----|
| FIN-011 | Criar ordem de pagamento no MGF/Sankhya | 13 |
| FIN-012 | Processar pagamento via PIX | 21 |
| FIN-013 | Atualizar status em cada etapa do fluxo | 8 |
| FIN-014 | Notificar consultor quando pagamento for efetuado | 5 |

---

### 2.4 Contabilidade (2 US | 21 SP) — Importante

| ID | User Story | SP |
|----|------------|-----|
| FIN-015 | Lançamento contábil automático ao emitir NF | 13 |
| FIN-016 | Estornar lançamento contábil ao cancelar NF | 8 |

---

### 2.5 Cancelamentos e Estornos (4 US | 47 SP) — Importante

| ID | User Story | SP |
|----|------------|-----|
| FIN-017 | Debitar consultor quando venda for cancelada | 13 |
| FIN-018 | Devolver valores ao cliente via PIX | 13 |
| FIN-019 | Cancelar NF e estornar ordem de pagamento | 13 |
| FIN-020 | Aprovar/rejeitar estornos antes do processamento | 8 |

---

### 2.6 Motor de Regras Básico (5 US | 68 SP) — Importante

| ID | User Story | SP |
|----|------------|-----|
| FIN-021 | Cadastrar regras de comissão com fórmulas | 21 |
| FIN-022 | Cadastrar regras de residual sobre mensalidades | 13 |
| FIN-023 | Cadastrar regras de bonificação por metas | 13 |
| FIN-024 | Criar campanhas de premiação com período | 13 |
| FIN-025 | Simular cálculo antes de ativar regra | 8 |

---

### 2.7 Demonstrativos (4 US | 37 SP) — Importante

| ID | User Story | SP |
|----|------------|-----|
| FIN-026 | Visualizar demonstrativo analítico de comissões | 13 |
| FIN-027 | Visualizar demonstrativo sintético (resumo) | 8 |
| FIN-028 | Enviar demonstrativos automaticamente | 8 |
| FIN-029 | Aprovar/contestar valores a receber | 8 |

---

### 2.8 Funcionalidades Avançadas (5 US | 52 SP) — Desejável

| ID | User Story | SP |
|----|------------|-----|
| FIN-030 | Acessar demonstrativos pelo App | 13 |
| FIN-031 | Receber push notification de créditos | 5 |
| FIN-032 | Dashboard financeiro consolidado (gestor) | 13 |
| FIN-033 | Creditar residuais automaticamente | 13 |
| FIN-034 | Exportar relatórios financeiros | 8 |

---

### 2.9 Motor de Regras Avançado - SplitC (8 US | 89 SP) — Importante/Desejável

| ID | User Story | SP |
|----|------------|-----|
| FIN-035 | Cadastrar regras SPIFF (incentivo pontual) | 8 |
| FIN-036 | Cadastrar regras de PLR com fórmulas complexas | 13 |
| FIN-037 | Cadastrar aceleradores progressivos por faixa | 13 |
| FIN-038 | Cadastrar comissão escalonada por volume | 8 |
| FIN-039 | Cadastrar override (comissão sobre equipe) | 13 |
| FIN-040 | Cadastrar split de comissão entre consultores | 8 |
| FIN-041 | Usar templates pré-configurados de regras | 5 |
| FIN-042 | Montar regras visualmente (low-code) | 21 |

---

### 2.10 Gestão de Metas (6 US | 47 SP) — Importante/Desejável

| ID | User Story | SP |
|----|------------|-----|
| FIN-043 | Cadastrar metas individuais (floor/target/stretch) | 8 |
| FIN-044 | Cadastrar metas de equipe agregadas | 8 |
| FIN-045 | Cadastrar metas compostas (múltiplos indicadores) | 13 |
| FIN-046 | Visualizar atingimento em tempo real | 8 |
| FIN-047 | Ver projeção de atingimento até fim do período | 5 |
| FIN-048 | Receber alertas de desvio de meta | 5 |

---

### 2.11 Portal de Transparência (3 US | 21 SP) — Importante/Desejável

| ID | User Story | SP |
|----|------------|-----|
| FIN-049 | Ver detalhamento de cada cálculo de comissão | 8 |
| FIN-050 | Simular "quanto ganho se vender X" | 8 |
| FIN-051 | Ver posição no ranking da equipe | 5 |

---

### 2.12 Aceite Digital de Políticas (4 US | 34 SP) — Importante

| ID | User Story | SP |
|----|------------|-----|
| FIN-052 | Publicar políticas de comissionamento versionadas | 8 |
| FIN-053 | Aceitar digitalmente políticas (validade jurídica) | 13 |
| FIN-054 | Visualizar aceites pendentes e enviar lembretes | 5 |
| FIN-055 | Registrar aceite com hash, timestamp e IP | 8 |

---

### 2.13 Distribuição Hierárquica - Filiação (8 US | 52 SP) — Essencial/Importante

| ID | User Story | SP |
|----|------------|-----|
| FIN-056 | Configurar % por nível (Vendedor→Gerente→Cooperativa→Regional→Associação) | 13 |
| FIN-057 | Escolher tipo Comissão ou Repasse por usuário | 5 |
| FIN-058 | Definir destinatário do restante | 5 |
| FIN-059 | Validar soma dos percentuais ≤ 100% | 3 |
| FIN-060 | Calcular distribuição automaticamente na filiação | 8 |
| FIN-061 | Tornar valores imutáveis após pagamento | 5 |
| FIN-062 | Visualizar detalhamento da distribuição | 5 |
| FIN-063 | Relatório de distribuições por nível hierárquico | 8 |

---

## 3. Consolidação por Prioridade

| Prioridade | Histórias | Story Points | % do Total |
|------------|-----------|--------------|------------|
| **Essencial** | 20 | 201 SP | 33% |
| **Importante** | 30 | 324 SP | 52% |
| **Desejável** | 13 | 92 SP | 15% |
| **TOTAL** | **63** | **617 SP** | **100%** |

---

## 4. Integrações Externas

| Sistema | Função | Prioridade |
|---------|--------|------------|
| **Banco Digital** | Tickets, saldo, PIX | Alta |
| **SEFAZ** | Emissão NF-e | Alta |
| **Prefeituras** | Emissão NFS-e | Alta |
| **MGF/Sankhya** | Ordens de pagamento | Alta |
| **Sistema Contábil** | Lançamentos | Média |
| **App Consultor** | Demonstrativos, push | Média |

---

## 5. Regras de Negócio Principais

| Área | Qtd Regras | Destaques |
|------|------------|-----------|
| Saque | 5 | Mínimo R$ 50, dados PIX obrigatórios |
| Nota Fiscal | 4 | Tipo por regime, prazos de cancelamento |
| Estorno | 4 | Automático em cancelamento, aprovação > R$ 500 |
| Motor de Regras | 4 | Prioridade, vigência, validação de fórmula |
| Metas | 4 | Hierarquia floor/target/stretch, alertas |
| Políticas | 4 | Aceite obrigatório, validade jurídica |
| Distribuição Hierárquica | 8 | Soma ≤ 100%, imutabilidade, níveis fixos |
| **TOTAL** | **33** | |

---

## 6. Entidades DDD

| Agregado (Root) | Entidades | Tabela Principal |
|-----------------|-----------|------------------|
| **ContaConsultor** | LancamentoFinanceiro, SolicitacaoSaque | crm_conta_consultor |
| **NotaFiscal** | LancamentoContabil | crm_nota_fiscal |
| **OrdemPagamento** | PagamentoPIX | crm_ordem_pagamento |
| **RegraComissao** | RegraParametro, RegraCondicao | crm_regra_comissao |
| **Meta** | — | crm_meta |
| **Campanha** | — | crm_campanha |
| **PoliticaComissionamento** | AceitePolitica | crm_politica_comissao |
| **Estorno** | — | crm_estorno |
| **DistribuicaoFiliacao** | DistribuicaoNivel | crm_distribuicao_filiacao |
| **ConfiguracaoDistribuicao** | — | crm_config_distribuicao |

**Total: 19 entidades | 10 agregados**

---

## 7. Evolução do Módulo

| Versão | Data | Histórias | SP | Principais Adições |
|--------|------|-----------|-----|---------------------|
| 1.0 | 29/01/2026 | 34 | 374 | Estrutura base: Conta, NF, Pagamento, Motor básico |
| 2.0 | 29/01/2026 | 55 | 565 | SplitC: SPIFF, PLR, Acelerador, Override, Split, Metas, Políticas |
| 2.1 | 29/01/2026 | 63 | 617 | Distribuição Hierárquica (Filiação): 5 níveis fixos |

---

## 8. Métricas de Sucesso (KPIs)

| KPI | Meta |
|-----|------|
| Tempo saque → pagamento | < 24h |
| Taxa sucesso emissão NF | > 98% |
| Taxa sucesso PIX | > 99% |
| Taxa de estornos | < 5% |
| Atingimento de metas | > 70% consultores |
| Aceites pendentes | < 5% |

---

## 9. Referências

- [README CRM-Financeiro](historias-usuario/CRM-Financeiro/README.md) - Documentação completa
- [Product Backlog](backlog/product-backlog.md) - Backlog consolidado
- [Context Map](ddd/context-map.md) - Mapa de contextos DDD
- [Visão CRM Geral](visao-produto-crm.md) - Visão do produto completo

---

**Versão**: 2.1  
**Data**: 29/01/2026  
**Responsável**: Product Owner - CRM
