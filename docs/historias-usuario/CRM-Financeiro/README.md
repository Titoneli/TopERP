# Módulo: Gestão Financeira do Consultor (CRM-FIN)

| Metadado | Valor |
|----------|-------|
| **Módulo** | CRM-Financeiro |
| **Código** | CRM-FIN |
| **Versão** | 2.0 |
| **Data** | 29/01/2026 |
| **Responsável** | Product Owner - CRM |
| **Status** | Planejado |
| **Tipo DDD** | Core Domain |
| **Banco de Dados** | PostgreSQL 16 (topbrasil_crm) |

---

## 1. Visão Geral

O módulo **CRM-Financeiro** é responsável pela gestão completa do ciclo financeiro dos consultores, desde a acumulação de valores a receber das vendas até o pagamento efetivo via PIX, incluindo emissão de notas fiscais, lançamentos contábeis e controle de comissões.

### 1.1 Objetivos

- Automatizar o fluxo completo: **Saque → NF → Contábil → Pagamento → PIX**
- Integrar com sistemas externos (Banco Digital, SEFAZ, Sistema Contábil, ERP)
- Implementar **Motor de Regras** para cálculo de comissões, residuais, bonificações e premiações
- Fornecer demonstrativos financeiros analíticos/sintéticos aos consultores
- Controlar cancelamentos, estornos e devoluções com rastreabilidade completa
- Permitir aprovação/reprovação de valores a receber

### 1.2 Posição no Funil

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                         FLUXO FINANCEIRO DO CONSULTOR                               │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│   [Venda Concretizada]                                                              │
│          │                                                                          │
│          ▼                                                                          │
│   ┌──────────────┐     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐   │
│   │  Acumulação  │────►│  Solicitação │────►│  Emissão de  │────►│  Lançamento  │   │
│   │   Valores    │     │   de Saque   │     │     NF-e     │     │   Contábil   │   │
│   └──────────────┘     └──────────────┘     └──────────────┘     └──────────────┘   │
│                                                                          │          │
│   ┌──────────────────────────────────────────────────────────────────────┘          │
│   │                                                                                 │
│   ▼                                                                                 │
│   ┌──────────────┐     ┌──────────────┐     ┌──────────────┐                        │
│   │    Ordem     │────►│  Pagamento   │────►│   Extrato    │                        │
│   │  Pagamento   │     │   via PIX    │     │  Consultor   │                        │
│   │  MGF/Sankhya │     │              │     │              │                        │
│   └──────────────┘     └──────────────┘     └──────────────┘                        │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### 1.3 Subfluxos

#### 1.3.1 Fluxo Principal - Solicitação de Saque

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                              FLUXO DE SAQUE                                         │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│   1. Consultor visualiza saldo disponível (total ou por período)                    │
│   2. Consultor solicita saque (total ou parcial)                                    │
│   3. Sistema abre ticket de solicitação no Banco Digital/Setor Financeiro           │
│   4. Sistema emite NF-e/NFS-e automaticamente (SEFAZ/SRF)                           │
│   5. Sistema arquiva XML e PDF da NF                                                │
│   6. Sistema realiza lançamento contábil                                            │
│   7. Sistema gera ordem de pagamento no MGF/Sankhya com anexos                      │
│   8. Sistema processa pagamento via PIX na conta do consultor                       │
│   9. Sistema atualiza extrato e histórico de pagamentos                             │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

#### 1.3.2 Fluxo de Cancelamento/Estorno

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                         FLUXO DE CANCELAMENTO/ESTORNO                               │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│   [Cancelamento de Venda]                                                           │
│          │                                                                          │
│          ├──► Estorno para Lead/Cliente (se aplicável)                              │
│          │         │                                                                │
│          │         ▼                                                                │
│          │    [Devolução via PIX/Banco Digital]                                     │
│          │                                                                          │
│          └──► Débito na conta do Consultor                                          │
│                    │                                                                │
│                    ▼                                                                │
│               [Ajuste no saldo disponível]                                          │
│                    │                                                                │
│                    ▼                                                                │
│               [Cancelamento de NF (se emitida)]                                     │
│                    │                                                                │
│                    ▼                                                                │
│               [Estorno de Ordem de Pagamento]                                       │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

#### 1.3.3 Motor de Regras - Comissões e Remuneração Variável

> **Inspirado em:** SplitC - Plataforma de automação de remuneração variável

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                         MOTOR DE REGRAS AVANÇADO                                    │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│   TIPOS DE REMUNERAÇÃO:                                                             │
│   ┌────────────────────────────────────────────────────────────────────────────┐    │
│   │  BÁSICOS:                                                                  │    │
│   │  • Comissão Direta: % sobre valor da venda                                 │    │
│   │  • Residual: % sobre mensalidades recorrentes                              │    │
│   │  • Bonificação: valor fixo por meta atingida                               │    │
│   │  • Premiação: campanhas especiais (período específico)                     │    │
│   │                                                                            │    │
│   │  AVANÇADOS (inspirado SplitC):                                             │    │
│   │  • SPIFF: incentivo pontual por produto/período (Sales Performance)        │    │
│   │  • PLR: participação nos lucros com fórmulas complexas                     │    │
│   │  • Acelerador: multiplicador progressivo por faixa de resultado            │    │
│   │  • Comissão Escalonada: % variável conforme volume                         │    │
│   │  • Override: comissão sobre vendas da equipe (gestores)                    │    │
│   │  • Split: divisão de comissão entre múltiplos consultores                  │    │
│   └────────────────────────────────────────────────────────────────────────────┘    │
│                                                                                     │
│   VARIÁVEIS DO MOTOR:                                                               │
│   ┌────────────────────────────────────────────────────────────────────────────┐    │
│   │  VENDA:                                                                    │    │
│   │  • Tipo de plano vendido (Básico, Premium)                                 │    │
│   │  • Valor da venda (adesão, mensalidade)                                    │    │
│   │  • Margem de contribuição                                                  │    │
│   │  • Tipo de cliente (novo, renovação, upgrade)                              │    │
│   │                                                                            │    │
│   │  CONSULTOR:                                                                │    │
│   │  • Quantidade de vendas no período                                         │    │
│   │  • Tempo como consultor (senioridade)                                      │    │
│   │  • Região de atuação                                                       │    │
│   │  • Nível/cargo hierárquico                                                 │    │
│   │  • Indicadores de desempenho (taxa de conversão, NPS)                      │    │
│   │                                                                            │    │
│   │  CONTEXTO:                                                                 │    │
│   │  • Campanhas ativas                                                        │    │
│   │  • Sazonalidade                                                            │    │
│   │  • Metas individuais e de equipe                                           │    │
│   │  • Atingimento acumulado                                                   │    │
│   └────────────────────────────────────────────────────────────────────────────┘    │
│                                                                                     │
│   FÓRMULAS CONFIGURÁVEIS (MOTOR VISUAL LOW-CODE):                                   │
│   ┌────────────────────────────────────────────────────────────────────────────┐    │
│   │  comissao = (valor_venda × perc_comissao) + bonus_plano + bonus_meta       │    │
│   │  residual = mensalidade × perc_residual × fator_senioridade                │    │
│   │  bonificacao = IF(vendas >= meta) THEN valor_bonus ELSE 0                  │    │
│   │  premiacao = regras_campanha_ativa(periodo, valores)                       │    │
│   │                                                                            │    │
│   │  AVANÇADAS:                                                                │    │
│   │  acelerador = base × CASE                                                  │    │
│   │                  WHEN ating >= 120% THEN 1.5                               │    │
│   │                  WHEN ating >= 100% THEN 1.2                               │    │
│   │                  WHEN ating >= 80%  THEN 1.0                               │    │
│   │                  ELSE 0.8 END                                              │    │
│   │  override = SUM(vendas_equipe) × perc_override × nivel_gestor              │    │
│   │  split = valor_total × participacao_percentual                             │    │
│   │  plr = (lucro_periodo × perc_plr) × peso_individual × fator_tempo          │    │
│   └────────────────────────────────────────────────────────────────────────────┘    │
│                                                                                     │
│   TEMPLATES PRÉ-CONFIGURADOS:                                                       │
│   ┌────────────────────────────────────────────────────────────────────────────┐    │
│   │  • Comissão Simples (% fixo)                                               │    │
│   │  • Comissão por Faixa (escalonada)                                         │    │
│   │  • Bônus por Meta                                                          │    │
│   │  • SPIFF Produto Específico                                                │    │
│   │  • Override Gestor 2 níveis                                                │    │
│   │  • PLR Trimestral                                                          │    │
│   └────────────────────────────────────────────────────────────────────────────┘    │
│                                                                                     │
│   RASTREABILIDADE 100%:                                                             │
│   ┌────────────────────────────────────────────────────────────────────────────┐    │
│   │  • Log completo de cada cálculo realizado                                  │    │
│   │  • Variáveis utilizadas e valores                                          │    │
│   │  • Regra aplicada e versão                                                 │    │
│   │  • Comparativo antes/depois em alterações                                  │    │
│   │  • Trilha de auditoria para compliance                                     │    │
│   └────────────────────────────────────────────────────────────────────────────┘    │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

