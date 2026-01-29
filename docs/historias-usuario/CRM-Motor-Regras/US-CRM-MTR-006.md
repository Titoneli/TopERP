# US-CRM-MTR-006: Versionamento e Auditoria

> **Modulo**: CRM-Motor-Regras  
> **Versao**: 1.0  
> **Data**: 29/01/2026  
> **Status**: Pronto para Desenvolvimento  
> **Story Points**: 21

---

## Historia de Usuario

**Como** gestor do sistema,  
**Quero** ter controle completo sobre versoes das regras e auditoria de todas as execucoes,  
**Para** garantir rastreabilidade, compliance e capacidade de rollback.

---

## Descricao

Esta historia implementa o sistema de versionamento de regras e auditoria completa de execucoes. Cada alteracao em regra gera nova versao, mantendo historico completo. Toda execucao e registrada com detalhes para rastreabilidade.

---

## Criterios de Aceitacao

### CA-001: Versionamento Automatico

- [ ] Sistema cria nova versao ao alterar regra ATIVA
- [ ] Sistema mantem historico de todas as versoes
- [ ] Numero da versao e incremental (1, 2, 3...)
- [ ] Sistema registra data, usuario e alteracoes de cada versao

### CA-002: Comparar Versoes

- [ ] Sistema permite visualizar duas versoes lado a lado
- [ ] Sistema destaca diferencas (campos alterados)
- [ ] Sistema permite comparar qualquer versao com qualquer outra

### CA-003: Rollback

- [ ] Sistema permite reativar versao anterior
- [ ] Rollback desativa versao atual e ativa a selecionada
- [ ] Sistema exige justificativa para rollback
- [ ] Sistema registra rollback no historico

### CA-004: Imutabilidade

- [ ] Regra com execucoes nao pode ser editada diretamente
- [ ] Edicao cria nova versao automaticamente
- [ ] Versoes antigas sao somente leitura
- [ ] Snapshot completo de cada versao e preservado

### CA-005: Auditoria de Execucoes

- [ ] Toda execucao do motor e registrada
- [ ] Registro inclui: regra, versao, inputs, outputs, resultado
- [ ] Registro inclui: timestamp, usuario, tempo de execucao
- [ ] Registro inclui: contexto (venda_id, consultor_id, etc.)

### CA-006: Consulta de Auditoria

- [ ] Sistema permite buscar execucoes por regra
- [ ] Sistema permite buscar execucoes por periodo
- [ ] Sistema permite buscar execucoes por usuario/consultor
- [ ] Sistema permite exportar log de auditoria

### CA-007: Trilha de Auditoria de Alteracoes

- [ ] Sistema registra quem criou/editou/ativou/desativou regra
- [ ] Sistema registra justificativas quando obrigatorias
- [ ] Sistema permite visualizar timeline de alteracoes
- [ ] Sistema atende requisitos de compliance (SOX, LGPD)

### CA-008: Retencao de Dados

- [ ] Sistema define periodo de retencao de execucoes
- [ ] Sistema permite arquivar execucoes antigas
- [ ] Sistema permite purgar dados apos periodo legal
- [ ] Sistema mantem minimo necessario para auditoria

---

## Mockups

