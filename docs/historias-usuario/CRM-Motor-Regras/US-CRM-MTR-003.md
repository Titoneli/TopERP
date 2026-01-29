# US-CRM-MTR-003: Templates Pre-configurados

> **Modulo**: CRM-Motor-Regras  
> **Versao**: 1.0  
> **Data**: 29/01/2026  
> **Status**: Pronto para Desenvolvimento  
> **Story Points**: 13

---

## Historia de Usuario

**Como** gestor do sistema,  
**Quero** utilizar templates pre-configurados de regras e clonar regras existentes,  
**Para** agilizar a criacao de novas regras sem comecar do zero.

---

## Descricao

Esta historia implementa uma biblioteca de templates prontos para os tipos mais comuns de regras, alem da funcionalidade de clonar regras existentes. Reduz significativamente o tempo de configuracao.

---

## Criterios de Aceitacao

### CA-001: Biblioteca de Templates

- [ ] Sistema exibe catalogo de templates disponiveis
- [ ] Templates organizados por categoria (Comissao, Bonus, Override, etc.)
- [ ] Cada template tem nome, descricao e preview da configuracao
- [ ] Sistema permite buscar templates por nome ou categoria

### CA-002: Usar Template

- [ ] Sistema permite criar regra a partir de template
- [ ] Sistema copia toda a estrutura do template (variaveis, condicoes, formula)
- [ ] Sistema permite editar valores antes de salvar
- [ ] Sistema gera codigo unico para nova regra
- [ ] Sistema registra que regra foi criada a partir de template

### CA-003: Clonar Regra Existente

- [ ] Sistema permite clonar qualquer regra existente
- [ ] Clone recebe novo codigo e nome
- [ ] Clone inicia com status RASCUNHO
- [ ] Sistema copia todas as configuracoes (variaveis, condicoes, formula, faixas)
- [ ] Sistema registra origem do clone

### CA-004: Gerenciar Templates

- [ ] Administrador pode criar novos templates
- [ ] Administrador pode editar templates existentes
- [ ] Administrador pode ativar/desativar templates
- [ ] Administrador pode definir templates em destaque

### CA-005: Parametros Configuraveis

- [ ] Templates definem quais campos sao configuraveis
- [ ] Sistema destaca campos que precisam ser preenchidos
- [ ] Sistema valida campos obrigatorios antes de criar regra

---

## Templates Padrao

### Lista de Templates Iniciais

| Categoria | Template | Descricao |
|-----------|----------|-----------|
| Comissao | Comissao Simples | % fixo sobre valor da venda |
| Comissao | Comissao por Plano | % diferente para cada plano |
| Comissao | Comissao Escalonada | % varia por faixa de volume |
| Bonus | Bonus por Meta | Valor fixo ao atingir meta |
| Bonus | Bonus Progressivo | Valor cresce conforme superacao |
| SPIFF | Campanha Produto | Bonus por produto especifico |
| SPIFF | Campanha Periodo | Bonus por vendas no periodo |
| Acelerador | Acelerador 4 Faixas | Multiplicador padrao |
| Override | Override 2 Niveis | Gerente e Coordenador |
| Split | Captacao/Fechamento | Divisao 40/60 |
| Residual | Residual por Placa | Valor fixo por placa ativa |

---

## Mockups

