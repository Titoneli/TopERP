# ACOMPANHAMENTO DE CONTINUIDADE — Módulo CRM-Leads

**Última Atualização**: 23 de janeiro de 2026  
**Status**: Em Desenvolvimento  
**Versão**: 2.0

---

## 📍 CHECKPOINT ATUAL

Sabemos **exatamente onde paramos**:

```
Sprint Atual: Sprint 1 - Fase 2 Captura Avançada
Histórias Prontas para Dev: LED-001, LED-002, LED-003, LED-004, LED-005, LED-006
Próximas: LED-007, LED-008, LED-009 (Fase 3)
Status: ✅ Fase 2 Especificada (23/01/2026)
```

---

## 📊 MAPA DE PROGRESSO — CRM-Leads

### Fase 1: CAPTAÇÃO E COMPARAÇÃO (✅ COMPLETA)

| ID | Histórias | Status | Versão | SP | PDF | Notas |
|----|-----------|---------|-----------|----|-----|----|
| **LED-001** | Captação de Lead via Landing Page | ✅ Pronto | v1.0 | 13 | ✅ | 3-step form, 12 códigos origem, DDD extract |
| **LED-002** | Comparativo de Planos de Proteção | ✅ Pronto | v1.1 | 13 | ✅ | 3 colunas, 18 termos ajustados |
| **LED-003** | Dashboard de Leads e Analytics | ✅ Pronto | v1.1 | 13 | ✅ | 10 métricas de conversão, análise por DDD/origem |

**Subtotal Fase 1**: 39 SP | 21 Cenários de Aceitação

---

### Fase 2: CAPTURA AVANÇADA (✅ ESPECIFICADA)

| ID | Histórias | Status | Versão | SP | PDF | Notas |
|----|-----------|--------|--------|----|-----|-------|
| **LED-004** | Captura via Formulário Embarcado | ✅ Pronto | v1.0 | 8 | ⏳ | iframe/widget, token parceiro, CORS |
| **LED-005** | Captura via WhatsApp Business | ✅ Pronto | v1.0 | 13 | ⏳ | Chatbot, webhook Meta, fluxo BANT |
| **LED-006** | Qualificar Lead (BANT) | ✅ Pronto | v1.0 | 5 | ⏳ | Score 0-12, temperatura FRIO/MORNO/QUENTE |

**Subtotal Fase 2**: 26 SP | Status: **✅ Especificação Completa**

---

### Fase 3: GESTÃO AVANÇADA (⏳ NÃO INICIADA)

| ID | Histórias | Status | SP | Prioridade | Dependências |
|----|-----------|--------|----|-----------|----|
| **LED-007** | Importar Leads em Massa (CSV/Excel) | 📋 Planejado | 8 | Importante | LED-001 |
| **LED-008** | Marcar Lead como Inativo | 📋 Planejado | 3 | Importante | LED-001 |
| **LED-009** | Exportar Leads | 📋 Planejado | 5 | Importante | LED-001 |

**Subtotal Fase 3**: 16 SP | Status: **Aguardando Especificação**

---

### Fase 4: INTEGRAÇÕES EXTERNAS (⏳ NÃO INICIADA)

| ID | Histórias | Status | SP | Prioridade | Dependências |
|----|-----------|--------|----|-----------|----|
| **LED-010** | Integração com Facebook Lead Ads | 📋 Planejado | 13 | Desejável | Webhook Meta |
| **LED-011** | Integração com Google Ads | 📋 Planejado | 13 | Desejável | Google Ads API |
| **LED-012** | Score Automático de Lead | 📋 Planejado | 8 | Desejável | ML Engine |
| **LED-013** | Detecção de Lead Duplicado | 📋 Planejado | 5 | Desejável | LED-001 |
| **LED-014** | Enriquecimento de Dados (APIs externas) | 📋 Planejado | 8 | Desejável | Integrações externas |