### Tela: Historico de Versoes

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  HISTORICO DE VERSOES - REG-COM-001                                                │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  Regra: Comissao Plano Premium                                                      │
│  Status atual: ATIVA (v3)                                                           │
│                                                                                     │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Versao │ Status     │ Data       │ Usuario      │ Alteracoes  │ Acoes      │   │
│  ├─────────────────────────────────────────────────────────────────────────────┤   │
│  │ v3     │ ATIVA      │ 15/01/2026 │ Maria Santos │ +Acelerador │ [Ver]      │   │
│  │ v2     │ INATIVA    │ 01/12/2025 │ Joao Silva   │ +Bonus plano│ [Ver][↩ ]  │   │
│  │ v1     │ ARQUIVADA  │ 01/01/2025 │ Admin        │ Criacao     │ [Ver]      │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  [Comparar Versoes]                                                                │
│                                                                                     │
│  DETALHES DA VERSAO 3 (ATIVA)                                                       │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Criada em: 15/01/2026 14:30                                                 │   │
│  │ Criada por: Maria Santos                                                    │   │
│  │ Aprovada por: Gerente Financeiro                                            │   │
│  │                                                                             │   │
│  │ Alteracoes em relacao a v2:                                                 │   │
│  │ + Adicionado acelerador progressivo (4 faixas)                              │   │
│  │ ~ Alterado percentual de 7% para 8%                                         │   │
│  │                                                                             │   │
│  │ Justificativa: "Nova politica de comissionamento Q1 2026"                   │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  ESTATISTICAS                                                                       │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Total de execucoes: 1.234                                                   │   │
│  │ Ultima execucao: 29/01/2026 14:25                                           │   │
│  │ Valor total calculado: R$ 45.678,00                                         │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### Tela: Log de Auditoria de Execucoes

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  LOG DE EXECUCOES - MOTOR DE REGRAS                           [Exportar CSV/Excel] │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  Filtros:                                                                           │
│  [Regra: Todas ▼] [Periodo: Ultimos 7 dias ▼] [Consultor: Todos ▼] [Buscar]       │
│                                                                                     │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ ID Exec. │ Regra       │ Versao │ Data/Hora        │ Resultado │ Tempo    │   │
│  ├─────────────────────────────────────────────────────────────────────────────┤   │
│  │ #12345   │ REG-COM-001 │ v3     │ 29/01/26 14:25:33│ R$ 72,00  │ 12ms     │   │
│  │ #12344   │ REG-COM-001 │ v3     │ 29/01/26 14:20:15│ R$ 40,00  │ 8ms      │   │
│  │ #12343   │ REG-RES-001 │ v2     │ 29/01/26 14:15:00│ R$ 100,00 │ 15ms     │   │
│  │ #12342   │ REG-BON-001 │ v1     │ 29/01/26 14:00:00│ R$ 500,00 │ 5ms      │   │
│  │ #12341   │ REG-COM-002 │ v5     │ 29/01/26 13:45:22│ R$ 55,00  │ 10ms     │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  Mostrando 5 de 1.234 execucoes                               [< 1 2 3 ... 247 >]  │
│                                                                                     │
│  DETALHES DA EXECUCAO #12345                                                        │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Regra: REG-COM-001 - Comissao Plano Premium (versao 3)                      │   │
│  │ Executada em: 29/01/2026 14:25:33.456                                       │   │
│  │ Tempo de execucao: 12ms                                                     │   │
│  │                                                                             │   │
│  │ INPUTS:                                                                     │   │
│  │ ├─ VALOR_VENDA: 500.00                                                     │   │
│  │ ├─ TIPO_PLANO: "PREMIUM"                                                   │   │
│  │ ├─ QTD_VENDAS_MES: 15                                                      │   │
│  │ └─ SENIORIDADE: 24                                                         │   │
│  │                                                                             │   │
│  │ OUTPUTS:                                                                    │   │
│  │ └─ comissao: 72.00                                                         │   │
│  │                                                                             │   │
│  │ CONTEXTO:                                                                   │   │
│  │ ├─ venda_id: "abc-123-def"                                                 │   │
│  │ ├─ consultor_id: "usr-456-ghi"                                             │   │
│  │ └─ modulo_origem: "CRM-FIN"                                                │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### Modal: Rollback de Versao

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  ROLLBACK DE VERSAO                                                        [X]     │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  ATENCAO: Esta acao ira reativar uma versao anterior da regra.                     │
│                                                                                     │
│  Regra: REG-COM-001 - Comissao Plano Premium                                       │
│                                                                                     │
│  ┌────────────────────────────────┬────────────────────────────────┐               │
│  │      VERSAO ATUAL (v3)         │      VERSAO DESTINO (v2)       │               │
│  ├────────────────────────────────┼────────────────────────────────┤               │
│  │ Status: ATIVA                  │ Status: INATIVA                │               │
│  │ Desde: 15/01/2026              │ Desde: 01/12/2025              │               │
│  │ Execucoes: 1.234               │ Execucoes: 3.456               │               │
│  │ Inclui acelerador              │ Sem acelerador                 │               │
│  │ Percentual: 8%                 │ Percentual: 7%                 │               │
│  └────────────────────────────────┴────────────────────────────────┘               │
│                                                                                     │
│  JUSTIFICATIVA (obrigatoria)*:                                                     │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Erro identificado no calculo do acelerador. Revertendo para versao         │   │
│  │ anterior enquanto corrigimos a formula.                                     │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  [ ] Notificar equipe financeira sobre rollback                                    │
│  [ ] Recalcular execucoes afetadas (ultimos 7 dias)                               │
│                                                                                     │
│                                           [Cancelar] [Confirmar Rollback]          │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

---

## Regras de Negocio

| Codigo | Regra | Validacao |
|--------|-------|-----------|
| RN-MTR-050 | Versionamento automatico | Alteracao em regra ATIVA cria nova versao |
| RN-MTR-051 | Imutabilidade | Versao com execucoes nao pode ser editada |
| RN-MTR-052 | Rollback com justificativa | Rollback exige justificativa textual |
| RN-MTR-053 | Auditoria completa | Toda execucao deve ser registrada |
| RN-MTR-054 | Retencao 5 anos | Logs de auditoria retidos por 5 anos |
| RN-MTR-055 | Uma versao ativa | Apenas uma versao pode estar ATIVA por vez |

---

## Modelo de Dados

