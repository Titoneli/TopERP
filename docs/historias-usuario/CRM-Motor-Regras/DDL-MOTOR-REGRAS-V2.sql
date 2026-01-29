# DDL Completo - Motor de Regras v2.0

> **Documento**: Scripts DDL para PostgreSQL 16+  
> **Versao**: 2.0  
> **Data**: 29/01/2026  
> **Autor**: Product Owner

---

## 1. Visao Geral da Arquitetura

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                       MODELO DE DADOS - MOTOR DE REGRAS v2.0                    │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐    │
│  │                        NUCLEO DO MOTOR                                  │    │
│  │                                                                         │    │
│  │  ┌────────────────┐      ┌────────────────┐      ┌────────────────┐    │    │
│  │  │ mtr_regra_v2   │─────►│ mtr_variavel   │      │ mtr_template   │    │    │
│  │  │ (Definicao)    │      │ (Inputs/Calc)  │      │ (Modelos)      │    │    │
│  │  └───────┬────────┘      └────────────────┘      └────────────────┘    │    │
│  │          │                                                             │    │
│  │          ├──────────────────────────────────────────────────┐          │    │
│  │          │                                                  │          │    │
│  │          ▼                                                  ▼          │    │
│  │  ┌────────────────┐      ┌────────────────┐      ┌────────────────┐    │    │
│  │  │ mtr_condicao   │      │ mtr_acao       │      │ mtr_versao     │    │    │
│  │  │ (When/If)      │      │ (Then/Do)      │      │ (Historico)    │    │    │
│  │  └────────────────┘      └────────────────┘      └────────────────┘    │    │
│  │                                                                         │    │
│  └─────────────────────────────────────────────────────────────────────────┘    │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐    │
│  │                       EXECUCAO E AUDITORIA                              │    │
│  │                                                                         │    │
│  │  ┌────────────────┐      ┌────────────────┐      ┌────────────────┐    │    │
│  │  │ mtr_execucao   │      │ mtr_execucao   │      │ mtr_simulacao  │    │    │
│  │  │ (Particao 1)   │      │ (Particao N)   │      │ (Testes)       │    │    │
│  │  └────────────────┘      └────────────────┘      └────────────────┘    │    │
│  │                                                                         │    │
│  └─────────────────────────────────────────────────────────────────────────┘    │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐    │
│  │                       DATA PROVIDERS                                    │    │
│  │                                                                         │    │
│  │  ┌────────────────┐      ┌────────────────┐      ┌────────────────┐    │    │
│  │  │ mtr_provider   │      │ mtr_provider   │      │ mtr_tabela_aux │    │    │
│  │  │ (Configuracao) │      │ _campo         │      │ (Lookups)      │    │    │
│  │  └────────────────┘      └────────────────┘      └────────────────┘    │    │
│  │                                                                         │    │
│  └─────────────────────────────────────────────────────────────────────────┘    │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Schema e Extensoes

```sql
-- ============================================================================
-- MOTOR DE REGRAS v2.0 - DDL COMPLETO
-- PostgreSQL 16+
-- ============================================================================

-- Criar schema dedicado
CREATE SCHEMA IF NOT EXISTS mtr;

-- Extensoes necessarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Comentario do schema
COMMENT ON SCHEMA mtr IS 'Motor de Regras v2.0 - Shared Kernel para calculo dinamico de regras de negocio';
```

---

## 3. Tipos Enumerados

```sql
-- ============================================================================
-- ENUMERACOES
-- ============================================================================

-- Categoria da regra
CREATE TYPE mtr.categoria_regra AS ENUM (
    'COMISSAO',
    'RESIDUAL', 
    'BONIFICACAO',
    'PREMIACAO',
    'SPIFF',
    'PLR',
    'ACELERADOR',
    'ESCALONADA',
    'OVERRIDE',
    'SPLIT',
    'DESCONTO',
    'PRECIFICACAO',
    'SCORE',
    'PRIORIZACAO',
    'APROVACAO',
    'COMPOSTA'
);

-- Status da regra
CREATE TYPE mtr.status_regra AS ENUM (
    'RASCUNHO',
    'PENDENTE_APROVACAO',
    'ATIVA',
    'INATIVA',
    'ARQUIVADA'
);

-- Escopo de aplicacao
CREATE TYPE mtr.escopo_tipo AS ENUM (
    'GLOBAL',
    'CONSULTOR',
    'EQUIPE',
    'FILIAL',
    'REGIAO'
);

-- Tipo de variavel
CREATE TYPE mtr.tipo_variavel AS ENUM (
    'INPUT',
    'CONSTANTE',
    'AGREGACAO',
    'FORMULA',
    'LOOKUP',
    'CONTEXTO'
);

-- Tipo de dado
CREATE TYPE mtr.tipo_dado AS ENUM (
    'DECIMAL',
    'INTEGER',
    'BOOLEAN',
    'STRING',
    'DATE',
    'DATETIME',
    'UUID',
    'LISTA',
    'OBJETO'
);

-- Operadores de comparacao
CREATE TYPE mtr.operador AS ENUM (
    'IGUAL',
    'DIFERENTE',
    'MAIOR',
    'MAIOR_IGUAL',
    'MENOR',
    'MENOR_IGUAL',
    'ENTRE',
    'NAO_ENTRE',
    'EM_LISTA',
    'NAO_EM_LISTA',
    'CONTEM',
    'NAO_CONTEM',
    'COMECA_COM',
    'TERMINA_COM',
    'COMO',
    'NULO',
    'NAO_NULO'
);

-- Operador logico
CREATE TYPE mtr.operador_logico AS ENUM (
    'AND',
    'OR'
);

-- Funcao de agregacao
CREATE TYPE mtr.funcao_agregacao AS ENUM (
    'COUNT',
    'SUM',
    'AVG',
    'MIN',
    'MAX',
    'FIRST',
    'LAST',
    'MODE',
    'CUSTOM'
);

-- Tipo de acao
CREATE TYPE mtr.tipo_acao AS ENUM (
    'ADICIONAR_VALOR',
    'SUBTRAIR_VALOR',
    'ATUALIZAR_CAMPO',
    'NOTIFICAR',
    'CRIAR_TAREFA',
    'ENVIAR_EMAIL',
    'WEBHOOK',
    'RETORNAR_VALOR'
);

-- Destino de credito
CREATE TYPE mtr.destino_credito AS ENUM (
    'COMISSAO',
    'BONUS',
    'RESIDUAL',
    'PREMIACAO',
    'OVERRIDE',
    'SPIFF',
    'PLR',
    'DESCONTO'
);

-- Tipo de provider
CREATE TYPE mtr.tipo_provider AS ENUM (
    'TABLE',
    'VIEW',
    'API',
    'FORMULA'
);
```

