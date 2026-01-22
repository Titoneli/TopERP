# US-CRM-LED-003 — Dashboard de Leads e Analytics

## História de Usuário

**Como** gestor comercial ou consultor,  
**Quero** visualizar dashboards com métricas de captação de leads,  
**Para** tomar decisões estratégicas sobre investimentos em marketing e expansão regional.

## Prioridade

Essencial

## Estimativa

13 SP

---

## Contexto de Negócio

Os dados capturados durante a captação de leads ([US-CRM-LED-001](US-CRM-LED-001.md)) precisam ser visualizados de forma analítica para apoiar decisões de negócio. Este dashboard consolida métricas por DDD, origem, consultor e funil de conversão.

---

## Dependência

Esta user story depende da captura de dados implementada em:
- [US-CRM-LED-001](US-CRM-LED-001.md) - Captação de Lead via Landing Page

---

## Critérios de Aceitação

### Cenário 1 — Visualizar métricas de conversão
- **Dado que** estou autenticado como consultor ou gestor
- **Quando** acesso o dashboard como consultor visualizo apenas os meus leads, o gester visualiza todos os leads
- **Então** visualizo as métricas de conversão do funil 

### Cenário 2 — Visualizar leads por DDD
- **Dado que** estou no dashboard
- **Quando** acesso a seção "Leads por DDD"
- **Então** visualizo gráfico com distribuição de leads por região (DDD)

### Cenário 3 — Visualizar leads por origem
- **Dado que** estou no dashboard
- **Quando** acesso a seção "Leads por Origem"
- **Então** visualizo gráfico com distribuição por `cod_origem`

### Cenário 4 — Filtrar por período
- **Dado que** estou no dashboard
- **Quando** seleciono um período (últimos 7, 30, 90 dias ou personalizado)
- **Então** todas as métricas são recalculadas para o período selecionado

---

## Métricas de Conversão

| Métrica | Descrição | Meta |
|---------|-----------|------|
| **Taxa de Conversão Etapa 1** | % visitantes que completam Etapa 1 | > 40% |
| **Taxa de Conclusão Total** | % que completam todas as etapas | > 25% |
| **Taxa de Abandono** | % que abandonam após iniciar | < 60% |
| **Tempo Médio de Preenchimento** | Tempo para completar 3 etapas | < 2 min |
| **Leads por Dia** | Volume de leads captados | Monitorar |
| **Qualidade do Lead** | % que avança no funil | > 30% |

---

## 📊 Dashboard Regional (por DDD)

### Métricas por DDD

| Métrica | Descrição | Uso |
|---------|-----------|-----|
| **Leads por DDD** | Quantidade de leads agrupados por DDD | Identificar regiões com maior demanda |
| **Conversão por DDD** | % de conversão por região (DDD) | Avaliar qualidade regional |
| **Custo por Lead por DDD** | Investimento / Leads por região | Otimizar budget de marketing |
| **Top 10 DDDs** | Ranking das regiões com mais leads | Priorizar expansão comercial |

### Wireframe Dashboard Regional

```
┌────────────────────────────────────────────────────────┐
│  LEADS POR DDD - ÚLTIMOS 30 DIAS                       │
├────────────────────────────────────────────────────────┤
│  DDD 11 (SP Capital)     ████████████████████  42%     │
│  DDD 21 (RJ Capital)     ████████████          18%     │
│  DDD 31 (BH)             ██████████            12%     │
│  DDD 19 (Campinas)       ████████               9%     │
│  DDD 41 (Curitiba)       ██████                 7%     │
│  Outros                  ██████                12%     │
└────────────────────────────────────────────────────────┘
```

---

## 📊 Dashboard por Origem (`cod_origem`)

### Métricas por Origem

| Métrica | Descrição | Uso |
|---------|-----------|-----|
| **Leads por Origem** | Volume por canal de aquisição | Avaliar efetividade de campanhas |
| **Conversão por Origem** | % conversão por canal | Identificar canais mais qualificados |
| **ROI por Origem** | Retorno por canal de marketing | Otimizar investimento |

### Tabela de Origens