#### 1.3.4 Gestão de Metas Avançada

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                         GESTÃO DE METAS EM TEMPO REAL                               │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│   TIPOS DE META:                                                                    │
│   ┌────────────────────────────────────────────────────────────────────────────┐    │
│   │  • Meta Individual: por consultor                                          │    │
│   │  • Meta de Equipe: agregada por gerente/regional                           │    │
│   │  • Meta Composta: combinação de indicadores (vendas + NPS + retenção)      │    │
│   │  • Meta Progressiva: faixas crescentes (floor, target, stretch)            │    │
│   └────────────────────────────────────────────────────────────────────────────┘    │
│                                                                                     │
│   ACOMPANHAMENTO:                                                                   │
│   ┌────────────────────────────────────────────────────────────────────────────┐    │
│   │  • Dashboard em tempo real                                                 │    │
│   │  • Projeção de atingimento                                                 │    │
│   │  • Alertas de desvio                                                       │    │
│   │  • Ranking/gamificação                                                     │    │
│   │  • Histórico de performance                                                │    │
│   └────────────────────────────────────────────────────────────────────────────┘    │
│                                                                                     │
│   PERÍODOS:                                                                         │
│   ┌────────────────────────────────────────────────────────────────────────────┐    │
│   │  • Mensal | Trimestral | Semestral | Anual                                 │    │
│   │  • Campanhas especiais (período customizado)                               │    │
│   │  • Acumulado (YTD - Year to Date)                                          │    │
│   └────────────────────────────────────────────────────────────────────────────┘    │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

#### 1.3.5 Portal de Transparência

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                         PORTAL DE TRANSPARÊNCIA                                     │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│   VISÃO DO CONSULTOR:                                                               │
│   ┌────────────────────────────────────────────────────────────────────────────┐    │
│   │  • Dashboard com resumo de ganhos (realizado vs projetado)                 │    │
│   │  • Detalhamento de cada cálculo (drill-down)                               │    │
│   │  • Simulador de comissão ("quanto ganho se vender X?")                     │    │
│   │  • Extrato analítico por tipo de remuneração                               │    │
│   │  • Comparativo com períodos anteriores                                     │    │
│   │  • Posição no ranking da equipe/região                                     │    │
│   └────────────────────────────────────────────────────────────────────────────┘    │
│                                                                                     │
│   DETALHAMENTO DO CÁLCULO:                                                          │
│   ┌────────────────────────────────────────────────────────────────────────────┐    │
│   │  Venda #12345 - Plano Premium                                              │    │
│   │  ├─ Valor da venda: R$ 500,00                                              │    │
│   │  ├─ Comissão base (8%): R$ 40,00                                           │    │
│   │  ├─ Bônus plano Premium: R$ 10,00                                          │    │
│   │  ├─ Acelerador (ating. 110%): × 1.2                                        │    │
│   │  └─ TOTAL: R$ 60,00                                                        │    │
│   │  Regra aplicada: REG-COM-001 v3.2 (vigente desde 01/01/2026)               │    │
│   └────────────────────────────────────────────────────────────────────────────┘    │
│                                                                                     │
│   SIMULADOR:                                                                        │
│   ┌────────────────────────────────────────────────────────────────────────────┐    │
│   │  "Se eu vender mais 3 planos Premium este mês..."                          │    │
│   │  ├─ Comissão adicional: R$ 180,00                                          │    │
│   │  ├─ Bônus meta atingida: R$ 200,00                                         │    │
│   │  ├─ Acelerador sobe para 1.3x                                              │    │
│   │  └─ Impacto total: +R$ 520,00                                              │    │
│   └────────────────────────────────────────────────────────────────────────────┘    │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

#### 1.3.6 Aceite Digital de Políticas

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                         ACEITE DIGITAL DE POLÍTICAS                                 │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│   FLUXO DE ACEITE:                                                                  │
│   ┌────────────────────────────────────────────────────────────────────────────┐    │
│   │  1. Gestor publica nova política de comissionamento                        │    │
│   │  2. Consultor recebe notificação para aceitar                              │    │
│   │  3. Consultor visualiza documento completo                                 │    │
│   │  4. Consultor realiza aceite digital com autenticação                      │    │
│   │  5. Sistema registra: data/hora, IP, hash do documento, assinatura         │    │
│   │  6. Política entra em vigor para o consultor                               │    │
│   └────────────────────────────────────────────────────────────────────────────┘    │
│                                                                                     │
│   VALIDADE JURÍDICA:                                                                │
│   ┌────────────────────────────────────────────────────────────────────────────┐    │
│   │  • Assinatura digital com certificado                                      │    │
│   │  • Registro de timestamp (carimbo de tempo)                                │    │
│   │  • Hash SHA-256 do documento                                               │    │
│   │  • Log de auditoria imutável                                               │    │
│   │  • Conformidade com MP 2.200-2 (ICP-Brasil)                                │    │
│   └────────────────────────────────────────────────────────────────────────────┘    │
│                                                                                     │
│   GESTÃO DE VERSÕES:                                                                │
│   ┌────────────────────────────────────────────────────────────────────────────┐    │
│   │  • Histórico de todas as versões                                           │    │
│   │  • Comparativo entre versões (diff)                                        │    │
│   │  • Registro de quem aceitou cada versão                                    │    │
│   │  • Alertas para aceites pendentes                                          │    │
│   └────────────────────────────────────────────────────────────────────────────┘    │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Domain-Driven Design

### 2.1 Bounded Context

| Atributo | Descrição |
|----------|-----------|
| **Nome** | Gestão Financeira do Consultor |
| **Tipo** | Core Domain |
| **Linguagem Ubíqua** | Saldo, Saque, Nota Fiscal, Comissão, Residual, Bonificação, Premiação, Ordem de Pagamento, Estorno, Motor de Regras |

### 2.2 Agregados

#### Agregado: ContaConsultor (Aggregate Root)

> **Tabela BD:** `crm_conta_consultor`

