# CRM-Análise (CRM-ANA)

| Metadado | Valor |
|----------|-------|
| **Módulo** | Análise Documental |
| **Código** | CRM-ANA |
| **Versão** | 1.0 |
| **Data** | 22/01/2026 |
| **Autor** | Product Owner |
| **Status** | Planejado |
| **Tipo DDD** | Core Domain |

---

## 1. Visão Geral

O módulo **CRM-Análise** é responsável pela análise documental e aprovação final do processo de venda. Este é um **Bounded Context Core** por ser a etapa decisiva que determina se a negociação será concretizada ou não.

### 1.1 Responsabilidades

- Análise de documentos do cliente
- Análise do laudo de vistoria
- Verificação de conformidade
- Aprovação ou reprovação do processo
- Solicitação de documentos adicionais
- Concretização da negociação

### 1.2 Posição no Funil

```
[Vistoria Realizada] ──► [ANÁLISE] ──► [Concretizada / Perdida]
                            │
                        CRM-ANA
```

---

## 2. Domain-Driven Design

### 2.1 Bounded Context

| Atributo | Descrição |
|----------|-----------|
| **Nome** | Análise Documental |
| **Tipo** | Core Domain |
| **Linguagem Ubíqua** | Análise, Parecer, Pendência, Aprovação, Concretização |

### 2.2 Agregados

#### Agregado: Análise

```
┌─────────────────────────────────────────────────────────┐
│                     ANÁLISE (Root)                      │
├─────────────────────────────────────────────────────────┤
│ - id: UUID                                              │
│ - proposta_id: UUID (FK CRM-PRO)                        │
│ - vistoria_id: UUID (FK CRM-VIS)                        │
│ - analista_id: UUID                                     │
│ - status: StatusAnalise                                 │
│ - data_inicio: DateTime                                 │
│ - data_conclusao: DateTime?                             │
│ - resultado: ResultadoAnalise?                          │
│                                                         │
│ Entidades:                                              │
│ ├── Parecer                                             │
│ │   - id: UUID                                          │
│ │   - tipo: TipoParecer                                 │
│ │   - descricao: String                                 │
│ │   - data_emissao: DateTime                            │
│ │   - analista_id: UUID                                 │
│ │                                                       │
│ ├── DocumentoAnalise                                    │
│ │   - id: UUID                                          │
│ │   - tipo: TipoDocumento                               │
│ │   - arquivo_url: String                               │
│ │   - status: StatusDocumento                           │
│ │   - observacao: String?                               │
│ │                                                       │
│ └── Pendencia                                           │
│     - id: UUID                                          │
│     - descricao: String                                 │
│     - documento_solicitado: TipoDocumento?              │
│     - prazo: DateTime                                   │
│     - resolvida: Boolean                                │
│                                                         │
│ Value Objects:                                          │
│ ├── ResultadoAnalise (APROVADO, REPROVADO, PENDENTE)    │
│ ├── StatusAnalise (EM_ANDAMENTO, AGUARDANDO, etc)       │
│ └── TipoDocumento (RG, CPF, COMPROVANTE_RESIDENCIA)     │
└─────────────────────────────────────────────────────────┘
```

### 2.3 Entidades

| Entidade | Descrição | Atributos Principais |
|----------|-----------|----------------------|
| **Análise** | Aggregate Root - Processo de análise | id, proposta_id, status |
| **Parecer** | Opinião formal do analista | tipo, descricao |
| **DocumentoAnalise** | Documento em verificação | tipo, status |
| **Pendência** | Documentação faltante | descricao, prazo |

### 2.4 Value Objects