---

## 4. Tabelas de Configuracao (Data Providers)

```sql
-- ============================================================================
-- DATA PROVIDERS - Fontes de dados para variaveis
-- ============================================================================

-- Configuracao de providers disponiveis
CREATE TABLE mtr.data_provider (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(30) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    tipo mtr.tipo_provider NOT NULL DEFAULT 'VIEW',
    fonte VARCHAR(200) NOT NULL,
    schema_name VARCHAR(63) DEFAULT 'public',
    
    -- Cache e performance
    cache_ttl_segundos INTEGER DEFAULT 0,
    max_registros INTEGER DEFAULT 10000,
    
    -- Metadados
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE mtr.data_provider IS 'Registro de fontes de dados disponiveis para o motor de regras';

-- Campos disponiveis por provider
CREATE TABLE mtr.data_provider_campo (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    provider_id UUID NOT NULL REFERENCES mtr.data_provider(id) ON DELETE CASCADE,
    codigo VARCHAR(50) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    tipo_dado mtr.tipo_dado NOT NULL,
    nullable BOOLEAN DEFAULT true,
    valor_padrao TEXT,
    
    UNIQUE(provider_id, codigo)
);

COMMENT ON TABLE mtr.data_provider_campo IS 'Campos disponiveis em cada data provider';

-- Tabelas auxiliares para lookups
CREATE TABLE mtr.tabela_auxiliar (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(50) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    definicao JSONB NOT NULL,
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    created_by UUID NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE mtr.tabela_auxiliar IS 'Tabelas auxiliares para lookups em regras (faixas, multiplicadores, etc)';
```

---

## 5. Tabelas de Definicao de Regras

```sql
-- ============================================================================
-- REGRAS - Definicao principal
-- ============================================================================

-- Tabela principal de regras
CREATE TABLE mtr.regra (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(30) UNIQUE NOT NULL,
    nome VARCHAR(150) NOT NULL,
    descricao TEXT,
    categoria mtr.categoria_regra NOT NULL,
    
    -- Escopo de aplicacao
    escopo_tipo mtr.escopo_tipo NOT NULL DEFAULT 'GLOBAL',
    escopo_ids UUID[],
    
    -- Vigencia
    vigencia_inicio DATE NOT NULL,
    vigencia_fim DATE,
    
    -- Status e versionamento
    status mtr.status_regra NOT NULL DEFAULT 'RASCUNHO',
    versao INTEGER NOT NULL DEFAULT 1,
    
    -- Prioridade (menor = maior prioridade)
    prioridade INTEGER DEFAULT 100,
    
    -- Definicao completa em JSON (schema v2.0)
    definicao JSONB NOT NULL,
    
    -- DSL textual (opcional, para visualizacao)
    dsl_texto TEXT,
    
    -- Metadados de aprovacao
    aprovado_por UUID,
    aprovado_em TIMESTAMPTZ,
    
    -- Auditoria
    created_by UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_by UUID,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Constraints
    CONSTRAINT chk_vigencia CHECK (vigencia_fim IS NULL OR vigencia_fim >= vigencia_inicio),
    CONSTRAINT chk_versao CHECK (versao > 0),
    CONSTRAINT chk_prioridade CHECK (prioridade BETWEEN 1 AND 1000)
);

COMMENT ON TABLE mtr.regra IS 'Definicao principal de regras do motor';

-- Variaveis da regra (desnormalizado para consultas rapidas)
CREATE TABLE mtr.regra_variavel (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    regra_id UUID NOT NULL REFERENCES mtr.regra(id) ON DELETE CASCADE,
    codigo VARCHAR(50) NOT NULL,
    nome VARCHAR(100),
    descricao TEXT,
    tipo mtr.tipo_variavel NOT NULL,
    tipo_dado mtr.tipo_dado NOT NULL,
    
    -- Configuracao especifica por tipo
    config JSONB NOT NULL,
    
    -- Ordem de avaliacao
    ordem INTEGER NOT NULL DEFAULT 0,
    
    UNIQUE(regra_id, codigo)
);

COMMENT ON TABLE mtr.regra_variavel IS 'Variaveis declaradas em uma regra';

-- Condicoes da regra
CREATE TABLE mtr.regra_condicao (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    regra_id UUID NOT NULL REFERENCES mtr.regra(id) ON DELETE CASCADE,
    
    -- Estrutura da condicao
    variavel_codigo VARCHAR(50),
    operador mtr.operador NOT NULL,
    valor_comparacao JSONB,
    
    -- Agrupamento e logica
    grupo INTEGER DEFAULT 0,
    operador_logico mtr.operador_logico DEFAULT 'AND',
    ordem INTEGER NOT NULL DEFAULT 0
);

COMMENT ON TABLE mtr.regra_condicao IS 'Condicoes (WHEN) de uma regra';

-- Acoes da regra
CREATE TABLE mtr.regra_acao (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    regra_id UUID NOT NULL REFERENCES mtr.regra(id) ON DELETE CASCADE,
    
    tipo mtr.tipo_acao NOT NULL,
    
    -- Condicao especifica da acao (opcional)
    condicao JSONB,
    
    -- Configuracao da acao
    config JSONB NOT NULL,
    
    ordem INTEGER NOT NULL DEFAULT 0
);

COMMENT ON TABLE mtr.regra_acao IS 'Acoes (THEN) de uma regra';
```

