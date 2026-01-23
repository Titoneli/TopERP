# 📋 PROCEDIMENTOS - TopERP CRM

> **📌 Este é o arquivo ÚNICO de procedimentos de desenvolvimento do projeto TopERP CRM.**  
> Última atualização: 23/01/2026  
> Metodologia: Domain-Driven Design (DDD)

---

## 📑 Índice

1. [Visão Geral](#-visão-geral)
2. [Padrão de Commits (Obrigatório)](#-padrão-de-commits-obrigatório)
3. [Regras de Desenvolvimento DDD](#-regras-de-desenvolvimento-ddd)
4. [Fluxo de Desenvolvimento](#-fluxo-de-desenvolvimento)
5. [Checklist DDD](#-checklist-ddd)
6. [Bounded Contexts e Escopos](#-bounded-contexts-e-escopos)
7. [Decisões Arquiteturais (ADRs)](#-decisões-arquiteturais-adrs)
8. [Erros Solucionados](#-erros-solucionados)
9. [Comandos Úteis](#-comandos-úteis)
10. [Referências](#-referências)

---

## 🎯 Visão Geral

O TopERP CRM é desenvolvido seguindo os princípios de **Domain-Driven Design (DDD)**, com foco em:

- **Bounded Contexts** bem definidos
- **Ubiquitous Language** (Linguagem Ubíqua)
- **Aggregates** como unidades de consistência
- **Domain Events** para comunicação entre contextos
- **CQRS** para leitura otimizada

### Documentos de Referência

| Documento | Localização | Descrição |
|-----------|-------------|-----------|
| Context Map | `docs/ddd/context-map.md` | Mapa de contextos e relacionamentos |
| Product Backlog | `docs/backlog/product-backlog.md` | Backlog priorizado |
| Glossário | `docs/glossario/glossario.md` | Termos e definições do domínio |
| Roadmap | `docs/releases/roadmap.md` | Planejamento de releases |

---

## 📝 Padrão de Commits (OBRIGATÓRIO)

### ⚠️ Todo commit DEVE seguir o padrão Conventional Commits

### Formato Obrigatório

```
<tipo>(<bounded-context>): <descrição>

[corpo opcional]

[rodapé opcional]
```

### Tipos Permitidos

| Tipo | Emoji | Descrição | Exemplo |
|------|-------|-----------|---------|
| `feat` | ⭐ | Nova funcionalidade | `feat(crm-led): adicionar captação via WhatsApp` |
| `fix` | 🐛 | Correção de bug | `fix(crm-pag): corrigir cálculo de parcelas` |
| `refactor` | 🔧 | Refatoração | `refactor(crm-cot): extrair Value Object Preco` |
| `docs` | 📝 | Documentação | `docs(crm-vis): atualizar User Stories` |
| `style` | 🎨 | Estilo/formatação | `style(crm-das): ajustar cores do dashboard` |
| `perf` | 🚀 | Otimização | `perf(crm-rel): implementar Materialized View` |
| `test` | ✅ | Testes | `test(crm-ana): adicionar testes de Aggregate` |
| `chore` | 📦 | Manutenção | `chore: atualizar dependências` |
| `ci` | 🔄 | CI/CD | `ci: configurar GitHub Actions` |

### Escopos por Bounded Context

| Escopo | Bounded Context | Tipo |
|--------|-----------------|------|
| `crm-aut` | Autenticação | Generic |
| `crm-cad` | Cadastros Básicos | Supporting |
| `crm-led` | Leads | **Core** |
| `crm-cot` | Cotações | **Core** |
| `crm-fun` | Funil de Leads | **Core** |
| `crm-pro` | Propostas | **Core** |
| `crm-pag` | Pagamentos | **Core** |
| `crm-vis` | Vistorias | **Core** |
| `crm-ana` | Análise | **Core** |
| `crm-tar` | Tarefas & Agendas | Supporting |
| `crm-com` | Comissionamento | Supporting |
| `crm-app` | App Consultor | Supporting |
| `crm-cap` | Captação & Follow-Up | Supporting |
| `crm-ass` | Assinatura Digital | Supporting |
| `crm-pos` | Pós-Venda | Supporting |
| `crm-das` | Dashboard | CQRS Read |
| `crm-rel` | Relatórios | CQRS Read |
| `crm-aud` | Auditoria | Generic |
| `shared` | Shared Kernel | Compartilhado |

### Regras

1. ✅ **Tipo em minúsculas**: `feat`, não `Feat` ou `FEAT`
2. ✅ **Escopo = Bounded Context**: Usar o código do contexto
3. ✅ **Sem ponto final**: `adicionar filtro`, não `adicionar filtro.`
4. ✅ **Modo imperativo**: `adicionar`, não `adicionado` ou `adicionando`
5. ✅ **Máximo 100 caracteres** no header
6. ✅ **Um commit por alteração** atômica no domínio

### Exemplos Corretos ✅

```bash
feat(crm-led): implementar captação multicanal de leads
feat(crm-cot): adicionar cálculo de preço por tabela FIPE
fix(crm-pag): corrigir integração com banco digital para PIX
refactor(crm-pro): extrair Aggregate PropostaComercial
docs(crm-vis): documentar Domain Events de vistoria
test(crm-ana): adicionar testes para regras de aprovação
style(crm-das): implementar tema visual do dashboard
perf(crm-rel): criar Materialized View para KPIs mensais
chore(shared): atualizar entidades do Shared Kernel
```

### Exemplos Incorretos ❌

```bash
# ❌ Escopo genérico demais
feat(api): adicionar endpoint

# ❌ Fora do padrão de escopos
feat(leads): nova funcionalidade

# ❌ Mistura múltiplos contextos
feat(crm-led,crm-cot): adicionar funcionalidades

# ❌ Commit gigante
feat(crm-led): implementar captação, validação, persistência e notificação
```

### 🎯 Boas Práticas: Commits Atômicos por Domínio

> **⚠️ REGRA**: Um commit = Uma mudança atômica em um Bounded Context

#### Por que commits atômicos?

| Vantagem | Descrição DDD |
|----------|---------------|
| 📖 **Rastreabilidade** | Histórico claro por Bounded Context |
| 🔍 **Auditoria** | Fácil identificar mudanças no domínio |
| ⏪ **Reversão precisa** | Reverter apenas um contexto específico |
| 🧩 **Isolamento** | Mudanças não vazam entre contextos |

---

## ⚠️ Regras de Desenvolvimento DDD

### ✅ Obrigatório

| Regra | Descrição | Conceito DDD |
|-------|-----------|--------------|
| 📝 **Usar Ubiquitous Language** | Termos do glossário no código | Linguagem Ubíqua |
| 📦 **Respeitar Bounded Contexts** | Não acessar diretamente outros contextos | Fronteiras |
| 🎯 **Aggregate como unidade** | Persistir Aggregate Root completo | Aggregate |
| 📨 **Domain Events entre contextos** | Comunicação via eventos, não chamadas diretas | Event-Driven |
| 🛡️ **ACL para sistemas externos** | Adapters para APIs externas | Anti-Corruption Layer |
| 📖 **Consultar User Stories** | Verificar requisitos antes de implementar | Product Backlog |
| ✔️ **Validar no domínio** | Regras de negócio nos Aggregates/Entities | Rich Domain Model |

### ❌ Proibido

| Proibição | Motivo | Conceito DDD |
|-----------|--------|--------------|
| 🚫 **Acesso direto entre contextos** | Viola fronteiras | Bounded Context |
| 🚫 **Lógica de negócio em controllers** | Anemia no modelo | Rich Domain Model |
| 🚫 **CRUD direto no banco** | Ignora invariantes | Aggregate |
| 🚫 **Compartilhar Entities entre contextos** | Acoplamento forte | Shared Kernel controlado |
| 🚫 **Ignorar Domain Events** | Perde rastreabilidade | Event Sourcing |
| 🚫 **Implementar sem User Story** | Fora do escopo aprovado | Product Backlog |

---

## 🔄 Fluxo de Desenvolvimento

### Ciclo Completo

```
┌──────────────────────────────────────────────────────────────────────────┐
│  1. CONSULTAR  →  2. MODELAR  →  3. IMPLEMENTAR  →  4. TESTAR  →  5. COMMIT │
│     (US/DDD)       (Domínio)      (Código)          (Agregados)    (Push)    │
└──────────────────────────────────────────────────────────────────────────┘
```

### 1️⃣ ANTES de começar (Consultar)

**⚠️ OBRIGATÓRIO: Verificações antes de iniciar qualquer desenvolvimento**

```
□ Qual User Story estou implementando? (US-CRM-XXX-NNN)
□ A qual Bounded Context pertence?
□ Consultei o Context Map para entender relacionamentos?
□ Consultei o Glossário para usar termos corretos?
□ Há decisões arquiteturais (ADRs) que afetam esta tarefa?
□ Verifiquei erros similares já solucionados?
```

### 2️⃣ DURANTE o desenvolvimento (Modelar + Implementar)

**📝 Manter durante todo o desenvolvimento:**

```
□ Estou usando a Ubiquitous Language do glossário?
□ O Aggregate Root está gerenciando as invariantes?
□ Os Domain Events estão sendo publicados?
□ As validações estão no domínio (não no controller)?
□ Preciso de ACL para integração externa?
```

### 3️⃣ APÓS finalizar (Testar + Commit)

```
□ Testes do Aggregate cobrem as invariantes?
□ Domain Events estão sendo capturados?
□ A mensagem de commit segue o padrão?
□ O escopo do commit é o Bounded Context correto?
□ É um commit atômico (uma mudança)?
```

---

## ✅ Checklist DDD

### Checklist por Tipo de Tarefa

#### 🆕 Nova Funcionalidade (feat)

```markdown
□ User Story identificada: US-CRM-___-___
□ Bounded Context: CRM-___
□ Aggregate Root envolvido: _______________
□ Domain Events a publicar:
  □ ____________________
  □ ____________________
□ Integrações necessárias (ACL):
  □ ____________________
□ Contextos downstream afetados:
  □ ____________________
```

#### 🐛 Correção de Bug (fix)

```markdown
□ Bug afeta qual Bounded Context: CRM-___
□ Aggregate com problema: _______________
□ Invariante violada: _______________
□ Teste de regressão adicionado: □ Sim □ Não
□ Documentar na seção "Erros Solucionados": □ Sim
```

#### 🔧 Refatoração (refactor)

```markdown
□ Motivo da refatoração: _______________
□ Bounded Context afetado: CRM-___
□ Mudança de modelo de domínio: □ Sim □ Não
□ Se sim, atualizar:
  □ Context Map
  □ Glossário
  □ User Stories relacionadas
□ Testes passando após refatoração: □ Sim
```

---

## 🗺️ Bounded Contexts e Escopos

### Contextos Core (Prioridade Alta)

| Contexto | Aggregate Root | Principais Domain Events |
|----------|----------------|-------------------------|
| **CRM-LED** | `Lead` | `LeadCaptado`, `LeadQualificado` |
| **CRM-COT** | `Cotacao` | `CotacaoCriada`, `CotacaoEnviada` |
| **CRM-FUN** | `Negociacao` | `NegociacaoIniciada`, `EtapaAvancada` |
| **CRM-PRO** | `Proposta` | `PropostaGerada`, `PropostaAceita` |
| **CRM-PAG** | `Pagamento` | `PagamentoConfirmado`, `PagamentoFalhou` |
| **CRM-VIS** | `Vistoria` | `VistoriaAgendada`, `VistoriaRealizada` |
| **CRM-ANA** | `Analise` | `AnaliseAprovada`, `AnaliseReprovada` |

### Contextos Supporting

| Contexto | Responsabilidade |
|----------|------------------|
| **CRM-CAD** | CRUD de Planos, Serviços, Tabelas FIPE |
| **CRM-TAR** | Gestão de tarefas e calendário |
| **CRM-COM** | Cálculo de comissões |
| **CRM-CAP** | Captação multicanal |
| **CRM-ASS** | Assinatura digital de contratos |
| **CRM-POS** | Acompanhamento pós-venda |
| **CRM-APP** | App mobile para consultores |

### Contextos CQRS (Read-Only)

| Contexto | Uso |
|----------|-----|
| **CRM-DAS** | Dashboard consolidado |
| **CRM-REL** | Relatórios e KPIs |

### Shared Kernel

```
COR_PESSOA  →  COR_CLIENTE  →  COR_VEICULO
```

Entidades compartilhadas entre CRM e TopERP Core.

---

## 📋 Decisões Arquiteturais (ADRs)

> Registre aqui decisões arquiteturais importantes.

### ADR-001: Padrão de Commits por Bounded Context

| Campo | Valor |
|-------|-------|
| **Data** | 23/01/2026 |
| **Status** | Aprovado |
| **Contexto** | Necessidade de rastreabilidade por domínio |
| **Decisão** | Adotar Conventional Commits com escopo = Bounded Context |
| **Consequência** | Histórico git organizado por contexto |

### ADR-002: CQRS para Dashboard e Relatórios

| Campo | Valor |
|-------|-------|
| **Data** | 22/01/2026 |
| **Status** | Aprovado |
| **Contexto** | Queries complexas impactam performance de escrita |
| **Decisão** | Implementar Read Models separados com Materialized Views |
| **Consequência** | CRM-DAS e CRM-REL consomem eventos e mantêm views |

### ADR-003: ACL para Integrações Externas

| Campo | Valor |
|-------|-------|
| **Data** | 22/01/2026 |
| **Status** | Aprovado |
| **Contexto** | Sistemas externos (FIPE, Banco, SGA) têm modelos diferentes |
| **Decisão** | Implementar Anti-Corruption Layer com Adapters |
| **Consequência** | Domínio protegido de mudanças externas |

---

## 🐛 Erros Solucionados

> Quando resolver um bug, documente aqui para referência futura.

| Data | Bounded Context | Erro | Causa | Solução |
|------|-----------------|------|-------|---------|
| - | - | - | - | - |

### Template para Novo Erro

```markdown
| DD/MM/AAAA | CRM-XXX | Descrição do erro | Causa raiz identificada | Como foi resolvido |
```

---

## 🔧 Comandos Úteis

### Git (Padrão de Commits)

```bash
# Verificar status
git status --short

# Commit seguindo padrão DDD
git commit -m "feat(crm-led): implementar captação via WhatsApp"

# Ver histórico por contexto
git log --oneline --grep="crm-led"

# Ver histórico formatado
git log --oneline -10
```

### Desenvolvimento

```bash
# Rodar testes de um Bounded Context específico
npm test -- --grep="CRM-LED"

# Verificar lint
npm run lint

# Build
npm run build
```

### Banco de Dados (CQRS)

```sql
-- Refresh de Materialized View (CRM-DAS/CRM-REL)
REFRESH MATERIALIZED VIEW mv_dashboard_kpis;
REFRESH MATERIALIZED VIEW mv_relatorio_conversao;
```

---

## 📚 Referências

### Documentação do Projeto

| Documento | Caminho |
|-----------|---------|
| Context Map | [docs/ddd/context-map.md](docs/ddd/context-map.md) |
| Product Backlog | [docs/backlog/product-backlog.md](docs/backlog/product-backlog.md) |
| Glossário | [docs/glossario/glossario.md](docs/glossario/glossario.md) |
| Roadmap | [docs/releases/roadmap.md](docs/releases/roadmap.md) |
| Visão do Produto | [docs/visao-produto-crm.md](docs/visao-produto-crm.md) |

### Histórias de Usuário por Contexto

| Contexto | README |
|----------|--------|
| CRM-AUT | [docs/historias-usuario/CRM-Autenticacao/README.md](docs/historias-usuario/CRM-Autenticacao/README.md) |
| CRM-LED | [docs/historias-usuario/CRM-Leads/README.md](docs/historias-usuario/CRM-Leads/README.md) |
| CRM-COT | [docs/historias-usuario/CRM-Cotacoes/README.md](docs/historias-usuario/CRM-Cotacoes/README.md) |
| CRM-FUN | [docs/historias-usuario/CRM-Funil-Vendas/README.md](docs/historias-usuario/CRM-Funil-Vendas/README.md) |

---

## 📜 Histórico de Atualizações

| Data | Tipo | Descrição | Autor |
|------|------|-----------|-------|
| 23/01/2026 | feat | Criação do documento adaptado para DDD | Product Owner |

---

> **📌 Lembre-se**: Este arquivo é a fonte única de verdade para procedimentos de desenvolvimento do TopERP CRM.  
> Sempre consulte aqui e o Context Map antes de desenvolver.
