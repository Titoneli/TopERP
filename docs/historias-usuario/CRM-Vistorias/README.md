# CRM-Vistorias (CRM-VIS)

| Metadado | Valor |
|----------|-------|
| **Módulo** | Vistorias |
| **Código** | CRM-VIS |
| **Versão** | 1.0 |
| **Data** | 22/01/2026 |
| **Autor** | Product Owner |
| **Status** | Planejado |
| **Tipo DDD** | Core Domain |

---

## 1. Visão Geral

O módulo **CRM-Vistorias** é responsável pelo agendamento, execução e registro de vistorias de veículos. Este é um **Bounded Context Core** por ser essencial para a validação do bem antes da aprovação final.

### 1.1 Responsabilidades

- Agendamento de vistorias
- Atribuição de vistoriadores
- Execução e registro da vistoria
- Captura de fotos e documentos
- Geração de laudo de vistoria
- Aprovação/reprovação do veículo

### 1.2 Posição no Funil

```
[Pagamento Confirmado] ──► [VISTORIA] ──► [Análise Documental]
                              │
                          CRM-VIS
```

---

## 2. Domain-Driven Design

### 2.1 Bounded Context

| Atributo | Descrição |
|----------|-----------|
| **Nome** | Vistorias |
| **Tipo** | Core Domain |
| **Linguagem Ubíqua** | Vistoria, Agendamento, Vistoriador, Laudo, Checklist |

### 2.2 Agregados

#### Agregado: Vistoria

```
┌─────────────────────────────────────────────────────────┐
│                    VISTORIA (Root)                      │
├─────────────────────────────────────────────────────────┤
│ - id: UUID                                              │
│ - proposta_id: UUID (FK CRM-PRO)                        │
│ - veiculo_id: UUID (FK COR_VEICULO)                     │
│ - vistoriador_id: UUID                                  │
│ - status: StatusVistoria                                │
│ - tipo: TipoVistoria                                    │
│ - data_agendada: DateTime                               │
│ - data_realizada: DateTime?                             │
│ - local: EnderecoVistoria                               │
│                                                         │
│ Entidades:                                              │
│ ├── Laudo                                               │
│ │   - id: UUID                                          │
│ │   - resultado: ResultadoLaudo                         │
│ │   - observacoes: String                               │
│ │   - data_emissao: DateTime                            │
│ │                                                       │
│ ├── ItemChecklist                                       │
│ │   - id: UUID                                          │
│ │   - item: String                                      │
│ │   - conforme: Boolean                                 │
│ │   - observacao: String?                               │
│ │                                                       │
│ └── FotoVistoria                                        │
│     - id: UUID                                          │
│     - tipo: TipoFoto                                    │
│     - url: String                                       │
│     - data_captura: DateTime                            │
│                                                         │
│ Value Objects:                                          │
│ ├── EnderecoVistoria (logradouro, cidade, coord)        │
│ ├── ResultadoLaudo (APROVADO, REPROVADO, PENDENCIA)     │
│ └── StatusVistoria (AGENDADA, EM_ANDAMENTO, etc)        │
└─────────────────────────────────────────────────────────┘
```

#### Agregado: Vistoriador

```
┌─────────────────────────────────────────────────────────┐
│                   VISTORIADOR (Root)                    │
├─────────────────────────────────────────────────────────┤
│ - id: UUID                                              │
│ - pessoa_id: UUID (FK COR_PESSOA)                       │
│ - regional_id: UUID                                     │
│ - status: StatusVistoriador                             │
│ - capacidade_diaria: Integer                            │
│                                                         │
│ Entidades:                                              │
│ └── AgendaVistoriador                                   │
│     - id: UUID                                          │
│     - data: Date                                        │
│     - horarios_disponiveis: List<Horario>               │
│                                                         │
│ Value Objects:                                          │
│ └── Horario (inicio, fim)                               │
└─────────────────────────────────────────────────────────┘
```

### 2.3 Entidades