---

## 6. Tabelas de Templates

```sql
-- ============================================================================
-- TEMPLATES - Modelos pre-configurados
-- ============================================================================

CREATE TABLE mtr.template (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(30) UNIQUE NOT NULL,
    nome VARCHAR(150) NOT NULL,
    descricao TEXT,
    categoria mtr.categoria_regra NOT NULL,
    
    -- Definicao base do template
    definicao_base JSONB NOT NULL,
    
    -- Parametros configuraveis
    parametros JSONB NOT NULL DEFAULT '[]',
    
    -- Metadados
    uso_count INTEGER DEFAULT 0,
    ativo BOOLEAN DEFAULT true,
    created_by UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE mtr.template IS 'Templates pre-configurados para criacao rapida de regras';

-- Registro de uso de templates
CREATE TABLE mtr.template_uso (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    template_id UUID NOT NULL REFERENCES mtr.template(id),
    regra_id UUID NOT NULL REFERENCES mtr.regra(id),
    parametros_utilizados JSONB,
    created_by UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE mtr.template_uso IS 'Registro de regras criadas a partir de templates';
```

---

## 7. Tabelas de Versionamento

```sql
-- ============================================================================
-- VERSIONAMENTO - Historico de alteracoes
-- ============================================================================

CREATE TABLE mtr.regra_versao (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    regra_id UUID NOT NULL REFERENCES mtr.regra(id) ON DELETE CASCADE,
    versao INTEGER NOT NULL,
    
    -- Snapshot completo da regra nesta versao
    snapshot JSONB NOT NULL,
    
    -- Diff em relacao a versao anterior
    alteracoes JSONB,
    
    -- Motivo da alteracao
    motivo TEXT,
    
    -- Auditoria
    created_by UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(regra_id, versao)
);

COMMENT ON TABLE mtr.regra_versao IS 'Historico de versoes de cada regra';
```

---

## 8. Tabelas de Execucao (Particionadas)

```sql
-- ============================================================================
-- EXECUCAO - Registro de execucoes (particionado por mes)
-- ============================================================================

CREATE TABLE mtr.execucao (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    regra_id UUID NOT NULL,
    regra_codigo VARCHAR(30) NOT NULL,
    regra_versao INTEGER NOT NULL,
    
    -- Timestamp de execucao (chave de particao)
    executado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    -- Contexto da execucao
    contexto JSONB NOT NULL,
    
    -- Variaveis de entrada
    inputs JSONB NOT NULL,
    
    -- Variaveis calculadas
    variaveis_calculadas JSONB,
    
    -- Resultado
    condicao_atendida BOOLEAN NOT NULL,
    resultado JSONB,
    
    -- Performance
    tempo_execucao_ms INTEGER,
    
    -- Usuario/Sistema que executou
    executado_por UUID,
    
    PRIMARY KEY (id, executado_em)
) PARTITION BY RANGE (executado_em);

COMMENT ON TABLE mtr.execucao IS 'Log de execucoes do motor (particionado por mes)';

-- Criar particoes para 2026
CREATE TABLE mtr.execucao_2026_01 PARTITION OF mtr.execucao
    FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');
CREATE TABLE mtr.execucao_2026_02 PARTITION OF mtr.execucao
    FOR VALUES FROM ('2026-02-01') TO ('2026-03-01');
CREATE TABLE mtr.execucao_2026_03 PARTITION OF mtr.execucao
    FOR VALUES FROM ('2026-03-01') TO ('2026-04-01');
CREATE TABLE mtr.execucao_2026_04 PARTITION OF mtr.execucao
    FOR VALUES FROM ('2026-04-01') TO ('2026-05-01');
CREATE TABLE mtr.execucao_2026_05 PARTITION OF mtr.execucao
    FOR VALUES FROM ('2026-05-01') TO ('2026-06-01');
CREATE TABLE mtr.execucao_2026_06 PARTITION OF mtr.execucao
    FOR VALUES FROM ('2026-06-01') TO ('2026-07-01');
CREATE TABLE mtr.execucao_2026_07 PARTITION OF mtr.execucao
    FOR VALUES FROM ('2026-07-01') TO ('2026-08-01');
CREATE TABLE mtr.execucao_2026_08 PARTITION OF mtr.execucao
    FOR VALUES FROM ('2026-08-01') TO ('2026-09-01');
CREATE TABLE mtr.execucao_2026_09 PARTITION OF mtr.execucao
    FOR VALUES FROM ('2026-09-01') TO ('2026-10-01');
CREATE TABLE mtr.execucao_2026_10 PARTITION OF mtr.execucao
    FOR VALUES FROM ('2026-10-01') TO ('2026-11-01');
CREATE TABLE mtr.execucao_2026_11 PARTITION OF mtr.execucao
    FOR VALUES FROM ('2026-11-01') TO ('2026-12-01');
CREATE TABLE mtr.execucao_2026_12 PARTITION OF mtr.execucao
    FOR VALUES FROM ('2026-12-01') TO ('2027-01-01');

-- Particao default para datas fora do range
CREATE TABLE mtr.execucao_default PARTITION OF mtr.execucao DEFAULT;
```

