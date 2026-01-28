# Módulo: Funil de Vendas e Negociações (CRM-FUN)

| Metadado | Valor |
|----------|-------|
| **Módulo** | CRM-Funil-Vendas |
| **Código** | CRM-FUN |
| **Versão** | 3.1 |
| **Data** | 28/01/2026 |
| **Responsável** | Product Owner - CRM |
| **Tipo DDD** | Core Domain |

---

## 1. Visão Geral

O módulo de Funil de Vendas é o **Core Domain** central do CRM de proteção veicular, permitindo aos consultores gerenciar todo o ciclo de vendas desde a captação do lead até o fechamento do contrato. Este é o coração do processo comercial. O sistema CRM permitirá que existam vários funis personalizados, começando do funil de Leads Recebidos com as etapas (Pronto para Abordar, Tentando Contato, Coleta de Dados, Em Negociacao, Co, tacao Enviada, Fechado), Funil Pagamentos com as etapas (Contrato Fechado, Aguardando Pagamento, Pagamento Não efetuado, Pagamento Efetuado, Aguardando Vistoria), Funil Vistorias com as Etapas (Pendente de Vistoria, Vistoria Agendada, Vistoria Efetuada, Vistoria Cancelada/Revistoria, Vistoria Aprovada), Funil Analise de Cotações com as etapas (Pendente de Análise, Negociação em Análise, Negociação Pendente/Reprovada, Negociação Aprovada, Liberado para Cadastro), Funil Negociação Concretizada com as etapas (Triagem Pós Venda - Envio Contrato, Conferência do Cadastro, Checklist Integrações, Checklist Financeiro e Finalizados).
Cada funil tem um fluxo específico que interage com outros aplicativos e funcionalidades especificas, por exemplo, o Funil de Leads Recebidos interage diretamente com todo o processo de captação de leads descrito nas US-CRM-LEADS. O Funil Pagamentos irá interagir com um aplicativo/banco digital, onde os consultores poderão sacar os valores a receber de cada de negociação fechada, a integração com banco digital será visual, nos próprios cards e via api/webhooks. O funil de Vistorias será integrado com um aplicativo próprio de vistoria, chamado VistorIA, onde será feito todo o processo de vistoria, com coleta de fotos, assinaturas e demais confirmações de dados, a integração também ocorrerá via banco de dados, api/webhook e visualmente. Os funis de Análise de Cotações e Negociação Concretizada terão integração com o ERP da Top que poderá ser o SGA ou SAV.

### 1.1 Objetivos

- Proporcionar visão clara e organizada de todas as oportunidades de vendas
- Facilitar o acompanhamento do progresso de cada negociação por etapa
- Aumentar a taxa de conversão através de gestão eficiente do funil
- Automatizar follow-ups e tarefas do processo de vendas
- Fornecer métricas e indicadores de performance de vendas
- Processos com fluxos separados que facilitam a gestão das negociações

### 1.2 Fluxo Geral dos Funis

```
Leads Recebidos → Pagamentos → Vistorias → Análise de Cotações → Negociação Concretizada
```

### 1.3 Funis Personalizados e Etapas

O sistema CRM possui **5 funis personalizados**, cada um com etapas específicas e integrações próprias:

#### 1.3.1 Funil de Leads Recebidos

| Etapa | Descrição |
|-------|-----------|
| Pronto para Abordar | Lead recém-captado, aguardando primeiro contato |
| Tentando Contato | Consultor realizando tentativas de contato |
| Coleta de Dados | Coletando informações do veículo e cliente |
| Em Negociação | Processo de negociação de valores/condições |
| Cotação Enviada | Cotação elaborada e enviada ao lead |
| Fechado | Negociação concluída (ganho ou perdido) |

**Integração**: Conecta-se diretamente com o processo de captação de leads (US-CRM-LEADS)

#### 1.3.2 Funil de Pagamentos

| Etapa | Descrição |
|-------|-----------|
| Contrato Fechado | Negociação convertida em contrato |
| Aguardando Pagamento | Esperando confirmação de pagamento |
| Pagamento Não Efetuado | Pagamento não realizado (follow-up) |
| Pagamento Efetuado | Pagamento confirmado com sucesso |
| Aguardando Vistoria | Pagamento ok, aguardando processo de vistoria |

**Integração**: Aplicativo/banco digital para saques dos valores a receber. Integração visual nos cards + API/webhooks

#### 1.3.3 Funil de Vistorias

| Etapa | Descrição |
|-------|-----------|
| Pendente de Vistoria | Aguardando agendamento de vistoria |
| Vistoria Agendada | Vistoria marcada com data/hora |
| Vistoria Efetuada | Vistoria realizada, em análise |
| Vistoria Cancelada/Revistoria | Necessita nova vistoria |
| Vistoria Aprovada | Vistoria aprovada, liberada |

**Integração**: Aplicativo VistorIA para coleta de fotos, assinaturas e confirmações. Integração via banco de dados, API/webhook e visualmente

#### 1.3.4 Funil de Análise de Cotações

| Etapa | Descrição |
|-------|-----------|
| Pendente de Análise | Cotação aguardando análise |
| Negociação Em Análise | Cotação sendo analisada |
| Negociação Pendente/Reprovada | Cotação com pendências ou reprovada |
| Negociação Aprovada | Cotação aprovada |
| Liberado para Cadastro | Pronto para cadastro no sistema |

