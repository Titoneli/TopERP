# CRM-Pagamentos (CRM-PAG)

| Metadado | Valor |
|----------|-------|
| **Módulo** | Pagamentos |
| **Código** | CRM-PAG |
| **Versão** | 1.0 |
| **Data** | 22/01/2026 |
| **Autor** | Product Owner |
| **Status** | Planejado |
| **Tipo DDD** | Core Domain |

---

## 1. Visão Geral

O módulo **CRM-Pagamentos** é responsável pelo processamento e gestão de pagamentos no fluxo de vendas do CRM. Este é um **Bounded Context Core** pois representa uma etapa crítica no funil de conversão.

### 1.1 Responsabilidades

- Geração de cobranças (PIX, Boleto)
- Integração com banco digital
- Confirmação automática de pagamentos
- Gestão de status de pagamento
- Notificações de vencimento
- Registro de comprovantes

### 1.2 Posição no Funil

```
[Proposta Aceita] ──► [PAGAMENTO] ──► [Vistoria Agendada]
                         │
                    CRM-PAG
```

---

## 2. Domain-Driven Design

### 2.1 Bounded Context

| Atributo | Descrição |
|----------|-----------|
| **Nome** | Pagamentos |
| **Tipo** | Core Domain |
| **Linguagem Ubíqua** | Cobrança, PIX, Boleto, Confirmação, Comprovante |

### 2.2 Agregados

#### Agregado: Cobrança

```
┌─────────────────────────────────────────────────────────┐
│                    COBRANÇA (Root)                      │
├─────────────────────────────────────────────────────────┤
│ - id: UUID                                              │
│ - proposta_id: UUID (FK CRM-PRO)                        │
│ - lead_id: UUID (FK CRM-LED)                            │
│ - valor: Money                                          │
│ - tipo: TipoCobranca (PIX, BOLETO)                      │
│ - status: StatusCobranca                                │
│ - data_emissao: DateTime                                │
│ - data_vencimento: DateTime                             │
│ - data_pagamento: DateTime?                             │
│                                                         │
│ Entidades:                                              │
│ ├── Comprovante                                         │
│ │   - id: UUID                                          │
│ │   - arquivo_url: String                               │
│ │   - data_upload: DateTime                             │
│ │   - validado: Boolean                                 │
│ │                                                       │
│ └── NotificacaoCobranca                                 │
│     - id: UUID                                          │
│     - tipo: TipoNotificacao                             │
│     - data_envio: DateTime                              │
│     - canal: CanalNotificacao                           │
│                                                         │
│ Value Objects:                                          │
│ ├── Money (valor, moeda)                                │
│ ├── DadosPIX (chave, qrcode, copia_cola)                │
│ └── DadosBoleto (linha_digitavel, codigo_barras)        │
└─────────────────────────────────────────────────────────┘
```

### 2.3 Entidades

| Entidade | Descrição | Atributos Principais |
|----------|-----------|----------------------|
| **Cobrança** | Aggregate Root - Registro de cobrança | id, valor, tipo, status |
| **Comprovante** | Arquivo de comprovante anexado | arquivo_url, validado |
| **NotificacaoCobranca** | Registro de notificação enviada | tipo, canal, data_envio |

### 2.4 Value Objects

| Value Object | Descrição | Atributos |
|--------------|-----------|-----------|
| **Money** | Valor monetário | valor, moeda |
| **DadosPIX** | Informações do PIX | chave, qrcode, copia_cola, txid |
| **DadosBoleto** | Informações do boleto | linha_digitavel, codigo_barras, nosso_numero |
| **StatusCobranca** | Estado da cobrança | PENDENTE, PAGO, VENCIDO, CANCELADO |

### 2.5 Eventos de Domínio

| Evento | Trigger | Consumidores |
|--------|---------|--------------|
| `CobrancaGerada` | Nova cobrança criada | CRM-DAS, CRM-AUD, CRM-LED |
| `PagamentoConfirmado` | Pagamento identificado | CRM-VIS, CRM-COM, CRM-AUD |
| `CobrancaVencida` | Data vencimento ultrapassada | CRM-TAR, CRM-LED, CRM-AUD |
| `ComprovantAnexado` | Comprovante manual enviado | CRM-ANA, CRM-AUD |
| `NotificacaoEnviada` | Lembrete/aviso enviado | CRM-AUD |

### 2.6 Repositórios

| Repositório | Métodos Principais |
|-------------|-------------------|
| `CobrancaRepository` | save, findById, findByPropostaId, findByStatus |
| `ComprovanteRepository` | save, findByCobrancaId |

---

## 3. Integrações

### 3.1 Upstream (Recebe de)