| Value Object | Descrição | Atributos |
|--------------|-----------|-----------|
| **ResultadoAnalise** | Resultado final | APROVADO, REPROVADO, PENDENTE |
| **StatusAnalise** | Estado da análise | EM_ANDAMENTO, AGUARDANDO_DOC, CONCLUIDA |
| **TipoParecer** | Tipo de parecer | TECNICO, DOCUMENTAL, FINAL |
| **StatusDocumento** | Estado do documento | PENDENTE, RECEBIDO, VALIDADO, REJEITADO |
| **TipoDocumento** | Categoria do documento | RG, CPF, CNH, COMPROVANTE_RESIDENCIA, CRLV |

### 2.5 Eventos de Domínio

| Evento | Trigger | Consumidores |
|--------|---------|--------------|
| `AnaliseIniciada` | Análise começou | CRM-DAS, CRM-AUD, CRM-TAR |
| `DocumentoSolicitado` | Pendência criada | CRM-LED, CRM-TAR, CRM-AUD |
| `DocumentoRecebido` | Cliente enviou doc | CRM-AUD |
| `DocumentoValidado` | Analista aprovou doc | CRM-AUD |
| `ParecerEmitido` | Parecer registrado | CRM-AUD |
| `AnaliseAprovada` | Aprovação final | CRM-POS, CRM-COM, CRM-DAS, CRM-AUD |
| `AnaliseReprovada` | Reprovação | CRM-LED, CRM-DAS, CRM-AUD |
| `NegociacaoConcretizada` | Venda finalizada | CRM-POS, CRM-REL, CRM-COM, CRM-AUD |

### 2.6 Repositórios

| Repositório | Métodos Principais |
|-------------|-------------------|
| `AnaliseRepository` | save, findById, findByPropostaId, findByStatus |
| `DocumentoAnaliseRepository` | save, findByAnaliseId, findPendentes |
| `ParecerRepository` | save, findByAnaliseId |

---

## 3. Integrações

### 3.1 Upstream (Recebe de)

| Contexto | Dados Recebidos | Padrão |
|----------|-----------------|--------|
| CRM-VIS | laudo_vistoria, vistoria_id | Domain Event |
| CRM-PRO | proposta_id, documentos_cliente | Customer/Supplier |
| CRM-LED | dados_lead, documentos | Shared Kernel |

### 3.2 Downstream (Envia para)

| Contexto | Dados Enviados | Padrão |
|----------|----------------|--------|
| CRM-POS | negociacao_concretizada | Domain Event |
| CRM-COM | aprovacao, valor_negociacao | Domain Event |
| CRM-DAS | métricas de análise | CQRS Read Model |
| CRM-AUD | todos os eventos | Event Sourcing |
| CRM-LED | status_final | Domain Event |

---

## 4. Fluxo de Análise

### 4.1 State Machine da Análise

