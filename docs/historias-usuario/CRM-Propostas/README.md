# CRM-Propostas (CRM-PRO)

| Metadado | Valor |
|----------|-------|
| **Módulo** | Propostas |
| **Código** | CRM-PRO |
| **Versão** | 1.0 |
| **Data** | 22/01/2026 |
| **Autor** | Product Owner |
| **Status** | Planejado |
| **Tipo DDD** | Core Domain |

---

## 1. Visão Geral

O módulo **CRM-Propostas** é responsável pela geração, envio e gestão de propostas comerciais. Este é um **Bounded Context Core** por representar a formalização da oferta comercial que inicia o fluxo sequencial do funil.

### 1.1 Responsabilidades

- Geração de propostas baseadas em cotações
- Personalização de condições comerciais
- Envio de propostas por múltiplos canais
- Rastreamento de visualização
- Aceite/recusa de propostas
- Versionamento de propostas

### 1.2 Posição no Funil

```
[Cotação Criada] ──► [PROPOSTA] ──► [Pagamento]
                        │
                    CRM-PRO
```

---

## 2. Domain-Driven Design

### 2.1 Bounded Context

| Atributo | Descrição |
|----------|-----------|
| **Nome** | Propostas |
| **Tipo** | Core Domain |
| **Linguagem Ubíqua** | Proposta, Aceite, Recusa, Condições, Vigência |

### 2.2 Agregados

#### Agregado: Proposta

```
┌─────────────────────────────────────────────────────────┐
│                    PROPOSTA (Root)                      │
├─────────────────────────────────────────────────────────┤
│ - id: UUID                                              │
│ - numero: String (único)                                │
│ - cotacao_id: UUID (FK CRM-COT)                         │
│ - lead_id: UUID (FK CRM-LED)                            │
│ - consultor_id: UUID                                    │
│ - status: StatusProposta                                │
│ - versao: Integer                                       │
│ - data_emissao: DateTime                                │
│ - data_validade: DateTime                               │
│ - data_resposta: DateTime?                              │
│                                                         │
│ Entidades:                                              │
│ ├── ItemProposta                                        │
│ │   - id: UUID                                          │
│ │   - plano_id: UUID                                    │
│ │   - servicos: List<Servico>                           │
│ │   - valor_mensal: Money                               │
│ │   - desconto: Percentual?                             │
│ │                                                       │
│ ├── CondicaoComercial                                   │
│ │   - id: UUID                                          │
│ │   - tipo: TipoCondicao                                │
│ │   - descricao: String                                 │
│ │   - valor: Money?                                     │
│ │                                                       │
│ └── HistoricoEnvio                                      │
│     - id: UUID                                          │
│     - canal: CanalEnvio                                 │
│     - data_envio: DateTime                              │
│     - data_visualizacao: DateTime?                      │
│     - status: StatusEnvio                               │
│                                                         │
│ Value Objects:                                          │
│ ├── Money (valor, moeda)                                │
│ ├── Percentual (valor)                                  │
│ ├── StatusProposta (RASCUNHO, ENVIADA, ACEITA, etc)     │
│ └── CanalEnvio (EMAIL, WHATSAPP, SMS)                   │
└─────────────────────────────────────────────────────────┘
```

### 2.3 Entidades

| Entidade | Descrição | Atributos Principais |
|----------|-----------|----------------------|
| **Proposta** | Aggregate Root - Oferta comercial | id, numero, status |
| **ItemProposta** | Plano/serviço incluído | plano_id, valor_mensal |
| **CondicaoComercial** | Condições especiais | tipo, descricao |
| **HistoricoEnvio** | Rastreamento de envios | canal, data_envio |

### 2.4 Value Objects

