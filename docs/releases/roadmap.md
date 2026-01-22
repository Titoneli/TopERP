# Planejamento de Releases - TopERP

| Metadado | Valor |
|----------|-------|
| **Versão** | 2.0 |
| **Data** | 22/01/2026 |
| **Autor** | Product Owner |
| **Metodologia** | Domain-Driven Design |

---

## Visão Geral

Este documento apresenta o planejamento de releases do TopERP, incluindo o módulo CRM com estrutura baseada em Domain-Driven Design (DDD).

---

## Roadmap Geral

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           ROADMAP TOPIERP 2026                                  │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  Q1/2026              Q2/2026              Q3/2026              Q4/2026         │
│     │                    │                    │                    │            │
│     ▼                    ▼                    ▼                    ▼            │
│  ┌─────────┐         ┌─────────┐         ┌─────────┐         ┌─────────┐       │
│  │  v1.0   │         │  v2.0   │         │  v3.0   │         │  v4.0   │       │
│  │   MVP   │─────────│  Core   │─────────│ Advanced│─────────│  Full   │       │
│  │         │         │  Funil  │         │  Tools  │         │  Suite  │       │
│  └─────────┘         └─────────┘         └─────────┘         └─────────┘       │
│                                                                                 │
│  CRM-AUT              CRM-PRO              CRM-TAR              CRM-APP         │
│  CRM-LED              CRM-PAG              CRM-CAP              CRM-DAS         │
│  CRM-COT              CRM-VIS              CRM-ASS              CRM-REL         │
│  CRM-FUN              CRM-ANA              CRM-COM              CRM-POS         │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Release 1.0 - MVP (CRM Base)

**Data Prevista**: Q1/2026 (Março)  
**Objetivo**: Estabelecer a base do CRM com autenticação, leads, cotações e funil básico

### Bounded Contexts v1.0

| Código | Bounded Context | Tipo | Status |
|--------|-----------------|------|--------|
| CRM-AUT | Autenticação | Generic | ✅ Documentado |
| CRM-LED | Leads | Core | ✅ Documentado |
| CRM-COT | Cotações | Core | ⚠️ Parcial |
| CRM-FUN | Funil de Leads | Core | ⚠️ Parcial |
| CRM-CAD | Cadastros Básicos | Supporting | 📋 Planejado |

### User Stories v1.0

| ID | Título | Contexto | Pontos |
|----|--------|----------|--------|
| US-CRM-AUT-001 | Login no sistema | CRM-AUT | 5 |
| US-CRM-AUT-002 | Logout do sistema | CRM-AUT | 2 |
| US-CRM-LED-001 | Cadastrar novo lead | CRM-LED | 8 |
| US-CRM-LED-002 | Listar leads | CRM-LED | 5 |
| US-CRM-LED-003 | Visualizar dashboard de leads | CRM-LED | 13 |
| US-CRM-COT-001 | Criar cotação para lead | CRM-COT | 8 |
| US-CRM-FUN-001 | Visualizar funil de vendas | CRM-FUN | 13 |

### Critérios de Aceite da Release
- [ ] Autenticação JWT funcional
- [ ] CRUD completo de leads
- [ ] Cotação vinculada a lead
- [ ] Funil básico visualizável
- [ ] Integração com banco PostgreSQL

---

## Release 2.0 - Core Funil

**Data Prevista**: Q2/2026 (Junho)  
**Objetivo**: Implementar o fluxo completo do funil de vendas

### Bounded Contexts v2.0

| Código | Bounded Context | Tipo | Status |
|--------|-----------------|------|--------|
| CRM-PRO | Propostas | Core | 📋 Planejado |
| CRM-PAG | Pagamentos | Core | 📋 Planejado |
| CRM-VIS | Vistorias | Core | 📋 Planejado |
| CRM-ANA | Análise | Core | 📋 Planejado |

### User Stories v2.0

| ID | Título | Contexto | Pontos |
|----|--------|----------|--------|
| US-CRM-PRO-001 | Gerar proposta de cotação | CRM-PRO | 8 |
| US-CRM-PRO-003 | Enviar proposta por email | CRM-PRO | 5 |
| US-CRM-PAG-001 | Gerar PIX para proposta | CRM-PAG | 8 |
| US-CRM-PAG-003 | Confirmar pagamento automático | CRM-PAG | 13 |
| US-CRM-VIS-001 | Agendar vistoria | CRM-VIS | 8 |
| US-CRM-VIS-005 | Emitir laudo de vistoria | CRM-VIS | 8 |
| US-CRM-ANA-005 | Aprovar análise | CRM-ANA | 8 |
| US-CRM-ANA-007 | Concretizar negociação | CRM-ANA | 5 |