```
┌─────────────────────────────────────────────────────────────────┐
│                    <<Aggregate Root>>                           │
│                    CONTA_CONSULTOR                              │
│                 (crm_conta_consultor)                           │
├─────────────────────────────────────────────────────────────────┤
│ - id_conta_consultor: bigint (PK)                               │
│ - id_colaborador: bigint (FK cor_colaborador)                   │
│ - id_empresa: bigint (FK cor_empresa)                           │
│ - saldo_disponivel: numeric(14,2)                               │
│ - saldo_bloqueado: numeric(14,2)                                │
│ - saldo_pendente: numeric(14,2)                                 │
│ - dados_bancarios: DadosBancarios (VO)                          │
│ - dados_fiscais: DadosFiscais (VO)                              │
│ - dom_sit_conta: text (ATIVA, BLOQUEADA, INATIVA)               │
│ - dat_abertura: timestamp                                       │
│ - dat_ultimo_movimento: timestamp                               │
│ - lancamentos: List<LancamentoFinanceiro> (1:N)                 │
│ - saques: List<SolicitacaoSaque> (1:N)                          │
├─────────────────────────────────────────────────────────────────┤
│ + creditarComissao(valor, origem): void                         │
│ + creditarResidual(valor, origem): void                         │
│ + creditarBonificacao(valor, origem): void                      │
│ + debitarEstorno(valor, motivo): void                           │
│ + bloquearSaldo(valor): void                                    │
│ + liberarSaldo(valor): void                                     │
│ + solicitarSaque(valor, tipo): SolicitacaoSaque                 │
│ + calcularSaldoDisponivel(): Dinheiro                           │
│ + obterExtrato(periodo): List<LancamentoFinanceiro>             │
│ + obterDemonstrativo(periodo): DemonstrativoFinanceiro          │
└─────────────────────────────────────────────────────────────────┘
         │
         │ contém (1:N)
         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    <<Entity>>                                   │
│                LANCAMENTO_FINANCEIRO                            │
│              (crm_lancamento_financeiro)                        │
├─────────────────────────────────────────────────────────────────┤
│ - id_lancamento: bigint (PK)                                    │
│ - id_conta_consultor: bigint (FK)                               │
│ - id_negociacao: bigint (FK crm_negociacao, opcional)           │
│ - dom_tpo_lancamento: text (COMISSAO, RESIDUAL, BONIFICACAO,    │
│                             PREMIACAO, ESTORNO, AJUSTE)         │
│ - dom_nat_lancamento: text (CREDITO, DEBITO)                    │
│ - val_lancamento: numeric(14,2)                                 │
│ - dsc_lancamento: text                                          │
│ - dat_lancamento: timestamp                                     │
│ - dat_competencia: date                                         │
│ - id_regra_comissao: bigint (FK, opcional)                      │
│ - json_detalhes: jsonb (detalhes da origem)                     │
│ - dom_sit_lancamento: text (PENDENTE, CONFIRMADO, CANCELADO)    │
├─────────────────────────────────────────────────────────────────┤
│ + confirmar(): void                                             │
│ + cancelar(motivo): void                                        │
│ + estornar(): LancamentoFinanceiro                              │
└─────────────────────────────────────────────────────────────────┘
         │
         │ gera (1:N)
         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    <<Entity>>                                   │
│                 SOLICITACAO_SAQUE                               │
│               (crm_solicitacao_saque)                           │
├─────────────────────────────────────────────────────────────────┤
│ - id_solicitacao_saque: bigint (PK)                             │
│ - id_conta_consultor: bigint (FK)                               │
│ - id_usuario: bigint (FK amb_usuario, solicitante)              │
│ - cod_solicitacao: text (código único)                          │
│ - val_solicitado: numeric(14,2)                                 │
│ - dom_tpo_saque: text (TOTAL, PARCIAL, PERIODO)                 │
│ - dat_ini_periodo: date (opcional)                              │
│ - dat_fim_periodo: date (opcional)                              │
│ - dom_sit_solicitacao: text (PENDENTE, EM_PROCESSAMENTO,        │
│                              AGUARDANDO_NF, NF_EMITIDA,         │
│                              AGUARDANDO_PAGAMENTO, PAGO,        │
│                              CANCELADO, REJEITADO)              │
│ - dat_solicitacao: timestamp                                    │
│ - dat_processamento: timestamp                                  │
│ - nota_fiscal: NotaFiscal? (1:1)                                │
│ - ordem_pagamento: OrdemPagamento? (1:1)                        │
│ - pagamento: PagamentoPIX? (1:1)                                │
├─────────────────────────────────────────────────────────────────┤
│ + aprovar(): void                                               │
│ + rejeitar(motivo): void                                        │
│ + cancelar(motivo): void                                        │
│ + iniciarProcessamento(): void                                  │
│ + vincularNotaFiscal(nf: NotaFiscal): void                      │
│ + vincularOrdemPagamento(op: OrdemPagamento): void              │
│ + registrarPagamento(pix: PagamentoPIX): void                   │
└─────────────────────────────────────────────────────────────────┘
```

#### Agregado: NotaFiscal

> **Tabela BD:** `crm_nota_fiscal`

```
┌─────────────────────────────────────────────────────────────────┐
│                    <<Aggregate Root>>                           │
│                      NOTA_FISCAL                                │
│                   (crm_nota_fiscal)                             │
├─────────────────────────────────────────────────────────────────┤
│ - id_nota_fiscal: bigint (PK)                                   │
│ - id_solicitacao_saque: bigint (FK)                             │
│ - id_colaborador: bigint (FK, emitente)                         │
│ - dom_tpo_nf: text (NFE, NFSE)                                  │
│ - num_nf: text (número da nota)                                 │
│ - serie_nf: text                                                │
│ - chave_acesso: text (44 dígitos)                               │
│ - val_nf: numeric(14,2)                                         │
│ - val_iss: numeric(14,2)                                        │
│ - val_irrf: numeric(14,2)                                       │
│ - val_liquido: numeric(14,2)                                    │
│ - dat_emissao: timestamp                                        │
│ - dat_competencia: date                                         │
│ - dom_sit_nf: text (EMITIDA, CANCELADA, INUTILIZADA)            │
│ - url_xml: text (arquivo XML)                                   │
│ - url_pdf: text (DANFE/PDF)                                     │
│ - json_retorno_sefaz: jsonb                                     │
│ - cod_municipio_prestacao: text                                 │
│ - uf_emitente: char(2)                                          │
├─────────────────────────────────────────────────────────────────┤
│ + emitir(): void                                                │
│ + cancelar(motivo, justificativa): void                         │
│ + consultarStatus(): StatusSEFAZ                                │
│ + baixarXML(): File                                             │
│ + baixarPDF(): File                                             │
│ + reemitir(): NotaFiscal                                        │
└─────────────────────────────────────────────────────────────────┘
         │
         │ registra (1:1)
         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    <<Entity>>                                   │
│                LANCAMENTO_CONTABIL                              │
│              (crm_lancamento_contabil)                          │
├─────────────────────────────────────────────────────────────────┤
│ - id_lancamento_contabil: bigint (PK)                           │
│ - id_nota_fiscal: bigint (FK)                                   │
│ - cod_conta_debito: text                                        │
│ - cod_conta_credito: text                                       │
│ - val_lancamento: numeric(14,2)                                 │
│ - dat_lancamento: timestamp                                     │
│ - dat_competencia: date                                         │
│ - dsc_historico: text                                           │
│ - dom_sit_lancamento: text (PENDENTE, INTEGRADO, ERRO)          │
│ - json_retorno_contabil: jsonb                                  │
│ - id_externo_contabil: text (ID no sistema contábil)            │
├─────────────────────────────────────────────────────────────────┤
│ + integrar(): void                                              │
│ + estornar(): LancamentoContabil                                │
│ + consultarStatus(): StatusContabil                             │
└─────────────────────────────────────────────────────────────────┘
```

#### Agregado: OrdemPagamento

> **Tabela BD:** `crm_ordem_pagamento`

