# US-CRM-LEAD-020 — Detecção de Lead Duplicado

## História de Usuário

**Como** gestor comercial,  
**Quero** que o sistema detecte leads duplicados automaticamente,  
**Para** evitar desperdício de esforço e conflitos de atribuição.

## Prioridade

Desejável

## Estimativa

5 SP

---

## Contexto DDD

### Bounded Context
- **Contexto**: Integrações e Inteligência (Intelligence & Integrations)
- **Módulo**: CRM-Leads

### Aggregate Root
- **Lead** (entidade principal)
- **GrupoDuplicados** (agrupamento de leads similares)

### Domain Events
| Evento | Trigger | Assinantes |
|--------|---------|------------|
| `DuplicateDetected` | Lead duplicado identificado | Alertas, Fila |
| `DuplicatesMerged` | Leads mesclados | Auditoria |
| `DuplicateIgnored` | Duplicata marcada como diferente | Logs |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Lead Duplicado** | Lead que representa a mesma pessoa |
| **Match** | Correspondência entre dois leads |
| **Mesclar** | Unir dois leads em um só |
| **Lead Master** | Lead principal após mesclagem |
| **Similaridade** | Grau de semelhança entre leads |

---

## Contexto de Negócio

A detecção de duplicados evita que o mesmo prospect seja contatado por múltiplos consultores ou receba comunicações repetidas. Também garante que todo o histórico de interações esteja consolidado.

### Problemas de Duplicados

| Problema | Impacto |
|----------|---------|
| Conflito de atribuição | Dois consultores disputando o mesmo cliente |
| Comunicação duplicada | Cliente recebe mesma mensagem várias vezes |
| Dados inconsistentes | Informações diferentes em cada registro |
| Métricas incorretas | Contagem inflada de leads |
| Experiência ruim | Cliente irritado com abordagens múltiplas |

---

## Critérios de Match

### Match Exato (Alta Confiança)

| Critério | Descrição | Confiança |
|----------|-----------|-----------|
| Telefone | Mesmo telefone normalizado | 99% |
| E-mail | Mesmo e-mail normalizado | 99% |
| CPF | Mesmo CPF (se disponível) | 100% |

### Match Fuzzy (Média Confiança)

| Critério | Descrição | Confiança |
|----------|-----------|-----------|
| Nome similar | Levenshtein distance < 3 | 70-90% |
| Telefone similar | Diferença de 1-2 dígitos | 60-80% |
| Nome + Cidade | Mesmo nome e cidade | 80% |

---

## Fluxo de Detecção

