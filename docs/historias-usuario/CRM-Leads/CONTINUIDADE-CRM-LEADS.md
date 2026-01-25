# ACOMPANHAMENTO DE CONTINUIDADE — Módulo CRM-Leads

**Última Atualização**: 25 de janeiro de 2026  
**Status**: Em Desenvolvimento  
**Versão**: 2.1

---

## 📍 CHECKPOINT ATUAL

Sabemos **exatamente onde paramos**:

```
Sprint Atual: Sprint 2 - Fase 2 Captura Avançada (COMPLETA)
Histórias Prontas para Dev: LEAD-001 a LEAD-006 (65 SP)
Próximas: LEAD-007 a LEAD-011 (Fase 3 - Gestão Avançada + Ads)
Status: ✅ Fase 2 Especificada (25/01/2026)
```

---

## 📊 MAPA DE PROGRESSO — CRM-Leads

### Fase 1: CAPTAÇÃO E COMPARAÇÃO (✅ COMPLETA)

| ID | Histórias | Status | Versão | SP | PDF | Notas |
|----|-----------|---------|-----------|----|-----|----|
| **LEAD-001** | Captação de Lead via Landing Page | ✅ Pronto | v1.0 | 13 | ✅ | 3-step form, 12 códigos origem, DDD extract |
| **LEAD-002** | Comparativo de Planos de Proteção | ✅ Pronto | v1.1 | 13 | ✅ | 3 colunas, 18 termos ajustados |
| **LEAD-003** | Dashboard de Leads e Analytics | ✅ Pronto | v1.1 | 13 | ✅ | 10 métricas de conversão, análise por DDD/origem |

**Subtotal Fase 1**: 39 SP | 21 Cenários de Aceitação

---

### Fase 2: CAPTURA AVANÇADA (✅ ESPECIFICADA)

| ID | Histórias | Status | Versão | SP | PDF | Notas |
|----|-----------|--------|--------|----|-----|-------|
| **LEAD-004** | Captura via Formulário Embarcado | ✅ Pronto | v1.0 | 8 | ⏳ | iframe/widget, token parceiro, CORS |
| **LEAD-005** | Captura via WhatsApp Business | ✅ Pronto | v1.0 | 13 | ⏳ | Chatbot, webhook Meta, fluxo BANT |
| **LEAD-006** | Qualificar Lead (BANT) | ✅ Pronto | v1.0 | 5 | ⏳ | Score 0-12, temperatura FRIO/MORNO/QUENTE |

**Subtotal Fase 2**: 26 SP | Status: **✅ Especificação Completa**

---

### Fase 3: GESTÃO AVANÇADA E INTEGRAÇÕES ADS (⏳ NÃO INICIADA)

| ID | Histórias | Status | SP | Prioridade | Dependências |
|----|-----------|--------|----|-----------|--------------|
| **LEAD-007** | Importar Leads em Massa (CSV/Excel/API) | 📋 Planejado | 8 | Importante | LEAD-001 |
| **LEAD-008** | Marcar Lead como Arquivado | 📋 Planejado | 3 | Importante | LEAD-001 |
| **LEAD-009** | Exportar Leads | 📋 Planejado | 5 | Importante | LEAD-001 |
| **LEAD-010** | Integração Facebook Lead Ads | 📋 Planejado | 13 | Importante | LEAD-001, Webhook Meta |
| **LEAD-011** | Integração Google Ads | 📋 Planejado | 13 | Importante | LEAD-001, API Google |

**Subtotal Fase 3**: 42 SP | Status: **Aguardando Especificação**

---

### Fase 4: GESTÃO DE LEADS (⏳ NÃO INICIADA)

| ID | Histórias | Status | SP | Prioridade | Dependências |
|----|-----------|--------|----|-----------|--------------| 
| **LEAD-012** | Cadastrar Lead Manualmente | 📋 Planejado | 8 | Essencial | LEAD-001 |
| **LEAD-013** | Visualizar Lista de Leads | 📋 Planejado | 5 | Essencial | LEAD-001, LEAD-012 |
| **LEAD-014** | Buscar e Filtrar Leads | 📋 Planejado | 5 | Essencial | LEAD-013 |
| **LEAD-015** | Atribuir Lead a Consultor | 📋 Planejado | 5 | Essencial | LEAD-013 |
| **LEAD-016** | Editar Dados do Lead | 📋 Planejado | 5 | Essencial | LEAD-012, LEAD-013 |
| **LEAD-017** | Visualizar Detalhes do Lead | 📋 Planejado | 5 | Essencial | LEAD-013 |

**Subtotal Fase 4**: 33 SP | Status: **Aguardando Especificação**

---

### Fase 5: INTEGRAÇÕES E INTELIGÊNCIA (⏳ NÃO INICIADA)