---

## 9. Tabelas de Simulacao

```sql
-- ============================================================================
-- SIMULACAO - Testes de regras
-- ============================================================================

CREATE TABLE mtr.simulacao (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    regra_id UUID NOT NULL REFERENCES mtr.regra(id),
    
    -- Dados de entrada da simulacao
    inputs JSONB NOT NULL,
    contexto_simulado JSONB,
    
    -- Resultados
    variaveis_calculadas JSONB,
    condicao_atendida BOOLEAN,
    resultado JSONB,
    
    -- Performance
    tempo_execucao_ms INTEGER,
    
    -- Comparacao com outra versao (opcional)
    versao_comparada INTEGER,
    resultado_comparado JSONB,
    diferencas JSONB,
    
    -- Auditoria
    created_by UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE mtr.simulacao IS 'Simulacoes de teste de regras';
```

---

## 10. Indices

```sql
-- ============================================================================
-- INDICES
-- ============================================================================

-- Data Providers
CREATE INDEX idx_provider_codigo ON mtr.data_provider(codigo);
CREATE INDEX idx_provider_ativo ON mtr.data_provider(ativo);

-- Regras
CREATE INDEX idx_regra_codigo ON mtr.regra(codigo);
CREATE INDEX idx_regra_categoria ON mtr.regra(categoria);
CREATE INDEX idx_regra_status ON mtr.regra(status);
CREATE INDEX idx_regra_vigencia ON mtr.regra(vigencia_inicio, vigencia_fim);
CREATE INDEX idx_regra_escopo ON mtr.regra(escopo_tipo);
CREATE INDEX idx_regra_definicao ON mtr.regra USING GIN(definicao);

-- Regras ativas (indice parcial)
CREATE INDEX idx_regra_ativas ON mtr.regra(categoria, prioridade)
    WHERE status = 'ATIVA';

-- Variaveis
CREATE INDEX idx_variavel_regra ON mtr.regra_variavel(regra_id);
CREATE INDEX idx_variavel_codigo ON mtr.regra_variavel(codigo);

-- Condicoes
CREATE INDEX idx_condicao_regra ON mtr.regra_condicao(regra_id);

-- Acoes
CREATE INDEX idx_acao_regra ON mtr.regra_acao(regra_id);

-- Templates
CREATE INDEX idx_template_categoria ON mtr.template(categoria);
CREATE INDEX idx_template_ativo ON mtr.template(ativo);

-- Versoes
CREATE INDEX idx_versao_regra ON mtr.regra_versao(regra_id);

-- Execucoes (indices por particao sao criados automaticamente)
CREATE INDEX idx_execucao_regra ON mtr.execucao(regra_id, executado_em);
CREATE INDEX idx_execucao_codigo ON mtr.execucao(regra_codigo, executado_em);
CREATE INDEX idx_execucao_contexto ON mtr.execucao USING GIN(contexto);

-- Simulacoes
CREATE INDEX idx_simulacao_regra ON mtr.simulacao(regra_id);
CREATE INDEX idx_simulacao_usuario ON mtr.simulacao(created_by);
```

---

## 11. Triggers e Functions

```sql
-- ============================================================================
-- TRIGGERS E FUNCTIONS
-- ============================================================================

-- Funcao para atualizar updated_at
CREATE OR REPLACE FUNCTION mtr.update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers de updated_at
CREATE TRIGGER trg_provider_updated
    BEFORE UPDATE ON mtr.data_provider
    FOR EACH ROW EXECUTE FUNCTION mtr.update_timestamp();

CREATE TRIGGER trg_regra_updated
    BEFORE UPDATE ON mtr.regra
    FOR EACH ROW EXECUTE FUNCTION mtr.update_timestamp();

-- Funcao para criar versao automaticamente
CREATE OR REPLACE FUNCTION mtr.criar_versao_regra()
RETURNS TRIGGER AS $$
BEGIN
    -- Se a regra ja estava ativa e foi modificada, criar versao
    IF OLD.status = 'ATIVA' AND OLD.definicao IS DISTINCT FROM NEW.definicao THEN
        INSERT INTO mtr.regra_versao (regra_id, versao, snapshot, alteracoes, created_by)
        VALUES (
            OLD.id,
            OLD.versao,
            jsonb_build_object(
                'definicao', OLD.definicao,
                'status', OLD.status,
                'vigencia_inicio', OLD.vigencia_inicio,
                'vigencia_fim', OLD.vigencia_fim
            ),
            jsonb_build_object(
                'campos_alterados', (
                    SELECT jsonb_agg(key)
                    FROM jsonb_each(NEW.definicao)
                    WHERE NEW.definicao->key IS DISTINCT FROM OLD.definicao->key
                )
            ),
            COALESCE(NEW.updated_by, NEW.created_by)
        );
        
        NEW.versao = OLD.versao + 1;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_regra_versao
    BEFORE UPDATE ON mtr.regra
    FOR EACH ROW EXECUTE FUNCTION mtr.criar_versao_regra();

-- Funcao para incrementar uso de template
CREATE OR REPLACE FUNCTION mtr.incrementar_uso_template()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE mtr.template 
    SET uso_count = uso_count + 1 
    WHERE id = NEW.template_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_template_uso
    AFTER INSERT ON mtr.template_uso
    FOR EACH ROW EXECUTE FUNCTION mtr.incrementar_uso_template();

-- Funcao para validar definicao JSON
CREATE OR REPLACE FUNCTION mtr.validar_definicao_regra(def JSONB)
RETURNS BOOLEAN AS $$
BEGIN
    -- Validar schema version
    IF NOT (def ? 'versao_schema') THEN
        RAISE EXCEPTION 'Campo versao_schema obrigatorio';
    END IF;
    
    -- Validar variaveis
    IF NOT (def ? 'variaveis') THEN
        RAISE EXCEPTION 'Campo variaveis obrigatorio';
    END IF;
    
    -- Validar condicoes
    IF NOT (def ? 'condicoes') THEN
        RAISE EXCEPTION 'Campo condicoes obrigatorio';
    END IF;
    
    -- Validar acoes
    IF NOT (def ? 'acoes') THEN
        RAISE EXCEPTION 'Campo acoes obrigatorio';
    END IF;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Trigger de validacao
CREATE OR REPLACE FUNCTION mtr.trigger_validar_regra()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM mtr.validar_definicao_regra(NEW.definicao);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_regra
    BEFORE INSERT OR UPDATE ON mtr.regra
    FOR EACH ROW EXECUTE FUNCTION mtr.trigger_validar_regra();
```