**Subtotal Fase 4**: 47 SP | Status: **Backlog Futuro**

---

### Fase 5: GESTÃO DE LEADS (⏳ NÃO INICIADA)

| ID | Histórias | Status | SP | Prioridade | Dependências |
|----|-----------|--------|----|-----------|----|
| **LED-015** | Cadastrar Lead Manualmente | 📋 Planejado | 8 | Essencial | LED-001 |
| **LED-016** | Visualizar Lista de Leads | 📋 Planejado | 5 | Essencial | LED-001, LED-015 |
| **LED-017** | Buscar e Filtrar Leads | 📋 Planejado | 5 | Essencial | LED-016 |
| **LED-018** | Atribuir Lead a Consultor | 📋 Planejado | 5 | Essencial | LED-016 |
| **LED-019** | Editar Dados do Lead | 📋 Planejado | 5 | Essencial | LED-015, LED-016 |
| **LED-020** | Visualizar Detalhes do Lead | 📋 Planejado | 5 | Essencial | LED-016 |

**Subtotal Fase 5**: 33 SP | Status: **Aguardando Especificação**

---

## 🎯 RESUMO POR PRIORIDADE

### Essencial (Must-Have)
```
✅ LED-001 (v1.0) — Pronto para Dev
✅ LED-002 (v1.1) — Pronto para Dev
✅ LED-003 (v1.1) — Pronto para Dev
✅ LED-015 até LED-020 — Gestão de Leads (Fase 5) - Aguardando
🎯 Total: 9 histórias | 72 SP (39 prontos + 33 planejados)
```

### Importante (Should-Have)
```
✅ LED-004 (v1.0) — Formulário Embarcado - ESPECIFICADO
✅ LED-005 (v1.0) — WhatsApp Business - ESPECIFICADO
✅ LED-006 (v1.0) — Qualificar BANT - ESPECIFICADO
📋 LED-007 até LED-009 — Gestão Avançada (Fase 3) - Pendente
🎯 Total: 6 histórias | 42 SP (26 prontos + 16 planejados)
```