| ID | Histórias | Status | SP | Prioridade | Dependências |
|----|-----------|--------|----|-----------|----|
| **LEAD-018** | Enriquecimento de Dados (APIs externas) | 📋 Planejado | 8 | Desejável | Integrações externas |
| **LEAD-019** | Score Automático de Lead | 📋 Planejado | 8 | Desejável | ML Engine |
| **LEAD-020** | Detecção de Lead Duplicado | 📋 Planejado | 5 | Desejável | LEAD-001 |

**Subtotal Fase 5**: 21 SP | Status: **Backlog Futuro**

---

## 🎯 RESUMO POR PRIORIDADE

### Essencial (Must-Have)
```
✅ LEAD-001 (v1.0) — Pronto para Dev
✅ LEAD-002 (v1.1) — Pronto para Dev
✅ LEAD-003 (v1.1) — Pronto para Dev
📋 LEAD-012 até LEAD-017 — Gestão de Leads (Fase 4) - Aguardando
🎯 Total: 9 histórias | 72 SP (39 prontos + 33 planejados)
```

### Importante (Should-Have)
```
✅ LEAD-004 (v1.0) — Formulário Embarcado - ESPECIFICADO
✅ LEAD-005 (v1.0) — WhatsApp Business - ESPECIFICADO
✅ LEAD-006 (v1.0) — Qualificar BANT - ESPECIFICADO
📋 LEAD-007 até LEAD-011 — Gestão Avançada + Integrações Ads (Fase 3) - Pendente
🎯 Total: 8 histórias | 68 SP (26 prontos + 42 planejados)
```

### Desejável (Could-Have)
```
📋 LEAD-018 até LEAD-020 — Inteligência e IA (Fase 5)
🎯 Total: 3 histórias | 21 SP
```

---

## 📋 CHECKLIST DE CONTINUIDADE

### Histórias Documentadas

- [x] US-CRM-LEAD-001 (v1.0) — Arquivo criado e validado
- [x] US-CRM-LEAD-002 (v1.1) — Arquivo criado, terminologia atualizada, wireframe otimizado
- [x] US-CRM-LEAD-003 (v1.1) — Arquivo renumerado, validado e pronto
- [x] US-CRM-LEAD-004 (v1.0) — Formulário Embarcado (iframe/widget, token parceiro)
- [x] US-CRM-LEAD-005 (v1.0) — WhatsApp Business (chatbot, webhook Meta)
- [x] US-CRM-LEAD-006 (v1.0) — Qualificar Lead BANT (score 0-12, temperaturas)
- [ ] US-CRM-LEAD-007 — Importar Leads em Massa (arquivo ou API/BD)
- [ ] US-CRM-LEAD-008 — Marcar Lead como Arquivado
- [ ] US-CRM-LEAD-009 — Exportar Leads para arquivos
- [ ] US-CRM-LEAD-010 — Integração Facebook / Meta Lead Ads
- [ ] US-CRM-LEAD-011 — Integração Google Ads
- [ ] US-CRM-LEAD-012 — Cadastrar Lead Manualmente
- [ ] US-CRM-LEAD-013 — Visualizar Lista de Leads
- [ ] US-CRM-LEAD-014 — Buscar e Filtrar Leads
- [ ] US-CRM-LEAD-015 — Atribuir Lead a Consultor
- [ ] US-CRM-LEAD-016 — Editar Dados do Lead
- [ ] US-CRM-LEAD-017 — Visualizar Detalhes do Lead
- [ ] US-CRM-LEAD-018 — Enriquecimento de Dados
- [ ] US-CRM-LEAD-019 — Score Automático de Lead
- [ ] US-CRM-LEAD-020 — Detecção de Lead Duplicado

### Artefatos de Suporte

- [x] README.md (CRM-Leads) — Estrutura e mapeamento
- [x] CONTINUIDADE-CRM-LEADS.md — Acompanhamento geral
- [ ] Diagramas de Sequência — Desejável, não crítico
- [ ] Glossário CRM — Desejável, não crítico
- [ ] Relatório de Cenários Aceitos (RCA) — Importante, próximos 7 dias

### Validações

- [x] Auditoria de Integridade (21/01/2026)
- [x] Conformidade DDD (100%)
- [x] Rastreabilidade (Dependências mapeadas)
- [x] PDFs Gerados (3/3 prontos)
- [ ] QA Testing — Próximo: LEAD-001 + LEAD-002

---

## 🔄 FLUXO ESPERADO