---

## 12. Views Utilitarias

```sql
-- ============================================================================
-- VIEWS
-- ============================================================================

-- Regras ativas com detalhes
CREATE OR REPLACE VIEW mtr.vw_regras_ativas AS
SELECT 
    r.id,
    r.codigo,
    r.nome,
    r.categoria,
    r.escopo_tipo,
    r.vigencia_inicio,
    r.vigencia_fim,
    r.versao,
    r.prioridade,
    r.definicao->>'metadata'->>'descricao' as descricao,
    jsonb_array_length(r.definicao->'variaveis') as qtd_variaveis,
    jsonb_array_length(r.definicao->'acoes') as qtd_acoes,
    r.aprovado_por,
    r.aprovado_em,
    r.created_at,
    r.updated_at
FROM mtr.regra r
WHERE r.status = 'ATIVA'
    AND r.vigencia_inicio <= CURRENT_DATE
    AND (r.vigencia_fim IS NULL OR r.vigencia_fim >= CURRENT_DATE)
ORDER BY r.categoria, r.prioridade;

COMMENT ON VIEW mtr.vw_regras_ativas IS 'Regras atualmente ativas e dentro da vigencia';

-- Estatisticas de execucao por regra
CREATE OR REPLACE VIEW mtr.vw_estatisticas_execucao AS
SELECT 
    e.regra_codigo,
    e.regra_id,
    COUNT(*) as total_execucoes,
    COUNT(*) FILTER (WHERE e.condicao_atendida) as execucoes_aplicadas,
    ROUND(100.0 * COUNT(*) FILTER (WHERE e.condicao_atendida) / NULLIF(COUNT(*), 0), 2) as taxa_aplicacao_pct,
    AVG(e.tempo_execucao_ms) as tempo_medio_ms,
    MAX(e.tempo_execucao_ms) as tempo_maximo_ms,
    MIN(e.executado_em) as primeira_execucao,
    MAX(e.executado_em) as ultima_execucao
FROM mtr.execucao e
WHERE e.executado_em >= NOW() - INTERVAL '30 days'
GROUP BY e.regra_codigo, e.regra_id;

COMMENT ON VIEW mtr.vw_estatisticas_execucao IS 'Estatisticas de execucao das regras nos ultimos 30 dias';

-- Providers com campos
CREATE OR REPLACE VIEW mtr.vw_providers_completo AS
SELECT 
    p.id,
    p.codigo,
    p.nome,
    p.descricao,
    p.tipo,
    p.fonte,
    p.ativo,
    jsonb_agg(
        jsonb_build_object(
            'codigo', c.codigo,
            'nome', c.nome,
            'tipo', c.tipo_dado,
            'descricao', c.descricao
        ) ORDER BY c.codigo
    ) as campos
FROM mtr.data_provider p
LEFT JOIN mtr.data_provider_campo c ON c.provider_id = p.id
GROUP BY p.id;

COMMENT ON VIEW mtr.vw_providers_completo IS 'Data providers com seus campos';
```

---

## 13. Dados Iniciais

