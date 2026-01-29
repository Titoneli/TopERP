# CRM-Motor-Regras (MTR) - Especificacao Tecnica

> **Modulo**: Motor de Regras Configuravel  
> **Tipo DDD**: Generic Subdomain / Shared Kernel  
> **Versao**: 2.0  
> **Data**: 29/01/2026  
> **Autor**: Product Owner

---

## 1. Visao Geral

### 1.1 Proposito

O Motor de Regras e um componente **generico e reutilizavel** que permite configurar formulas, condicoes e calculos de forma dinamica, sem necessidade de alteracao de codigo. Serve como **Shared Kernel** para multiplos modulos do CRM.

### 1.2 Novidades da Versao 2.0

| Recurso | Descricao |
|---------|-----------|
| **Data Providers** | Conexoes automaticas com fontes de dados (PLACA, BOLETO, META, etc.) |
| **DSL Textual** | Linguagem em portugues para definir regras |
| **Editor Visual** | Interface drag-and-drop para criar regras |
| **Agregacoes** | Funcoes COUNT, SUM, AVG, MIN, MAX sobre Data Providers |
| **Filtros Dinamicos** | Filtros com variaveis de contexto (@consultor_atual, etc.) |
| **JSON Schema v2.0** | Estrutura padronizada para definicao de regras |

### 1.3 Principio Arquitetural

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                         MOTOR DE REGRAS (MTR)                                       │
│                    Generic Subdomain / Shared Kernel                                │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│   ┌─────────────────────────────────────────────────────────────────────────────┐   │
│   │                        NUCLEO DO MOTOR                                      │   │
│   │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │   │
│   │  │  Variaveis  │  │  Formulas   │  │  Condicoes  │  │  Acoes      │         │   │
│   │  │  (Inputs)   │  │  (Calculos) │  │  (IF/THEN)  │  │  (Outputs)  │         │   │
│   │  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘         │   │
│   └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│   MODULOS CONSUMIDORES:                                                             │
│   ┌────────────────────────────────────────────────────────────────────────────┐    │
│   │  CRM-FIN    │ Comissoes, Residuais, Bonificacoes, PLR, SPIFF              │    │
│   │  CRM-COT    │ Regras de precificacao, descontos em cotacoes               │    │
│   │  CRM-POS    │ Bonificacoes pos-venda, rewards por NPS                     │    │
│   │  CRM-LEAD   │ Score de leads, priorizacao automatica                      │    │
│   │  CRM-FUN    │ Regras de avanco automatico no funil                        │    │
│   │  CRM-VIS    │ Regras de aprovacao de vistorias                            │    │
│   └────────────────────────────────────────────────────────────────────────────┘    │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### 1.3 Beneficios

| Beneficio | Descricao |
|-----------|-----------|
| **Reutilizacao** | Um unico motor serve todos os modulos |
| **Flexibilidade** | Regras configuraveis sem deploy |
| **Rastreabilidade** | Auditoria completa de cada calculo |
| **Escalabilidade** | Novos modulos consomem facilmente |
| **Governanca** | Versionamento e aprovacao de regras |