**Integração**: ERP da Top (SGA ou SAV) para cadastro e faturamento

#### 1.3.5 Funil de Negociação Concretizada (Pós-Venda)

| Etapa | Descrição |
|-------|-----------|
| Triagem Pós Venda - Envio Contrato | Envio do contrato ao cliente |
| Conferência do Cadastro | Validação dos dados cadastrados |
| Checklist Integrações | Verificação de integrações ativas |
| Checklist Financeiro | Validação financeira final |
| Finalizados | Processo concluído com sucesso |

**Integração**: ERP da Top (SGA ou SAV) para finalização do cadastro

### 1.4 Atores

- **Consultor**: Gerencia suas próprias negociações
- **Supervisor/Gerente**: Visualiza funil da equipe
- **Administrador**: Configura funil e automações
- **Lead/Cliente**: Destinatário das ações de vendas

### 1.5 Interface do Usuário (Kanban)

#### Estrutura da Tela
- **Header**: Logo TopBrasil, ícones de navegação (Home, Menu, Notificações), Avatar do usuário
- **Seletor de Funil**: Dropdown para alternar entre os 5 funis
- **Barra de Busca**: Busca por nome, veículo, consultor
- **Botão Filtrar**: Filtros avançados
- **Botão "Nova Negociação"**: Criar nova negociação (laranja)
- **Colunas**: Etapas do funil em formato kanban com contador de cards

#### Estrutura do Card

```
┌─────────────────────────────────────────┐
│ [Pendente]                              │  ← Badge de Status (vermelho)
├─────────────────────────────────────────┤
│ 👤 Nome do Lead          22 Jan • 20:51 │  ← Nome + Data/Hora
│ 🚗 Veículo não informado                │  ← Dados do Veículo
│ 💰 R$ 0,00                              │  ← Valor Estimado
├─────────────────────────────────────────┤
│ [N]  ●●  ✏️  💬  📅  ➡️                  │  ← Ações Rápidas
└─────────────────────────────────────────┘
```

| Elemento | Descrição |
|----------|-----------|
| **Badge Status** | Indica status da negociação (Pendente = vermelho) |
| **Nome** | Nome do lead/cliente |
| **Data/Hora** | Data e hora de criação ou última atualização |
| **Veículo** | Modelo do veículo ou "Veículo não informado" |
| **Valor** | Valor estimado da negociação (R$) |
| **[N]** | Indicador de prioridade (N = Normal) |
| **●●** | Indicador de atividades/tarefas pendentes (laranja = pendente) |
| **✏️** | Editar dados da negociação |
| **💬** | Enviar mensagem WhatsApp |
| **📅** | Agendar atividade/follow-up |
| **➡️** | Mover para próxima etapa |

#### Funcionalidades de Interação
- **Drag & Drop**: Arrastar cards entre etapas ("Arraste cards aqui")
- **Contador por Etapa**: Número de cards em cada coluna
- **Scroll Horizontal**: Navegação entre etapas
- **Clique no Card**: Abre detalhes completos da negociação

---

## 2. Domain-Driven Design

### 2.1 Bounded Context

O contexto **Funil de Vendas (CRM-FUN)** é classificado como **Core Domain** por ser o núcleo do processo comercial. Orquestra todos os outros contextos do CRM (Leads, Cotações, Propostas, Vistorias, Pagamentos) em um pipeline coeso.

**Linguagem Ubíqua:**
- **Negociação**: Oportunidade de venda em andamento com um lead
- **Funil**: Pipeline específico com etapas próprias (Leads, Pagamentos, Vistorias, Análise, Pós-Venda)
- **Etapa**: Fase específica dentro de um funil onde a negociação se encontra
- **Card**: Representação visual da negociação no kanban do funil
- **Pipeline**: Visualização do funil com todas as negociações (formato kanban)
- **Transição**: Movimentação da negociação entre etapas ou funis
- **Conversão**: Transformação de negociação em contrato fechado
- **Follow-up**: Atividade de acompanhamento agendada
- **Win/Loss**: Resultado final da negociação (Ganho/Perdido)
- **Ciclo de Vendas**: Tempo total desde captação até fechamento
- **Vistoria**: Inspeção do veículo via aplicativo VistorIA
- **Checklist**: Verificação de itens obrigatórios por etapa

### 2.2 Agregados

#### Agregado: Negociação (Aggregate Root)