```
┌─────────────────────────────────────────────────────────────────┐
│                    <<Aggregate Root>>                           │
│                   ORDEM_PAGAMENTO                               │
│                (crm_ordem_pagamento)                            │
├─────────────────────────────────────────────────────────────────┤
│ - id_ordem_pagamento: bigint (PK)                               │
│ - id_solicitacao_saque: bigint (FK)                             │
│ - id_nota_fiscal: bigint (FK)                                   │
│ - cod_ordem: text (código MFG/Sankhya)                          │
│ - val_bruto: numeric(14,2)                                      │
│ - val_descontos: numeric(14,2)                                  │
│ - val_liquido: numeric(14,2)                                    │
│ - dat_criacao: timestamp                                        │
│ - dat_vencimento: date                                          │
│ - dat_pagamento: timestamp                                      │
│ - dom_sit_ordem: text (CRIADA, APROVADA, EM_PAGAMENTO,          │
│                        PAGA, CANCELADA, ESTORNADA)              │
│ - id_externo_erp: text (ID no MGF/Sankhya)                      │
│ - json_anexos: jsonb (URLs dos anexos - NF XML, PDF)            │
│ - json_retorno_erp: jsonb                                       │
│ - pagamento_pix: PagamentoPIX? (1:1)                            │
├─────────────────────────────────────────────────────────────────┤
│ + criar(): void                                                 │
│ + aprovar(): void                                               │
│ + anexarDocumento(tipo, url): void                              │
│ + processarPagamento(): PagamentoPIX                            │
│ + cancelar(motivo): void                                        │
│ + estornar(motivo): void                                        │
└─────────────────────────────────────────────────────────────────┘
         │
         │ executa (1:1)
         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    <<Entity>>                                   │
│                    PAGAMENTO_PIX                                │
│                  (crm_pagamento_pix)                            │
├─────────────────────────────────────────────────────────────────┤
│ - id_pagamento_pix: bigint (PK)                                 │
│ - id_ordem_pagamento: bigint (FK)                               │
│ - id_conta_consultor: bigint (FK)                               │
│ - chave_pix_destino: text                                       │
│ - dom_tpo_chave: text (CPF, CNPJ, EMAIL, TELEFONE, ALEATORIA)   │
│ - val_pagamento: numeric(14,2)                                  │
│ - end_to_end_id: text (ID do BACEN)                             │
│ - txid: text (ID da transação)                                  │
│ - dat_agendamento: timestamp                                    │
│ - dat_efetivacao: timestamp                                     │
│ - dom_sit_pagamento: text (AGENDADO, PROCESSANDO,               │
│                            EFETIVADO, REJEITADO, DEVOLVIDO)     │
│ - json_retorno_banco: jsonb                                     │
│ - comprovante_url: text                                         │
├─────────────────────────────────────────────────────────────────┤
│ + agendar(): void                                               │
│ + executar(): void                                              │
│ + consultarStatus(): StatusPIX                                  │
│ + gerarComprovante(): File                                      │
│ + devolver(motivo): void                                        │
└─────────────────────────────────────────────────────────────────┘
```

#### Agregado: MotorRegras (Aggregate Root)

> **Tabela BD:** `crm_regra_comissao`, `crm_regra_parametro`, `crm_campanha`, `crm_meta`, `crm_politica_comissao`

```
┌─────────────────────────────────────────────────────────────────┐
│                    <<Aggregate Root>>                           │
│                     REGRA_COMISSAO                              │
│                  (crm_regra_comissao)                           │
├─────────────────────────────────────────────────────────────────┤
│ - id_regra_comissao: bigint (PK)                                │
│ - id_empresa: bigint (FK cor_empresa)                           │
│ - cod_regra: text (código único)                                │
│ - nome_regra: text                                              │
│ - dsc_regra: text                                               │
│ - dom_tpo_regra: text (COMISSAO, RESIDUAL, BONIFICACAO,         │
│                        PREMIACAO, SPIFF, PLR, ACELERADOR,       │
│                        ESCALONADA, OVERRIDE, SPLIT)             │
│ - dom_tpo_template: text (SIMPLES, FAIXA, BONUS_META,           │
│                           SPIFF_PRODUTO, OVERRIDE_GESTOR, PLR)  │
│ - formula: text (expressão de cálculo)                          │
│ - json_formula_visual: jsonb (representação low-code)           │
│ - parametros: List<RegraParametro> (1:N)                        │
│ - condicoes: List<RegraCondicao> (1:N)                          │
│ - dom_sit_regra: text (ATIVA, INATIVA, RASCUNHO)                │
│ - dat_vigencia_ini: date                                        │
│ - dat_vigencia_fim: date                                        │
│ - prioridade: smallint                                          │
│ - id_campanha: bigint (FK, opcional)                            │
├─────────────────────────────────────────────────────────────────┤
│ + calcular(contexto: ContextoCalculo): ResultadoCalculo         │
│ + validarFormula(): boolean                                     │
│ + ativar(): void                                                │
│ + desativar(): void                                             │
│ + clonar(): RegraComissao                                       │
│ + simular(contexto: ContextoCalculo): ResultadoSimulacao        │
└─────────────────────────────────────────────────────────────────┘
         │
         │ contém (1:N)
         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    <<Entity>>                                   │
│                   REGRA_PARAMETRO                               │
│                (crm_regra_parametro)                            │
├─────────────────────────────────────────────────────────────────┤
│ - id_regra_parametro: bigint (PK)                               │
│ - id_regra_comissao: bigint (FK)                                │
│ - cod_parametro: text (ex: PERC_COMISSAO, VALOR_BONUS)          │
│ - dom_tpo_parametro: text (PERCENTUAL, VALOR, QUANTIDADE,       │
│                            BOOLEAN, TEXTO)                      │
│ - val_parametro: text                                           │
│ - dsc_parametro: text                                           │
├─────────────────────────────────────────────────────────────────┤
│ + obterValor<T>(): T                                            │
│ + validar(): boolean                                            │
└─────────────────────────────────────────────────────────────────┘
         │
         │ avalia (1:N)
         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    <<Entity>>                                   │
│                   REGRA_CONDICAO                                │
│                (crm_regra_condicao)                             │
├─────────────────────────────────────────────────────────────────┤
│ - id_regra_condicao: bigint (PK)                                │
│ - id_regra_comissao: bigint (FK)                                │
│ - campo: text (ex: plano.tipo, venda.valor, consultor.tempo)    │
│ - operador: text (=, !=, >, <, >=, <=, IN, BETWEEN)             │
│ - valor: text                                                   │
│ - ordem: smallint                                               │
│ - operador_logico: text (AND, OR)                               │
├─────────────────────────────────────────────────────────────────┤
│ + avaliar(contexto: ContextoCalculo): boolean                   │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    <<Entity>>                                   │
│                      CAMPANHA                                   │
│                    (crm_campanha)                               │
├─────────────────────────────────────────────────────────────────┤
│ - id_campanha: bigint (PK)                                      │
│ - id_empresa: bigint (FK)                                       │
│ - nome_campanha: text                                           │
│ - dsc_campanha: text                                            │
│ - dat_inicio: date                                              │
│ - dat_fim: date                                                 │
│ - dom_sit_campanha: text (RASCUNHO, ATIVA, ENCERRADA, CANCELADA)│
│ - regras: List<RegraComissao> (1:N)                             │
│ - metas: List<MetaCampanha> (1:N)                               │
├─────────────────────────────────────────────────────────────────┤
│ + ativar(): void                                                │
│ + encerrar(): void                                              │
│ + calcularRanking(): List<RankingConsultor>                     │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    <<Entity>>                                   │
│                        META                                     │
│                     (crm_meta)                                  │
├─────────────────────────────────────────────────────────────────┤
│ - id_meta: bigint (PK)                                          │
│ - id_empresa: bigint (FK)                                       │
│ - id_colaborador: bigint (FK, opcional - meta individual)       │
│ - id_equipe: bigint (FK, opcional - meta de equipe)             │
│ - cod_meta: text                                                │
│ - nome_meta: text                                               │
│ - dom_tpo_meta: text (INDIVIDUAL, EQUIPE, COMPOSTA, PROGRESSIVA)│
│ - dom_tpo_indicador: text (VENDAS_QTD, VENDAS_VALOR, NPS,       │
│                            RETENCAO, CONVERSAO, CUSTOMIZADO)    │
│ - val_floor: numeric(14,2) (mínimo)                             │
│ - val_target: numeric(14,2) (alvo)                              │
│ - val_stretch: numeric(14,2) (superação)                        │
│ - val_realizado: numeric(14,2)                                  │
│ - perc_atingimento: numeric(5,2)                                │
│ - dat_inicio: date                                              │
│ - dat_fim: date                                                 │
│ - dom_periodo: text (MENSAL, TRIMESTRAL, SEMESTRAL, ANUAL)      │
│ - dom_sit_meta: text (ATIVA, ENCERRADA, CANCELADA)              │
│ - json_indicadores_compostos: jsonb (para metas compostas)      │
├─────────────────────────────────────────────────────────────────┤
│ + atualizarRealizado(valor): void                               │
│ + calcularAtingimento(): Percentual                             │
│ + projetarAtingimento(): Percentual                             │
│ + verificarAlertaDesvio(): Alerta?                              │
│ + obterPosicaoRanking(): RankingPosition                        │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    <<Entity>>                                   │
│              POLITICA_COMISSIONAMENTO                           │
│             (crm_politica_comissao)                             │
├─────────────────────────────────────────────────────────────────┤
│ - id_politica: bigint (PK)                                      │
│ - id_empresa: bigint (FK)                                       │
│ - cod_politica: text                                            │
│ - nome_politica: text                                           │
│ - dsc_politica: text                                            │
│ - versao: smallint                                              │
│ - documento_url: text (PDF da política)                         │
│ - hash_documento: text (SHA-256)                                │
│ - dat_vigencia_ini: date                                        │
│ - dat_vigencia_fim: date                                        │
│ - dom_sit_politica: text (RASCUNHO, PUBLICADA, VIGENTE, EXPIRADA)│
│ - regras: List<RegraComissao> (1:N)                             │
│ - aceites: List<AceitePolitica> (1:N)                           │
├─────────────────────────────────────────────────────────────────┤
│ + publicar(): void                                              │
│ + expirar(): void                                               │
│ + compararVersao(outra: PoliticaComissionamento): Diff          │
│ + verificarAceitesPendentes(): List<Colaborador>                │
└─────────────────────────────────────────────────────────────────┘
         │
         │ registra (1:N)
         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    <<Entity>>                                   │
│                   ACEITE_POLITICA                               │
│                (crm_aceite_politica)                            │
├─────────────────────────────────────────────────────────────────┤
│ - id_aceite: bigint (PK)                                        │
│ - id_politica: bigint (FK)                                      │
│ - id_colaborador: bigint (FK)                                   │
│ - dat_aceite: timestamp                                         │
│ - ip_aceite: text                                               │
│ - user_agent: text                                              │
│ - hash_documento: text (hash no momento do aceite)              │
│ - assinatura_digital: text                                      │
│ - dom_tpo_aceite: text (DIGITAL, PRESENCIAL)                    │
├─────────────────────────────────────────────────────────────────┤
│ + validarAssinatura(): boolean                                  │
│ + gerarComprovante(): File                                      │
└─────────────────────────────────────────────────────────────────┘
```

