# US-CRM-LEAD-012 — Cadastrar Lead Manualmente

## História de Usuário

**Como** consultor de vendas,  
**Quero** cadastrar leads manualmente no sistema,  
**Para** registrar contatos de indicações, eventos e prospecção ativa.

## Prioridade

Essencial

## Estimativa

8 SP

---

## Contexto DDD

### Bounded Context
- **Contexto**: Gestão de Leads (Lead Management)
- **Módulo**: CRM-Leads

### Aggregate Root
- **Lead** (entidade principal)

### Domain Events
| Evento | Trigger | Assinantes |
|--------|---------|------------|
| `LeadCreatedManually` | Lead cadastrado | Analytics, Notificações |
| `LeadAssignedOnCreation` | Lead atribuído ao criador | Fila de Atendimento |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Cadastro Manual** | Inclusão de lead via formulário interno |
| **Venda Própria** | Lead cadastrado pelo próprio consultor |
| **Indicação** | Lead vindo de recomendação de cliente |
| **Prospecção Ativa** | Busca ativa de novos clientes |

---

## Contexto de Negócio

Nem todos os leads chegam por canais digitais. Consultores recebem indicações, participam de eventos, fazem prospecção em campo. O cadastro manual permite registrar esses leads no CRM para acompanhamento. A ideia aqui é termos uma forma de cadastro no estilo landing page, que seja simples e intuitiva para o cadastro rápido de um lead.

### Origens de Cadastro Manual

| Origem | Código | Cenário |
|--------|--------|---------|
| Venda Própria | 10 | Consultor cadastra seu próprio lead |
| Indicação | 6 | Cliente existente indicou |
| Evento/Feira | 11 | Lead captado em evento presencial |
| Prospecção | 10 | Contato frio identificado |
| Telefone | 10 | Lead ligou pedindo informação |

---

## Fluxo de Cadastro Manual