```
┌─────────────────────────────────────────────────────────────────┐
│                    <<Aggregate Root>>                           │
│                      NEGOCIAÇÃO                                 │
├─────────────────────────────────────────────────────────────────┤
│ - id: id_negociacao                                             │
│ - numero: NumeroNegociacao                                      │
│ - leadId: UUID (FK CRM-LED)                                     │
│ - consultorId: UUID                                             │
│ - funilAtual: TipoFunil                                         │
│ - etapaAtual: EtapaFunil                                        │
│ - historicoFunis: List<HistoricoFunil>                          │
│ - valorEstimado: Dinheiro                                       │
│ - dataPrevisaoFechamento: Date                                  │
│ - cotacoes: List<UUID> (ref CRM-COT)                            │
│ - propostas: List<UUID> (ref CRM-PRO)                           │
│ - vistoria: DadosVistoria? (ref VistorIA)                       │
│ - pagamento: DadosPagamento? (ref Banco Digital)                │
│ - atividades: List<Atividade>                                   │
│ - interacoes: List<Interacao>                                   │
│ - checklists: List<ChecklistItem>                               │
│ - resultado: ResultadoNegociacao?                               │
│ - status: StatusNegociacao                                      │
│ - criadoEm: DateTime                                            │
│ - atualizadoEm: DateTime                                        │
├─────────────────────────────────────────────────────────────────┤
│ + moverParaEtapa(etapa: EtapaFunil): void                       │
│ + moverParaFunil(funil: TipoFunil, etapaInicial: EtapaFunil)    │
│ + adicionarAtividade(atividade: Atividade): void                │
│ + concluirAtividade(atividadeId: UUID): void                    │
│ + registrarInteracao(interacao: Interacao): void                │
│ + vincularCotacao(cotacaoId: UUID): void                        │
│ + vincularProposta(propostaId: UUID): void                      │
│ + vincularVistoria(vistoria: DadosVistoria): void               │
│ + atualizarPagamento(pagamento: DadosPagamento): void           │
│ + marcarChecklistItem(itemId: UUID, concluido: boolean): void   │
│ + marcarComoGanho(contrato: DadosContrato): void                │
│ + marcarComoPerdido(motivo: MotivoPerdaNegociacao): void        │
│ + agendarFollowUp(data: DateTime, descricao: string): void      │
│ + reativar(): void                                              │
│ + duplicar(): Negociacao                                        │
│ + calcularTempoNaEtapa(): Duration                              │
│ + calcularTempoNoFunil(): Duration                              │
│ + calcularCicloVendas(): Duration                               │
│ + estaParada(dias: number): boolean                             │
│ + obterHistoricoCompleto(): List<HistoricoFunil>                │
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
         │
         │ rastreia
         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    <<Entity>>                                   │
│                  HISTORICO_FUNIL                                │
├─────────────────────────────────────────────────────────────────┤
│ - id: UUID                                                      │
│ - funilOrigem: TipoFunil                                        │
│ - etapaOrigem: EtapaFunil                                       │
│ - funilDestino: TipoFunil                                       │
│ - etapaDestino: EtapaFunil                                      │
│ - dataMovimentacao: DateTime                                    │
│ - usuarioId: UUID                                               │
│ - motivo: string?                                               │
│ - tempoNaEtapaAnterior: Duration                                │
└─────────────────────────────────────────────────────────────────┘
         │
         │ valida
         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    <<Entity>>                                   │
│                  CHECKLIST_ITEM                                 │
├─────────────────────────────────────────────────────────────────┤
│ - id: UUID                                                      │
│ - funil: TipoFunil                                              │
│ - etapa: EtapaFunil                                             │
│ - descricao: string                                             │
│ - obrigatorio: boolean                                          │
│ - concluido: boolean                                            │
│ - dataConclusao: DateTime?                                      │
│ - usuarioId: UUID?                                              │
└─────────────────────────────────────────────────────────────────┘
```

#### Agregado: ConfiguracaoFunil

```
┌─────────────────────────────────────────────────────────────────┐
│                    <<Aggregate Root>>                           │
│                 CONFIGURACAO_FUNIL                              │
├─────────────────────────────────────────────────────────────────┤
│ - id: UUID                                                      │
│ - tipo: TipoFunil                                               │
│ - nome: string                                                  │
│ - descricao: string                                             │
│ - etapas: List<EtapaFunilConfig>                                │
│ - automacoes: List<AutomacaoFunil>                              │
│ - integracoes: List<IntegracaoFunil>                            │
│ - checklists: List<ChecklistConfig>                             │
│ - regraAlertaParado: number (dias)                              │
│ - regraExpiracao: number (dias)                                 │
│ - ordemNoFluxo: number                                          │
│ - funilAnterior: TipoFunil?                                     │
│ - funilProximo: TipoFunil?                                      │
│ - ativo: boolean                                                │
├─────────────────────────────────────────────────────────────────┤
│ + adicionarEtapa(etapa: EtapaFunilConfig): void                 │
│ + removerEtapa(etapaId: UUID): void                             │
│ + reordenarEtapas(ordem: UUID[]): void                          │
│ + definirAutomacao(automacao: AutomacaoFunil): void             │
│ + configurarIntegracao(integracao: IntegracaoFunil): void       │
│ + definirChecklist(checklist: ChecklistConfig): void            │
│ + ativar(): void                                                │
│ + desativar(): void                                             │
│ + obterEtapaInicial(): EtapaFunilConfig                         │
│ + obterEtapaFinal(): EtapaFunilConfig                           │
└─────────────────────────────────────────────────────────────────┘
         │
         │ contém
         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    <<Entity>>                                   │
│                  ETAPA_FUNIL_CONFIG                             │
├─────────────────────────────────────────────────────────────────┤
│ - id: UUID                                                      │
│ - codigo: string                                                │
│ - nome: string                                                  │
│ - ordem: number                                                 │
│ - cor: CorHex                                                   │
│ - probabilidadeConversao: Percentual                            │
│ - tempoMedioEsperado: Duration                                  │
│ - camposObrigatorios: List<string>                              │
│ - tipoEtapa: TipoEtapaFunil                                     │
│ - permiteRetroceder: boolean                                    │
│ - gatilhoAutomatico: boolean                                    │
└─────────────────────────────────────────────────────────────────┘
         │
         │ integra
         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    <<Entity>>                                   │
│                  INTEGRACAO_FUNIL                               │
├─────────────────────────────────────────────────────────────────┤
│ - id: UUID                                                      │
│ - sistema: SistemaIntegracao                                    │
│ - tipo: TipoIntegracao                                          │
│ - configuracao: JSON                                            │
│ - webhookUrl: string?                                           │
│ - apiEndpoint: string?                                          │
│ - ativo: boolean                                                │
└─────────────────────────────────────────────────────────────────┘
```

