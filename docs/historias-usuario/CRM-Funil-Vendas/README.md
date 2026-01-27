# Módulo: Funil de Vendas e Negociações (CRM-FUN)

| Metadado | Valor |
|----------|-------|
| **Módulo** | CRM-Funil-Vendas |
| **Código** | CRM-FUN |
| **Versão** | 2.0 |
| **Data** | 21/01/2026 |
| **Responsável** | Product Owner - CRM |
| **Tipo DDD** | Core Domain |

---

## 1. Visão Geral

O módulo de Funil de Vendas é o **Core Domain** central do CRM de proteção veicular, permitindo aos consultores gerenciar todo o ciclo de vendas desde a captação do lead até o fechamento do contrato. Este é o coração do processo comercial.

### 1.1 Objetivos

- Proporcionar visão clara e organizada de todas as oportunidades de vendas
- Facilitar o acompanhamento do progresso de cada negociação
- Aumentar a taxa de conversão através de gestão eficiente do funil
- Automatizar follow-ups e tarefas do processo de vendas
- Fornecer métricas e indicadores de performance de vendas

### 1.2 Fluxo do Funil

```
Captação → Qualificação → Cotação → Proposta → Negociação → Fechamento → Pós-venda
```

### 1.3 Etapas do Funil Padrão

1. **Novo Lead** - Lead recém-captado, aguardando primeiro contato
2. **Contato Inicial** - Primeiro contato realizado, lead qualificado
3. **Cotação** - Cotação em elaboração ou enviada
4. **Proposta Enviada** - Proposta formal enviada ao lead
5. **Em Negociação** - Processo de negociação de valores/condições
6. **Aguardando Vistoria** - Aguardando realização de vistoria
7. **Aguardando Pagamento** - Aguardando confirmação de pagamento
8. **Fechado (Ganho)** - Contrato fechado com sucesso
9. **Perdido** - Negociação não convertida
10. **Futuro** - Lead para contato futuro (nurturing)

### 1.4 Atores

- **Consultor**: Gerencia suas próprias negociações
- **Supervisor/Gerente**: Visualiza funil da equipe
- **Administrador**: Configura funil e automações
- **Lead/Cliente**: Destinatário das ações de vendas

---

## 2. Domain-Driven Design

### 2.1 Bounded Context

O contexto **Funil de Vendas (CRM-FUN)** é classificado como **Core Domain** por ser o núcleo do processo comercial. Orquestra todos os outros contextos do CRM (Leads, Cotações, Propostas, Vistorias, Pagamentos) em um pipeline coeso.

**Linguagem Ubíqua:**
- **Negociação**: Oportunidade de venda em andamento com um lead
- **Etapa**: Fase do funil onde a negociação se encontra
- **Pipeline**: Visualização do funil com todas as negociações
- **Conversão**: Transformação de negociação em contrato fechado
- **Follow-up**: Atividade de acompanhamento agendada
- **Win/Loss**: Resultado final da negociação (Ganho/Perdido)
- **Ciclo de Vendas**: Tempo total desde captação até fechamento

### 2.2 Agregados

#### Agregado: Negociação (Aggregate Root)