### Critérios de Aceite da Release
- [ ] Fluxo completo Proposta → Pagamento → Vistoria → Análise
- [ ] Integração com banco digital (PIX/Boleto)
- [ ] Vistoria com checklist e fotos
- [ ] Análise documental funcional
- [ ] Concretização de negociação

---

## Release 3.0 - Advanced Tools

**Data Prevista**: Q3/2026 (Setembro)  
**Objetivo**: Ferramentas avançadas de gestão e produtividade

### Bounded Contexts v3.0

| Código | Bounded Context | Tipo | Status |
|--------|-----------------|------|--------|
| CRM-TAR | Tarefas & Agendas | Supporting | 📋 Planejado |
| CRM-CAP | Captação & Follow-Up | Supporting | 📋 Planejado |
| CRM-ASS | Assinatura Digital | Supporting | 📋 Planejado |
| CRM-COM | Comissionamento | Supporting | 📋 Planejado |

### User Stories v3.0

| ID | Título | Contexto | Pontos |
|----|--------|----------|--------|
| US-CRM-TAR-001 | Criar tarefa | CRM-TAR | 5 |
| US-CRM-TAR-002 | Agendar compromisso | CRM-TAR | 5 |
| US-CRM-CAP-001 | Captar lead via WhatsApp | CRM-CAP | 8 |
| US-CRM-CAP-002 | Configurar follow-up automático | CRM-CAP | 8 |
| US-CRM-ASS-001 | Assinar documento digitalmente | CRM-ASS | 13 |
| US-CRM-COM-001 | Calcular comissão de venda | CRM-COM | 8 |
| US-CRM-COM-002 | Gerar relatório de comissões | CRM-COM | 5 |

### Critérios de Aceite da Release
- [ ] Gestão de tarefas e agenda
- [ ] Captação multicanal (8 canais)
- [ ] Assinatura digital integrada
- [ ] Cálculo automático de comissões

---

## Release 4.0 - Full Suite

**Data Prevista**: Q4/2026 (Dezembro)  
**Objetivo**: Suite completa com mobile, dashboards avançados e pós-venda

### Bounded Contexts v4.0

| Código | Bounded Context | Tipo | Status |
|--------|-----------------|------|--------|
| CRM-APP | App Consultor (Mobile) | Supporting | 📋 Planejado |
| CRM-DAS | Dashboard | CQRS Read | 📋 Planejado |
| CRM-REL | Relatórios | CQRS Read | 📋 Planejado |
| CRM-POS | Pós-Venda | Supporting | 📋 Planejado |
| CRM-AUD | Auditoria | Generic | 📋 Planejado |

### User Stories v4.0

| ID | Título | Contexto | Pontos |
|----|--------|----------|--------|
| US-CRM-APP-001 | Acessar CRM via mobile | CRM-APP | 13 |
| US-CRM-DAS-001 | Visualizar resumo do funil | CRM-DAS | 8 |
| US-CRM-DAS-004 | Ver ranking de consultores | CRM-DAS | 5 |
| US-CRM-REL-001 | Gerar relatório de vendas | CRM-REL | 8 |
| US-CRM-POS-001 | Enviar boas-vindas automático | CRM-POS | 5 |
| US-CRM-POS-003 | Enviar pesquisa NPS | CRM-POS | 5 |
| US-CRM-AUD-001 | Consultar log de ações | CRM-AUD | 8 |

### Critérios de Aceite da Release
- [ ] App mobile funcional
- [ ] Dashboard em tempo real (CQRS)
- [ ] Relatórios completos
- [ ] Fluxo de pós-venda com NPS
- [ ] Auditoria completa de ações

---

