# US-CRM-LEAD-018 — Enriquecimento de Dados (APIs Externas)

## História de Usuário

**Como** gestor comercial,  
**Quero** enriquecer automaticamente os dados dos leads via APIs externas,  
**Para** ter informações mais completas e qualificar melhor os prospects.

## Prioridade

Desejável

## Estimativa

8 SP

---

## Contexto DDD

### Bounded Context
- **Contexto**: Integrações e Inteligência (Intelligence & Integrations)
- **Módulo**: CRM-Leads

### Aggregate Root
- **Lead** (entidade principal)
- **ConfiguracaoEnriquecimento** (configuração das APIs)

### Domain Events
| Evento | Trigger | Assinantes |
|--------|---------|------------|
| `LeadEnrichmentRequested` | Solicitação de enriquecimento | Processador |
| `LeadEnriched` | Dados complementados | Analytics, Notificações |
| `LeadEnrichmentFailed` | Falha no enriquecimento | Logs, Alertas |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Enriquecimento** | Complementar dados do lead via APIs |
| **API de Dados** | Serviço externo que fornece informações |
| **Dados Complementares** | Informações adicionais ao cadastro |

---

## Contexto de Negócio

O enriquecimento de dados permite complementar informações do lead automaticamente, melhorando a qualidade da base e fornecendo insights para a abordagem comercial, a sugestão de consultas, seria o próprio ERP da Top ou bases de dados como uma consulta jurídica (PuxaCapivara ou similares), denatran, detran e etc.

### APIs de Enriquecimento

| API | Dados Obtidos | Aplicação |
|-----|---------------|-----------|
| FIPE | Valor do veículo | Precificação de plano |
| IBGE | Cidade/Estado por CEP | Validação de localização |
| Receita Federal (futura) | Dados de CNPJ | Leads PJ |
| Clearbit/Similar (futura) | Dados de empresa | Enriquecimento B2B |
| PuxaCapivara (futura) | Dados da Pessoa | Histório Jurídico |
---

## Fluxo de Enriquecimento