```
┌─────────────────────────────────────────────────────────────────┐
│                    <<Aggregate Root>>                           │
│                      NEGOCIAÇÃO                                 │
├─────────────────────────────────────────────────────────────────┤
│ - id: UUID                                                      │
│ - numero: NumeroNegociacao                                      │
│ - leadId: UUID (FK CRM-LED)                                     │
│ - consultorId: UUID                                             │
│ - etapaAtual: EtapaFunil                                        │
│ - valorEstimado: Dinheiro                                       │
│ - dataPrevisaoFechamento: Date                                  │
│ - cotacoes: List<UUID> (ref CRM-COT)                            │
│ - propostas: List<UUID> (ref CRM-PRO)                           │
│ - vistoria: UUID? (ref CRM-VIS)                                 │
│ - atividades: List<Atividade>                                   │
│ - interacoes: List<Interacao>                                   │
│ - resultado: ResultadoNegociacao?                               │
│ - status: StatusNegociacao                                      │
│ - criadoEm: DateTime                                            │
│ - atualizadoEm: DateTime                                        │
├─────────────────────────────────────────────────────────────────┤
│ + moverParaEtapa(etapa: EtapaFunil): void                       │
│ + adicionarAtividade(atividade: Atividade): void                │
│ + concluirAtividade(atividadeId: UUID): void                    │
│ + registrarInteracao(interacao: Interacao): void                │
│ + vincularCotacao(cotacaoId: UUID): void                        │
│ + vincularProposta(propostaId: UUID): void                      │
│ + vincularVistoria(vistoriaId: UUID): void                      │
│ + marcarComoGanho(contrato: DadosContrato): void                │
│ + marcarComoPerdido(motivo: MotivoPerdaNegociacao): void        │
│ + agendarFollowUp(data: DateTime, descricao: string): void      │
│ + reativar(): void                                              │
│ + duplicar(): Negociacao                                        │
│ + calcularTempoNaEtapa(): Duration                              │
│ + calcularCicloVendas(): Duration                               │
│ + estaParada(dias: number): boolean                             │
└─────────────────────────────────────────────────────────────────┘
         │
         │ contém
         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    <<Entity>>                                   │
│                    ATIVIDADE                                    │
├─────────────────────────────────────────────────────────────────┤
│ - id: UUID                                                      │
│ - tipo: TipoAtividade                                           │
│ - titulo: string                                                │
│ - descricao: string                                             │
│ - dataAgendada: DateTime                                        │
│ - dataConclusao: DateTime?                                      │
│ - responsavelId: UUID                                           │
│ - prioridade: Prioridade                                        │
│ - status: StatusAtividade                                       │
│ - resultado: string?                                            │
└─────────────────────────────────────────────────────────────────┘
         │
         │ registra
         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    <<Entity>>                                   │
│                    INTERAÇÃO                                    │
├─────────────────────────────────────────────────────────────────┤
│ - id: UUID                                                      │
│ - tipo: TipoInteracao                                           │
│ - canal: CanalInteracao                                         │
│ - direcao: DirecaoInteracao                                     │
│ - resumo: string                                                │
│ - detalhes: string?                                             │
│ - consultorId: UUID                                             │
│ - dataHora: DateTime                                            │
│ - duracao: Duration?                                            │
└─────────────────────────────────────────────────────────────────┘
```

#### Agregado: ConfiguracaoFunil

```
┌─────────────────────────────────────────────────────────────────┐
│                    <<Aggregate Root>>                           │
│                 CONFIGURACAO_FUNIL                              │
├─────────────────────────────────────────────────────────────────┤
│ - id: UUID                                                      │
│ - nome: string                                                  │
│ - descricao: string                                             │
│ - etapas: List<EtapaFunilConfig>                                │
│ - automacoes: List<AutomacaoFunil>                              │
│ - regraAlertaParado: number (dias)                              │
│ - regraExpiracao: number (dias)                                 │
│ - ativo: boolean                                                │
│ - padrao: boolean                                               │
├─────────────────────────────────────────────────────────────────┤
│ + adicionarEtapa(etapa: EtapaFunilConfig): void                 │
│ + removerEtapa(etapaId: UUID): void                             │
│ + reordenarEtapas(ordem: UUID[]): void                          │
│ + definirAutomacao(automacao: AutomacaoFunil): void             │
│ + ativar(): void                                                │
│ + desativar(): void                                             │
└─────────────────────────────────────────────────────────────────┘
         │
         │ contém
         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    <<Entity>>                                   │
│                  ETAPA_FUNIL_CONFIG                             │
├─────────────────────────────────────────────────────────────────┤
│ - id: UUID                                                      │
│ - nome: string                                                  │
│ - ordem: number                                                 │
│ - cor: CorHex                                                   │
│ - probabilidadeConversao: Percentual                            │
│ - tempoMedioEsperado: Duration                                  │
│ - camposObrigatorios: List<string>                              │
│ - tipoEtapa: TipoEtapaFunil                                     │
└─────────────────────────────────────────────────────────────────┘
```