### 1.4 Arquitetura v2.0 - Data Providers

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                         ARQUITETURA MOTOR v2.0                                      │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│   ┌─────────────────────────────────────────────────────────────────────────────┐   │
│   │                          DATA PROVIDERS                                     │   │
│   │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐         │   │
│   │  │ PLACA  │ │ BOLETO │ │  META  │ │CONSULTR│ │  LEAD  │ │INTERAC │         │   │
│   │  └───┬────┘ └───┬────┘ └───┬────┘ └───┬────┘ └───┬────┘ └───┬────┘         │   │
│   │      │          │          │          │          │          │               │   │
│   │      └──────────┴──────────┴──────────┼──────────┴──────────┘               │   │
│   │                                       │                                     │   │
│   │                                       ▼                                     │   │
│   │                          ┌────────────────────┐                             │   │
│   │                          │   AGGREGATION      │                             │   │
│   │                          │     ENGINE         │                             │   │
│   │                          │  (COUNT, SUM, etc) │                             │   │
│   │                          └─────────┬──────────┘                             │   │
│   │                                    │                                        │   │
│   │                                    ▼                                        │   │
│   │   ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │   │
│   │   │  VARIAVEIS  │  │  FORMULAS   │  │  CONDICOES  │  │    ACOES    │        │   │
│   │   │   INPUT     │  │  CALCULOS   │  │   IF/THEN   │  │   OUTPUTS   │        │   │
│   │   │  AGREGACAO  │  │ EXPRESSOES  │  │  COMPOSTAS  │  │  CREDITAR   │        │   │
│   │   │   LOOKUP    │  │  FUNCOES    │  │  GRUPOS     │  │  NOTIFICAR  │        │   │
│   │   └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘        │   │
│   │                                                                             │   │
│   │                          ┌────────────────────┐                             │   │
│   │                          │   DSL / EDITOR     │                             │   │
│   │                          │     VISUAL         │                             │   │
│   │                          └────────────────────┘                             │   │
│   └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│   MODULOS CONSUMIDORES:                                                             │
│   ┌────────────────────────────────────────────────────────────────────────────┐    │
│   │  CRM-FIN    │ Comissoes, Residuais, Bonificacoes, PLR, SPIFF              │    │
│   │  CRM-COT    │ Regras de precificacao, descontos em cotacoes               │    │
│   │  CRM-POS    │ Bonificacoes pos-venda, rewards por NPS                     │    │
│   │  CRM-LEAD   │ Score de leads, priorizacao automatica                      │    │
│   │  CRM-FUN    │ Regras de avanco automatico no funil                        │    │
│   │  CRM-VIS    │ Regras de aprovacao de vistorias                            │    │
│   └────────────────────────────────────────────────────────────────────────────┘    │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Domain-Driven Design