```
┌─────────────────────────────────────────────────────────────────┐
│                 FLUXO DE ENRIQUECIMENTO                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌───────────────┐                                              │
│  │  LEAD CRIADO  │                                              │
│  │  OU EDITADO   │                                              │
│  └───────┬───────┘                                              │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              TRIGGER DE ENRIQUECIMENTO                    │  │
│  │                                                           │  │
│  │  • Automático (ao criar lead)                             │  │
│  │  • Manual (botão "Enriquecer Dados")                      │  │
│  │  • Em lote (job noturno)                                  │  │
│  └───────────────────────────────────────────────────────────┘  │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              CHAMADAS ÀS APIs                             │  │
│  │                                                           │  │
│  │  ┌─────────────┐   ┌─────────────┐   ┌─────────────┐      │  │
│  │  │  API FIPE   │   │  API IBGE   │   │   OUTRAS    │      │  │
│  │  │  (Veículo)  │   │   (Local)   │   │   (Futuro)  │      │  │
│  │  └─────────────┘   └─────────────┘   └─────────────┘      │  │
│  │                                                           │  │
│  └───────────────────────────────────────────────────────────┘  │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              ATUALIZAÇÃO DO LEAD                          │  │
│  │                                                           │  │
│  │  • Valor FIPE atualizado                                  │  │
│  │  • Localização validada                                   │  │
│  │  • Flag "enriquecido" = true                              │  │
│  │  • Data de enriquecimento                                 │  │
│  │                                                           │  │
│  └───────────────────────────────────────────────────────────┘  │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────┐                                              │
│  │  LEAD         │                                              │
│  │  ENRIQUECIDO  │                                              │
│  └───────────────┘                                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Dados Enriquecidos

### Via API FIPE

| Dado | Descrição | Uso |
|------|-----------|-----|
| valor_fipe | Valor médio do veículo | Cálculo de plano |
| codigo_fipe | Código FIPE do veículo | Identificação única |
| ano_modelo | Confirmação do ano | Validação |

### Via API IBGE

| Dado | Descrição | Uso |
|------|-----------|-----|
| codigo_municipio | Código IBGE da cidade | Integração |
| regiao | Região do país | Segmentação |
| mesorregiao | Mesorregião | Analytics |

---

## Inputs e Outputs

### Input (Trigger)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| lead_id | uuid | ID do lead a enriquecer |
| apis | array | APIs a consultar (ou todas) |
| forcar | boolean | Forçar mesmo se já enriquecido |

### Output

| Campo | Valor |
|-------|-------|
| enriquecido | true |
| data_enriquecimento | timestamp |
| valor_fipe | Valor obtido |
| fonte_enriquecimento | APIs utilizadas |

---

## Critérios de Aceitação

### Cenário 1 — Enriquecimento automático com FIPE
- **Dado que** um lead é criado com marca/modelo/ano
- **Quando** o enriquecimento automático é executado
- **Então** o valor FIPE é obtido e armazenado
- **E** o lead é marcado como "enriquecido"

### Cenário 2 — Enriquecimento manual
- **Dado que** visualizo um lead não enriquecido
- **Quando** clico em "Enriquecer Dados"
- **Então** as APIs são consultadas
- **E** os dados são atualizados em tempo real

### Cenário 3 — Veículo não encontrado na FIPE
- **Dado que** o veículo não existe na tabela FIPE
- **Quando** o enriquecimento é executado
- **Então** o campo valor_fipe fica nulo
- **E** um aviso é registrado: "Veículo não encontrado na FIPE"

### Cenário 4 — Lead já enriquecido
- **Dado que** o lead foi enriquecido há menos de 7 dias
- **Quando** tento enriquecer novamente
- **Então** vejo aviso: "Lead enriquecido recentemente"
- **E** posso forçar re-enriquecimento se necessário

### Cenário 5 — Enriquecimento em lote
- **Dado que** tenho 100 leads não enriquecidos
- **Quando** executo o job de enriquecimento em lote
- **Então** todos os leads elegíveis são processados
- **E** um relatório é gerado com sucessos e falhas

### Cenário 6 — Falha na API externa
- **Dado que** a API FIPE está indisponível
- **Quando** tento enriquecer um lead
- **Então** o lead não é marcado como enriquecido
- **E** é agendado para retry posterior

### Cenário 7 — Validação de localização
- **Dado que** um lead tem CEP informado
- **Quando** o enriquecimento é executado
- **Então** cidade e estado são validados/corrigidos via IBGE
- **E** código do município é armazenado

### Cenário 8 — Visualizar dados enriquecidos
- **Dado que** um lead está enriquecido
- **Quando** visualizo os detalhes
- **Então** vejo badge "Enriquecido"
- **E** vejo valor FIPE do veículo
- **E** vejo data do último enriquecimento

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Enriquecimento automático ao criar lead (se config ativo) |
| RN-002 | Re-enriquecimento bloqueado por 7 dias (configurável) |
| RN-003 | Forçar re-enriquecimento disponível para gestores |
| RN-004 | Job noturno processa leads não enriquecidos |
| RN-005 | Limite de 1000 leads por execução de lote |
| RN-006 | Falhas são registradas para retry (3 tentativas) |
| RN-007 | Valor FIPE é informativo, não vinculante |
| RN-008 | APIs externas têm rate limit respeitado |
| RN-009 | Dados de enriquecimento são armazenados em histórico |
| RN-010 | Permissão necessária: `leads.enriquecer` |

---

## Configurações

| Configuração | Tipo | Padrão | Descrição |
|--------------|------|--------|-----------|
| enriquecimento_automatico | boolean | true | Enriquecer ao criar |
| dias_reenriquecimento | integer | 7 | Dias entre enriquecimentos |
| apis_ativas | array | ["fipe", "ibge"] | APIs habilitadas |
| limite_lote | integer | 1000 | Leads por lote |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────┐
│  📊 ENRIQUECIMENTO DE DADOS                                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Lead: João da Silva - Fiat Strada 2024                         │
│                                                                 │
│  Status: ✅ Enriquecido em 25/01/2026 às 10:45                  │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  📈 DADOS OBTIDOS                                               │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  FIPE                                                   │    │
│  │  Código: 001267-0                                       │    │
│  │  Valor: R$ 85.500,00                                    │    │
│  │  Referência: Janeiro/2026                               │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  IBGE                                                   │    │
│  │  Município: Campinas (3509502)                          │    │
│  │  Região: Sudeste                                        │    │
│  │  Mesorregião: Campinas                                  │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  [🔄 Re-enriquecer]   Próximo enriquecimento: 01/02/2026        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 25/01/2026 | 1.0 | PO | Criação inicial com DDD |

---

**Identificador**: US-CRM-LEAD-018  
**Módulo**: CRM-Leads  
**Fase**: 5 - Integrações e Inteligência  
**Status**: ✅ Pronto  
**Versão**: 1.0