#### Agregado: Estorno

> **Tabela BD:** `crm_estorno`

```
┌─────────────────────────────────────────────────────────────────┐
│                    <<Aggregate Root>>                           │
│                        ESTORNO                                  │
│                     (crm_estorno)                               │
├─────────────────────────────────────────────────────────────────┤
│ - id_estorno: bigint (PK)                                       │
│ - id_negociacao: bigint (FK crm_negociacao, venda cancelada)    │
│ - id_conta_consultor: bigint (FK, débito)                       │
│ - id_cliente: bigint (FK cor_cliente, crédito)                  │
│ - cod_estorno: text                                             │
│ - dom_tpo_estorno: text (CANCELAMENTO, DEVOLUCAO, AJUSTE)       │
│ - dom_mot_estorno: text (motivo)                                │
│ - val_estorno_consultor: numeric(14,2)                          │
│ - val_devolucao_cliente: numeric(14,2)                          │
│ - dat_solicitacao: timestamp                                    │
│ - dat_processamento: timestamp                                  │
│ - dom_sit_estorno: text (PENDENTE, APROVADO, PROCESSANDO,       │
│                          CONCLUIDO, CANCELADO)                  │
│ - lancamento_debito: LancamentoFinanceiro? (débito consultor)   │
│ - devolucao_cliente: DevolucaoCliente? (PIX para cliente)       │
│ - cancelamento_nf: CancelamentoNF? (se aplicável)               │
│ - estorno_ordem: EstornoOrdem? (se aplicável)                   │
├─────────────────────────────────────────────────────────────────┤
│ + aprovar(): void                                               │
│ + rejeitar(motivo): void                                        │
│ + processar(): void                                             │
│ + debitarConsultor(): void                                      │
│ + devolverCliente(): void                                       │
│ + cancelarNF(): void                                            │
│ + estornarOrdemPagamento(): void                                │
└─────────────────────────────────────────────────────────────────┘
```

### 2.3 Entidades

| Entidade | Tabela BD | Descrição | Identificador |
|----------|-----------|-----------|---------------|
| **ContaConsultor** | `crm_conta_consultor` | Aggregate Root - Conta financeira do consultor | id_conta_consultor |
| **LancamentoFinanceiro** | `crm_lancamento_financeiro` | Movimentação de crédito/débito | id_lancamento |
| **SolicitacaoSaque** | `crm_solicitacao_saque` | Pedido de saque do consultor | id_solicitacao_saque + cod_solicitacao |
| **NotaFiscal** | `crm_nota_fiscal` | NF-e ou NFS-e emitida | id_nota_fiscal + chave_acesso |
| **LancamentoContabil** | `crm_lancamento_contabil` | Registro no sistema contábil | id_lancamento_contabil |
| **OrdemPagamento** | `crm_ordem_pagamento` | Ordem no MGF/Sankhya | id_ordem_pagamento + cod_ordem |
| **PagamentoPIX** | `crm_pagamento_pix` | Transferência PIX executada | id_pagamento_pix + end_to_end_id |
| **RegraComissao** | `crm_regra_comissao` | Regra do motor de cálculo | id_regra_comissao + cod_regra |
| **RegraParametro** | `crm_regra_parametro` | Parâmetro da regra | id_regra_parametro |
| **RegraCondicao** | `crm_regra_condicao` | Condição de aplicação | id_regra_condicao |
| **Campanha** | `crm_campanha` | Campanha de premiação | id_campanha |
| **Meta** | `crm_meta` | Meta individual/equipe/composta | id_meta + cod_meta |
| **PoliticaComissionamento** | `crm_politica_comissao` | Política de comissão versionada | id_politica + cod_politica |
| **AceitePolitica** | `crm_aceite_politica` | Aceite digital da política | id_aceite |
| **Estorno** | `crm_estorno` | Cancelamento/devolução | id_estorno + cod_estorno |

### 2.4 Value Objects

#### Domínios do Banco de Dados

| Value Object | Domínio BD | Valores | Descrição |
|--------------|------------|---------|-----------|
| **DomTpoLancamento** | `dom_tpo_lancamento` | COMISSAO, RESIDUAL, BONIFICACAO, PREMIACAO, SPIFF, PLR, ACELERADOR, OVERRIDE, SPLIT, ESTORNO, AJUSTE | Tipo de lançamento |
| **DomNatLancamento** | `dom_nat_lancamento` | CREDITO, DEBITO | Natureza (C/D) |
| **DomSitLancamento** | `dom_sit_lancamento` | PENDENTE, CONFIRMADO, CANCELADO | Status do lançamento |
| **DomTpoSaque** | `dom_tpo_saque` | TOTAL, PARCIAL, PERIODO | Tipo de saque |
| **DomSitSolicitacao** | `dom_sit_solicitacao` | PENDENTE, EM_PROCESSAMENTO, AGUARDANDO_NF, NF_EMITIDA, AGUARDANDO_PAGAMENTO, PAGO, CANCELADO, REJEITADO | Status da solicitação |
| **DomTpoNF** | `dom_tpo_nf` | NFE, NFSE | Tipo de nota fiscal |
| **DomSitNF** | `dom_sit_nf` | EMITIDA, CANCELADA, INUTILIZADA | Status da NF |
| **DomSitOrdem** | `dom_sit_ordem` | CRIADA, APROVADA, EM_PAGAMENTO, PAGA, CANCELADA, ESTORNADA | Status da ordem |
| **DomTpoChavePIX** | `dom_tpo_chave` | CPF, CNPJ, EMAIL, TELEFONE, ALEATORIA | Tipo de chave PIX |
| **DomSitPagamentoPIX** | `dom_sit_pagamento` | AGENDADO, PROCESSANDO, EFETIVADO, REJEITADO, DEVOLVIDO | Status do PIX |
| **DomTpoRegra** | `dom_tpo_regra` | COMISSAO, RESIDUAL, BONIFICACAO, PREMIACAO, SPIFF, PLR, ACELERADOR, ESCALONADA, OVERRIDE, SPLIT | Tipo de regra |
| **DomTpoTemplate** | `dom_tpo_template` | SIMPLES, FAIXA, BONUS_META, SPIFF_PRODUTO, OVERRIDE_GESTOR, PLR | Template de regra |
| **DomSitRegra** | `dom_sit_regra` | ATIVA, INATIVA, RASCUNHO | Status da regra |
| **DomTpoParametro** | `dom_tpo_parametro` | PERCENTUAL, VALOR, QUANTIDADE, BOOLEAN, TEXTO | Tipo de parâmetro |
| **DomTpoMeta** | `dom_tpo_meta` | INDIVIDUAL, EQUIPE, COMPOSTA, PROGRESSIVA | Tipo de meta |
| **DomTpoIndicador** | `dom_tpo_indicador` | VENDAS_QTD, VENDAS_VALOR, NPS, RETENCAO, CONVERSAO, CUSTOMIZADO | Indicador da meta |
| **DomPeriodo** | `dom_periodo` | MENSAL, TRIMESTRAL, SEMESTRAL, ANUAL | Período da meta |
| **DomSitMeta** | `dom_sit_meta` | ATIVA, ENCERRADA, CANCELADA | Status da meta |
| **DomSitPolitica** | `dom_sit_politica` | RASCUNHO, PUBLICADA, VIGENTE, EXPIRADA | Status da política |
| **DomTpoAceite** | `dom_tpo_aceite` | DIGITAL, PRESENCIAL | Tipo de aceite |
| **DomTpoEstorno** | `dom_tpo_estorno` | CANCELAMENTO, DEVOLUCAO, AJUSTE | Tipo de estorno |
| **DomSitEstorno** | `dom_sit_estorno` | PENDENTE, APROVADO, PROCESSANDO, CONCLUIDO, CANCELADO | Status do estorno |
| **DomSitConta** | `dom_sit_conta` | ATIVA, BLOQUEADA, INATIVA | Status da conta |