### 2.1 Context Map

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                              CONTEXT MAP - MTR                                      │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│                        ┌─────────────────────┐                                      │
│                        │   MOTOR DE REGRAS   │                                      │
│                        │   (Shared Kernel)   │                                      │
│                        └──────────┬──────────┘                                      │
│                                   │                                                 │
│           ┌───────────────────────┼───────────────────────┐                         │
│           │                       │                       │                         │
│           ▼                       ▼                       ▼                         │
│   ┌───────────────┐       ┌───────────────┐       ┌───────────────┐                 │
│   │   CRM-FIN     │       │   CRM-COT     │       │   CRM-LEAD    │                 │
│   │  (Customer)   │       │  (Customer)   │       │  (Customer)   │                 │
│   └───────────────┘       └───────────────┘       └───────────────┘                 │
│                                                                                     │
│   Relacao: SHARED KERNEL                                                            │
│   - Modulos consumidores usam API do Motor                                          │
│   - Motor nao conhece detalhes dos consumidores                                     │
│   - Contratos bem definidos via interfaces                                          │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### 2.2 Agregados

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                              AGREGADOS DO MOTOR                                     │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│   REGRA (Aggregate Root)                                                            │
│   ├── id: UUID                                                                      │
│   ├── codigo: String (ex: REG-COM-001)                                              │
│   ├── nome: String                                                                  │
│   ├── descricao: String                                                             │
│   ├── tipo: TipoRegra (COMISSAO, DESCONTO, SCORE, BONUS, etc)                       │
│   ├── modulo_consumidor: String (FIN, COT, LEAD, etc)                               │
│   ├── status: StatusRegra (RASCUNHO, ATIVA, INATIVA, ARQUIVADA)                     │
│   ├── versao: Integer                                                               │
│   ├── vigencia_inicio: Date                                                         │
│   ├── vigencia_fim: Date (nullable)                                                 │
│   ├── variaveis: List<Variavel>                                                     │
│   ├── condicoes: List<Condicao>                                                     │
│   ├── formula: Formula                                                              │
│   └── acoes: List<Acao>                                                             │
│                                                                                     │
│   VARIAVEL (Entity)                                                                 │
│   ├── id: UUID                                                                      │
│   ├── codigo: String (ex: VALOR_VENDA, QTD_PLACAS)                                  │
│   ├── nome: String                                                                  │
│   ├── tipo_dado: TipoDado (DECIMAL, INTEGER, STRING, BOOLEAN, DATE)                 │
│   ├── origem: OrigemVariavel (INPUT, CALCULADA, SISTEMA)                            │
│   ├── valor_padrao: Any (nullable)                                                  │
│   └── validacoes: List<Validacao>                                                   │
│                                                                                     │
│   CONDICAO (Entity)                                                                 │
│   ├── id: UUID                                                                      │
│   ├── ordem: Integer                                                                │
│   ├── variavel: Variavel                                                            │
│   ├── operador: Operador (IGUAL, MAIOR, MENOR, ENTRE, CONTEM, etc)                  │
│   ├── valor_comparacao: Any                                                         │
│   ├── operador_logico: OperadorLogico (AND, OR)                                     │
│   └── grupo: Integer (para agrupamento de condicoes)                                │
│                                                                                     │
│   FORMULA (Value Object)                                                            │
│   ├── expressao: String (ex: "valor * percentual + bonus")                          │
│   ├── variaveis_utilizadas: List<String>                                            │
│   └── tipo_resultado: TipoDado                                                      │
│                                                                                     │
│   ACAO (Entity)                                                                     │
│   ├── id: UUID                                                                      │
│   ├── tipo: TipoAcao (CREDITAR, DEBITAR, NOTIFICAR, ATUALIZAR_STATUS)               │
│   ├── parametros: Map<String, Any>                                                  │
│   └── ordem: Integer                                                                │
│                                                                                     │
│   TEMPLATE (Aggregate Root)                                                         │
│   ├── id: UUID                                                                      │
│   ├── nome: String                                                                  │
│   ├── descricao: String                                                             │
│   ├── categoria: String                                                             │
│   ├── regra_base: Regra                                                             │
│   └── parametros_configuraveis: List<String>                                        │
│                                                                                     │
│   EXECUCAO (Aggregate Root)                                                         │
│   ├── id: UUID                                                                      │
│   ├── regra_id: UUID                                                                │
│   ├── regra_versao: Integer                                                         │
│   ├── timestamp: DateTime                                                           │
│   ├── inputs: Map<String, Any>                                                      │
│   ├── outputs: Map<String, Any>                                                     │
│   ├── resultado: Any                                                                │
│   ├── tempo_execucao_ms: Integer                                                    │
│   ├── usuario_id: UUID (nullable)                                                   │
│   └── contexto: Map<String, Any> (metadados)                                        │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### 2.3 Domain Events

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                             DOMAIN EVENTS                                           │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│   RegraCriadaEvent                                                                  │
│   ├── regra_id, codigo, tipo, modulo, criado_por, timestamp                         │
│                                                                                     │
│   RegraAtivadaEvent                                                                 │
│   ├── regra_id, versao, vigencia_inicio, ativado_por, timestamp                     │
│                                                                                     │
│   RegraDesativadaEvent                                                              │
│   ├── regra_id, motivo, desativado_por, timestamp                                   │
│                                                                                     │
│   RegraVersaonadaEvent                                                              │
│   ├── regra_id, versao_anterior, versao_nova, alteracoes, timestamp                 │
│                                                                                     │
│   RegraExecutadaEvent                                                               │
│   ├── execucao_id, regra_id, inputs, resultado, tempo_ms, timestamp                 │
│                                                                                     │
│   TemplateUtilizadoEvent                                                            │
│   ├── template_id, regra_criada_id, usuario, timestamp                              │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### 2.4 Enumeracoes