```
┌─────────────────────────────────────────────────────────┐
│  SPRINT 0 (ATUAL) — Validação e Planejamento            │
├─────────────────────────────────────────────────────────┤
│  ✅ Auditoria Concluída (21/01)                         │
│  ✅ 3 Histórias Prontas (LEAD-001, LEAD-002, LEAD-003)    │
│  📋 Próximo: QA + Dev Sprint 1                          │
└─────────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────┐
│  SPRINT 1 — Desenvolvimento Fase 1 + Planejamento Fase 2│
├─────────────────────────────────────────────────────────┤
│  Dev:                                                   │
│  • LEAD-001 (Captação)                                   │
│  • LEAD-002 (Comparativo)                                │
│  • LEAD-003 (Dashboard)                                  │
│                                                         │
│  QA:                                                    │
│  • 21 Cenários de Aceitação                            │
│                                                         │
│  Planejamento Fase 3:                                  │
│  • Especificar LEAD-007 até LEAD-011                     |
│  • Estimar SP                                          │
│  • Validar dependências                                │
└─────────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────┐
│  SPRINT 2 — Captura Avançada (LEAD-004 a LEAD-006)       │
├─────────────────────────────────────────────────────────┤
│  • Formulário Embarcado (LEAD-004)                      │
│  • WhatsApp Business (LEAD-005)                         │
│  • Qualificar BANT (LEAD-006)                           │
└─────────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────┐
│  SPRINT 3 — Gestão Avançada (LEAD-007 a LEAD-011)        │
├─────────────────────────────────────────────────────────┤
│  • Importar Leads (LEAD-007)                            │
│  • Arquivar Lead (LEAD-008)                             │
│  • Exportar Leads (LEAD-009)                            │
│  • Facebook Ads (LEAD-010)                              │
│  • Google Ads (LEAD-011)                                │
└─────────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────┐
│  SPRINT 4 — Gestão de Leads (LEAD-012 a LEAD-017)        │
├─────────────────────────────────────────────────────────┤
│  • Cadastro Manual (LEAD-012)                           │
│  • Lista de Leads (LEAD-013)                            │
│  • Busca/Filtro (LEAD-014)                              │
│  • Atribuição (LEAD-015)                                │
│  • Edição (LEAD-016)                                    │
│  • Visualização Detalhes (LEAD-017)                     │
└─────────────────────────────────────────────────────────┘
```

---

## 📌 PONTOS CRÍTICOS PARA CONTINUIDADE

### 1. **LEAD-007 é o Próximo**
- Primeira história da Fase 3 (Gestão Avançada)
- Importação em massa de leads (CSV/Excel/API)
- **Ação**: Especificar em próxima sessão

### 2. **Dependências Críticas**
```
Fase 1 (Captação):
LEAD-001 ├─→ LEAD-002 (Comparativo)
        └─→ LEAD-003 (Dashboard)

Fase 2 (Captura Avançada):
LEAD-001 ├─→ LEAD-004 (Formulário Embarcado)
        ├─→ LEAD-005 (WhatsApp Business)
        └─→ LEAD-006 (Qualificar BANT)

Fase 3 (Gestão Avançada + Ads):
LEAD-001 ├─→ LEAD-007 (Importar)
        ├─→ LEAD-008 (Arquivar)
        ├─→ LEAD-009 (Exportar)
        ├─→ LEAD-010 (Facebook Ads)
        └─→ LEAD-011 (Google Ads)

Fase 4 (Gestão de Leads):
LEAD-001 ├─→ LEAD-012 (Cadastro Manual)
        └─→ LEAD-013 (Lista) ├─→ LEAD-014 (Busca)
                             ├─→ LEAD-015 (Atribuição)
                             ├─→ LEAD-016 (Edição)
                             └─→ LEAD-017 (Detalhes)
```

### 3. **Métricas de Sucesso**
- ✅ LEAD-001: 12 códigos de origem, DDD extract, 3 etapas
- ✅ LEAD-002: 3 planos em comparação paralela, terminologia "serviços"
- ✅ LEAD-003: 10 KPIs de conversão definidos

---

## 🎁 BENEFÍCIOS DAS 3 HISTÓRIAS PRONTAS

| História | Valor | Impacto |
|----------|-------|---------|
| **LEAD-001** | Captação de qualidade | Alimenta todo o funil |
| **LEAD-002** | Conversão de planos | Monetização imediata |
| **LEAD-003** | Inteligência de negócio | Otimização contínua |

---

## 📅 TIMELINE RECOMENDADA

| Período | Ação | Status |
|---------|------|--------|
| **21-24 Jan** | QA Testing (LEAD-001, LEAD-002) | ✅ Pronto |
| **24-25 Jan** | Especificar LEAD-004 | 📋 Próximo |
| **25-26 Jan** | Especificar LEAD-005 a LEAD-009 | 📋 Planejado |
| **27-28 Jan** | Sprint Planning Semana 2 | 📋 Planejado |
| **28 Jan+** | Dev Sprint 1 | 📋 Futuro |

---

## ✅ ASSINATURA DE CONTINUIDADE

| Campo | Valor |
|-------|-------|
| **Responsável** | Gustavo Titoneli (Product Owner) |
| **Data Atualização** | 21 de janeiro de 2026 |
| **Versão** | 1.1 |
| **Status** | ✅ Conforme - Checkpoint Documentado |
| **Próxima Revisão** | 25 de janeiro de 2026 (Antes de LEAD-003) |

---

## 📝 NOTAS OPERACIONAIS

- Todos os 3 user stories prontos têm PDFs gerados
- Auditoria de integridade validou 100% conformidade
- Próxima ação: QA Testing e Especificação LEAD-003
- Manter este documento atualizado a cada novo user story
- Usar como referência rápida para "onde paramos"