### 2.3 Entidades

| Entidade | Descrição | Identificador |
|----------|-----------|---------------|
| **Negociacao** | Oportunidade de venda com lead | UUID + NumeroNegociacao |
| **Atividade** | Tarefa agendada na negociação | UUID |
| **Interacao** | Registro de contato com lead | UUID |
| **ConfiguracaoFunil** | Definição das etapas do funil | UUID |
| **EtapaFunilConfig** | Configuração de uma etapa | UUID |
| **AutomacaoFunil** | Regra de automação do funil | UUID |

### 2.4 Value Objects

| Value Object | Propriedades | Validações |
|--------------|--------------|------------|
| **NumeroNegociacao** | numero: string | Formato NEG-AAAA-NNNNNN |
| **EtapaFunil** | codigo: string, nome: string | Código válido da configuração |
| **Dinheiro** | valor: decimal, moeda: string | >= 0, BRL |
| **ResultadoNegociacao** | tipo: TipoResultado, data: Date, detalhes: string | GANHO ou PERDIDO |
| **MotivoPerdaNegociacao** | codigo: string, descricao: string | Código válido de motivo |
| **DadosContrato** | contratoId: UUID, numero: string, valor: Dinheiro | Referência válida |
| **StatusNegociacao** | valor: enum | ATIVA, GANHA, PERDIDA, SUSPENSA, FUTURA |
| **TipoAtividade** | valor: enum | LIGACAO, EMAIL, REUNIAO, TAREFA, FOLLOWUP |
| **StatusAtividade** | valor: enum | PENDENTE, EM_ANDAMENTO, CONCLUIDA, CANCELADA |
| **Prioridade** | valor: enum | BAIXA, NORMAL, ALTA, URGENTE |
| **TipoInteracao** | valor: enum | LIGACAO, EMAIL, WHATSAPP, REUNIAO, VISITA |
| **CanalInteracao** | valor: enum | TELEFONE, EMAIL, WHATSAPP, PRESENCIAL, VIDEO |
| **DirecaoInteracao** | valor: enum | ENTRADA, SAIDA |
| **TipoEtapaFunil** | valor: enum | INICIAL, INTERMEDIARIA, FINAL_POSITIVO, FINAL_NEGATIVO |
| **CorHex** | valor: string | Formato #RRGGBB |
| **Percentual** | valor: decimal | 0-100 |

### 2.5 Eventos de Domínio

| Evento | Trigger | Payload | Consumidores |
|--------|---------|---------|--------------|
| **NegociacaoCriada** | Nova negociação | negociacaoId, leadId, consultorId | AUD, ANA |
| **NegociacaoMovida** | Mudança de etapa | negociacaoId, etapaAnterior, etapaNova | AUD, ANA |
| **AtividadeAgendada** | Nova atividade | negociacaoId, atividadeId, data | TAR, AUD |
| **AtividadeConcluida** | Atividade finalizada | negociacaoId, atividadeId, resultado | AUD |
| **InteracaoRegistrada** | Contato com lead | negociacaoId, interacaoId, tipo | AUD, ANA |
| **NegociacaoGanha** | Fechamento com sucesso | negociacaoId, contratoId, valor | PRO, PAG, POS, AUD, ANA |
| **NegociacaoPerdida** | Não convertida | negociacaoId, motivo | AUD, ANA |
| **NegociacaoParada** | Sem atividade há X dias | negociacaoId, diasParada | TAR, AUD |
| **FollowUpAgendado** | Follow-up marcado | negociacaoId, atividadeId, data | TAR |
| **CotacaoVinculada** | Cotação associada | negociacaoId, cotacaoId | AUD |
| **PropostaVinculada** | Proposta associada | negociacaoId, propostaId | AUD |
| **VistoriaVinculada** | Vistoria associada | negociacaoId, vistoriaId | AUD |

### 2.6 Repositórios