```
TipoRegra:
  - COMISSAO          # Calculo de comissao sobre vendas
  - RESIDUAL          # Calculo de residual sobre mensalidades
  - BONIFICACAO       # Bonus por meta atingida
  - PREMIACAO         # Campanhas especiais
  - SPIFF             # Incentivo pontual
  - PLR               # Participacao nos lucros
  - ACELERADOR        # Multiplicador progressivo
  - ESCALONADA        # Percentual variavel por faixa
  - OVERRIDE          # Comissao sobre equipe
  - SPLIT             # Divisao entre consultores
  - DESCONTO          # Regras de desconto
  - PRECIFICACAO      # Regras de preco
  - SCORE             # Pontuacao de leads
  - PRIORIZACAO       # Ordenacao automatica
  - APROVACAO         # Regras de workflow

StatusRegra:
  - RASCUNHO          # Em edicao, nao pode ser executada
  - PENDENTE_APROVACAO # Aguardando aprovacao
  - ATIVA             # Pode ser executada
  - INATIVA           # Desativada temporariamente
  - ARQUIVADA         # Historico, nao pode ser reativada

Operador:
  - IGUAL, DIFERENTE
  - MAIOR, MAIOR_IGUAL
  - MENOR, MENOR_IGUAL
  - ENTRE, NAO_ENTRE
  - CONTEM, NAO_CONTEM
  - COMECA_COM, TERMINA_COM
  - NULO, NAO_NULO
  - EM_LISTA, NAO_EM_LISTA

TipoDado:
  - DECIMAL, INTEGER, BOOLEAN
  - STRING, DATE, DATETIME
  - LISTA, OBJETO
```

---

## 3. Modelo de Dados

### 3.1 Diagrama ER

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                              MODELO DE DADOS                                        │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│   ┌────────────────────┐         ┌────────────────────┐                             │
│   │    mtr_regra       │         │   mtr_variavel     │                             │
│   ├────────────────────┤         ├────────────────────┤                             │
│   │ id              PK │◄───┐    │ id              PK │                             │
│   │ codigo             │    │    │ regra_id        FK │────────┐                    │
│   │ nome               │    │    │ codigo             │        │                    │
│   │ descricao          │    │    │ nome               │        │                    │
│   │ tipo               │    │    │ tipo_dado          │        │                    │
│   │ modulo_consumidor  │    │    │ origem             │        │                    │
│   │ status             │    │    │ valor_padrao       │        │                    │
│   │ versao             │    │    │ validacoes_json    │        │                    │
│   │ vigencia_inicio    │    │    └────────────────────┘        │                    │
│   │ vigencia_fim       │    │                                  │                    │
│   │ formula_expressao  │    │    ┌────────────────────┐        │                    │
│   │ criado_em          │    │    │   mtr_condicao     │        │                    │
│   │ criado_por         │    │    ├────────────────────┤        │                    │
│   │ atualizado_em      │    │    │ id              PK │        │                    │
│   │ atualizado_por     │    └────│ regra_id        FK │────────┤                    │
│   └────────────────────┘         │ variavel_id     FK │────────┘                    │
│            │                     │ ordem              │                             │
│            │                     │ operador           │                             │
│            │                     │ valor_comparacao   │                             │
│            │                     │ operador_logico    │                             │
│            │                     │ grupo              │                             │
│            │                     └────────────────────┘                             │
│            │                                                                        │
│            │         ┌────────────────────┐                                         │
│            │         │     mtr_acao       │                                         │
│            │         ├────────────────────┤                                         │
│            └────────►│ id              PK │                                         │
│                      │ regra_id        FK │                                         │
│                      │ tipo               │                                         │
│                      │ parametros_json    │                                         │
│                      │ ordem              │                                         │
│                      └────────────────────┘                                         │
│                                                                                     │
│   ┌────────────────────┐         ┌────────────────────┐                             │
│   │   mtr_template     │         │   mtr_execucao     │                             │
│   ├────────────────────┤         ├────────────────────┤                             │
│   │ id              PK │         │ id              PK │                             │
│   │ nome               │         │ regra_id        FK │                             │
│   │ descricao          │         │ regra_versao       │                             │
│   │ categoria          │         │ timestamp          │                             │
│   │ regra_base_json    │         │ inputs_json        │                             │
│   │ params_config_json │         │ outputs_json       │                             │
│   │ ativo              │         │ resultado          │                             │
│   └────────────────────┘         │ tempo_execucao_ms  │                             │
│                                  │ usuario_id         │                             │
│   ┌────────────────────┐         │ contexto_json      │                             │
│   │ mtr_regra_versao   │         └────────────────────┘                             │
│   ├────────────────────┤                                                            │
│   │ id              PK │                                                            │
│   │ regra_id        FK │                                                            │
│   │ versao             │                                                            │
│   │ snapshot_json      │                                                            │
│   │ alteracoes_json    │                                                            │
│   │ criado_em          │                                                            │
│   │ criado_por         │                                                            │
│   └────────────────────┘                                                            │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### 3.2 Scripts DDL