#### Agregado: Funil (5 Instâncias Pré-configuradas)

```
┌─────────────────────────────────────────────────────────────────┐
│                    <<Aggregate Root>>                           │
│                        FUNIL                                    │
├─────────────────────────────────────────────────────────────────┤
│ Instâncias Pré-configuradas:                                    │
│                                                                 │
│ 1. FUNIL_LEADS_RECEBIDOS                                        │
│    - Etapas: Pronto p/ Abordar → Tentando Contato →             │
│              Coleta de Dados → Em Negociação →                  │
│              Cotação Enviada → Fechado                          │
│    - Integração: CRM-LEADS (US-CRM-LEADS)                       │
│                                                                 │
│ 2. FUNIL_PAGAMENTOS                                             │
│    - Etapas: Contrato Fechado → Aguardando Pagamento →          │
│              Pagamento Não Efetuado → Pagamento Efetuado →      │
│              Aguardando Vistoria                                │
│    - Integração: Banco Digital (API/Webhooks)                   │
│                                                                 │
│ 3. FUNIL_VISTORIAS                                              │
│    - Etapas: Pendente de Vistoria → Vistoria Agendada →         │
│              Vistoria Efetuada → Vistoria Cancelada/Revistoria →│
│              Vistoria Aprovada                                  │
│    - Integração: App VistorIA (BD/API/Webhook)                  │
│                                                                 │
│ 4. FUNIL_ANALISE_COTACOES                                       │
│    - Etapas: Pendente de Análise → Negociação em Análise →      │
│              Negociação Pendente/Reprovada →                    │
│              Negociação Aprovada → Liberado para Cadastro       │
│    - Integração: ERP Top (SGA/SAV)                              │
│                                                                 │
│ 5. FUNIL_NEGOCIACAO_CONCRETIZADA                                │
│    - Etapas: Triagem Pós Venda - Envio Contrato →               │
│              Conferência do Cadastro → Checklist Integrações →  │
│              Checklist Financeiro → Finalizados                 │
│    - Integração: ERP Top (SGA/SAV)                              │
└─────────────────────────────────────────────────────────────────┘
```

### 2.3 Entidades

| Entidade | Descrição | Identificador |
|----------|-----------|---------------|
| **Negociacao** | Oportunidade de venda com lead, transita entre funis | UUID + NumeroNegociacao |
| **Atividade** | Tarefa agendada na negociação | UUID |
| **Interacao** | Registro de contato com lead | UUID |
| **HistoricoFunil** | Registro de movimentações entre funis/etapas | UUID |
| **ChecklistItem** | Item de verificação por etapa | UUID |
| **ConfiguracaoFunil** | Definição de um dos 5 funis | UUID + TipoFunil |
| **EtapaFunilConfig** | Configuração de uma etapa do funil | UUID |
| **IntegracaoFunil** | Configuração de integração externa | UUID |
| **AutomacaoFunil** | Regra de automação do funil | UUID |
| **ChecklistConfig** | Template de checklist por etapa | UUID |

### 2.4 Value Objects

| Value Object | Propriedades | Validações |
|--------------|--------------|------------|
| **NumeroNegociacao** | numero: string | Formato NEG-AAAA-NNNNNN |
| **TipoFunil** | valor: enum | LEADS_RECEBIDOS, PAGAMENTOS, VISTORIAS, ANALISE_COTACOES, NEGOCIACAO_CONCRETIZADA |
| **EtapaFunil** | funil: TipoFunil, codigo: string, nome: string | Código válido para o funil |
| **Dinheiro** | valor: decimal, moeda: string | >= 0, BRL |
| **ResultadoNegociacao** | tipo: TipoResultado, data: Date, detalhes: string | GANHO ou PERDIDO |
| **MotivoPerdaNegociacao** | codigo: string, descricao: string | Código válido de motivo |
| **DadosContrato** | contratoId: UUID, numero: string, valor: Dinheiro | Referência válida |
| **DadosVistoria** | vistoriaId: UUID, status: StatusVistoria, fotos: List<URL>, dataAgendada: DateTime | Ref VistorIA |
| **DadosPagamento** | transacaoId: UUID, valor: Dinheiro, status: StatusPagamento, dataPagamento: DateTime? | Ref Banco Digital |
| **DadosVeiculo** | modelo: string, placa: string?, ano: number?, cor: string? | Veículo da negociação |
| **CardVisual** | leadNome, dataHora, veiculo, valor, statusBadge, prioridade, atividadesPendentes | Representação visual |
| **StatusNegociacao** | valor: enum | ATIVA, GANHA, PERDIDA, SUSPENSA, FUTURA |
| **StatusBadge** | valor: enum, cor: CorHex | PENDENTE (vermelho), EM_ANDAMENTO (amarelo), CONCLUIDO (verde) |
| **StatusVistoria** | valor: enum | PENDENTE, AGENDADA, EFETUADA, CANCELADA, APROVADA |
| **StatusPagamento** | valor: enum | AGUARDANDO, NAO_EFETUADO, EFETUADO, ESTORNADO |
| **TipoAtividade** | valor: enum | LIGACAO, EMAIL, REUNIAO, TAREFA, FOLLOWUP, VISTORIA, WHATSAPP |
| **StatusAtividade** | valor: enum | PENDENTE, EM_ANDAMENTO, CONCLUIDA, CANCELADA |
| **Prioridade** | valor: enum, indicador: string | BAIXA (B), NORMAL (N), ALTA (A), URGENTE (U) |
| **TipoInteracao** | valor: enum | LIGACAO, EMAIL, WHATSAPP, REUNIAO, VISITA |
| **CanalInteracao** | valor: enum | TELEFONE, EMAIL, WHATSAPP, PRESENCIAL, VIDEO |
| **DirecaoInteracao** | valor: enum | ENTRADA, SAIDA |
| **TipoEtapaFunil** | valor: enum | INICIAL, INTERMEDIARIA, FINAL_POSITIVO, FINAL_NEGATIVO, TRANSICAO |
| **SistemaIntegracao** | valor: enum | VISTORIA_APP, BANCO_DIGITAL, ERP_SGA, ERP_SAV, CRM_LEADS |
| **TipoIntegracao** | valor: enum | API, WEBHOOK, BANCO_DADOS, VISUAL |
| **AcaoRapidaCard** | valor: enum | EDITAR, WHATSAPP, AGENDAR, MOVER_PROXIMO |
| **CorHex** | valor: string | Formato #RRGGBB |
| **Percentual** | valor: decimal | 0-100 |