| Contexto | Dados Recebidos | Padrão |
|----------|-----------------|--------|
| CRM-PRO | proposta_id, valor, cliente_id | Customer/Supplier |
| CRM-LED | lead_id, dados_contato | Shared Kernel |

### 3.2 Downstream (Envia para)

| Contexto | Dados Enviados | Padrão |
|----------|----------------|--------|
| CRM-VIS | pagamento_confirmado, proposta_id | Domain Event |
| CRM-COM | valor_pago, data_pagamento | Domain Event |
| CRM-DAS | métricas de pagamento | CQRS Read Model |
| CRM-AUD | todos os eventos | Event Sourcing |

### 3.3 Integrações Externas (ACL)

| Sistema | Adapter | Operações |
|---------|---------|-----------|
| **Banco Digital** | BancoDigitalAdapter | gerarPIX, gerarBoleto, consultarPagamento |
| **Webhook Banco** | WebhookHandler | receberConfirmacao |

```
┌─────────────────────────────────────────────────────────┐
│              ANTI-CORRUPTION LAYER                      │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────┐       ┌─────────────┐                 │
│  │  CRM-PAG    │──────►│   Adapter   │                 │
│  │  (Domain)   │       │   Banco     │                 │
│  └─────────────┘       └──────┬──────┘                 │
│                               │                         │
│                               ▼                         │
│                        ┌─────────────┐                 │
│                        │Banco Digital│                 │
│                        │  (External) │                 │
│                        └─────────────┘                 │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 4. Regras de Negócio

| Código | Regra | Descrição |
|--------|-------|-----------|
| RN-PAG-001 | Tipo de cobrança | PIX é padrão; Boleto mediante solicitação |
| RN-PAG-002 | Vencimento PIX | PIX tem validade de 30 minutos |
| RN-PAG-003 | Vencimento Boleto | Boleto tem validade de 3 dias úteis |
| RN-PAG-004 | Confirmação automática | Webhook do banco confirma automaticamente |
| RN-PAG-005 | Confirmação manual | Comprovante pode ser validado manualmente |
| RN-PAG-006 | Notificações | Enviar lembrete 24h antes do vencimento |
| RN-PAG-007 | Reemissão | Cobrança vencida pode ser reemitida |
| RN-PAG-008 | Valor mínimo | Valor mínimo de cobrança: R$ 50,00 |

---

## 5. User Stories Planejadas

| ID | Título | Prioridade | Status |
|----|--------|------------|--------|
| US-CRM-PAG-001 | Gerar PIX para proposta | Must | 📋 Planejado |
| US-CRM-PAG-002 | Gerar Boleto para proposta | Should | 📋 Planejado |
| US-CRM-PAG-003 | Confirmar pagamento automático | Must | 📋 Planejado |
| US-CRM-PAG-004 | Anexar comprovante manual | Should | 📋 Planejado |
| US-CRM-PAG-005 | Enviar notificação de vencimento | Should | 📋 Planejado |
| US-CRM-PAG-006 | Reemitir cobrança vencida | Could | 📋 Planejado |
| US-CRM-PAG-007 | Visualizar histórico de pagamentos | Should | 📋 Planejado |

---

## 6. Critérios de Aceitação Gerais

- [ ] Integração com banco digital funcional
- [ ] PIX gerado com QR Code válido
- [ ] Boleto gerado com código de barras válido
- [ ] Webhook de confirmação implementado
- [ ] Notificações automáticas configuradas
- [ ] Dashboard atualizado em tempo real
- [ ] Auditoria de todas as transações

---

## 7. Métricas do Contexto

| Métrica | Descrição |
|---------|-----------|
| Taxa de conversão | % de cobranças pagas vs geradas |
| Tempo médio de pagamento | Média entre emissão e confirmação |
| Cobranças vencidas | Quantidade de cobranças não pagas |
| Preferência de pagamento | % PIX vs % Boleto |

---

## 8. Dependências

### 8.1 Dependências de Contexto

```
CRM-PRO (Propostas) ──[proposta_aceita]──► CRM-PAG ──[pagamento_confirmado]──► CRM-VIS (Vistorias)
```

### 8.2 Dependências Técnicas

- API do Banco Digital
- Serviço de geração de QR Code
- Serviço de notificações (WhatsApp/Email)
- Armazenamento de comprovantes (S3/similar)

---

## 9. Histórico de Alterações

| Data | Versão | Autor | Alteração |
|------|--------|-------|-----------|
| 22/01/2026 | 1.0 | Product Owner | Criação inicial com estrutura DDD |

---

## 10. Referências

- [Context Map](../../ddd/context-map.md)
- [Visão do Produto](../../visao-produto-crm.md)
- [Product Backlog](../../backlog/product-backlog.md)