### Desejável (Could-Have)
```
📋 LED-015 até LED-020 — Backlog Futuro
🎯 Total: 6 histórias | 47 SP
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
- [ ] US-CRM-LEAD-007 — Importar Leads em Massa
- [ ] US-CRM-LEAD-008 — Marcar Lead como Inativo
- [ ] US-CRM-LEAD-009 — Exportar Leads
- [ ] US-CRM-LEAD-010 — Integração Facebook Lead Ads
- [ ] US-CRM-LEAD-011 — Integração Google Ads
- [ ] US-CRM-LEAD-012 — Score Automático de Lead
- [ ] US-CRM-LEAD-013 — Detecção de Lead Duplicado
- [ ] US-CRM-LEAD-014 — Enriquecimento de Dados
- [ ] US-CRM-LEAD-015 — Cadastrar Lead Manualmente
- [ ] US-CRM-LEAD-016 — Visualizar Lista de Leads
- [ ] US-CRM-LEAD-017 — Buscar e Filtrar Leads
- [ ] US-CRM-LEAD-018 — Atribuir Lead a Consultor
- [ ] US-CRM-LEAD-019 — Editar Dados do Lead
- [ ] US-CRM-LEAD-020 — Visualizar Detalhes do Lead

### Artefatos de Suporte

- [x] README.md (CRM-Leads) — Estrutura e mapeamento
- [x] CONTINUIDADE-LED-002.md — **Transformado em acompanhamento geral**
- [ ] Diagramas de Sequência — Desejável, não crítico
- [ ] Glossário CRM — Desejável, não crítico
- [ ] Relatório de Cenários Aceitos (RCA) — Importante, próximos 7 dias

### Validações

- [x] Auditoria de Integridade (21/01/2026)
- [x] Conformidade DDD (100%)
- [x] Rastreabilidade (Dependências mapeadas)
- [x] PDFs Gerados (3/3 prontos)
- [ ] QA Testing — Próximo: LED-001 + LED-002

---

## 🔄 FLUXO ESPERADO

```
┌─────────────────────────────────────────────────────────┐
│  SPRINT 0 (ATUAL) — Validação e Planejamento            │
├─────────────────────────────────────────────────────────┤
│  ✅ Auditoria Concluída (21/01)                         │
│  ✅ 3 Histórias Prontas (LED-001, LED-002, LED-003)    │
│  📋 Próximo: QA + Dev Sprint 1                          │
└─────────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────┐
│  SPRINT 1 — Desenvolvimento Fase 1 + Planejamento Fase 2│
├─────────────────────────────────────────────────────────┤
│  Dev:                                                   │
│  • LED-001 (Captação)                                   │
│  • LED-002 (Comparativo)                                │
│  • LED-003 (Dashboard)                                  │
│                                                         │
│  QA:                                                    │
│  • 21 Cenários de Aceitação                            │
│                                                         │
│  Planejamento Fase 2:                                  │
│  • Especificar LED-004 até LED-009                     |
│  • Estimar SP                                          │
│  • Validar dependências                                │
└─────────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────┐
│  SPRINT 2 — Gestão de Leads (LED-004 a LED-009)        │
├─────────────────────────────────────────────────────────┤
│  • Cadastro Manual (LED-004)                           │
│  • Lista de Leads (LED-005)                            │
│  • Busca/Filtro (LED-006)                              │
│  • Atribuição (LED-007)                                │
│  • Edição (LED-008)                                    │
│  • Visualização Detalhes (LED-009)                     │
└─────────────────────────────────────────────────────────┘
```

---

## 📌 PONTOS CRÍTICOS PARA CONTINUIDADE

### 1. **LED-004 é o Próximo**
- Depende de LED-001 estar qualificado
- Base para LED-005, LED-006, LED-007, LED-008, LED-009
- **Ação**: Especificar em próxima sessão

### 2. **Dependências Críticas**
```
LED-001 ├─→ LED-002 (Fluxo principal)
        ├─→ LED-003 (Dashboard)
        ├─→ LED-004 (Cadastro manual)
        └─→ LED-005 (Visualização)

LED-005 ├─→ LED-006 (Busca)
        ├─→ LED-007 (Atribuição)
        ├─→ LED-008 (Edição)
        └─→ LED-009 (Detalhes)
```

### 3. **Métricas de Sucesso**
- ✅ LED-001: 12 códigos de origem, DDD extract, 3 etapas
- ✅ LED-002: 3 planos em comparação paralela, terminologia "serviços"
- ✅ LED-003: 10 KPIs de conversão definidos

---

## 🎁 BENEFÍCIOS DAS 3 HISTÓRIAS PRONTAS

| História | Valor | Impacto |
|----------|-------|---------|
| **LED-001** | Captação de qualidade | Alimenta todo o funil |
| **LED-002** | Conversão de planos | Monetização imediata |
| **LED-003** | Inteligência de negócio | Otimização contínua |

---

## 📅 TIMELINE RECOMENDADA

| Período | Ação | Status |
|---------|------|--------|
| **21-24 Jan** | QA Testing (LED-001, LED-002) | ✅ Pronto |
| **24-25 Jan** | Especificar LED-004 | 📋 Próximo |
| **25-26 Jan** | Especificar LED-005 a LED-009 | 📋 Planejado |
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
| **Próxima Revisão** | 25 de janeiro de 2026 (Antes de LED-003) |

---

## 📝 NOTAS OPERACIONAIS

- Todos os 3 user stories prontos têm PDFs gerados
- Auditoria de integridade validou 100% conformidade
- Próxima ação: QA Testing e Especificação LED-003
- Manter este documento atualizado a cada novo user story
- Usar como referência rápida para "onde paramos"