```sql
-- Schema: crm_motor_regras

CREATE TABLE mtr_regra (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(20) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    tipo VARCHAR(20) NOT NULL,
    modulo_consumidor VARCHAR(10) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'RASCUNHO',
    versao INTEGER NOT NULL DEFAULT 1,
    vigencia_inicio DATE,
    vigencia_fim DATE,
    formula_expressao TEXT,
    criado_em TIMESTAMP NOT NULL DEFAULT NOW(),
    criado_por UUID NOT NULL,
    atualizado_em TIMESTAMP,
    atualizado_por UUID,
    CONSTRAINT chk_tipo CHECK (tipo IN ('COMISSAO','RESIDUAL','BONIFICACAO','PREMIACAO','SPIFF','PLR','ACELERADOR','ESCALONADA','OVERRIDE','SPLIT','DESCONTO','PRECIFICACAO','SCORE','PRIORIZACAO','APROVACAO')),
    CONSTRAINT chk_status CHECK (status IN ('RASCUNHO','PENDENTE_APROVACAO','ATIVA','INATIVA','ARQUIVADA'))
);

CREATE TABLE mtr_variavel (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    regra_id UUID NOT NULL REFERENCES mtr_regra(id) ON DELETE CASCADE,
    codigo VARCHAR(50) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    tipo_dado VARCHAR(20) NOT NULL,
    origem VARCHAR(20) NOT NULL DEFAULT 'INPUT',
    valor_padrao TEXT,
    validacoes_json JSONB,
    CONSTRAINT chk_tipo_dado CHECK (tipo_dado IN ('DECIMAL','INTEGER','BOOLEAN','STRING','DATE','DATETIME','LISTA','OBJETO')),
    CONSTRAINT chk_origem CHECK (origem IN ('INPUT','CALCULADA','SISTEMA'))
);

CREATE TABLE mtr_condicao (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    regra_id UUID NOT NULL REFERENCES mtr_regra(id) ON DELETE CASCADE,
    variavel_id UUID REFERENCES mtr_variavel(id),
    ordem INTEGER NOT NULL DEFAULT 0,
    operador VARCHAR(20) NOT NULL,
    valor_comparacao TEXT,
    operador_logico VARCHAR(5) DEFAULT 'AND',
    grupo INTEGER DEFAULT 0,
    CONSTRAINT chk_operador CHECK (operador IN ('IGUAL','DIFERENTE','MAIOR','MAIOR_IGUAL','MENOR','MENOR_IGUAL','ENTRE','NAO_ENTRE','CONTEM','NAO_CONTEM','COMECA_COM','TERMINA_COM','NULO','NAO_NULO','EM_LISTA','NAO_EM_LISTA')),
    CONSTRAINT chk_logico CHECK (operador_logico IN ('AND','OR'))
);

CREATE TABLE mtr_acao (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    regra_id UUID NOT NULL REFERENCES mtr_regra(id) ON DELETE CASCADE,
    tipo VARCHAR(30) NOT NULL,
    parametros_json JSONB,
    ordem INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT chk_tipo_acao CHECK (tipo IN ('CREDITAR','DEBITAR','NOTIFICAR','ATUALIZAR_STATUS','CRIAR_TAREFA','ENVIAR_EMAIL','WEBHOOK'))
);

CREATE TABLE mtr_template (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    categoria VARCHAR(50),
    regra_base_json JSONB NOT NULL,
    params_config_json JSONB,
    ativo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE mtr_execucao (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    regra_id UUID NOT NULL REFERENCES mtr_regra(id),
    regra_versao INTEGER NOT NULL,
    timestamp TIMESTAMP NOT NULL DEFAULT NOW(),
    inputs_json JSONB NOT NULL,
    outputs_json JSONB,
    resultado TEXT,
    tempo_execucao_ms INTEGER,
    usuario_id UUID,
    contexto_json JSONB
);

CREATE TABLE mtr_regra_versao (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    regra_id UUID NOT NULL REFERENCES mtr_regra(id) ON DELETE CASCADE,
    versao INTEGER NOT NULL,
    snapshot_json JSONB NOT NULL,
    alteracoes_json JSONB,
    criado_em TIMESTAMP NOT NULL DEFAULT NOW(),
    criado_por UUID NOT NULL,
    UNIQUE(regra_id, versao)
);

-- Indices
CREATE INDEX idx_mtr_regra_tipo ON mtr_regra(tipo);
CREATE INDEX idx_mtr_regra_modulo ON mtr_regra(modulo_consumidor);
CREATE INDEX idx_mtr_regra_status ON mtr_regra(status);
CREATE INDEX idx_mtr_execucao_regra ON mtr_execucao(regra_id);
CREATE INDEX idx_mtr_execucao_timestamp ON mtr_execucao(timestamp);
```