```typescript
interface NegociacaoRepository {
  salvar(negociacao: Negociacao): Promise<void>;
  buscarPorId(id: UUID): Promise<Negociacao | null>;
  buscarPorNumero(numero: NumeroNegociacao): Promise<Negociacao | null>;
  buscarPorLead(leadId: UUID): Promise<Negociacao[]>;
  buscarPorConsultor(consultorId: UUID, filtros?: FiltroNegociacao): Promise<Negociacao[]>;
  buscarPorEtapa(etapa: EtapaFunil): Promise<Negociacao[]>;
  buscarAtivas(): Promise<Negociacao[]>;
  buscarParadas(dias: number): Promise<Negociacao[]>;
  contarPorEtapa(consultorId?: UUID): Promise<Map<EtapaFunil, number>>;
  excluir(id: UUID): Promise<void>;
}

interface ConfiguracaoFunilRepository {
  salvar(config: ConfiguracaoFunil): Promise<void>;
  buscarPorId(id: UUID): Promise<ConfiguracaoFunil | null>;
  buscarPadrao(): Promise<ConfiguracaoFunil>;
  buscarAtivas(): Promise<ConfiguracaoFunil[]>;
}

interface AtividadeRepository {
  buscarPendentes(consultorId: UUID): Promise<Atividade[]>;
  buscarPorData(inicio: Date, fim: Date): Promise<Atividade[]>;
  buscarAtrasadas(): Promise<Atividade[]>;
}
```

---

## 3. Integrações

### 3.1 Upstream (Dependências)

| Contexto | Tipo | Dados Consumidos |
|----------|------|------------------|
| **CRM-Leads (LED)** | Customer/Supplier | Lead para criar negociação |
| **CRM-Cotações (COT)** | Event-Driven | Eventos de cotação |
| **CRM-Propostas (PRO)** | Event-Driven | Eventos de proposta |
| **CRM-Vistorias (VIS)** | Event-Driven | Eventos de vistoria |
| **CRM-Pagamentos (PAG)** | Event-Driven | Eventos de pagamento |

### 3.2 Downstream (Dependentes)

| Contexto | Tipo | Dados Fornecidos |
|----------|------|------------------|
| **CRM-Pós-Venda (POS)** | Customer/Supplier | Negociação ganha para iniciar onboarding |
| **CRM-Tarefas (TAR)** | Event-Driven | Atividades e follow-ups |
| **CRM-Análise (ANA)** | Published Language | Métricas do funil para BI |
| **CRM-Dashboard (DAS)** | CQRS Read | Visão consolidada do pipeline |

---

## 4. Histórias de Usuário

### 4.1 Essenciais (Must Have)

| ID | História | Story Points |
|----|----------|--------------|
| [US-CRM-FUN-001](US-CRM-FUN-001.md) | Visualizar Funil de Vendas | 8 |
| [US-CRM-FUN-002](US-CRM-FUN-002.md) | Criar Nova Negociação | 5 |
| [US-CRM-FUN-003](US-CRM-FUN-003.md) | Mover Negociação entre Etapas | 5 |
| [US-CRM-FUN-004](US-CRM-FUN-004.md) | Adicionar Atividade/Tarefa | 5 |
| [US-CRM-FUN-005](US-CRM-FUN-005.md) | Registrar Interação com Lead | 5 |
| [US-CRM-FUN-006](US-CRM-FUN-006.md) | Filtrar e Buscar Negociações | 5 |
| [US-CRM-FUN-007](US-CRM-FUN-007.md) | Visualizar Detalhes da Negociação | 5 |
| [US-CRM-FUN-008](US-CRM-FUN-008.md) | Marcar Negociação como Ganha | 8 |
| [US-CRM-FUN-009](US-CRM-FUN-009.md) | Marcar Negociação como Perdida | 5 |
| [US-CRM-FUN-010](US-CRM-FUN-010.md) | Agendar Follow-up | 3 |

### 4.2 Importantes (Should Have)

| ID | História | Story Points |
|----|----------|--------------|
| [US-CRM-FUN-011](US-CRM-FUN-011.md) | Configurar Funil Personalizado | 13 |
| [US-CRM-FUN-012](US-CRM-FUN-012.md) | Visualizar Métricas do Funil | 8 |
| [US-CRM-FUN-013](US-CRM-FUN-013.md) | Automação de Movimentação | 13 |
| [US-CRM-FUN-014](US-CRM-FUN-014.md) | Alertas de Negociações Paradas | 5 |
| [US-CRM-FUN-015](US-CRM-FUN-015.md) | Duplicar Negociação | 3 |