```sql
-- ============================================================================
-- DADOS INICIAIS - Data Providers
-- ============================================================================

-- Provider: PLACA
INSERT INTO mtr.data_provider (codigo, nome, descricao, tipo, fonte) VALUES
('PLACA', 'Placas/Contratos', 'Dados de placas e contratos fechados', 'VIEW', 'vw_placas_motor');

INSERT INTO mtr.data_provider_campo (provider_id, codigo, nome, tipo_dado, descricao) 
SELECT p.id, c.codigo, c.nome, c.tipo::mtr.tipo_dado, c.descricao
FROM mtr.data_provider p, 
(VALUES 
    ('id', 'ID', 'UUID', 'Identificador unico da placa'),
    ('consultor_id', 'Consultor', 'UUID', 'ID do consultor responsavel'),
    ('associado_id', 'Associado', 'UUID', 'ID do associado'),
    ('data_fechamento', 'Data Fechamento', 'DATE', 'Data de fechamento do contrato'),
    ('valor_veiculo', 'Valor Veiculo', 'DECIMAL', 'Valor de mercado do veiculo'),
    ('tipo_veiculo', 'Tipo Veiculo', 'STRING', 'AUTOMOVEL, MOTO, CAMINHAO, etc'),
    ('uf_veiculo', 'UF Veiculo', 'STRING', 'Estado do veiculo'),
    ('tipo_plano', 'Tipo Plano', 'STRING', 'BRONZE, PRATA, OURO, PLATINUM'),
    ('valor_plano', 'Valor Plano', 'DECIMAL', 'Valor mensal do plano'),
    ('status', 'Status', 'STRING', 'FECHADA, CANCELADA, SUSPENSA')
) AS c(codigo, nome, tipo, descricao)
WHERE p.codigo = 'PLACA';

-- Provider: BOLETO
INSERT INTO mtr.data_provider (codigo, nome, descricao, tipo, fonte) VALUES
('BOLETO', 'Boletos', 'Dados de boletos e recebimentos', 'VIEW', 'vw_boletos_motor');

INSERT INTO mtr.data_provider_campo (provider_id, codigo, nome, tipo_dado, descricao) 
SELECT p.id, c.codigo, c.nome, c.tipo::mtr.tipo_dado, c.descricao
FROM mtr.data_provider p, 
(VALUES 
    ('id', 'ID', 'UUID', 'Identificador unico do boleto'),
    ('consultor_id', 'Consultor', 'UUID', 'ID do consultor vinculado'),
    ('associado_id', 'Associado', 'UUID', 'ID do associado'),
    ('valor_nominal', 'Valor Nominal', 'DECIMAL', 'Valor original do boleto'),
    ('valor_recebido', 'Valor Recebido', 'DECIMAL', 'Valor efetivamente recebido'),
    ('data_vencimento', 'Data Vencimento', 'DATE', 'Data de vencimento'),
    ('data_pagamento', 'Data Pagamento', 'DATE', 'Data do pagamento'),
    ('status', 'Status', 'STRING', 'PAGO, PENDENTE, VENCIDO, CANCELADO')
) AS c(codigo, nome, tipo, descricao)
WHERE p.codigo = 'BOLETO';

-- Provider: META
INSERT INTO mtr.data_provider (codigo, nome, descricao, tipo, fonte) VALUES
('META', 'Metas', 'Metas dos consultores', 'VIEW', 'vw_metas_motor');

INSERT INTO mtr.data_provider_campo (provider_id, codigo, nome, tipo_dado, descricao) 
SELECT p.id, c.codigo, c.nome, c.tipo::mtr.tipo_dado, c.descricao
FROM mtr.data_provider p, 
(VALUES 
    ('consultor_id', 'Consultor', 'UUID', 'ID do consultor'),
    ('ano', 'Ano', 'INTEGER', 'Ano da meta'),
    ('mes', 'Mes', 'INTEGER', 'Mes da meta (1-12)'),
    ('meta_placas', 'Meta Placas', 'INTEGER', 'Meta de quantidade de placas'),
    ('meta_valor', 'Meta Valor', 'DECIMAL', 'Meta em valor monetario'),
    ('meta_ativacoes', 'Meta Ativacoes', 'INTEGER', 'Meta de ativacoes')
) AS c(codigo, nome, tipo, descricao)
WHERE p.codigo = 'META';

-- Provider: CONSULTOR
INSERT INTO mtr.data_provider (codigo, nome, descricao, tipo, fonte) VALUES
('CONSULTOR', 'Consultores', 'Dados cadastrais dos consultores', 'VIEW', 'vw_consultores_motor');

INSERT INTO mtr.data_provider_campo (provider_id, codigo, nome, tipo_dado, descricao) 
SELECT p.id, c.codigo, c.nome, c.tipo::mtr.tipo_dado, c.descricao
FROM mtr.data_provider p, 
(VALUES 
    ('id', 'ID', 'UUID', 'Identificador unico'),
    ('nome', 'Nome', 'STRING', 'Nome completo'),
    ('data_admissao', 'Data Admissao', 'DATE', 'Data de admissao'),
    ('gerente_id', 'Gerente', 'UUID', 'ID do gerente direto'),
    ('equipe_id', 'Equipe', 'UUID', 'ID da equipe'),
    ('filial_id', 'Filial', 'UUID', 'ID da filial'),
    ('regiao', 'Regiao', 'STRING', 'Regiao de atuacao'),
    ('status', 'Status', 'STRING', 'ATIVO, INATIVO, AFASTADO')
) AS c(codigo, nome, tipo, descricao)
WHERE p.codigo = 'CONSULTOR';

-- Provider: HIERARQUIA
INSERT INTO mtr.data_provider (codigo, nome, descricao, tipo, fonte) VALUES
('HIERARQUIA', 'Hierarquia', 'Estrutura hierarquica', 'VIEW', 'vw_hierarquia_motor');

INSERT INTO mtr.data_provider_campo (provider_id, codigo, nome, tipo_dado, descricao) 
SELECT p.id, c.codigo, c.nome, c.tipo::mtr.tipo_dado, c.descricao
FROM mtr.data_provider p, 
(VALUES 
    ('consultor_id', 'Consultor', 'UUID', 'ID do consultor'),
    ('gerente_id', 'Gerente', 'UUID', 'ID do gerente'),
    ('diretor_id', 'Diretor', 'UUID', 'ID do diretor'),
    ('nivel', 'Nivel', 'INTEGER', 'Nivel hierarquico')
) AS c(codigo, nome, tipo, descricao)
WHERE p.codigo = 'HIERARQUIA';

-- Provider: LEAD
INSERT INTO mtr.data_provider (codigo, nome, descricao, tipo, fonte) VALUES
('LEAD', 'Leads', 'Dados de leads', 'VIEW', 'vw_leads_motor');

INSERT INTO mtr.data_provider_campo (provider_id, codigo, nome, tipo_dado, descricao) 
SELECT p.id, c.codigo, c.nome, c.tipo::mtr.tipo_dado, c.descricao
FROM mtr.data_provider p, 
(VALUES 
    ('id', 'ID', 'UUID', 'Identificador unico'),
    ('consultor_id', 'Consultor', 'UUID', 'ID do consultor responsavel'),
    ('nome', 'Nome', 'STRING', 'Nome do lead'),
    ('valor_veiculo', 'Valor Veiculo', 'DECIMAL', 'Valor estimado do veiculo'),
    ('uf', 'UF', 'STRING', 'Estado'),
    ('tipo_veiculo', 'Tipo Veiculo', 'STRING', 'Tipo do veiculo'),
    ('origem', 'Origem', 'STRING', 'Origem do lead'),
    ('score', 'Score', 'INTEGER', 'Pontuacao calculada'),
    ('classificacao', 'Classificacao', 'STRING', 'HOT, WARM, COLD, FROZEN'),
    ('ultimo_contato', 'Ultimo Contato', 'DATETIME', 'Data do ultimo contato'),
    ('status', 'Status', 'STRING', 'Status do lead')
) AS c(codigo, nome, tipo, descricao)
WHERE p.codigo = 'LEAD';

-- Provider: INTERACAO
INSERT INTO mtr.data_provider (codigo, nome, descricao, tipo, fonte) VALUES
('INTERACAO', 'Interacoes', 'Interacoes com leads', 'VIEW', 'vw_interacoes_motor');

INSERT INTO mtr.data_provider_campo (provider_id, codigo, nome, tipo_dado, descricao) 
SELECT p.id, c.codigo, c.nome, c.tipo::mtr.tipo_dado, c.descricao
FROM mtr.data_provider p, 
(VALUES 
    ('id', 'ID', 'UUID', 'Identificador unico'),
    ('lead_id', 'Lead', 'UUID', 'ID do lead'),
    ('tipo', 'Tipo', 'STRING', 'Tipo da interacao'),
    ('data', 'Data', 'DATETIME', 'Data da interacao'),
    ('descricao', 'Descricao', 'STRING', 'Descricao da interacao')
) AS c(codigo, nome, tipo, descricao)
WHERE p.codigo = 'INTERACAO';

-- Provider: RANKING
INSERT INTO mtr.data_provider (codigo, nome, descricao, tipo, fonte) VALUES
('RANKING', 'Rankings', 'Rankings de vendas', 'VIEW', 'vw_rankings_motor');

INSERT INTO mtr.data_provider_campo (provider_id, codigo, nome, tipo_dado, descricao) 
SELECT p.id, c.codigo, c.nome, c.tipo::mtr.tipo_dado, c.descricao
FROM mtr.data_provider p, 
(VALUES 
    ('consultor_id', 'Consultor', 'UUID', 'ID do consultor'),
    ('mes', 'Mes', 'INTEGER', 'Mes do ranking'),
    ('ano', 'Ano', 'INTEGER', 'Ano do ranking'),
    ('tipo', 'Tipo', 'STRING', 'REGIONAL, NACIONAL, FILIAL'),
    ('posicao', 'Posicao', 'INTEGER', 'Posicao no ranking'),
    ('pontuacao', 'Pontuacao', 'DECIMAL', 'Pontuacao obtida')
) AS c(codigo, nome, tipo, descricao)
WHERE p.codigo = 'RANKING';

-- Provider: INDICACAO
INSERT INTO mtr.data_provider (codigo, nome, descricao, tipo, fonte) VALUES
('INDICACAO', 'Indicacoes', 'Indicacoes de clientes', 'VIEW', 'vw_indicacoes_motor');

INSERT INTO mtr.data_provider_campo (provider_id, codigo, nome, tipo_dado, descricao) 
SELECT p.id, c.codigo, c.nome, c.tipo::mtr.tipo_dado, c.descricao
FROM mtr.data_provider p, 
(VALUES 
    ('id', 'ID', 'UUID', 'Identificador unico'),
    ('indicador_id', 'Indicador', 'UUID', 'ID do associado que indicou'),
    ('indicado_id', 'Indicado', 'UUID', 'ID do indicado'),
    ('data', 'Data', 'DATE', 'Data da indicacao'),
    ('status', 'Status', 'STRING', 'CONVERTIDO, PENDENTE, PERDIDO')
) AS c(codigo, nome, tipo, descricao)
WHERE p.codigo = 'INDICACAO';

-- ============================================================================
-- DADOS INICIAIS - Templates
-- ============================================================================

-- Template: Comissao Simples
INSERT INTO mtr.template (codigo, nome, descricao, categoria, definicao_base, parametros, created_by) VALUES
('TPL-COM-SIMPLES', 'Comissao Simples', 'Percentual fixo sobre valor da venda', 'COMISSAO',
'{
  "versao_schema": "2.0",
  "variaveis": [
    {
      "nome": "valor_venda",
      "tipo": "INPUT",
      "config": {"tipo_dado": "DECIMAL", "obrigatorio": true}
    },
    {
      "nome": "percentual",
      "tipo": "CONSTANTE",
      "config": {"valor": "@PARAM_PERCENTUAL"}
    },
    {
      "nome": "comissao",
      "tipo": "FORMULA",
      "config": {"expressao": "valor_venda * percentual"}
    }
  ],
  "condicoes": {"tipo": "AND", "expressoes": [{"variavel": "valor_venda", "operador": ">", "valor": 0}]},
  "acoes": [{"tipo": "ADICIONAR_VALOR", "config": {"destino_tipo": "COMISSAO", "valor": {"ref": "comissao"}}}]
}',
'[{"nome": "PARAM_PERCENTUAL", "tipo": "DECIMAL", "descricao": "Percentual de comissao (ex: 0.08 para 8%)", "obrigatorio": true}]',
'00000000-0000-0000-0000-000000000000');

-- Template: Bonus por Meta
INSERT INTO mtr.template (codigo, nome, descricao, categoria, definicao_base, parametros, created_by) VALUES
('TPL-BONUS-META', 'Bonus por Meta', 'Valor fixo ao atingir meta', 'BONIFICACAO',
'{
  "versao_schema": "2.0",
  "variaveis": [
    {
      "nome": "realizado",
      "tipo": "INPUT",
      "config": {"tipo_dado": "DECIMAL", "obrigatorio": true}
    },
    {
      "nome": "meta",
      "tipo": "CONSTANTE",
      "config": {"valor": "@PARAM_META"}
    },
    {
      "nome": "valor_bonus",
      "tipo": "CONSTANTE",
      "config": {"valor": "@PARAM_BONUS"}
    }
  ],
  "condicoes": {"tipo": "AND", "expressoes": [{"variavel": "realizado", "operador": ">=", "valor": {"ref": "meta"}}]},
  "acoes": [{"tipo": "ADICIONAR_VALOR", "config": {"destino_tipo": "BONUS", "valor": {"ref": "valor_bonus"}}}]
}',
'[
  {"nome": "PARAM_META", "tipo": "DECIMAL", "descricao": "Valor da meta a atingir", "obrigatorio": true},
  {"nome": "PARAM_BONUS", "tipo": "DECIMAL", "descricao": "Valor do bonus ao atingir", "obrigatorio": true}
]',
'00000000-0000-0000-0000-000000000000');

-- Template: Residual por Placa
INSERT INTO mtr.template (codigo, nome, descricao, categoria, definicao_base, parametros, created_by) VALUES
('TPL-RES-PLACA', 'Residual por Placa', 'Valor fixo por placa ativa', 'RESIDUAL',
'{
  "versao_schema": "2.0",
  "variaveis": [
    {
      "nome": "qtd_placas_ativas",
      "tipo": "INPUT",
      "config": {"tipo_dado": "INTEGER", "obrigatorio": true}
    },
    {
      "nome": "valor_por_placa",
      "tipo": "CONSTANTE",
      "config": {"valor": "@PARAM_VALOR_PLACA"}
    },
    {
      "nome": "residual",
      "tipo": "FORMULA",
      "config": {"expressao": "qtd_placas_ativas * valor_por_placa"}
    }
  ],
  "condicoes": {"tipo": "AND", "expressoes": [{"variavel": "qtd_placas_ativas", "operador": ">", "valor": 0}]},
  "acoes": [{"tipo": "ADICIONAR_VALOR", "config": {"destino_tipo": "RESIDUAL", "valor": {"ref": "residual"}}}]
}',
'[{"nome": "PARAM_VALOR_PLACA", "tipo": "DECIMAL", "descricao": "Valor por placa ativa (ex: 2.00)", "obrigatorio": true}]',
'00000000-0000-0000-0000-000000000000');
```