| Entidade | Descrição | Atributos Principais |
|----------|-----------|----------------------|
| **Vistoria** | Aggregate Root - Registro de vistoria | id, veiculo_id, status |
| **Laudo** | Resultado da vistoria | resultado, observacoes |
| **ItemChecklist** | Item verificado na vistoria | item, conforme |
| **FotoVistoria** | Registro fotográfico | tipo, url |
| **Vistoriador** | Aggregate Root - Profissional | id, regional_id |
| **AgendaVistoriador** | Disponibilidade do vistoriador | data, horarios |

### 2.4 Value Objects

| Value Object | Descrição | Atributos |
|--------------|-----------|-----------|
| **EnderecoVistoria** | Local da vistoria | logradouro, cidade, coordenadas |
| **ResultadoLaudo** | Resultado final | APROVADO, REPROVADO, PENDENCIA |
| **StatusVistoria** | Estado da vistoria | AGENDADA, EM_ANDAMENTO, REALIZADA, CANCELADA |
| **TipoVistoria** | Modalidade | PRESENCIAL, DIGITAL |
| **TipoFoto** | Categoria da foto | FRENTE, LATERAL, TRASEIRA, MOTOR, CHASSI, DOCUMENTO |

### 2.5 Eventos de Domínio

| Evento | Trigger | Consumidores |
|--------|---------|--------------|
| `VistoriaAgendada` | Agendamento criado | CRM-TAR, CRM-DAS, CRM-AUD |
| `VistoriaIniciada` | Vistoriador inicia | CRM-DAS, CRM-AUD |
| `VistoriaRealizada` | Vistoria concluída | CRM-ANA, CRM-DAS, CRM-AUD |
| `LaudoEmitido` | Laudo gerado | CRM-ANA, CRM-LED, CRM-AUD |
| `VistoriaCancelada` | Cancelamento | CRM-TAR, CRM-LED, CRM-AUD |
| `FotoCapturada` | Foto registrada | CRM-AUD |

### 2.6 Repositórios

| Repositório | Métodos Principais |
|-------------|-------------------|
| `VistoriaRepository` | save, findById, findByPropostaId, findByStatus |
| `VistoriadorRepository` | save, findById, findByRegional, findDisponiveis |
| `LaudoRepository` | save, findByVistoriaId |

---

## 3. Integrações

### 3.1 Upstream (Recebe de)

| Contexto | Dados Recebidos | Padrão |
|----------|-----------------|--------|
| CRM-PAG | pagamento_confirmado, proposta_id | Domain Event |
| CRM-PRO | proposta_id, veiculo_id, endereco | Customer/Supplier |
| COR_VEICULO | dados do veículo | Shared Kernel |

### 3.2 Downstream (Envia para)

| Contexto | Dados Enviados | Padrão |
|----------|----------------|--------|
| CRM-ANA | laudo, resultado_vistoria | Domain Event |
| CRM-DAS | métricas de vistoria | CQRS Read Model |
| CRM-AUD | todos os eventos | Event Sourcing |
| CRM-TAR | agendamentos | Domain Event |

### 3.3 Integrações Externas

| Sistema | Operações |
|---------|-----------|
| **Storage (S3)** | Upload de fotos e documentos |
| **Maps API** | Geocodificação de endereços |
| **Notificações** | Lembrete de agendamento |

---

## 4. Checklist de Vistoria Padrão

### 4.1 Itens Obrigatórios

| Categoria | Item | Obrigatório |
|-----------|------|-------------|
| **Documentação** | Documento do veículo (CRLV) | Sim |
| **Documentação** | CNH do proprietário | Sim |
| **Identificação** | Placa legível | Sim |
| **Identificação** | Chassi visível | Sim |
| **Identificação** | Motor (número) | Sim |
| **Estrutura** | Carroceria sem avarias graves | Sim |
| **Estrutura** | Vidros sem trincas | Sim |
| **Funcionamento** | Motor funcional | Sim |
| **Funcionamento** | Freios funcionais | Sim |
| **Funcionamento** | Iluminação funcional | Sim |