### 4.3 Desejáveis (Could Have)

| ID | História | Story Points |
|----|----------|--------------|
| [US-CRM-FUN-016](US-CRM-FUN-016.md) | Funil por Regional/Filial | 8 |
| [US-CRM-FUN-017](US-CRM-FUN-017.md) | Previsão de Faturamento | 8 |
| [US-CRM-FUN-018](US-CRM-FUN-018.md) | Análise de Tempo por Etapa | 5 |
| [US-CRM-FUN-019](US-CRM-FUN-019.md) | Comparativo de Performance | 8 |

### 4.4 Gestão de Leads/Negociações (Movidas de CRM-Leads)

> **Nota DDD:** Histórias movidas de CRM-Leads em 27/01/2026 para melhor alinhamento com o contexto de Funil de Vendas.

| ID | História | Story Points | Origem |
|----|----------|--------------|--------|
| [US-CRM-FUN-020](US-CRM-FUN-020.md) | Visualizar Lista de Leads/Negociações | 5 | ex-LEAD-013 |
| [US-CRM-FUN-021](US-CRM-FUN-021.md) | Buscar e Filtrar Negociações | 5 | ex-LEAD-014 |
| [US-CRM-FUN-022](US-CRM-FUN-022.md) | Editar Dados da Negociação/Lead | 5 | ex-LEAD-016 |
| [US-CRM-FUN-023](US-CRM-FUN-023.md) | Visualizar Detalhes da Negociação/Lead | 5 | ex-LEAD-017 |

**Subtotal Seção 4.4**: 20 SP | **Status**: ✅ Pronto

---

## 5. Regras de Negócio

| Código | Regra | Validação |
|--------|-------|-----------|
| RN-CRM-FUN-001 | Lead obrigatório | Negociação deve estar associada a um lead |
| RN-CRM-FUN-002 | Etapa única | Negociação só pode estar em uma etapa por vez |
| RN-CRM-FUN-003 | Valor estimado | Obrigatório informar valor estimado |
| RN-CRM-FUN-004 | Data previsão | Data de fechamento é obrigatória |
| RN-CRM-FUN-005 | Motivo perda | Obrigatório ao marcar como "Perdido" |
| RN-CRM-FUN-006 | Visibilidade | Consultor vê apenas suas negociações |
| RN-CRM-FUN-007 | Alerta parado | +7 dias sem atividade gera alerta |
| RN-CRM-FUN-008 | Contrato obrigatório | Ao marcar "Ganho", gerar proposta no sistema |
| RN-CRM-FUN-009 | Histórico completo | Manter todas as movimentações |

---

## 6. Métricas de Sucesso

| KPI | Meta | Descrição |
|-----|------|-----------|
| Taxa de Conversão | > 25% | % de negociações fechadas |
| Ticket Médio | R$ 1.500 | Valor médio por fechamento |
| Ciclo de Vendas | < 15 dias | Tempo médio lead→fechamento |
| Negociações Ativas | 20-40 | Por consultor |
| Taxa de Follow-up | > 80% | Leads contatados no prazo |
| Valor Médio Fechamento | R$ 1.500 | Ticket médio |

---

## 7. Histórico de Alterações

| Data | Versão | Autor | Alteração |
|------|--------|-------|-----------|
| 21/01/2026 | 1.0 | Product Owner | Versão inicial |
| 21/01/2026 | 2.0 | Product Owner | Reestruturação completa para padrão DDD |
| 27/01/2026 | 2.1 | Product Owner | DDD: Incorporar FUN-020 a FUN-023 (ex-LEAD-013, 014, 016, 017). Total +20 SP |

---

**Versão**: 2.1  
**Data**: 27/01/2026  
**Responsável**: Product Owner - CRM  
**Tipo DDD**: Core Domain