### 2.5 Eventos de Domínio

| Evento | Trigger | Payload | Consumidores |
|--------|---------|---------|--------------|
| **NegociacaoCriada** | Nova negociação | negociacaoId, leadId, consultorId, funilInicial | AUD, ANA |
| **NegociacaoMovidaEtapa** | Mudança de etapa no mesmo funil | negociacaoId, funil, etapaAnterior, etapaNova | AUD, ANA |
| **NegociacaoMovidaFunil** | Transição entre funis | negociacaoId, funilAnterior, funilNovo, etapaNova | AUD, ANA, Integrações |
| **AtividadeAgendada** | Nova atividade | negociacaoId, atividadeId, data | TAR, AUD |
| **AtividadeConcluida** | Atividade finalizada | negociacaoId, atividadeId, resultado | AUD |
| **InteracaoRegistrada** | Contato com lead | negociacaoId, interacaoId, tipo, canal | AUD, ANA |
| **NegociacaoGanha** | Fechamento com sucesso | negociacaoId, contratoId, valor | PRO, PAG, POS, AUD, ANA |
| **NegociacaoPerdida** | Não convertida | negociacaoId, motivo, funilAtual | AUD, ANA |
| **NegociacaoParada** | Sem atividade há X dias | negociacaoId, diasParada, funilAtual | TAR, AUD |
| **FollowUpAgendado** | Follow-up marcado | negociacaoId, atividadeId, data | TAR |
| **CotacaoVinculada** | Cotação associada | negociacaoId, cotacaoId | AUD |
| **PropostaVinculada** | Proposta associada | negociacaoId, propostaId | AUD |
| **VistoriaVinculada** | Vistoria do VistorIA | negociacaoId, vistoriaId, status | AUD, VIS |
| **VistoriaAtualizada** | Status vistoria alterado | negociacaoId, vistoriaId, statusAnterior, statusNovo | AUD, VIS |
| **PagamentoAtualizado** | Status pagamento alterado | negociacaoId, transacaoId, statusAnterior, statusNovo | AUD, PAG |
| **ChecklistItemConcluido** | Item checklist marcado | negociacaoId, checklistItemId, funil, etapa | AUD |
| **ChecklistCompletado** | Todos itens obrigatórios ok | negociacaoId, funil, etapa | AUD, Automação |
| **IntegracaoRecebida** | Webhook/evento externo | sistemaOrigem, tipo, payload | Processador Eventos |
| **IntegracaoEnviada** | Dados enviados p/ externo | sistemaDestino, tipo, payload | AUD |

### 2.6 Repositórios