```sql
-- Versoes de Regras
CREATE TABLE mtr_regra_versao (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    regra_id UUID NOT NULL REFERENCES mtr_regra(id) ON DELETE CASCADE,
    versao INTEGER NOT NULL,
    snapshot_json JSONB NOT NULL, -- Estado completo da regra
    alteracoes_json JSONB, -- Diff em relacao a versao anterior
    justificativa TEXT,
    criado_em TIMESTAMP NOT NULL DEFAULT NOW(),
    criado_por UUID NOT NULL,
    aprovado_em TIMESTAMP,
    aprovado_por UUID,
    UNIQUE(regra_id, versao)
);

-- Execucoes do Motor (Auditoria)
CREATE TABLE mtr_execucao (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    regra_id UUID NOT NULL REFERENCES mtr_regra(id),
    regra_codigo VARCHAR(20) NOT NULL, -- Denormalizado para consultas rapidas
    regra_versao INTEGER NOT NULL,
    timestamp TIMESTAMP NOT NULL DEFAULT NOW(),
    inputs_json JSONB NOT NULL,
    outputs_json JSONB,
    resultado DECIMAL(15,2),
    tempo_execucao_ms INTEGER,
    usuario_id UUID,
    contexto_json JSONB -- venda_id, consultor_id, modulo, etc.
) PARTITION BY RANGE (timestamp);

-- Particoes por mes
CREATE TABLE mtr_execucao_202601 PARTITION OF mtr_execucao
    FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');

-- Trilha de Auditoria de Alteracoes
CREATE TABLE mtr_auditoria_alteracao (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    regra_id UUID NOT NULL REFERENCES mtr_regra(id),
    acao VARCHAR(30) NOT NULL, -- CRIOU, EDITOU, ATIVOU, DESATIVOU, ROLLBACK
    versao_anterior INTEGER,
    versao_nova INTEGER,
    detalhes_json JSONB,
    justificativa TEXT,
    ip_origem VARCHAR(45),
    user_agent TEXT,
    executado_em TIMESTAMP NOT NULL DEFAULT NOW(),
    executado_por UUID NOT NULL
);

-- Indices para consultas
CREATE INDEX idx_mtr_execucao_regra ON mtr_execucao(regra_id);
CREATE INDEX idx_mtr_execucao_timestamp ON mtr_execucao(timestamp);
CREATE INDEX idx_mtr_execucao_usuario ON mtr_execucao(usuario_id);
CREATE INDEX idx_mtr_auditoria_regra ON mtr_auditoria_alteracao(regra_id);
CREATE INDEX idx_mtr_auditoria_data ON mtr_auditoria_alteracao(executado_em);
```

---

## Cenarios de Teste

### CT-001: Versionamento Automatico

```gherkin
Dado que tenho regra REG-COM-001 versao 3 ATIVA
E regra ja tem 100 execucoes
Quando altero o percentual de 8% para 9%
E salvo a alteracao
Entao sistema cria versao 4
E versao 3 permanece inalterada
E versao 4 fica com status RASCUNHO
```

### CT-002: Executar Rollback

```gherkin
Dado que regra REG-COM-001 versao 3 esta ATIVA
E versao 2 esta INATIVA
Quando clico em Rollback para versao 2
E preencho justificativa "Erro no calculo"
E confirmo
Entao versao 3 muda para INATIVA
E versao 2 muda para ATIVA
E sistema registra acao na trilha de auditoria
```

### CT-003: Registrar Execucao

```gherkin
Dado que regra REG-COM-001 esta ATIVA
Quando sistema executa calculo para uma venda
Entao registro e criado em mtr_execucao
E registro contem: inputs, outputs, resultado, tempo
E registro contem: contexto (venda_id, consultor_id)
```

---

## Dependencias

- **Depende de**: US-CRM-MTR-001 (estrutura de regras)
- **Dependentes**: Todos os modulos que usam MTR (para auditoria)

---

## Estimativa

| Componente | Story Points |
|------------|-------------|
| Backend: Versionamento | 5 |
| Backend: Auditoria execucoes | 5 |
| Backend: Trilha alteracoes | 3 |
| Backend: Rollback | 3 |
| Frontend: Telas | 5 |
| **TOTAL** | **21** |

---

## Compliance

### Requisitos Atendidos

| Regulamento | Requisito | Como Atende |
|-------------|-----------|-------------|
| SOX | Trilha de auditoria | Registro completo de alteracoes e aprovacoes |
| LGPD | Retencao de dados | Politica de retencao configuravel |
| Auditoria Interna | Rastreabilidade | Log de todas as execucoes com contexto |

---

## Historico de Alteracoes

| Versao | Data | Autor | Alteracao |
|--------|------|-------|-----------|
| 1.0 | 29/01/2026 | PO | Criacao inicial |
