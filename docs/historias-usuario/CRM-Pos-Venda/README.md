# CRM-Pós-Venda (CRM-POS)

| Metadado | Valor |
|----------|-------|
| **Módulo** | Pós-Venda |
| **Código** | CRM-POS |
| **Versão** | 1.0 |
| **Data** | 22/01/2026 |
| **Autor** | Product Owner |
| **Status** | Planejado |
| **Tipo DDD** | Supporting Domain |

---

## 1. Visão Geral

O módulo **CRM-Pós-Venda** é responsável pelo acompanhamento do cliente após a concretização da venda. Este é um **Bounded Context de Suporte** que garante a satisfação e fidelização do cliente.

### 1.1 Responsabilidades

- Onboarding do novo cliente
- Ativação dos serviços contratados
- Pesquisa de satisfação
- Acompanhamento dos primeiros dias
- Gestão de reclamações
- Retenção e upsell

### 1.2 Posição no Funil

```
[Negociação Concretizada] ──► [PÓS-VENDA] ──► [Cliente Ativo]
                                  │
                              CRM-POS
```

---

## 2. Domain-Driven Design

### 2.1 Bounded Context

| Atributo | Descrição |
|----------|-----------|
| **Nome** | Pós-Venda |
| **Tipo** | Supporting Domain |
| **Linguagem Ubíqua** | Onboarding, Ativação, Satisfação, NPS, Retenção |

### 2.2 Agregados

#### Agregado: Onboarding

```
┌─────────────────────────────────────────────────────────┐
│                   ONBOARDING (Root)                     │
├─────────────────────────────────────────────────────────┤
│ - id: UUID                                              │
│ - cliente_id: UUID (FK COR_CLIENTE)                     │
│ - negociacao_id: UUID (FK CRM-ANA)                      │
│ - status: StatusOnboarding                              │
│ - data_inicio: DateTime                                 │
│ - data_conclusao: DateTime?                             │
│                                                         │
│ Entidades:                                              │
│ ├── EtapaOnboarding                                     │
│ │   - id: UUID                                          │
│ │   - nome: String                                      │
│ │   - ordem: Integer                                    │
│ │   - status: StatusEtapa                               │
│ │   - data_conclusao: DateTime?                         │
│ │                                                       │
│ └── ContatoOnboarding                                   │
│     - id: UUID                                          │
│     - tipo: TipoContato                                 │
│     - data: DateTime                                    │
│     - resultado: String                                 │
│                                                         │
│ Value Objects:                                          │
│ └── StatusOnboarding (INICIADO, EM_ANDAMENTO, etc)      │
└─────────────────────────────────────────────────────────┘
```

#### Agregado: PesquisaSatisfacao

```
┌─────────────────────────────────────────────────────────┐
│              PESQUISA SATISFAÇÃO (Root)                 │
├─────────────────────────────────────────────────────────┤
│ - id: UUID                                              │
│ - cliente_id: UUID                                      │
│ - tipo: TipoPesquisa                                    │
│ - data_envio: DateTime                                  │
│ - data_resposta: DateTime?                              │
│ - nps_score: Integer? (0-10)                            │
│                                                         │
│ Entidades:                                              │
│ └── RespostaPesquisa                                    │
│     - id: UUID                                          │
│     - pergunta_id: UUID                                 │
│     - resposta: String                                  │
│     - nota: Integer?                                    │
│                                                         │
│ Value Objects:                                          │
│ ├── TipoPesquisa (NPS, CSAT, CES)                       │
│ └── ClassificacaoNPS (PROMOTOR, NEUTRO, DETRATOR)       │
└─────────────────────────────────────────────────────────┘
```

#### Agregado: CasoAtendimento

```
┌─────────────────────────────────────────────────────────┐
│               CASO ATENDIMENTO (Root)                   │
├─────────────────────────────────────────────────────────┤
│ - id: UUID                                              │
│ - cliente_id: UUID                                      │
│ - tipo: TipoCaso                                        │
│ - prioridade: Prioridade                                │
│ - status: StatusCaso                                    │
│ - descricao: String                                     │
│ - data_abertura: DateTime                               │
│ - data_resolucao: DateTime?                             │
│                                                         │
│ Entidades:                                              │
│ └── InteracaoCaso                                       │
│     - id: UUID                                          │
│     - autor_id: UUID                                    │
│     - tipo: TipoInteracao                               │
│     - mensagem: String                                  │
│     - data: DateTime                                    │
│                                                         │
│ Value Objects:                                          │
│ ├── TipoCaso (DUVIDA, RECLAMACAO, SUGESTAO, CANCELAMENTO)│
│ └── Prioridade (BAIXA, MEDIA, ALTA, CRITICA)            │
└─────────────────────────────────────────────────────────┘
```