| Value Object | Descrição | Atributos |
|--------------|-----------|-----------|
| **Money** | Valor monetário | valor, moeda |
| **Percentual** | Percentual de desconto | valor |
| **StatusProposta** | Estado da proposta | RASCUNHO, ENVIADA, VISUALIZADA, ACEITA, RECUSADA, EXPIRADA |
| **CanalEnvio** | Canal de comunicação | EMAIL, WHATSAPP, SMS, LINK |
| **TipoCondicao** | Tipo de condição | DESCONTO, CARENCIA, BONUS, BRINDE |

### 2.5 Eventos de Domínio

| Evento | Trigger | Consumidores |
|--------|---------|--------------|
| `PropostaCriada` | Nova proposta gerada | CRM-DAS, CRM-AUD |
| `PropostaEnviada` | Proposta enviada | CRM-TAR, CRM-AUD |
| `PropostaVisualizada` | Cliente abriu proposta | CRM-DAS, CRM-AUD |
| `PropostaAceita` | Cliente aceitou | CRM-PAG, CRM-COM, CRM-DAS, CRM-AUD |
| `PropostaRecusada` | Cliente recusou | CRM-LED, CRM-DAS, CRM-AUD |
| `PropostaExpirada` | Validade expirou | CRM-LED, CRM-TAR, CRM-AUD |
| `PropostaRevisada` | Nova versão criada | CRM-AUD |

### 2.6 Repositórios

| Repositório | Métodos Principais |
|-------------|-------------------|
| `PropostaRepository` | save, findById, findByNumero, findByCotacaoId, findByStatus |
| `ItemPropostaRepository` | save, findByPropostaId |
| `HistoricoEnvioRepository` | save, findByPropostaId |

---

## 3. Integrações

### 3.1 Upstream (Recebe de)

| Contexto | Dados Recebidos | Padrão |
|----------|-----------------|--------|
| CRM-COT | cotacao_id, valores, planos | Customer/Supplier |
| CRM-LED | lead_id, dados_contato | Shared Kernel |
| CRM-CAD | planos, servicos, precos | Upstream/Downstream |

### 3.2 Downstream (Envia para)

| Contexto | Dados Enviados | Padrão |
|----------|----------------|--------|
| CRM-PAG | proposta_aceita, valor | Domain Event |
| CRM-DAS | métricas de proposta | CQRS Read Model |
| CRM-AUD | todos os eventos | Event Sourcing |
| CRM-LED | status_proposta | Domain Event |

### 3.3 Integrações Externas

| Sistema | Operações |
|---------|-----------|
| **Email Service** | Envio de proposta por email |
| **WhatsApp API** | Envio de proposta por WhatsApp |
| **PDF Generator** | Geração de PDF da proposta |
| **Tracking Service** | Rastreamento de visualização |

---

## 4. Template da Proposta

### 4.1 Estrutura do Documento

```
┌─────────────────────────────────────────────────────────┐
│                    PROPOSTA COMERCIAL                   │
├─────────────────────────────────────────────────────────┤
│ Número: PRO-2026-00001                                  │
│ Data: 22/01/2026                                        │
│ Validade: 30/01/2026                                    │
├─────────────────────────────────────────────────────────┤
│ CLIENTE                                                 │
│ Nome: [Nome do Lead]                                    │
│ CPF/CNPJ: [Documento]                                   │
│ Email: [Email]                                          │
├─────────────────────────────────────────────────────────┤
│ VEÍCULO                                                 │
│ Marca/Modelo: [Marca] [Modelo]                          │
│ Ano: [Ano]                                              │
│ Placa: [Placa]                                          │
│ Valor FIPE: [Valor]                                     │
├─────────────────────────────────────────────────────────┤
│ PLANO OFERECIDO                                         │
│ [Nome do Plano]                                         │
│ Serviços inclusos:                                      │
│   • [Serviço 1]                                         │
│   • [Serviço 2]                                         │
│   • [Serviço N]                                         │
├─────────────────────────────────────────────────────────┤
│ VALORES                                                 │
│ Mensalidade: R$ [Valor]                                 │
│ Adesão: R$ [Valor]                                      │
│ Desconto: [%] (se aplicável)                            │
│ TOTAL PRIMEIRO PAGAMENTO: R$ [Valor]                    │
├─────────────────────────────────────────────────────────┤
│ CONDIÇÕES ESPECIAIS                                     │
│ [Condições aplicáveis]                                  │
├─────────────────────────────────────────────────────────┤
│ [ACEITAR PROPOSTA] [RECUSAR]                            │
└─────────────────────────────────────────────────────────┘
```