### 4.2 Fotos Obrigatórias

| Tipo | Descrição | Obrigatória |
|------|-----------|-------------|
| FRENTE | Visão frontal completa | Sim |
| TRASEIRA | Visão traseira completa | Sim |
| LATERAL_ESQ | Lateral esquerda | Sim |
| LATERAL_DIR | Lateral direita | Sim |
| PAINEL | Painel com hodômetro | Sim |
| MOTOR | Compartimento do motor | Sim |
| CHASSI | Número do chassi | Sim |
| DOCUMENTO | CRLV do veículo | Sim |

---

## 5. Regras de Negócio

| Código | Regra | Descrição |
|--------|-------|-----------|
| RN-VIS-001 | Agendamento | Vistoria só pode ser agendada após pagamento confirmado |
| RN-VIS-002 | Prazo | Vistoria deve ocorrer em até 7 dias após pagamento |
| RN-VIS-003 | Reagendamento | Máximo de 2 reagendamentos permitidos |
| RN-VIS-004 | Fotos obrigatórias | Todas as fotos obrigatórias devem ser capturadas |
| RN-VIS-005 | Checklist completo | Todos os itens obrigatórios devem ser verificados |
| RN-VIS-006 | Laudo | Laudo deve ser emitido em até 24h após vistoria |
| RN-VIS-007 | Pendência | Vistoria com pendência pode ter nova tentativa |
| RN-VIS-008 | Reprovação | Reprovação encerra o processo (Lead perdido) |

---

## 6. User Stories Planejadas

| ID | Título | Prioridade | Status |
|----|--------|------------|--------|
| US-CRM-VIS-001 | Agendar vistoria após pagamento | Must | 📋 Planejado |
| US-CRM-VIS-002 | Atribuir vistoriador automaticamente | Should | 📋 Planejado |
| US-CRM-VIS-003 | Executar checklist de vistoria | Must | 📋 Planejado |
| US-CRM-VIS-004 | Capturar fotos obrigatórias | Must | 📋 Planejado |
| US-CRM-VIS-005 | Emitir laudo de vistoria | Must | 📋 Planejado |
| US-CRM-VIS-006 | Reagendar vistoria | Should | 📋 Planejado |
| US-CRM-VIS-007 | Consultar agenda de vistoriadores | Should | 📋 Planejado |
| US-CRM-VIS-008 | Aprovar/reprovar veículo | Must | 📋 Planejado |

---

## 7. Critérios de Aceitação Gerais

- [ ] Agendamento automático após confirmação de pagamento
- [ ] Checklist digital funcional
- [ ] Captura de fotos com validação
- [ ] Laudo gerado automaticamente
- [ ] Notificações de lembrete configuradas
- [ ] Integração com análise documental
- [ ] Dashboard atualizado em tempo real

---

## 8. Métricas do Contexto

| Métrica | Descrição |
|---------|-----------|
| Taxa de aprovação | % de vistorias aprovadas |
| Tempo médio de vistoria | Duração da execução |
| Taxa de reagendamento | % de vistorias reagendadas |
| Produtividade vistoriador | Vistorias/dia por vistoriador |

---

## 9. Dependências

### 9.1 Dependências de Contexto

```
CRM-PAG (Pagamentos) ──[pagamento_confirmado]──► CRM-VIS ──[vistoria_realizada]──► CRM-ANA (Análise)
```

### 9.2 Dependências Técnicas

- Armazenamento de arquivos (S3/similar)
- API de geolocalização
- Serviço de notificações
- Câmera do dispositivo (App)

---

## 10. Histórico de Alterações

| Data | Versão | Autor | Alteração |
|------|--------|-------|-----------|
| 22/01/2026 | 1.0 | Product Owner | Criação inicial com estrutura DDD |

---

## 11. Referências

- [Context Map](../../ddd/context-map.md)
- [CRM-Pagamentos](../CRM-Pagamentos/README.md)
- [CRM-Análise](../CRM-Analise/README.md)
- [Product Backlog](../../backlog/product-backlog.md)