#### Value Objects de Negócio

| Value Object | Propriedades | Validações |
|--------------|--------------|------------|
| **Dinheiro** | valor: numeric(14,2), moeda: text | >= 0, BRL |
| **DadosBancarios** | banco, agencia, conta, digito, tipo_conta, chave_pix | Dados bancários do consultor |
| **DadosFiscais** | cpf_cnpj, inscricao_municipal, regime_tributario | Dados para emissão de NF |
| **ChaveAcessoNF** | valor: text (44 dígitos) | Formato válido SEFAZ |
| **ContextoCalculo** | negociacao, consultor, plano, valores, periodo, metas | Dados para cálculo |
| **ResultadoCalculo** | valor, regra_aplicada, detalhamento, log_auditoria | Resultado do motor com rastreabilidade |
| **DemonstrativoFinanceiro** | periodo, lancamentos, totais, saldos | Demonstrativo analítico/sintético |
| **ExtratoConsultor** | periodo, movimentacoes, saldo_anterior, saldo_final | Extrato de movimentações |
| **SimulacaoComissao** | cenario, vendas_adicionais, impacto_financeiro | Simulação "what-if" |
| **RankingPosition** | posicao, total_participantes, percentil | Posição no ranking |

#### Tabelas de Referência (FK)

| Entidade Externa | Tabela BD | Relacionamento |
|------------------|-----------|----------------|
| **Colaborador** | `cor_colaborador` | crm_conta_consultor.id_colaborador |
| **Empresa** | `cor_empresa` | crm_conta_consultor.id_empresa |
| **Usuario** | `amb_usuario` | crm_solicitacao_saque.id_usuario |
| **Negociacao** | `crm_negociacao` | crm_lancamento_financeiro.id_negociacao |
| **Cliente** | `cor_cliente` | crm_estorno.id_cliente |
| **Equipe** | `cor_equipe` | crm_meta.id_equipe |

### 2.5 Eventos de Domínio

| Evento | Trigger | Payload | Consumidores |
|--------|---------|---------|--------------|
| **ComissaoCreditada** | Venda concretizada | contaId, valor, negociacaoId | Notificação, Dashboard |
| **ResidualCreditado** | Mensalidade paga | contaId, valor, associadoId | Notificação |
| **SaqueSolicitado** | Consultor solicita saque | solicitacaoId, contaId, valor | Workflow, Banco Digital |
| **NotaFiscalEmitida** | NF gerada com sucesso | nfId, solicitacaoId, chaveAcesso | Contábil, Workflow |
| **NotaFiscalCancelada** | NF cancelada | nfId, motivo | Contábil, Estorno |
| **LancamentoContabilIntegrado** | Integração contábil OK | lancamentoId, idExterno | Auditoria |
| **OrdemPagamentoCriada** | Ordem criada no ERP | ordemId, solicitacaoId | Workflow |
| **PagamentoPIXEfetivado** | PIX confirmado | pagamentoId, endToEndId | Notificação, Extrato |
| **EstornoProcessado** | Estorno concluído | estornoId, valorConsultor, valorCliente | Notificação, Contábil |
| **RegraComissaoAtivada** | Nova regra ativada | regraId, vigencia | Auditoria |
| **CampanhaIniciada** | Campanha ativa | campanhaId, periodo | Notificação |
| **DemonstrativoGerado** | Demonstrativo disponível | contaId, periodo, url | Notificação, App |
| **MetaAtualizada** | Realizado atualizado | metaId, valorAnterior, valorNovo, atingimento | Dashboard, Ranking |
| **MetaAtingida** | Meta floor/target/stretch alcançada | metaId, tipoMeta, colaboradorId | Notificação, Bonificação |
| **AlertaDesvioMeta** | Desvio significativo detectado | metaId, percDesvio | Gestor, Notificação |
| **PoliticaPublicada** | Nova política publicada | politicaId, versao | Notificação, Aceite |
| **AceiteRegistrado** | Consultor aceitou política | aceiteId, colaboradorId, politicaId | Auditoria, Compliance |
| **AceitePendente** | Lembrete de aceite pendente | colaboradorId, politicaId, diasPendente | Notificação |

### 2.6 Integrações Externas

| Sistema | Tipo | Protocolo | Descrição |
|---------|------|-----------|-----------|
| **Banco Digital** | Externo | API REST + Webhooks | Abertura de tickets, consulta de saldo, execução PIX |
| **SEFAZ** | Externo | Web Service SOAP | Emissão, consulta e cancelamento de NF-e |
| **Prefeitura (NFS-e)** | Externo | API REST/SOAP | Emissão de NFS-e (varia por município) |
| **Sistema Contábil** | Externo | API REST | Lançamentos contábeis automáticos |
| **MGF/Sankhya** | Externo | API REST | Ordens de pagamento, contas a pagar |
| **App Consultor** | Interno | API REST + Push | Demonstrativos, notificações, aprovações |
| **CRM Principal** | Interno | Eventos | Vendas concretizadas, cancelamentos |

---

## 3. Histórias de Usuário

### 3.1 Essenciais - Conta e Saldo

| ID | História | Prioridade | SP |
|----|----------|------------|-----|
| US-CRM-FIN-001 | Como consultor, quero visualizar meu saldo disponível para saque, para saber quanto posso receber | Essencial | 8 |
| US-CRM-FIN-002 | Como consultor, quero visualizar meu extrato de movimentações, para acompanhar entradas e saídas | Essencial | 8 |
| US-CRM-FIN-003 | Como consultor, quero solicitar saque total do meu saldo, para receber meus valores | Essencial | 13 |
| US-CRM-FIN-004 | Como consultor, quero solicitar saque parcial (valor específico), para gerenciar meus recebimentos | Essencial | 8 |
| US-CRM-FIN-005 | Como consultor, quero solicitar saque por período, para receber valores de um intervalo específico | Essencial | 8 |
| US-CRM-FIN-006 | Como sistema, quero creditar automaticamente comissões na conta do consultor quando uma venda for concretizada | Essencial | 13 |

### 3.2 Essenciais - Emissão de NF