| Código | Origem | Descrição |
|--------|--------|----------|
| 1 | `LINK_DIRETO` | Acesso direto à landing page |
| 2 | `INFLUENCER_INSTAGRAM` | Publicidade via influenciador no Instagram |
| 3 | `ADS_GOOGLE` | Anúncio no Google Ads |
| 4 | `ADS_META` | Anúncio no Facebook/Instagram Ads |
| 5 | `WHATSAPP` | Link compartilhado via WhatsApp |
| 6 | `INDICACAO` | Indicação de associado existente |
| 7 | `CONSULTOR_PROPRIO` | Link personalizado do consultor |
| 8 | `APP_CONSULTOR` | Lead cadastrado pelo consultor via app |
| 9 | `APP_ASS_INDICACAO` | Indicação feita pelo associado via app |
| 10 | `VENDA_PROPRIA` | Lead cadastrado pelo consultor direto no CRM |
| 11 | `AUTOMACAO` | Lead gerado via automação |
| 99 | `OUTROS` | Outras origens não mapeadas |

### Wireframe Dashboard por Origem

```
┌────────────────────────────────────────────────────────────────┐
│  LEADS POR ORIGEM - ÚLTIMOS 30 DIAS                            │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  Origem              │ Leads │ Conv. │ Custo │   ROI    │   │
│  ├──────────────────────┼───────┼───────┼───────┼──────────┤   │
│  │  Google Ads          │  450  │  32%  │ R$15  │   3.2x   │   │
│  │  Influencer IG       │  320  │  28%  │ R$22  │   2.1x   │   │
│  │  Meta Ads            │  280  │  25%  │ R$18  │   2.5x   │   │
│  │  Link Direto         │  150  │  45%  │ R$ 0  │    ∞     │   │
│  │  WhatsApp            │  120  │  38%  │ R$ 5  │   4.8x   │   │
│  │  Indicação           │   80  │  55%  │ R$ 0  │    ∞     │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## 📊 Dashboard de Funil

### Pontos de Medição

```
Visitante ──▶ Etapa 1 ──▶ Etapa 2 ──▶ Etapa 3 ──▶ Qualificado
   100%         40%         32%         25%          25%
              (drop 60%)  (drop 20%)  (drop 22%)
```

### Wireframe Funil

```
┌──────────────────────────────────────────────────────────┐
│  FUNIL DE CONVERSÃO - ÚLTIMOS 30 DIAS                    │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  ┌────────────────────────────────────────────────────┐  │
│  │████████████████████████████████████████████████████│  │ Visitantes: 10.000 (100%)
│  └────────────────────────────────────────────────────┘  │
│           │                                              │
│           ▼ -60%                                         │
│  ┌────────────────────────────────────┐                  │
│  │████████████████████████████████████│                  │ Etapa 1: 4.000 (40%)
│  └────────────────────────────────────┘                  │
│           │                                              │
│           ▼ -20%                                         │
│  ┌─────────────────────────────┐                         │
│  │█████████████████████████████│                         │ Etapa 2: 3.200 (32%)
│  └─────────────────────────────┘                         │
│           │                                              │
│           ▼ -22%                                         │
│  ┌────────────────────────┐                              │
│  │████████████████████████│                              │ Etapa 3: 2.500 (25%)
│  └────────────────────────┘                              │
│           │                                              │
│           ▼                                              │
│  ┌────────────────────────┐                              │
│  │████████████████████████│                              │ Qualificados: 2.500 (25%)
│  └────────────────────────┘                              │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

---

## Definição de Pronto

- Dashboard de métricas de conversão implementado
- Gráfico de leads por DDD funcional
- Gráfico de leads por origem funcional
- Filtro de período funcionando
- Permissões de acesso configuradas (gestor/consultor)
- Testes de performance com volume de dados

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Gestor visualiza dados de todos os consultores |
| RN-002 | Consultor visualiza apenas seus próprios leads |
| RN-003 | Dados são atualizados em tempo real ou com delay máximo de 5 minutos |
| RN-004 | Período máximo de consulta: 12 meses |

---

**Criado por**: Gustavo Titoneli (Product Owner)  
**Data**: 21/01/2026  
**Versão**: 1.1

**Histórico de Alterações:**
| Versão | Data | Alteração |
|--------|------|----------|