```
┌─────────────────────────────────────────────────────────────────┐
│                 FLUXO DE CADASTRO MANUAL                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌───────────────┐                                              │
│  │  CONSULTOR    │                                              │
│  │  Click "+Novo"│                                              │
│  └───────┬───────┘                                              │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              FORMULÁRIO DE CADASTRO                       │  │
│  │                                                           │  │
│  │  ┌─────────────────────────────────────────────────────┐  │  │
│  │  │  DADOS OBRIGATÓRIOS                                 │  │  │
│  │  │  • Nome Completo                                    │  │  │
│  │  │  • Telefone (com DDD)                               │  │  │
│  │  │  • Origem do Lead                                   │  │  │
│  │  └─────────────────────────────────────────────────────┘  │  │
│  │                                                           │  │
│  │  ┌─────────────────────────────────────────────────────┐  │  │
│  │  │  DADOS OPCIONAIS                                    │  │  │
│  │  │  • E-mail                                           │  │  │
│  │  │  • Veículo (Marca/Modelo/Ano)                       │  │  │
│  │  │  • Localização (UF/Cidade)                          │  │  │
│  │  │  • Observações                                      │  │  │
│  │  └─────────────────────────────────────────────────────┘  │  │
│  │                                                           │  │
│  └───────────────────────────────────────────────────────────┘  │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              VALIDAÇÕES                                   │  │
│  │  • Telefone não é de consultor ativo                      │  │
│  │  • Formato de telefone válido                             │  │
│  │  • E-mail válido (se preenchido)                          │  │
│  └───────────────────────────────────────────────────────────┘  │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────┐                                              │
│  │  LEAD CRIADO  │                                              │
│  │  Status: NOVO │                                              │
│  │  Atribuído ao │                                              │
│  │   consultor   │                                              │
│  └───────────────┘                                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Inputs e Outputs

### Campos de Entrada

#### Obrigatórios

| Campo | Tipo | Validação |
|-------|------|-----------|
| nome | text | Mín. 3 caracteres |
| telefone | tel | Formato BR, DDD obrigatório |
| cod_origem | select | Código da origem (grava no campo `dom_ind_origem` da tabela `crm_negociacao`) |

#### Opcionais

| Campo | Tipo | Validação |
|-------|------|-----------|
| email | email | Formato válido |
| marca | select | Lista de marcas |
| modelo | select | Filtrado por marca |
| ano_modelo | select | Últimos 30 anos |
| tipo_uso | select | Passeio/Comercial |
| uf | select | UFs brasileiras |
| cidade | select | Filtrada por UF |
| observacoes | textarea | Máx. 1000 caracteres |

### Output

| Campo | Valor |
|-------|-------|
| status | NOVO |
| etapa_abandono | null (cadastro completo) |
| cod_colaborador | ID do consultor que cadastrou |
| data_criacao | Timestamp atual |
| criado_por | ID do usuário logado |

---

## Critérios de Aceitação

### Cenário 1 — Cadastro com dados mínimos
- **Dado que** clico em "+ Novo Lead"
- **Quando** preencho nome, telefone e origem
- **E** clico em "Salvar"
- **Então** o lead é criado com status `NOVO`
- **E** é atribuído automaticamente a mim
- **E** evento `LeadCreatedManually` é disparado

### Cenário 2 — Cadastro completo
- **Dado que** preencho todos os campos do formulário
- **Quando** clico em "Salvar"
- **Então** o lead é criado com todos os dados
- **E** já possui informações de veículo e localização

### Cenário 3 — Telefone de consultor bloqueado
- **Dado que** informo telefone de um consultor ativo
- **Quando** tento salvar
- **Então** recebo erro: "Este telefone pertence a um consultor ativo"
- **E** o lead não é criado

### Cenário 4 — Telefone duplicado
- **Dado que** informo telefone de lead existente
- **Quando** salvo o formulário
- **Então** o sistema exibe aviso: "Telefone já cadastrado. Deseja criar mesmo assim?"
- **E** posso confirmar ou cancelar

### Cenário 5 — Cadastro de indicação
- **Dado que** seleciono origem "Indicação"
- **Quando** o formulário é exibido
- **Então** aparece campo adicional "Quem indicou" (opcional Indicador/Afiliado)
- **E** posso vincular a um associado existente

### Cenário 6 — Extração de DDD
- **Dado que** informo telefone (11) 99999-8888
- **Quando** o lead é criado
- **Então** o campo ddd_telefone é preenchido com "11"

### Cenário 7 — Redirecionar após cadastro
- **Dado que** salvei um lead com sucesso
- **Quando** a confirmação é exibida
- **Então** tenho opção de "Ver Lead" ou "Cadastrar Outro"

### Cenário 8 — Gestor cadastra para consultor
- **Dado que** sou gestor comercial
- **Quando** cadastro um lead manualmente
- **Então** posso selecionar o consultor para atribuição
- **E** não sou obrigado a atribuir a mim mesmo

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Campos obrigatórios: nome, telefone, origem |
| RN-002 | Lead manual é atribuído ao consultor que cadastrou |
| RN-003 | Gestor pode atribuir a outro consultor |
| RN-004 | Telefone de consultor ativo é bloqueado |
| RN-005 | Telefone duplicado gera aviso, mas não bloqueia |
| RN-006 | DDD é extraído automaticamente |
| RN-007 | Status inicial: NOVO |
| RN-008 | etapa_abandono fica null (não veio de formulário web) |
| RN-009 | cod_origem padrão: 10 (VENDA_PROPRIA) |
| RN-010 | Origem "Indicação" habilita campo de referência |

---

## Ações Possíveis

| Ação | Trigger | Resultado |
|------|---------|-----------|
| Novo Lead | Click "+ Novo Lead" | Abre formulário |
| Salvar | Click "Salvar" | Cria lead |
| Salvar e Novo | Click "Salvar e Novo" | Cria e abre form vazio |
| Cancelar | Click "Cancelar" | Fecha sem salvar |
| Buscar Modelo | Seleção de marca | Carrega modelos |
| Buscar Cidade | Seleção de UF | Carrega cidades |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────┐
│  ➕ NOVO LEAD                                        [X]        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  📋 DADOS DE CONTATO *                                          │
│                                                                 │
│  Nome Completo *                                                │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ João da Silva                                           │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  Telefone *                        E-mail                       │
│  ┌──────────────────────────┐     ┌──────────────────────────┐  │
│  │ (11) 99999-8888          │     │ joao@email.com           │  │
│  └──────────────────────────┘     └──────────────────────────┘  │
│                                                                 │
│  Origem do Lead *                                               │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ ▼ Venda Própria (Prospecção)                            │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  🚗 DADOS DO VEÍCULO (Opcional)                                 │
│                                                                 │
│  Marca                 Modelo                  Ano              │
│  ┌──────────────┐     ┌──────────────┐        ┌──────────┐      │
│  │ ▼ Fiat       │     │ ▼ Strada     │        │ ▼ 2023   │      │
│  └──────────────┘     └──────────────┘        └──────────┘      │
│                                                                 │
│  Tipo de Uso                                                    │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ ▼ Passeio                                               │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  📍 LOCALIZAÇÃO (Opcional)                                      │
│                                                                 │
│  Estado (UF)                       Cidade                       │
│  ┌──────────────────────────┐     ┌──────────────────────────┐  │
│  │ ▼ São Paulo              │     │ ▼ São Paulo              │  │
│  └──────────────────────────┘     └──────────────────────────┘  │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  📝 OBSERVAÇÕES                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ Cliente conheceu a TopBrasil por indicação do amigo     │    │
│  │ Carlos. Interessado em plano completo para Strada.      │    │
│  │                                                         │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│                    [Cancelar]  [Salvar e Novo]  [Salvar]        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 25/01/2026 | 1.0 | PO | Criação inicial com DDD |
| 27/01/2026 | 1.1 | PO | Padronização DDD: cod_origem grava no campo dom_ind_origem da tabela crm_negociacao |

---

**Identificador**: US-CRM-LEAD-012  
**Módulo**: CRM-Leads  
**Fase**: 4 - Gestão de Leads  
**Status**: ✅ Pronto  
**Versão**: 1.1