---

## 4. API do Motor

### 4.1 Interface de Execucao

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                              API DO MOTOR                                           │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│   ENDPOINTS PRINCIPAIS:                                                             │
│                                                                                     │
│   POST /api/v1/motor/executar                                                       │
│   ├── Input: { regra_codigo, variaveis: { key: value }, contexto: { ... } }         │
│   └── Output: { resultado, detalhamento, execucao_id }                              │
│                                                                                     │
│   POST /api/v1/motor/simular                                                        │
│   ├── Input: { regra_codigo, variaveis: { key: value } }                            │
│   └── Output: { resultado_simulado, detalhamento, warnings }                        │
│                                                                                     │
│   POST /api/v1/motor/validar                                                        │
│   ├── Input: { regra: { ... definicao completa ... } }                              │
│   └── Output: { valido: boolean, erros: [], avisos: [] }                            │
│                                                                                     │
│   GET /api/v1/motor/regras?modulo={modulo}&tipo={tipo}&status=ATIVA                 │
│   └── Output: { regras: [ ... ] }                                                   │
│                                                                                     │
│   GET /api/v1/motor/regras/{codigo}/historico                                       │
│   └── Output: { versoes: [ ... ] }                                                  │
│                                                                                     │
│   GET /api/v1/motor/execucoes?regra_id={id}&de={date}&ate={date}                    │
│   └── Output: { execucoes: [ ... ], total, paginacao }                              │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### 4.2 Exemplo de Uso (CRM-FIN)

```json
// Requisicao: Calcular comissao de uma venda
POST /api/v1/motor/executar
{
  "regra_codigo": "REG-COM-PREMIUM-001",
  "variaveis": {
    "VALOR_VENDA": 500.00,
    "TIPO_PLANO": "PREMIUM",
    "QTD_VENDAS_MES": 15,
    "META_MES": 10,
    "SENIORIDADE_MESES": 24
  },
  "contexto": {
    "venda_id": "uuid-da-venda",
    "consultor_id": "uuid-do-consultor",
    "modulo": "CRM-FIN"
  }
}

// Resposta
{
  "resultado": 72.00,
  "detalhamento": {
    "comissao_base": "500.00 × 8% = 40.00",
    "bonus_plano": "10.00 (PREMIUM)",
    "acelerador": "150% meta → 1.2x",
    "calculo_final": "(40.00 + 10.00) × 1.2 = 60.00",
    "bonus_senioridade": "12.00 (24 meses)"
  },
  "execucao_id": "uuid-da-execucao",
  "regra_versao": 3,
  "tempo_ms": 12
}
```

---

## 5. User Stories

### 5.1 Resumo v2.0

| ID | Historia | Prioridade | SP |
|----|----------|------------|-----|
| US-CRM-MTR-001 | Arquitetura de Data Providers e Definicao de Regras | Essencial | 55 |
| US-CRM-MTR-002 | Execucao do Motor e Acoes Configuraveis | Essencial | 55 |
| US-CRM-MTR-003 | DSL Textual e Templates Pre-configurados | Importante | 34 |
| US-CRM-MTR-004 | Editor Visual Low-Code | Desejavel | 55 |
| US-CRM-MTR-005 | Simulacao, Teste e Debug de Regras | Importante | 34 |
| US-CRM-MTR-006 | Versionamento, Auditoria e Performance | Essencial | 34 |
| **TOTAL** | | | **267 SP** |

### 5.2 Detalhamento por Historia