```typescript
interface NegociacaoRepository {
  salvar(negociacao: Negociacao): Promise<void>;
  buscarPorId(id: UUID): Promise<Negociacao | null>;
  buscarPorNumero(numero: NumeroNegociacao): Promise<Negociacao | null>;
  buscarPorLead(leadId: UUID): Promise<Negociacao[]>;
  buscarPorConsultor(consultorId: UUID, filtros?: FiltroNegociacao): Promise<Negociacao[]>;
  buscarPorFunil(funil: TipoFunil, filtros?: FiltroNegociacao): Promise<Negociacao[]>;
  buscarPorEtapa(funil: TipoFunil, etapa: EtapaFunil): Promise<Negociacao[]>;
  buscarAtivas(): Promise<Negociacao[]>;
  buscarParadas(dias: number): Promise<Negociacao[]>;
  contarPorFunilEtapa(consultorId?: UUID): Promise<Map<TipoFunil, Map<EtapaFunil, number>>>;
  excluir(id: UUID): Promise<void>;
}

interface ConfiguracaoFunilRepository {
  salvar(config: ConfiguracaoFunil): Promise<void>;
  buscarPorId(id: UUID): Promise<ConfiguracaoFunil | null>;
  buscarPorTipo(tipo: TipoFunil): Promise<ConfiguracaoFunil>;
  buscarTodos(): Promise<ConfiguracaoFunil[]>;
  buscarAtivos(): Promise<ConfiguracaoFunil[]>;
}

interface AtividadeRepository {
  buscarPendentes(consultorId: UUID): Promise<Atividade[]>;
  buscarPorData(inicio: Date, fim: Date): Promise<Atividade[]>;
  buscarAtrasadas(): Promise<Atividade[]>;
  buscarPorNegociacao(negociacaoId: UUID): Promise<Atividade[]>;
}

interface HistoricoFunilRepository {
  salvar(historico: HistoricoFunil): Promise<void>;
  buscarPorNegociacao(negociacaoId: UUID): Promise<HistoricoFunil[]>;
  buscarTransicoes(funil: TipoFunil, periodo: DateRange): Promise<HistoricoFunil[]>;
}

interface IntegracaoRepository {
  buscarPorFunil(funil: TipoFunil): Promise<IntegracaoFunil[]>;
  buscarPorSistema(sistema: SistemaIntegracao): Promise<IntegracaoFunil[]>;
  salvarEvento(evento: EventoIntegracao): Promise<void>;
}
```

---

## 3. Integrações

### 3.1 Integrações por Funil

| Funil | Sistema | Tipo | Descrição |
|-------|---------|------|-----------|
| **Leads Recebidos** | CRM-Leads | Event-Driven | Captação e qualificação de leads |
| **Pagamentos** | Banco Digital | API/Webhook/Visual | Saques, status de pagamento em tempo real |
| **Vistorias** | VistorIA (App) | BD/API/Webhook/Visual | Coleta fotos, assinaturas, validações |
| **Análise Cotações** | ERP Top (SGA/SAV) | API | Cadastro e faturamento |
| **Negociação Concretizada** | ERP Top (SGA/SAV) | API | Finalização de cadastros |

### 3.2 Upstream (Dependências)

| Contexto | Tipo | Dados Consumidos |
|----------|------|------------------|
| **CRM-Leads (LED)** | Customer/Supplier | Lead para criar negociação no Funil Leads Recebidos |
| **CRM-Cotações (COT)** | Event-Driven | Eventos de cotação para Funil Análise |
| **CRM-Propostas (PRO)** | Event-Driven | Eventos de proposta |
| **App VistorIA** | API/Webhook | Status e dados de vistoria para Funil Vistorias |
| **Banco Digital** | API/Webhook | Status de pagamento para Funil Pagamentos |
| **ERP Top (SGA/SAV)** | API | Validações e cadastros para Funis Análise e Pós-Venda |

### 3.3 Downstream (Dependentes)

| Contexto | Tipo | Dados Fornecidos |
|----------|------|------------------|
| **CRM-Pós-Venda (POS)** | Customer/Supplier | Negociação finalizada do Funil Negociação Concretizada |
| **CRM-Tarefas (TAR)** | Event-Driven | Atividades e follow-ups de todos os funis |
| **CRM-Análise (ANA)** | Published Language | Métricas consolidadas dos 5 funis para BI |
| **CRM-Dashboard (DAS)** | CQRS Read | Visão consolidada de todos os pipelines |
| **App VistorIA** | API/Webhook | Solicitações de vistoria |
| **Banco Digital** | API/Webhook | Solicitações de cobrança |
| **ERP Top (SGA/SAV)** | API | Dados para cadastro e faturamento |

---

## 4. Histórias de Usuário

### 4.1 Essenciais (Must Have) - Gestão Multi-Funil

| ID | História | Story Points |
|----|----------|--------------|
| [US-CRM-FUN-001](US-CRM-FUN-001.md) | Visualizar Pipeline dos 5 Funis (Kanban) | 13 |
| [US-CRM-FUN-002](US-CRM-FUN-002.md) | Criar Nova Negociação no Funil Leads Recebidos | 5 |
| [US-CRM-FUN-003](US-CRM-FUN-003.md) | Mover Negociação entre Etapas do Funil | 5 |
| [US-CRM-FUN-004](US-CRM-FUN-004.md) | Transicionar Negociação entre Funis | 8 |
| [US-CRM-FUN-005](US-CRM-FUN-005.md) | Adicionar Atividade/Tarefa à Negociação | 5 |
| [US-CRM-FUN-006](US-CRM-FUN-006.md) | Registrar Interação com Lead | 5 |
| [US-CRM-FUN-007](US-CRM-FUN-007.md) | Filtrar e Buscar Negociações por Funil | 5 |
| [US-CRM-FUN-008](US-CRM-FUN-008.md) | Visualizar Detalhes da Negociação com Histórico de Funis | 8 |
| [US-CRM-FUN-009](US-CRM-FUN-009.md) | Marcar Negociação como Ganha | 8 |
| [US-CRM-FUN-010](US-CRM-FUN-010.md) | Marcar Negociação como Perdida | 5 |
| [US-CRM-FUN-011](US-CRM-FUN-011.md) | Agendar Follow-up | 3 |

### 4.2 Integrações Específicas por Funil (Must Have)