### 2.3 Entidades

| Entidade | Descrição | Atributos Principais |
|----------|-----------|----------------------|
| **Onboarding** | Aggregate Root - Processo de ativação | id, cliente_id, status |
| **EtapaOnboarding** | Etapa do processo | nome, ordem, status |
| **PesquisaSatisfacao** | Aggregate Root - Pesquisa NPS/CSAT | id, nps_score |
| **CasoAtendimento** | Aggregate Root - Ticket de suporte | id, tipo, prioridade |
| **InteracaoCaso** | Histórico de interações | autor_id, mensagem |

### 2.4 Value Objects

| Value Object | Descrição | Atributos |
|--------------|-----------|-----------|
| **StatusOnboarding** | Estado do onboarding | INICIADO, EM_ANDAMENTO, CONCLUIDO, CANCELADO |
| **TipoPesquisa** | Tipo de pesquisa | NPS, CSAT, CES |
| **ClassificacaoNPS** | Categoria NPS | PROMOTOR (9-10), NEUTRO (7-8), DETRATOR (0-6) |
| **TipoCaso** | Tipo de atendimento | DUVIDA, RECLAMACAO, SUGESTAO, CANCELAMENTO |
| **Prioridade** | Urgência do caso | BAIXA, MEDIA, ALTA, CRITICA |

### 2.5 Eventos de Domínio

| Evento | Trigger | Consumidores |
|--------|---------|--------------|
| `OnboardingIniciado` | Negociação concretizada | CRM-TAR, CRM-AUD |
| `OnboardingConcluido` | Todas etapas completas | CRM-DAS, CRM-AUD |
| `ServicoAtivado` | Ativação do plano | CRM-AUD |
| `PesquisaEnviada` | Pesquisa disparada | CRM-AUD |
| `PesquisaRespondida` | Cliente respondeu | CRM-DAS, CRM-REL, CRM-AUD |
| `CasoAberto` | Novo ticket | CRM-TAR, CRM-AUD |
| `CasoResolvido` | Ticket fechado | CRM-DAS, CRM-AUD |
| `SolicitacaoCancelamento` | Cliente quer cancelar | CRM-TAR, CRM-AUD |

### 2.6 Repositórios

| Repositório | Métodos Principais |
|-------------|-------------------|
| `OnboardingRepository` | save, findById, findByClienteId, findByStatus |
| `PesquisaSatisfacaoRepository` | save, findById, findByClienteId, findPendentes |
| `CasoAtendimentoRepository` | save, findById, findByClienteId, findAbertos |

---

## 3. Integrações

### 3.1 Upstream (Recebe de)

| Contexto | Dados Recebidos | Padrão |
|----------|-----------------|--------|
| CRM-ANA | negociacao_concretizada | Domain Event |
| COR_CLIENTE | dados do cliente | Shared Kernel |

### 3.2 Downstream (Envia para)

| Contexto | Dados Enviados | Padrão |
|----------|----------------|--------|
| CRM-DAS | métricas de satisfação | CQRS Read Model |
| CRM-REL | dados para relatórios | CQRS Read Model |
| CRM-AUD | todos os eventos | Event Sourcing |

---

## 4. Jornada do Pós-Venda

### 4.1 Fluxo de Onboarding