```
┌─────────────────────────────────────────────────────────────────┐
│                    ANÁLISE - STATE MACHINE                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  [Vistoria Realizada]                                           │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────┐                                              │
│  │ EM_ANDAMENTO  │◄────────────────────────┐                    │
│  └───────┬───────┘                         │                    │
│          │                                 │                    │
│          ├──────── docs OK ────────────────┼──────┐             │
│          │                                 │      │             │
│          ▼                                 │      ▼             │
│  ┌───────────────┐    doc enviado   ┌─────────────────┐        │
│  │AGUARDANDO_DOC │─────────────────►│  ANALISANDO     │        │
│  │  (Pendência)  │                  │                 │        │
│  └───────────────┘                  └────────┬────────┘        │
│                                              │                  │
│                     ┌────────────────────────┼───────────────┐  │
│                     │                        │               │  │
│                     ▼                        ▼               ▼  │
│             ┌─────────────┐          ┌─────────────┐  ┌───────┐│
│             │  APROVADA   │          │  PENDENTE   │  │REPROV.││
│             │             │          │  (Correção) │  │       ││
│             └──────┬──────┘          └─────────────┘  └───────┘│
│                    │                                            │
│                    ▼                                            │
│           ┌───────────────────┐                                 │
│           │   CONCRETIZADA    │                                 │
│           │   (Venda Final)   │                                 │
│           └───────────────────┘                                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 4.2 Checklist de Documentos

| Documento | Obrigatório | Validação |
|-----------|-------------|-----------|
| RG/CNH do titular | Sim | Foto legível, válido |
| CPF | Sim | Verificação Receita Federal |
| Comprovante de residência | Sim | Menos de 90 dias |
| CRLV do veículo | Sim | Conferência com chassi |
| Comprovante de renda | Condicional | Para valores acima de X |

---

## 5. Regras de Negócio

| Código | Regra | Descrição |
|--------|-------|-----------|
| RN-ANA-001 | Início automático | Análise inicia após laudo de vistoria aprovado |
| RN-ANA-002 | Prazo de pendência | Cliente tem 5 dias úteis para enviar documentos |
| RN-ANA-003 | Expiração | Análise expira após 10 dias sem resolução |
| RN-ANA-004 | Documentos obrigatórios | Todos os docs obrigatórios devem estar validados |
| RN-ANA-005 | Parecer obrigatório | Aprovação requer parecer formal do analista |
| RN-ANA-006 | Reprovação definitiva | Reprovação encerra o processo definitivamente |
| RN-ANA-007 | Concretização | Aprovação + confirmação gera concretização |
| RN-ANA-008 | Notificação | Cliente notificado em cada mudança de status |

---

## 6. User Stories Planejadas

| ID | Título | Prioridade | Status |
|----|--------|------------|--------|
| US-CRM-ANA-001 | Iniciar análise após vistoria | Must | 📋 Planejado |
| US-CRM-ANA-002 | Validar documentos do cliente | Must | 📋 Planejado |
| US-CRM-ANA-003 | Solicitar documento pendente | Must | 📋 Planejado |
| US-CRM-ANA-004 | Emitir parecer de análise | Must | 📋 Planejado |
| US-CRM-ANA-005 | Aprovar análise | Must | 📋 Planejado |
| US-CRM-ANA-006 | Reprovar análise | Must | 📋 Planejado |
| US-CRM-ANA-007 | Concretizar negociação | Must | 📋 Planejado |
| US-CRM-ANA-008 | Consultar histórico de análise | Should | 📋 Planejado |

---

## 7. Critérios de Aceitação Gerais

- [ ] Análise inicia automaticamente após vistoria aprovada
- [ ] Todos os documentos obrigatórios validáveis
- [ ] Pendências com prazo e notificação
- [ ] Parecer formal obrigatório
- [ ] Concretização registrada corretamente
- [ ] Integração com comissionamento
- [ ] Dashboard atualizado em tempo real

---

## 8. Métricas do Contexto

| Métrica | Descrição |
|---------|-----------|
| Taxa de aprovação | % de análises aprovadas |
| Tempo médio de análise | Duração do processo |
| Taxa de pendências | % que requer docs adicionais |
| Taxa de conversão final | % que concretiza |

---

## 9. Dependências

### 9.1 Dependências de Contexto

```
CRM-VIS (Vistorias) ──[laudo_aprovado]──► CRM-ANA ──[concretizada]──► CRM-POS (Pós-Venda)
                                             │
                                             └──[aprovada]──► CRM-COM (Comissionamento)
```

### 9.2 Dependências Técnicas

- Armazenamento de documentos
- Serviço de validação de CPF
- Serviço de notificações
- Geração de contratos/termos

---

## 10. Histórico de Alterações

| Data | Versão | Autor | Alteração |
|------|--------|-------|-----------|
| 22/01/2026 | 1.0 | Product Owner | Criação inicial com estrutura DDD |

---

## 11. Referências

- [Context Map](../../ddd/context-map.md)
- [CRM-Vistorias](../CRM-Vistorias/README.md)
- [CRM-Pós-Venda](../CRM-Pos-Venda/README.md)
- [Product Backlog](../../backlog/product-backlog.md)