### Tela: Catalogo de Templates

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  TEMPLATES DE REGRAS                                                                │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  Buscar: [_______________________] [Categoria: Todas ▼]                            │
│                                                                                     │
│  DESTAQUES                                                                          │
│  ┌───────────────────────┐ ┌───────────────────────┐ ┌───────────────────────┐     │
│  │ ★ COMISSAO SIMPLES    │ │ ★ BONUS POR META      │ │ ★ ACELERADOR 4 FAIXAS │     │
│  │                       │ │                       │ │                       │     │
│  │ % fixo sobre valor    │ │ Valor ao atingir      │ │ Multiplicador por     │     │
│  │ da venda              │ │ meta definida         │ │ atingimento           │     │
│  │                       │ │                       │ │                       │     │
│  │ [Usar Template]       │ │ [Usar Template]       │ │ [Usar Template]       │     │
│  └───────────────────────┘ └───────────────────────┘ └───────────────────────┘     │
│                                                                                     │
│  TODOS OS TEMPLATES                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Nome                    │ Categoria  │ Descricao                    │ Acao  │   │
│  ├─────────────────────────────────────────────────────────────────────────────┤   │
│  │ Comissao Simples        │ Comissao   │ % fixo sobre valor          │ [Usar]│   │
│  │ Comissao por Plano      │ Comissao   │ % diferente por plano       │ [Usar]│   │
│  │ Comissao Escalonada     │ Comissao   │ % por faixa de volume       │ [Usar]│   │
│  │ Bonus por Meta          │ Bonus      │ Valor ao atingir meta       │ [Usar]│   │
│  │ Acelerador 4 Faixas     │ Acelerador │ Multiplicador padrao        │ [Usar]│   │
│  │ Override 2 Niveis       │ Override   │ Gerente + Coordenador       │ [Usar]│   │
│  │ Split Captacao/Fecham.  │ Split      │ Divisao 40/60               │ [Usar]│   │
│  │ Residual por Placa      │ Residual   │ Valor fixo por placa        │ [Usar]│   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### Modal: Usar Template

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  CRIAR REGRA A PARTIR DE TEMPLATE                                          [X]     │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  Template: Comissao Simples                                                         │
│  Descricao: Percentual fixo sobre valor da venda                                   │
│                                                                                     │
│  DADOS DA NOVA REGRA                                                                │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Codigo*: [REG-COM-___    ]   Nome*: [_________________________________]    │   │
│  │ Modulo*: [CRM-FIN ▼]                                                       │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  PARAMETROS CONFIGURAVEIS                                                           │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Percentual de Comissao*: [____] %                                          │   │
│  │                                                                             │   │
│  │ [ ] Aplicar apenas para planos especificos                                 │   │
│  │     Planos: [_______________________________________]                      │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  PREVIEW DA FORMULA                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ VALOR_VENDA × {PERCENTUAL}                                                 │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│                                              [Cancelar] [Criar Regra]              │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### Modal: Clonar Regra

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  CLONAR REGRA                                                              [X]     │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  Regra Original: REG-COM-001 - Comissao Plano Basico                               │
│  Status: ATIVA | Versao: 3                                                         │
│                                                                                     │
│  DADOS DO CLONE                                                                     │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ Novo Codigo*: [REG-COM-___    ]                                            │   │
│  │ Novo Nome*:   [Comissao Plano Basico (copia)                          ]    │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  O QUE SERA COPIADO:                                                                │
│  ┌─────────────────────────────────────────────────────────────────────────────┐   │
│  │ [✓] Variaveis (3)                                                          │   │
│  │ [✓] Condicoes (2)                                                          │   │
│  │ [✓] Formula                                                                │   │
│  │ [✓] Faixas/Configuracoes especificas                                       │   │
│  │ [ ] Vigencia (clone inicia sem vigencia)                                   │   │
│  └─────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                     │
│  Nota: Clone sera criado com status RASCUNHO                                       │
│                                                                                     │
│                                              [Cancelar] [Criar Clone]              │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

---

## Regras de Negocio

| Codigo | Regra | Validacao |
|--------|-------|-----------|
| RN-MTR-020 | Clone inicia rascunho | Clone sempre inicia com status RASCUNHO |
| RN-MTR-021 | Codigo unico no clone | Clone deve ter codigo diferente da origem |
| RN-MTR-022 | Rastreabilidade | Sistema registra origem (template ou regra clonada) |
| RN-MTR-023 | Template ativo | Apenas templates ativos aparecem no catalogo |
| RN-MTR-024 | Parametros obrigatorios | Campos marcados no template devem ser preenchidos |

---

## Modelo de Dados

```sql
-- Tabela de Templates
CREATE TABLE mtr_template (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    categoria VARCHAR(50) NOT NULL,
    tipo_regra VARCHAR(20) NOT NULL,
    regra_base_json JSONB NOT NULL,
    params_configuraveis_json JSONB,
    destaque BOOLEAN DEFAULT FALSE,
    ativo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP NOT NULL DEFAULT NOW(),
    criado_por UUID NOT NULL
);

-- Adicionar coluna de origem na tabela de regras
ALTER TABLE mtr_regra ADD COLUMN origem_tipo VARCHAR(20); -- MANUAL, TEMPLATE, CLONE
ALTER TABLE mtr_regra ADD COLUMN origem_id UUID;
ALTER TABLE mtr_regra ADD COLUMN origem_nome VARCHAR(100);
```

---

## Cenarios de Teste

### CT-001: Criar Regra de Template

```gherkin
Dado que estou no catalogo de templates
Quando clico em "Usar Template" do "Comissao Simples"
E preencho codigo "REG-COM-010"
E preencho nome "Comissao Nova"
E preencho percentual "6"
E clico em "Criar Regra"
Entao regra e criada com status RASCUNHO
E regra tem origem_tipo = "TEMPLATE"
```

### CT-002: Clonar Regra Existente

```gherkin
Dado que existe regra REG-COM-001 ativa
Quando clico em "Clonar" na regra
E preencho novo codigo "REG-COM-011"
E preencho novo nome "Comissao Clone"
E clico em "Criar Clone"
Entao clone e criado com status RASCUNHO
E clone tem mesmas variaveis/formula/condicoes
E clone tem origem_tipo = "CLONE"
E clone tem origem_id = id da REG-COM-001
```

---

## Dependencias

- **Depende de**: US-CRM-MTR-001 (Regras Basicas)
- **Dependentes**: Nenhum

---

## Estimativa

| Componente | Story Points |
|------------|-------------|
| Backend: CRUD Templates | 3 |
| Backend: Criar de Template | 3 |
| Backend: Clonar Regra | 2 |
| Frontend: Catalogo | 3 |
| Frontend: Modais | 2 |
| **TOTAL** | **13** |

---

## Historico de Alteracoes

| Versao | Data | Autor | Alteracao |
|--------|------|-------|-----------|
| 1.0 | 29/01/2026 | PO | Criacao inicial |