| ID | História | Prioridade | SP |
|----|----------|------------|-----|
| US-CRM-FIN-007 | Como sistema, quero emitir NF-e/NFS-e automaticamente ao aprovar solicitação de saque | Essencial | 21 |
| US-CRM-FIN-008 | Como sistema, quero arquivar XML e PDF das notas fiscais emitidas | Essencial | 5 |
| US-CRM-FIN-009 | Como consultor, quero visualizar minhas notas fiscais emitidas | Essencial | 5 |
| US-CRM-FIN-010 | Como sistema, quero cancelar nota fiscal quando necessário | Essencial | 13 |

### 3.3 Essenciais - Pagamento

| ID | História | Prioridade | SP |
|----|----------|------------|-----|
| US-CRM-FIN-011 | Como sistema, quero criar ordem de pagamento no MGF/Sankhya com anexos da NF | Essencial | 13 |
| US-CRM-FIN-012 | Como sistema, quero processar pagamento via PIX na conta do consultor | Essencial | 21 |
| US-CRM-FIN-013 | Como sistema, quero atualizar status da solicitação em cada etapa do fluxo | Essencial | 8 |
| US-CRM-FIN-014 | Como consultor, quero receber notificação quando meu pagamento for efetuado | Essencial | 5 |

### 3.4 Importantes - Contabilidade

| ID | História | Prioridade | SP |
|----|----------|------------|-----|
| US-CRM-FIN-015 | Como sistema, quero realizar lançamento contábil automático ao emitir NF | Importante | 13 |
| US-CRM-FIN-016 | Como sistema, quero estornar lançamento contábil ao cancelar NF | Importante | 8 |

### 3.5 Importantes - Cancelamentos e Estornos

| ID | História | Prioridade | SP |
|----|----------|------------|-----|
| US-CRM-FIN-017 | Como sistema, quero debitar o consultor quando uma venda for cancelada | Importante | 13 |
| US-CRM-FIN-018 | Como sistema, quero devolver valores ao cliente (PIX) em caso de cancelamento | Importante | 13 |
| US-CRM-FIN-019 | Como sistema, quero cancelar NF e estornar ordem de pagamento em cancelamentos | Importante | 13 |
| US-CRM-FIN-020 | Como gestor, quero aprovar/rejeitar estornos antes do processamento | Importante | 8 |

### 3.6 Importantes - Motor de Regras

| ID | História | Prioridade | SP |
|----|----------|------------|-----|
| US-CRM-FIN-021 | Como gestor, quero cadastrar regras de comissão com fórmulas configuráveis | Importante | 21 |
| US-CRM-FIN-022 | Como gestor, quero cadastrar regras de residual sobre mensalidades | Importante | 13 |
| US-CRM-FIN-023 | Como gestor, quero cadastrar regras de bonificação por metas | Importante | 13 |
| US-CRM-FIN-024 | Como gestor, quero criar campanhas de premiação com período específico | Importante | 13 |
| US-CRM-FIN-025 | Como gestor, quero simular cálculo de comissão antes de ativar regra | Importante | 8 |

### 3.7 Importantes - Demonstrativos

| ID | História | Prioridade | SP |
|----|----------|------------|-----|
| US-CRM-FIN-026 | Como consultor, quero visualizar demonstrativo analítico de comissões | Importante | 13 |
| US-CRM-FIN-027 | Como consultor, quero visualizar demonstrativo sintético (resumo) | Importante | 8 |
| US-CRM-FIN-028 | Como sistema, quero enviar demonstrativos automaticamente por período | Importante | 8 |
| US-CRM-FIN-029 | Como consultor, quero aprovar/contestar valores a receber | Importante | 8 |

### 3.8 Desejáveis - Avançado

| ID | História | Prioridade | SP |
|----|----------|------------|-----|
| US-CRM-FIN-030 | Como consultor, quero acessar demonstrativos pelo App | Desejável | 13 |
| US-CRM-FIN-031 | Como consultor, quero receber push notification de créditos | Desejável | 5 |
| US-CRM-FIN-032 | Como gestor, quero visualizar dashboard financeiro consolidado | Desejável | 13 |
| US-CRM-FIN-033 | Como sistema, quero creditar residuais automaticamente | Desejável | 13 |
| US-CRM-FIN-034 | Como gestor, quero exportar relatórios financeiros | Desejável | 8 |

### 3.9 Motor de Regras Avançado (SplitC)

> **Novas funcionalidades inspiradas na plataforma SplitC**

| ID | História | Prioridade | SP |
|----|----------|------------|-----|
| US-CRM-FIN-035 | Como gestor, quero cadastrar regras SPIFF (incentivo pontual por produto), para premiar vendas específicas | Importante | 8 |
| US-CRM-FIN-036 | Como gestor, quero cadastrar regras de PLR com fórmulas complexas, para distribuir lucros | Importante | 13 |
| US-CRM-FIN-037 | Como gestor, quero cadastrar aceleradores progressivos por faixa, para incentivar superação de metas | Importante | 13 |
| US-CRM-FIN-038 | Como gestor, quero cadastrar comissão escalonada por volume, para premiar alto desempenho | Importante | 8 |
| US-CRM-FIN-039 | Como gestor, quero cadastrar override (comissão sobre equipe), para remunerar gestores | Importante | 13 |
| US-CRM-FIN-040 | Como gestor, quero cadastrar split de comissão entre consultores, para vendas compartilhadas | Importante | 8 |
| US-CRM-FIN-041 | Como gestor, quero usar templates pré-configurados de regras, para agilizar cadastro | Desejável | 5 |
| US-CRM-FIN-042 | Como gestor, quero montar regras visualmente (low-code), para facilitar configuração | Desejável | 21 |

### 3.10 Gestão de Metas Avançada

| ID | História | Prioridade | SP |
|----|----------|------------|-----|
| US-CRM-FIN-043 | Como gestor, quero cadastrar metas individuais com floor/target/stretch | Importante | 8 |
| US-CRM-FIN-044 | Como gestor, quero cadastrar metas de equipe agregadas | Importante | 8 |
| US-CRM-FIN-045 | Como gestor, quero cadastrar metas compostas (múltiplos indicadores) | Desejável | 13 |
| US-CRM-FIN-046 | Como consultor, quero visualizar meu atingimento em tempo real | Importante | 8 |
| US-CRM-FIN-047 | Como consultor, quero ver projeção de atingimento até fim do período | Desejável | 5 |
| US-CRM-FIN-048 | Como gestor, quero receber alertas de desvio de meta da equipe | Desejável | 5 |

### 3.11 Portal de Transparência

| ID | História | Prioridade | SP |
|----|----------|------------|-----|
| US-CRM-FIN-049 | Como consultor, quero ver detalhamento de cada cálculo de comissão | Importante | 8 |
| US-CRM-FIN-050 | Como consultor, quero simular "quanto ganho se vender X" | Desejável | 8 |
| US-CRM-FIN-051 | Como consultor, quero ver minha posição no ranking da equipe | Desejável | 5 |

### 3.12 Aceite Digital de Políticas

| ID | História | Prioridade | SP |
|----|----------|------------|-----|
| US-CRM-FIN-052 | Como gestor, quero publicar políticas de comissionamento versionadas | Importante | 8 |
| US-CRM-FIN-053 | Como consultor, quero aceitar digitalmente políticas com validade jurídica | Importante | 13 |
| US-CRM-FIN-054 | Como gestor, quero visualizar aceites pendentes e enviar lembretes | Importante | 5 |
| US-CRM-FIN-055 | Como sistema, quero registrar aceite com hash, timestamp e IP para auditoria | Importante | 8 |

---

## 4. Regras de Negócio

### 4.1 Regras de Saque

| Código | Regra | Validação |
|--------|-------|-----------|
| RN-FIN-001 | Saldo mínimo para saque | Saldo disponível >= R$ 50,00 |
| RN-FIN-002 | Valor máximo por saque | Conforme limite da conta |
| RN-FIN-003 | Dados bancários obrigatórios | Conta PIX cadastrada e validada |
| RN-FIN-004 | Dados fiscais obrigatórios | CPF/CNPJ e regime tributário |
| RN-FIN-005 | Saque único por vez | Não pode ter solicitação em processamento |