| ID | História | Story Points | Funil |
|----|----------|--------------|-------|
| [US-CRM-FUN-012](US-CRM-FUN-012.md) | Integração Visual Pagamentos (Cards) | 8 | Pagamentos |
| [US-CRM-FUN-013](US-CRM-FUN-013.md) | Receber Webhook Banco Digital | 5 | Pagamentos |
| [US-CRM-FUN-014](US-CRM-FUN-014.md) | Integração Visual Vistorias (Cards) | 8 | Vistorias |
| [US-CRM-FUN-015](US-CRM-FUN-015.md) | Receber Webhook VistorIA | 5 | Vistorias |
| [US-CRM-FUN-016](US-CRM-FUN-016.md) | Enviar Dados para ERP Top (SGA/SAV) | 8 | Análise/Pós-Venda |
| [US-CRM-FUN-017](US-CRM-FUN-017.md) | Gerenciar Checklists por Etapa | 5 | Todos |

### 4.3 Importantes (Should Have)

| ID | História | Story Points |
|----|----------|--------------|
| [US-CRM-FUN-018](US-CRM-FUN-018.md) | Configurar Etapas dos Funis | 13 |
| [US-CRM-FUN-019](US-CRM-FUN-019.md) | Visualizar Métricas Consolidadas dos Funis | 8 |
| [US-CRM-FUN-020](US-CRM-FUN-020.md) | Automação de Transição entre Funis | 13 |
| [US-CRM-FUN-021](US-CRM-FUN-021.md) | Alertas de Negociações Paradas por Funil | 5 |
| [US-CRM-FUN-022](US-CRM-FUN-022.md) | Duplicar Negociação | 3 |

### 4.4 Desejáveis (Could Have)

| ID | História | Story Points |
|----|----------|--------------|
| [US-CRM-FUN-023](US-CRM-FUN-023.md) | Dashboard por Funil | 8 |
| [US-CRM-FUN-024](US-CRM-FUN-024.md) | Previsão de Faturamento por Funil | 8 |
| [US-CRM-FUN-025](US-CRM-FUN-025.md) | Análise de Tempo por Etapa/Funil | 5 |
| [US-CRM-FUN-026](US-CRM-FUN-026.md) | Comparativo de Performance entre Funis | 8 |
| [US-CRM-FUN-027](US-CRM-FUN-027.md) | Relatório de Histórico de Transições | 5 |

### 4.5 Gestão de Leads/Negociações (Movidas de CRM-Leads)

> **Nota DDD:** Histórias movidas de CRM-Leads em 27/01/2026 para melhor alinhamento com o contexto de Funil de Vendas. Renumeradas em 28/01/2026 para adequação à nova estrutura multi-funil.

| ID | História | Story Points | Origem |
|----|----------|--------------|--------|
| [US-CRM-FUN-028](US-CRM-FUN-028.md) | Visualizar Lista de Negociações por Funil | 5 | ex-LEAD-013 |
| [US-CRM-FUN-029](US-CRM-FUN-029.md) | Buscar e Filtrar Negociações Multi-Funil | 5 | ex-LEAD-014 |
| [US-CRM-FUN-030](US-CRM-FUN-030.md) | Editar Dados da Negociação/Lead | 5 | ex-LEAD-016 |
| [US-CRM-FUN-031](US-CRM-FUN-031.md) | Visualizar Detalhes Completos com Integrações | 5 | ex-LEAD-017 |

**Subtotal Seção 4.5**: 20 SP | **Status**: ✅ Pronto

---

## 5. Regras de Negócio

### 5.1 Regras Gerais

| Código | Regra | Validação |
|--------|-------|-----------|
| RN-CRM-FUN-001 | Lead obrigatório | Negociação deve estar associada a um lead |
| RN-CRM-FUN-002 | Funil único | Negociação só pode estar em um funil por vez |
| RN-CRM-FUN-003 | Etapa única | Negociação só pode estar em uma etapa por vez dentro do funil |
| RN-CRM-FUN-004 | Valor estimado | Obrigatório informar valor estimado |
| RN-CRM-FUN-005 | Data previsão | Data de fechamento é obrigatória |
| RN-CRM-FUN-006 | Motivo perda | Obrigatório ao marcar como "Perdido" |
| RN-CRM-FUN-007 | Visibilidade | Consultor vê apenas suas negociações |
| RN-CRM-FUN-008 | Alerta parado | +7 dias sem atividade gera alerta |
| RN-CRM-FUN-009 | Histórico completo | Manter todas as movimentações entre funis/etapas |
| RN-CRM-FUN-010 | Fluxo sequencial | Transição entre funis segue ordem: Leads → Pagamentos → Vistorias → Análise → Pós-Venda |

### 5.2 Regras por Funil

#### Funil Leads Recebidos
| Código | Regra | Validação |
|--------|-------|-----------|
| RN-FUN-LED-001 | Entrada obrigatória | Toda negociação inicia neste funil |
| RN-FUN-LED-002 | Coleta de dados | Para avançar de "Coleta de Dados", dados do veículo obrigatórios |
| RN-FUN-LED-003 | Cotação obrigatória | Para avançar para "Fechado", cotação deve estar vinculada |

#### Funil Pagamentos
| Código | Regra | Validação |
|--------|-------|-----------|
| RN-FUN-PAG-001 | Contrato obrigatório | Para entrar no funil, contrato deve estar gerado |
| RN-FUN-PAG-002 | Valor obrigatório | Valor do pagamento deve estar definido |
| RN-FUN-PAG-003 | Status banco | Status atualizado automaticamente via webhook do banco digital |