```
┌─────────────────────────────────────────────────────────────────┐
│                    JORNADA PÓS-VENDA                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  [CONCRETIZAÇÃO]                                                │
│        │                                                        │
│        ▼                                                        │
│  ┌──────────┐   D+0    ┌──────────┐   D+1    ┌──────────┐      │
│  │ Boas     │─────────►│ Ativação │─────────►│ Contato  │      │
│  │ Vindas   │          │ Serviço  │          │ D+1      │      │
│  └──────────┘          └──────────┘          └──────────┘      │
│                                                    │            │
│                                                    ▼            │
│  ┌──────────┐   D+15   ┌──────────┐   D+7    ┌──────────┐      │
│  │ Pesquisa │◄─────────│ Follow-  │◄─────────│ Contato  │      │
│  │ NPS      │          │ up       │          │ D+7      │      │
│  └──────────┘          └──────────┘          └──────────┘      │
│        │                                                        │
│        ▼                                                        │
│  ┌──────────────────────────────────────────────────────┐      │
│  │                 CLIENTE ATIVO                        │      │
│  │  • Acompanhamento contínuo                           │      │
│  │  • Pesquisas periódicas (NPS trimestral)             │      │
│  │  • Gestão de casos/reclamações                       │      │
│  │  • Oportunidades de upsell                           │      │
│  └──────────────────────────────────────────────────────┘      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 4.2 Checklist de Onboarding

| Etapa | Prazo | Responsável | Canal |
|-------|-------|-------------|-------|
| Boas-vindas | D+0 | Sistema | WhatsApp/Email |
| Ativação do serviço | D+0 | Sistema | Automático |
| Contato de confirmação | D+1 | Consultor | Telefone |
| Verificação de uso | D+7 | Sistema | WhatsApp |
| Follow-up | D+15 | Consultor | WhatsApp |
| Pesquisa NPS | D+30 | Sistema | Email/WhatsApp |

---

## 5. Regras de Negócio

| Código | Regra | Descrição |
|--------|-------|-----------|
| RN-POS-001 | Início automático | Onboarding inicia automaticamente após concretização |
| RN-POS-002 | Boas-vindas | Mensagem de boas-vindas em até 1h da concretização |
| RN-POS-003 | Contato D+1 | Contato obrigatório no dia seguinte |
| RN-POS-004 | NPS obrigatório | Pesquisa NPS enviada em D+30 |
| RN-POS-005 | Prioridade reclamação | Reclamações têm SLA de 24h para primeira resposta |
| RN-POS-006 | Cancelamento | Solicitação de cancelamento vai para retenção |
| RN-POS-007 | Detrator | NPS ≤6 gera caso automático para tratativa |
| RN-POS-008 | Promotor | NPS ≥9 elegível para programa de indicação |

---

## 6. User Stories Planejadas

| ID | Título | Prioridade | Status |
|----|--------|------------|--------|
| US-CRM-POS-001 | Enviar boas-vindas automático | Must | 📋 Planejado |
| US-CRM-POS-002 | Agendar contatos de onboarding | Must | 📋 Planejado |
| US-CRM-POS-003 | Enviar pesquisa NPS | Must | 📋 Planejado |
| US-CRM-POS-004 | Registrar resposta NPS | Must | 📋 Planejado |
| US-CRM-POS-005 | Abrir caso de atendimento | Must | 📋 Planejado |
| US-CRM-POS-006 | Gerenciar casos abertos | Should | 📋 Planejado |
| US-CRM-POS-007 | Tratar solicitação de cancelamento | Should | 📋 Planejado |
| US-CRM-POS-008 | Ver métricas de satisfação | Should | 📋 Planejado |

---

## 7. Métricas do Contexto

| Métrica | Descrição | Meta |
|---------|-----------|------|
| NPS | Net Promoter Score | ≥ 50 |
| Taxa de Onboarding | % concluídos vs iniciados | ≥ 95% |
| Tempo de Resolução | Média para fechar casos | ≤ 48h |
| Taxa de Cancelamento | % cancelamentos/base | ≤ 5% |
| Taxa de Retenção | % retidos após contato | ≥ 70% |

---

## 8. Critérios de Aceitação Gerais

- [ ] Onboarding iniciado automaticamente
- [ ] Mensagens de boas-vindas enviadas
- [ ] Contatos agendados no calendário
- [ ] Pesquisa NPS funcional
- [ ] Casos de atendimento com SLA
- [ ] Dashboard de satisfação disponível
- [ ] Integração com retenção

---

## 9. Dependências

### 9.1 Dependências de Contexto

```
CRM-ANA (Análise) ──[concretizada]──► CRM-POS ──[nps_score]──► CRM-DAS (Dashboard)
                                         │
                                         └──[caso_aberto]──► CRM-TAR (Tarefas)
```

### 9.2 Dependências Técnicas

- Serviço de envio de mensagens (WhatsApp/Email)
- Sistema de agendamento
- Plataforma de pesquisas
- Integração com telefonia (opcional)

---

## 10. Histórico de Alterações

| Data | Versão | Autor | Alteração |
|------|--------|-------|-----------|
| 22/01/2026 | 1.0 | Product Owner | Criação inicial com estrutura DDD |

---

## 11. Referências

- [Context Map](../../ddd/context-map.md)
- [CRM-Análise](../CRM-Analise/README.md)
- [Product Backlog](../../backlog/product-backlog.md)