### 4.2 Regras de NF

| Código | Regra | Validação |
|--------|-------|-----------|
| RN-FIN-006 | Tipo de NF por regime | MEI/Autônomo: NFS-e, Empresa: NF-e |
| RN-FIN-007 | Prazo cancelamento NF-e | Até 24h após emissão |
| RN-FIN-008 | Prazo cancelamento NFS-e | Conforme regra municipal |
| RN-FIN-009 | Retenções automáticas | ISS, IRRF conforme regime |

### 4.3 Regras de Estorno

| Código | Regra | Validação |
|--------|-------|-----------|
| RN-FIN-010 | Estorno obrigatório | Cancelamento de venda = estorno automático |
| RN-FIN-011 | Débito consultor | Estorno debita comissão já creditada |
| RN-FIN-012 | Devolução cliente | Valores pagos pelo cliente devolvidos via PIX |
| RN-FIN-013 | Aprovação de estorno | Estornos > R$ 500 requerem aprovação |

### 4.4 Regras do Motor

| Código | Regra | Validação |
|--------|-------|-----------|
| RN-FIN-014 | Prioridade de regras | Regra mais específica tem precedência |
| RN-FIN-015 | Vigência obrigatória | Toda regra deve ter período de vigência |
| RN-FIN-016 | Fórmula válida | Expressão deve ser válida antes de ativar |
| RN-FIN-017 | Campanha exclusiva | Premiação de campanha não acumula com bonificação |

### 4.5 Regras de Metas

| Código | Regra | Validação |
|--------|-------|-----------|
| RN-FIN-018 | Hierarquia de metas | floor < target < stretch |
| RN-FIN-019 | Alerta de desvio | Notificar se atingimento < 70% com 50%+ do período |
| RN-FIN-020 | Bonificação por faixa | floor = sem bônus, target = 100%, stretch = multiplicador |
| RN-FIN-021 | Meta de equipe | Atingimento = soma realizados / soma targets |

### 4.6 Regras de Políticas

| Código | Regra | Validação |
|--------|-------|-----------|
| RN-FIN-022 | Aceite obrigatório | Consultor deve aceitar política vigente para receber |
| RN-FIN-023 | Validade jurídica | Aceite deve registrar hash, timestamp, IP |
| RN-FIN-024 | Versão única | Apenas uma política pode estar VIGENTE por vez |
| RN-FIN-025 | Prazo de aceite | Máximo 7 dias para aceitar após publicação |

---

## 5. Métricas (KPIs)

| Métrica | Descrição | Meta |
|---------|-----------|------|
| Tempo médio saque → pagamento | Tempo do processo completo | < 24h |
| Taxa de sucesso emissão NF | NFs emitidas sem erro | > 98% |
| Taxa de sucesso PIX | PIXs efetivados | > 99% |
| Volume diário de saques | Quantidade de solicitações | Monitorar |
| Taxa de estornos | Estornos / vendas | < 5% |
| Ticket médio de saque | Valor médio por saque | Monitorar |
| Comissão média por venda | Valor médio de comissão | Monitorar |
| Taxa de atingimento de metas | Consultores que atingiram target | > 70% |
| Tempo médio aceite política | Dias entre publicação e aceite | < 3 dias |
| Taxa de aceites pendentes | Aceites pendentes / total | < 5% |
| Uso do simulador | Simulações realizadas / consultores | Monitorar |

---

## 6. Histórico de Alterações

| Data | Versão | Autor | Alteração |
|------|--------|-------|-----------|
| 29/01/2026 | 1.0 | Product Owner | Versão inicial - Estrutura completa do módulo CRM-Financeiro |
| 29/01/2026 | 2.0 | Product Owner | Motor de Regras Avançado inspirado SplitC: +21 histórias (+181 SP) |

---

**Versão**: 2.0  
**Data**: 29/01/2026  
**Responsável**: Product Owner - CRM  
**Tipo DDD**: Core Domain

## 7. Resumo de Story Points

| Categoria | Histórias | Story Points |
|-----------|-----------|--------------|
| Essenciais - Conta e Saldo (FIN-001 a FIN-006) | 6 | 58 SP |
| Essenciais - Emissão de NF (FIN-007 a FIN-010) | 4 | 44 SP |
| Essenciais - Pagamento (FIN-011 a FIN-014) | 4 | 47 SP |
| Importantes - Contabilidade (FIN-015 a FIN-016) | 2 | 21 SP |
| Importantes - Cancelamentos/Estornos (FIN-017 a FIN-020) | 4 | 47 SP |
| Importantes - Motor de Regras (FIN-021 a FIN-025) | 5 | 68 SP |
| Importantes - Demonstrativos (FIN-026 a FIN-029) | 4 | 37 SP |
| Desejáveis - Avançado (FIN-030 a FIN-034) | 5 | 52 SP |
| **Motor Regras Avançado - SplitC (FIN-035 a FIN-042)** | **8** | **89 SP** |
| **Gestão de Metas Avançada (FIN-043 a FIN-048)** | **6** | **47 SP** |
| **Portal de Transparência (FIN-049 a FIN-051)** | **3** | **21 SP** |
| **Aceite Digital de Políticas (FIN-052 a FIN-055)** | **4** | **34 SP** |
| **TOTAL CRM-Financeiro** | **55** | **565 SP** |

### 7.1 Comparativo de Evolução

| Métrica | v1.0 | v2.0 | Δ Variação |
|---------|------|------|------------|
| Histórias de Usuário | 34 | 55 | +21 (+62%) |
| Story Points | 374 SP | 565 SP | +191 SP (+51%) |
| Entidades DDD | 12 | 16 | +4 (+33%) |
| Eventos de Domínio | 12 | 18 | +6 (+50%) |
| Regras de Negócio | 17 | 25 | +8 (+47%) |

### 7.2 Novas Funcionalidades (SplitC-inspired)

| Funcionalidade | Descrição | SP |
|----------------|-----------|-----|
| **Motor de Cálculo Avançado** | SPIFF, PLR, Acelerador, Escalonada, Override, Split | 63 SP |
| **Motor Visual Low-Code** | Interface drag-and-drop para regras | 21 SP |
| **Templates Pré-configurados** | Modelos prontos de regras comuns | 5 SP |
| **Gestão de Metas** | Individual, Equipe, Composta, Progressiva | 47 SP |
| **Portal de Transparência** | Detalhamento, Simulador, Ranking | 21 SP |
| **Aceite Digital** | Políticas versionadas com validade jurídica | 34 SP |
| **Rastreabilidade 100%** | Log completo de cálculos para auditoria | Incluído |

---

## 8. Dependências e Impactos

### 8.1 Dependências de Outros Módulos

| Módulo | Dependência | Tipo |
|--------|-------------|------|
| **CRM-Funil-Vendas** | Evento de venda concretizada | Upstream |
| **CRM-Pagamentos** | Confirmação de pagamento do cliente | Upstream |
| **CRM-Leads** | Dados do lead para devolução | Shared |
| **CRM-Autenticação** | Autenticação do consultor | Generic |

### 8.2 Impactos em Outros Módulos

| Módulo | Impacto | Ação Necessária |
|--------|---------|-----------------|
| **CRM-Pagamentos** | Fluxo de cancelamento | Adicionar evento de cancelamento |
| **CRM-Funil-Vendas** | Crédito de comissão | Publicar evento NegociacaoConcretizada |
| **Context Map** | Novo bounded context | Atualizar diagrama |
| **Product Backlog** | Novas histórias | Adicionar épico CRM-FIN |

### 8.3 Integrações Externas Necessárias

| Sistema | Esforço Estimado | Prioridade |
|---------|------------------|------------|
| Banco Digital API | 40 SP | Alta |
| SEFAZ (NF-e) | 60 SP | Alta |
| Prefeituras (NFS-e) | 80 SP | Alta |
| Sistema Contábil | 30 SP | Média |
| MFMGF/Sankhya | 40 SP | Alta |
| App Consultor | 20 SP | Média |

**Total Integrações: ~270 SP adicionais**