```
┌─────────────────────────────────────────────────────────────────┐
│               FLUXO DE DETECÇÃO DE DUPLICADOS                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌───────────────┐                                              │
│  │  LEAD CRIADO  │                                              │
│  └───────┬───────┘                                              │
│          │                                                      │
│          ▼                                                      │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              BUSCA DE DUPLICADOS                          │  │
│  │                                                           │  │
│  │  1. Busca por telefone exato                              │  │
│  │  2. Busca por e-mail exato                                │  │
│  │  3. Busca por nome similar + cidade                       │  │
│  │                                                           │  │
│  └───────────────────────────────────────────────────────────┘  │
│          │                                                      │
│          ├───────────────────────────────────────┐              │
│          │ Não encontrou                         │ Encontrou    │
│          ▼                                       ▼              │
│  ┌───────────────┐                      ┌───────────────┐       │
│  │  LEAD ÚNICO   │                      │  DUPLICADO    │       │
│  │  Segue fluxo  │                      │  DETECTADO    │       │
│  │   normal      │                      │               │       │
│  └───────────────┘                      └───────┬───────┘       │
│                                                 │               │
│                                                 ▼               │
│                                 ┌───────────────────────────────┤
│                                 │    AÇÕES DISPONÍVEIS         │
│                                 │                              │
│                                 │  1. Mesclar leads            │
│                                 │  2. Manter separados         │
│                                 │  3. Marcar como diferente    │
│                                 │                              │
│                                 └───────────────────────────────┘
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Processo de Mesclagem

### Regras de Mesclagem

| Campo | Regra |
|-------|-------|
| Nome | Manter o mais completo |
| Telefone | Manter todos (principal + secundários) |
| E-mail | Manter todos |
| Veículo | Manter o mais recente |
| Origem | Manter a primeira (original) |
| Consultor | Manter do lead master |
| Histórico | Consolidar todas as interações |
| Status | Manter o mais avançado |

### Lead Master

| Critério de Escolha | Peso |
|--------------------|------|
| Lead mais antigo | Alto |
| Lead com mais dados | Médio |
| Lead já atribuído | Alto |
| Lead com mais interações | Médio |

---

## Inputs e Outputs

### Input (Detecção)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| lead_id | uuid | ID do lead a verificar |
| modo | enum | AUTOMATICO, MANUAL |

### Output (Resultado)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| duplicados_encontrados | array | Lista de leads similares |
| confianca | float | Grau de confiança do match |
| motivo | string | Critério que gerou o match |

### Input (Mesclagem)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| lead_master_id | uuid | Lead que será mantido |
| lead_duplicado_id | uuid | Lead que será mesclado |
| justificativa | text | Motivo da mesclagem |

---

## Critérios de Aceitação

### Cenário 1 — Detecção por telefone
- **Dado que** tento cadastrar lead com telefone (11) 99999-8888
- **E** já existe lead com esse telefone
- **Quando** a validação é executada
- **Então** recebo alerta: "Lead possivelmente duplicado encontrado"
- **E** vejo os dados do lead existente

### Cenário 2 — Detecção por e-mail
- **Dado que** tento cadastrar lead com e-mail joao@email.com
- **E** já existe lead com esse e-mail
- **Quando** a validação é executada
- **Então** recebo alerta de duplicidade

### Cenário 3 — Permitir cadastro mesmo duplicado
- **Dado que** recebi alerta de duplicidade
- **Quando** confirmo que são pessoas diferentes
- **Então** o novo lead é criado
- **E** é marcado como "verificado - não duplicado"

### Cenário 4 — Mesclar leads
- **Dado que** identifiquei dois leads que são a mesma pessoa
- **Quando** aciono "Mesclar Leads"
- **E** confirmo a operação
- **Então** os dados são consolidados no lead master
- **E** o lead duplicado é arquivado com referência

### Cenário 5 — Histórico consolidado
- **Dado que** mesclei dois leads
- **Quando** visualizo a timeline do lead master
- **Então** vejo interações de ambos os leads
- **E** está indicado de qual lead veio cada interação

### Cenário 6 — Relatório de duplicados
- **Dado que** sou gestor e quero limpar a base
- **Quando** acesso "Relatório de Duplicados"
- **Então** vejo lista de possíveis duplicados
- **E** posso resolver em lote

### Cenário 7 — Match fuzzy por nome
- **Dado que** existe lead "João da Silva Santos"
- **Quando** cadastro "Joao Silva Santos" (sem acento)
- **Então** o sistema detecta similaridade
- **E** sugere verificação manual

### Cenário 8 — Desfazer mesclagem
- **Dado que** mesclei leads por engano
- **Quando** aciono "Desfazer Mesclagem" (disponível por 24h)
- **Então** os leads são separados novamente
- **E** o histórico é restaurado

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Telefone igual = duplicado certo (99%) |
| RN-002 | E-mail igual = duplicado certo (99%) |
| RN-003 | Nome similar + cidade = verificação manual |
| RN-004 | Lead duplicado pode ser cadastrado com confirmação |
| RN-005 | Mesclagem mantém lead mais antigo como master |
| RN-006 | Histórico de ambos é consolidado |
| RN-007 | Lead mesclado é arquivado, não excluído |
| RN-008 | Desfazer mesclagem disponível por 24h |
| RN-009 | Permissão necessária para mesclar: `leads.mesclar` |
| RN-010 | Detecção automática pode ser desativada por config |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────┐
│  ⚠️ POSSÍVEL DUPLICADO DETECTADO                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  O lead que você está cadastrando pode já existir no sistema.   │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  NOVO LEAD                        LEAD EXISTENTE                │
│  ┌─────────────────────────┐     ┌─────────────────────────┐    │
│  │ Nome: João da Silva     │     │ Nome: João D. Silva     │    │
│  │ Tel: (11) 99999-8888    │ 🔗  │ Tel: (11) 99999-8888    │    │
│  │ Email: joao@email.com   │     │ Email: joao@gmail.com   │    │
│  │ Origem: Landing Page    │     │ Origem: WhatsApp        │    │
│  │ Data: Agora             │     │ Data: 20/01/2026        │    │
│  └─────────────────────────┘     └─────────────────────────┘    │
│                                                                 │
│  Confiança do Match: 99% (Mesmo telefone)                       │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  O que você deseja fazer?                                       │
│                                                                 │
│  ○ Mesclar com o lead existente (recomendado)                   │
│  ○ Cadastrar como novo lead (são pessoas diferentes)            │
│  ○ Cancelar cadastro                                            │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│                                 [Cancelar]  [Confirmar]         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Relatório de Duplicados

```
┌─────────────────────────────────────────────────────────────────┐
│  📋 RELATÓRIO DE DUPLICADOS                      [Executar Scan]│
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Última verificação: 25/01/2026 às 03:00 (automática)           │
│  Possíveis duplicados encontrados: 47 grupos                    │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  │ Leads            │ Match    │ Confiança │ Status  │ Ações   │
│  │──────────────────│──────────│───────────│─────────│─────────│
│  │ João Silva (2)   │ Telefone │ 99%       │Pendente │[Resolver│
│  │ Maria Santos (3) │ E-mail   │ 99%       │Pendente │[Resolver│
│  │ Pedro Souza (2)  │ Nome+UF  │ 75%       │Pendente │[Resolver│
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  Resolvidos hoje: 12 | Pendentes: 47                            │
│                                                                 │
│  [Resolver Todos Automáticos (>95%)]   [Exportar Lista]         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 25/01/2026 | 1.0 | PO | Criação inicial com DDD |

---

**Identificador**: US-CRM-LEAD-020  
**Módulo**: CRM-Leads  
**Fase**: 5 - Integrações e Inteligência  
**Status**: ✅ Pronto  
**Versão**: 1.0