---

## 14. Permissoes

```sql
-- ============================================================================
-- PERMISSOES (ajustar conforme roles do seu sistema)
-- ============================================================================

-- Role para leitura
GRANT USAGE ON SCHEMA mtr TO readonly_role;
GRANT SELECT ON ALL TABLES IN SCHEMA mtr TO readonly_role;

-- Role para execucao do motor
GRANT USAGE ON SCHEMA mtr TO motor_role;
GRANT SELECT ON ALL TABLES IN SCHEMA mtr TO motor_role;
GRANT INSERT ON mtr.execucao TO motor_role;
GRANT INSERT ON mtr.simulacao TO motor_role;

-- Role para administracao de regras
GRANT USAGE ON SCHEMA mtr TO regras_admin_role;
GRANT ALL ON ALL TABLES IN SCHEMA mtr TO regras_admin_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA mtr TO regras_admin_role;
```

---

## 15. Manutencao

```sql
-- ============================================================================
-- ROTINAS DE MANUTENCAO
-- ============================================================================

-- Funcao para criar particao do proximo mes
CREATE OR REPLACE FUNCTION mtr.criar_particao_mes(p_ano INTEGER, p_mes INTEGER)
RETURNS VOID AS $$
DECLARE
    v_inicio DATE;
    v_fim DATE;
    v_nome TEXT;
BEGIN
    v_inicio := make_date(p_ano, p_mes, 1);
    v_fim := v_inicio + INTERVAL '1 month';
    v_nome := format('execucao_%s_%s', p_ano, lpad(p_mes::text, 2, '0'));
    
    EXECUTE format(
        'CREATE TABLE IF NOT EXISTS mtr.%I PARTITION OF mtr.execucao 
         FOR VALUES FROM (%L) TO (%L)',
        v_nome, v_inicio, v_fim
    );
    
    RAISE NOTICE 'Particao % criada', v_nome;
END;
$$ LANGUAGE plpgsql;

-- Funcao para limpar execucoes antigas
CREATE OR REPLACE FUNCTION mtr.limpar_execucoes_antigas(p_meses INTEGER DEFAULT 12)
RETURNS INTEGER AS $$
DECLARE
    v_count INTEGER;
BEGIN
    WITH deleted AS (
        DELETE FROM mtr.execucao 
        WHERE executado_em < NOW() - (p_meses || ' months')::INTERVAL
        RETURNING id
    )
    SELECT COUNT(*) INTO v_count FROM deleted;
    
    RETURN v_count;
END;
$$ LANGUAGE plpgsql;

-- Exemplo: Criar particoes para 2027
-- SELECT mtr.criar_particao_mes(2027, generate_series(1, 12));
```

---

## Historico de Alteracoes

| Versao | Data | Autor | Alteracao |
|--------|------|-------|-----------|
| 2.0 | 29/01/2026 | PO | Criacao do DDL completo com nova arquitetura |