#### Funil Vistorias
| Código | Regra | Validação |
|--------|-------|-----------|
| RN-FUN-VIS-001 | Pagamento confirmado | Para entrar no funil, pagamento deve estar efetuado |
| RN-FUN-VIS-002 | Agendamento obrigatório | Para mover para "Vistoria Agendada", data/hora obrigatórios |
| RN-FUN-VIS-003 | Fotos obrigatórias | Vistoria só é concluída com fotos do VistorIA |
| RN-FUN-VIS-004 | Revistoria | Vistoria cancelada pode ser reaberta como revistoria |

#### Funil Análise de Cotações
| Código | Regra | Validação |
|--------|-------|-----------|
| RN-FUN-ANA-001 | Vistoria aprovada | Para entrar no funil, vistoria deve estar aprovada |
| RN-FUN-ANA-002 | Análise completa | Campos de análise obrigatórios antes de aprovar |
| RN-FUN-ANA-003 | Integração ERP | Ao aprovar, dados são enviados automaticamente ao ERP Top |

#### Funil Negociação Concretizada
| Código | Regra | Validação |
|--------|-------|-----------|
| RN-FUN-POS-001 | Cotação aprovada | Para entrar no funil, negociação deve estar aprovada |
| RN-FUN-POS-002 | Contrato enviado | Contrato deve ser enviado na triagem pós-venda |
| RN-FUN-POS-003 | Checklist completo | Todos os itens obrigatórios dos checklists devem estar marcados |
| RN-FUN-POS-004 | Conferência cadastro | Dados conferidos antes de avançar |
| RN-FUN-POS-005 | Finalização ERP | Ao finalizar, cadastro é concluído no ERP Top (SGA/SAV) |

---

## 6. Métricas de Sucesso

### 6.1 KPIs Gerais

| KPI | Meta | Descrição |
|-----|------|-----------|
| Taxa de Conversão Geral | > 25% | % de negociações fechadas (Lead → Finalizado) |
| Ticket Médio | R$ 1.500 | Valor médio por fechamento |
| Ciclo de Vendas Total | < 15 dias | Tempo médio lead → finalizado (todos os funis) |
| Negociações Ativas | 20-40 | Por consultor (soma de todos os funis) |
| Taxa de Follow-up | > 80% | Leads contatados no prazo |

### 6.2 KPIs por Funil

| Funil | KPI | Meta |
|-------|-----|------|
| **Leads Recebidos** | Taxa conversão para Pagamentos | > 40% |
| **Leads Recebidos** | Tempo médio no funil | < 5 dias |
| **Pagamentos** | Taxa de pagamento efetuado | > 85% |
| **Pagamentos** | Tempo médio até pagamento | < 3 dias |
| **Vistorias** | Taxa de aprovação | > 90% |
| **Vistorias** | Tempo agendamento → aprovação | < 2 dias |
| **Análise Cotações** | Taxa de aprovação | > 95% |
| **Análise Cotações** | Tempo médio análise | < 1 dia |
| **Negociação Concretizada** | Taxa de finalização | > 98% |
| **Negociação Concretizada** | Tempo médio finalização | < 2 dias |

---

## 7. Histórico de Alterações

| Data | Versão | Autor | Alteração |
|------|--------|-------|-----------|
| 21/01/2026 | 1.0 | Product Owner | Versão inicial |
| 21/01/2026 | 2.0 | Product Owner | Reestruturação completa para padrão DDD |
| 27/01/2026 | 2.1 | Product Owner | DDD: Incorporar FUN-020 a FUN-023 (ex-LEAD-013, 014, 016, 017). Total +20 SP |
| 27/01/2026 | 2.2 | Product Owner | DDD Completo: Criar FUN-002 a FUN-019 (18 novas histórias, +127 SP) |
| 28/01/2026 | 2.3 | Product Owner | Reestruturação seção 1.3: 5 funis personalizados com etapas e integrações específicas |
| 28/01/2026 | 3.0 | Product Owner | Revisão DDD completa: Agregados multi-funil, Value Objects expandidos, Eventos de domínio para integrações (VistorIA, Banco Digital, ERP Top), Regras por funil, 31 histórias totais |
| 28/01/2026 | 3.1 | Product Owner | Adicionada seção 1.5 Interface do Usuário (Kanban): estrutura de tela, estrutura do card, ações rápidas, funcionalidades de interação. Novos Value Objects: DadosVeiculo, CardVisual, StatusBadge, AcaoRapidaCard. Correção nomenclatura "Negociação Em Análise" |

---

**Versão**: 3.1  
**Data**: 28/01/2026  
**Responsável**: Product Owner - CRM  
**Tipo DDD**: Core Domain

## 8. Resumo de Story Points

| Categoria | Histórias | Story Points |
|-----------|-----------|--------------|
| Essenciais - Gestão Multi-Funil (FUN-001 a FUN-011) | 11 | 70 SP |
| Integrações por Funil (FUN-012 a FUN-017) | 6 | 39 SP |
| Importantes (FUN-018 a FUN-022) | 5 | 42 SP |
| Desejáveis (FUN-023 a FUN-027) | 5 | 34 SP |
| Movidos de Leads (FUN-028 a FUN-031) | 4 | 20 SP |
| **TOTAL CRM-Funil-Vendas** | **31** | **205 SP** |