## Roadmap Visual - Bounded Contexts

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                    BOUNDED CONTEXTS POR RELEASE                                 │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│         v1.0                v2.0                v3.0                v4.0        │
│      ┌───────┐           ┌───────┐           ┌───────┐           ┌───────┐     │
│      │CRM-AUT│           │CRM-PRO│           │CRM-TAR│           │CRM-APP│     │
│      │CRM-LED│───────────│CRM-PAG│───────────│CRM-CAP│───────────│CRM-DAS│     │
│      │CRM-COT│           │CRM-VIS│           │CRM-ASS│           │CRM-REL│     │
│      │CRM-FUN│           │CRM-ANA│           │CRM-COM│           │CRM-POS│     │
│      │CRM-CAD│           │       │           │       │           │CRM-AUD│     │
│      └───────┘           └───────┘           └───────┘           └───────┘     │
│                                                                                 │
│      Tipo:                Tipo:                Tipo:                Tipo:       │
│      Generic(1)           Core(4)              Supporting(4)       Mixed(5)    │
│      Core(3)                                                       - CQRS(2)   │
│      Supporting(1)                                                 - Support(2)│
│                                                                    - Generic(1)│
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Releases ERP (Legado - Mantido)

### Release 1.0 - MVP ERP

**Data Prevista**: Março/2026  
**Objetivo**: Lançar funcionalidades básicas para operação mínima

| Módulo | Funcionalidades |
|--------|-----------------|
| EST | Cadastro de produtos, Movimentação básica |
| VEN | Cadastro de clientes, Pedido de venda |
| FIN | Contas a receber básico |
| Base | Cadastros auxiliares, Usuários, Permissões |

### Critérios de Aceite da Release
- [ ] Todas as histórias do MVP implementadas
- [ ] Zero bugs críticos
- [ ] Performance dentro dos requisitos
- [ ] Documentação de usuário disponível
- [ ] Treinamento básico realizado

---

## Release 1.1 - Vendas Completo

**Data Prevista**: Junho/2026  
**Objetivo**: Completar módulo de vendas com NF-e

### Escopo

| Módulo | Funcionalidades |
|--------|-----------------|
| VEN | Orçamentos, NF-e, Comissões |
| FIN | Contas a receber completo, Relatórios |
| EST | Consultas avançadas |

### Critérios de Aceite da Release
- [ ] Emissão de NF-e homologada na SEFAZ
- [ ] Integração com estoque validada
- [ ] Relatórios fiscais disponíveis

---

## Release 1.2 - Compras

**Data Prevista**: Setembro/2026  
**Objetivo**: Implementar módulo de compras completo

### Escopo

| Módulo | Funcionalidades |
|--------|-----------------|
| COM | Cadastro de fornecedores, Pedidos, Cotações |
| EST | Entrada de mercadorias, Inventário |
| FIN | Contas a pagar |

### Critérios de Aceite da Release
- [ ] Fluxo completo de compras funcional
- [ ] Integração com financeiro validada
- [ ] Entrada de NF-e implementada

---

## Release 2.0 - Full

**Data Prevista**: Dezembro/2026  
**Objetivo**: Sistema completo com todos os módulos core

### Escopo

| Módulo | Funcionalidades |
|--------|-----------------|
| PRD | Estrutura de produtos, Ordens de produção |
| CRM | Gestão de oportunidades |
| CON | Integração contábil básica |
| ALL | Relatórios avançados, Dashboards |

---

## Métricas de Acompanhamento

| Métrica | Meta | Atual |
|---------|------|-------|
| Velocity média | 40 pts/sprint | - |
| Bug escape rate | < 5% | - |
| Cobertura de testes | > 80% | - |
| Satisfação do usuário | > 4.0/5.0 | - |

---

## Riscos do Roadmap

| Risco | Probabilidade | Impacto | Mitigação |
|-------|---------------|---------|-----------|
| Atraso na homologação NF-e | Média | Alto | Iniciar homologação antecipada |
| Mudança de requisitos | Alta | Médio | Sprints de descoberta |
| Recursos insuficientes | Média | Alto | Buffer de 20% no planejamento |
| Integração banco digital | Média | Alto | POC antecipada |
| Complexidade DDD | Média | Médio | Treinamento da equipe |

---

## Referências DDD

- [Context Map](../ddd/context-map.md)
- [Product Backlog](../backlog/product-backlog.md)
- [Glossário](../glossario/glossario.md)

---

**Última Atualização**: 22 de janeiro de 2026  
**Versão**: 2.0  
**Aprovado por**: Product Owner