---

## 5. Regras de Negócio

| Código | Regra | Descrição |
|--------|-------|-----------|
| RN-PRO-001 | Origem | Proposta só pode ser criada a partir de cotação |
| RN-PRO-002 | Validade | Proposta tem validade padrão de 7 dias |
| RN-PRO-003 | Numeração | Número único sequencial por ano (PRO-YYYY-NNNNN) |
| RN-PRO-004 | Versão | Alterações geram nova versão, não edição |
| RN-PRO-005 | Aceite único | Proposta aceita não pode ser alterada |
| RN-PRO-006 | Desconto máximo | Desconto máximo de 15% sem aprovação |
| RN-PRO-007 | Reenvio | Proposta pode ser reenviada até 3 vezes |
| RN-PRO-008 | Expiração | Proposta expirada pode gerar nova proposta |

---

## 6. User Stories Planejadas

| ID | Título | Prioridade | Status |
|----|--------|------------|--------|
| US-CRM-PRO-001 | Gerar proposta de cotação | Must | 📋 Planejado |
| US-CRM-PRO-002 | Personalizar condições comerciais | Should | 📋 Planejado |
| US-CRM-PRO-003 | Enviar proposta por email | Must | 📋 Planejado |
| US-CRM-PRO-004 | Enviar proposta por WhatsApp | Must | 📋 Planejado |
| US-CRM-PRO-005 | Rastrear visualização da proposta | Should | 📋 Planejado |
| US-CRM-PRO-006 | Aceitar proposta (cliente) | Must | 📋 Planejado |
| US-CRM-PRO-007 | Recusar proposta (cliente) | Must | 📋 Planejado |
| US-CRM-PRO-008 | Revisar proposta (nova versão) | Should | 📋 Planejado |
| US-CRM-PRO-009 | Gerar PDF da proposta | Should | 📋 Planejado |

---

## 7. Critérios de Aceitação Gerais

- [ ] Proposta gerada a partir de cotação válida
- [ ] Numeração automática única
- [ ] Envio por múltiplos canais
- [ ] Rastreamento de visualização funcional
- [ ] Aceite gera evento para pagamento
- [ ] PDF gerado corretamente
- [ ] Versionamento implementado

---

## 8. Métricas do Contexto

| Métrica | Descrição |
|---------|-----------|
| Taxa de aceite | % de propostas aceitas |
| Tempo de resposta | Média entre envio e resposta |
| Taxa de visualização | % de propostas visualizadas |
| Canal mais efetivo | Canal com maior taxa de aceite |

---

## 9. Dependências

### 9.1 Dependências de Contexto

```
CRM-COT (Cotações) ──[cotacao_aprovada]──► CRM-PRO ──[proposta_aceita]──► CRM-PAG (Pagamentos)
```

### 9.2 Dependências Técnicas

- Serviço de envio de emails
- API WhatsApp
- Gerador de PDF
- Serviço de rastreamento (pixel/webhook)

---

## 10. Histórico de Alterações

| Data | Versão | Autor | Alteração |
|------|--------|-------|-----------|
| 22/01/2026 | 1.0 | Product Owner | Criação inicial com estrutura DDD |

---

## 11. Referências

- [Context Map](../../ddd/context-map.md)
- [CRM-Cotações](../CRM-Cotacoes/README.md)
- [CRM-Pagamentos](../CRM-Pagamentos/README.md)
- [Product Backlog](../../backlog/product-backlog.md)