Ver arquivos individuais:
- [US-CRM-MTR-001.md](US-CRM-MTR-001.md) - Data Providers, JSON Schema v2.0
- [US-CRM-MTR-002.md](US-CRM-MTR-002.md) - Motor de execucao, acoes
- [US-CRM-MTR-003.md](US-CRM-MTR-003.md) - DSL em portugues, templates
- [US-CRM-MTR-004.md](US-CRM-MTR-004.md) - Editor visual drag-and-drop
- [US-CRM-MTR-005.md](US-CRM-MTR-005.md) - Simulador, debug passo-a-passo
- [US-CRM-MTR-006.md](US-CRM-MTR-006.md) - Versionamento, auditoria, cache

### 5.3 Documentacao Adicional

| Documento | Descricao |
|-----------|-----------|
| [ESPECIFICACAO-DSL.md](ESPECIFICACAO-DSL.md) | Sintaxe completa da DSL em portugues |
| [EXEMPLOS-REGRAS-COMPLEXAS.md](EXEMPLOS-REGRAS-COMPLEXAS.md) | 8 exemplos praticos detalhados |
| [DDL-MOTOR-REGRAS-V2.sql](DDL-MOTOR-REGRAS-V2.sql) | Estrutura completa do banco de dados |
| [visao-produto-crm-mtr.md](visao-produto-crm-mtr.md) | Documento acessivel para usuarios de negocio |
- [US-CRM-MTR-002.md](US-CRM-MTR-002.md)
- [US-CRM-MTR-003.md](US-CRM-MTR-003.md)
- [US-CRM-MTR-004.md](US-CRM-MTR-004.md)
- [US-CRM-MTR-005.md](US-CRM-MTR-005.md)
- [US-CRM-MTR-006.md](US-CRM-MTR-006.md)

---

## 6. Regras de Negocio

| Codigo | Regra | Validacao |
|--------|-------|-----------|
| RN-MTR-001 | Regra ativa unica por codigo | Apenas uma versao ativa por vez |
| RN-MTR-002 | Versionamento obrigatorio | Alteracao em regra ativa cria nova versao |
| RN-MTR-003 | Aprovacao para ativar | Regras precisam de aprovacao antes de ativar |
| RN-MTR-004 | Vigencia obrigatoria | Regra ativa deve ter data de inicio |
| RN-MTR-005 | Formula valida | Expressao deve ser sintaticamente correta |
| RN-MTR-006 | Variaveis declaradas | Formula so pode usar variaveis declaradas |
| RN-MTR-007 | Teste antes de ativar | Regra deve passar em simulacao antes de ativar |
| RN-MTR-008 | Auditoria completa | Toda execucao deve ser registrada |
| RN-MTR-009 | Imutabilidade | Regra executada nao pode ser alterada, apenas nova versao |
| RN-MTR-010 | Rollback permitido | Pode reativar versao anterior se necessario |

---

## 7. Dependencias

### 7.1 Modulos que Consomem MTR

| Modulo | Tipo de Regra | Status |
|--------|---------------|--------|
| CRM-FIN | COMISSAO, RESIDUAL, BONIFICACAO, SPIFF, PLR, OVERRIDE, SPLIT | Planejado |
| CRM-COT | DESCONTO, PRECIFICACAO | Futuro |
| CRM-LEAD | SCORE, PRIORIZACAO | Futuro |
| CRM-FUN | APROVACAO | Futuro |
| CRM-POS | BONIFICACAO | Futuro |

### 7.2 Dependencias Externas

- PostgreSQL 16+ (JSONB, gen_random_uuid)
- Parser de expressoes matematicas
- Sistema de notificacoes (para acoes)

---

## 8. Historico de Alteracoes

| Versao | Data | Autor | Alteracao |
|--------|------|-------|-----------|
| 1.0 | 29/01/2026 | PO | Criacao inicial do modulo |

---

## 9. Referencias

- [visao-produto-crm-mtr.md](visao-produto-crm-mtr.md) - Documento de visao acessivel
- [Product Backlog](../../backlog/product-backlog.md)
- [Context Map DDD](../../ddd/context-map.md)
- SplitC - Inspiracao para regras avancadas
