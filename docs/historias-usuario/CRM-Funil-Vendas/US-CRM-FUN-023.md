# US-CRM-FUN-023 — Visualizar Detalhes da Negociação/Lead

## História de Usuário

**Como** consultor de vendas,  
**Quero** visualizar todos os detalhes de uma negociação/lead,  
**Para** ter contexto completo antes de fazer contato ou avançar na negociação.

## Prioridade

Essencial

## Estimativa

5 SP

---

## Contexto DDD

### Bounded Context
- **Contexto**: Funil de Vendas (Sales Pipeline)
- **Módulo**: CRM-Funil-Vendas

### Aggregate Root
- **Negociação** (entidade principal)

### Domain Events
| Evento | Trigger | Assinantes |
|--------|---------|------------|
| `LeadViewed` | Lead visualizado | Analytics |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Detalhes do Lead** | Visão completa de todas as informações |
| **Timeline** | Histórico cronológico de interações |
| **Ficha do Lead** | Página com dados consolidados |

---

## Contexto de Negócio

Antes de contatar um lead, o consultor precisa ter visão completa do histórico, dados de contato, veículo de interesse e todas as interações anteriores. Isso permite um atendimento personalizado e eficiente.

### Seções da Página de Detalhes

| Seção | Conteúdo |
|-------|----------|
| Header | Nome, status, temperatura, ações rápidas |
| Contato | Telefone, e-mail, localização |
| Veículo | Marca, modelo, ano, tipo de uso |
| Qualificação | Score BANT, critérios individuais |
| Origem | Origem, campanha, parâmetros UTM |
| Timeline | Histórico de interações |
| Notas | Observações do consultor |

---

## Wireframe da Página de Detalhes

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  ◀ Voltar para lista                                                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────────┐│
│  │                           HEADER                                        ││
│  │  João da Silva Santos                           [✏️ Editar] [📦 Arquivar]││
│  │                                                                         ││
│  │  Status: 🟢 QUALIFICADO     Temperatura: 🔴 QUENTE (Score: 10)          ││
│  │  Consultor: Carlos Silva    Criado: 25/01/2026 às 10:30                 ││
│  │                                                                         ││
│  │  [📞 Ligar]  [💬 WhatsApp]  [📧 E-mail]  [📋 Nova Interação]            ││
│  └─────────────────────────────────────────────────────────────────────────┘│
│                                                                             │
│  ┌─────────────────────────────────┐ ┌─────────────────────────────────────┐│
│  │         CONTATO                 │ │         VEÍCULO                     ││
│  │                                 │ │                                     ││
│  │  📱 (11) 99999-8888             │ │  🚗 Fiat Strada 2024                ││
│  │     [Copiar] [WhatsApp]         │ │                                     ││
│  │                                 │ │  Tipo: Passeio                      ││
│  │  📧 joao.silva@email.com        │ │                                     ││
│  │     [Copiar] [Enviar e-mail]    │ │  Valor FIPE: R$ 85.000,00          ││
│  │                                 │ │                                     ││
│  │  📍 Campinas - SP               │ │  [🔄 Atualizar veículo]             ││
│  │                                 │ │                                     ││
│  └─────────────────────────────────┘ └─────────────────────────────────────┘│
│                                                                             │
│  ┌─────────────────────────────────┐ ┌─────────────────────────────────────┐│
│  │       QUALIFICAÇÃO BANT         │ │          ORIGEM                     ││
│  │                                 │ │                                     ││
│  │  Budget:    ███████░░░  2/3     │ │  Origem: Landing Page               ││
│  │  Authority: ██████████  3/3     │ │  Código: 1                          ││
│  │  Need:      ███████░░░  2/3     │ │                                     ││
│  │  Timeline:  ██████████  3/3     │ │  UTM Source: google                 ││
│  │  ─────────────────────────────  │ │  UTM Medium: cpc                    ││
│  │  Total: 10/12       🔴 QUENTE   │ │  UTM Campaign: protecao_veicular    ││
│  │                                 │ │                                     ││
│  │  [📋 Requalificar]              │ │  Consultor Origem: -                ││
│  └─────────────────────────────────┘ └─────────────────────────────────────┘│
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────────┐│
│  │                         TIMELINE                                        ││
│  │                                                                         ││
│  │  25/01/2026 14:30 │ 📞 Ligação realizada                                ││
│  │                   │ Carlos Silva                                        ││
│  │                   │ "Cliente interessado, agendou retorno para amanhã"  ││
│  │                   │                                                     ││
│  │  25/01/2026 11:00 │ 📋 Lead qualificado (BANT)                          ││
│  │                   │ Carlos Silva                                        ││
│  │                   │ Score: 10/12 - Temperatura: QUENTE                  ││
│  │                   │                                                     ││
│  │  25/01/2026 10:45 │ 👤 Lead atribuído                                   ││
│  │                   │ Sistema                                             ││
│  │                   │ Atribuído a Carlos Silva                            ││
│  │                   │                                                     ││
│  │  25/01/2026 10:30 │ ✨ Lead criado                                      ││
│  │                   │ Sistema                                             ││
│  │                   │ Origem: Landing Page                                ││
│  │                                                                         ││
│  │  [📝 Adicionar Nota]  [Carregar mais...]                                ││
│  └─────────────────────────────────────────────────────────────────────────┘│
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────────┐│
│  │                         OBSERVAÇÕES                                     ││
│  │                                                                         ││
│  │  Cliente conheceu a TopBrasil através de indicação do amigo Carlos.     ││
│  │  Interessado em plano completo para Strada nova.                        ││
│  │  Prefere contato no período da tarde, após às 14h.                      ││
│  │                                                                         ││
│  │  [✏️ Editar observações]                                                ││
│  └─────────────────────────────────────────────────────────────────────────┘│
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Critérios de Aceitação

### Cenário 1 — Visualizar dados básicos
- **Dado que** clico em um lead na lista
- **Quando** a página de detalhes carrega
- **Então** vejo nome, telefone, e-mail e status do lead
- **E** vejo a temperatura com indicador visual

### Cenário 2 — Visualizar dados do veículo
- **Dado que** o lead tem dados de veículo cadastrados
- **Quando** visualizo a seção Veículo
- **Então** vejo marca, modelo, ano e tipo de uso
- **E** vejo valor estimado FIPE (se disponível)

### Cenário 3 — Visualizar qualificação BANT
- **Dado que** o lead foi qualificado
- **Quando** visualizo a seção Qualificação
- **Então** vejo score de cada critério (Budget, Authority, Need, Timeline)
- **E** vejo score total e temperatura

### Cenário 4 — Visualizar origem e rastreamento
- **Dado que** visualizo a seção Origem
- **Quando** o lead veio de campanha
- **Então** vejo origem (Landing, WhatsApp, etc.)
- **E** vejo parâmetros UTM se disponíveis

### Cenário 5 — Visualizar timeline
- **Dado que** houve interações com o lead
- **Quando** visualizo a Timeline
- **Então** vejo lista cronológica de eventos
- **E** cada evento mostra data, tipo, autor e descrição

### Cenário 6 — Ações rápidas
- **Dado que** visualizo os detalhes do lead
- **Quando** clico em "Ligar" ou "WhatsApp"
- **Então** o aplicativo correspondente é aberto com o número do lead

### Cenário 7 — Copiar telefone
- **Dado que** preciso do telefone do lead
- **Quando** clico em "Copiar" ao lado do telefone
- **Então** o número é copiado para área de transferência
- **E** vejo feedback: "Copiado!"

### Cenário 8 — Lead sem veículo
- **Dado que** o lead não tem dados de veículo
- **Quando** visualizo a seção Veículo
- **Então** vejo mensagem: "Nenhum veículo informado"
- **E** vejo botão "Adicionar veículo"

### Cenário 9 — Lead não qualificado
- **Dado que** o lead ainda não foi qualificado
- **Quando** visualizo a seção Qualificação
- **Então** vejo mensagem: "Lead não qualificado"
- **E** vejo botão "Qualificar agora"

### Cenário 10 — Navegar para edição
- **Dado que** quero editar o lead
- **Quando** clico em "Editar"
- **Então** sou direcionado para a página de edição

### Cenário 11 — Visualizar lead arquivado
- **Dado que** o lead está com status ARQUIVADO
- **Quando** visualizo a página de detalhes
- **Então** vejo banner destacado com status "ARQUIVADO"
- **E** vejo o motivo do arquivamento (dos 14 disponíveis)
- **E** vejo data e usuário que arquivou
- **E** vejo botão "Reativar Lead"
- **E** as ações de contato ficam desabilitadas

### Cenário 12 — Reativar lead arquivado
- **Dado que** visualizo um lead arquivado
- **Quando** clico em "Reativar Lead"
- **Então** o lead volta para o status anterior ao arquivamento
- **E** evento `LeadUnarchived` é disparado
- **E** o lead volta a aparecer na fila de atendimento

---

## Motivos de Arquivamento (Referência)

| Código | Motivo | Descrição |
|--------|--------|-----------|
| 1 | Sem interesse | Lead informou que não tem interesse |
| 2 | Concorrente | Contratou com outra associação |
| 3 | Seguradora | Contratou com seguradora |
| 4 | Região não coberta | Região fora da área de abrangência |
| 5 | Valor não coberto | Valor do veículo superior ao aceito |
| 6 | Veículo não coberto | Modelo não aceito |
| 7 | Adesão alta | Valor da adesão superior ao esperado |
| 8 | Mensalidade alta | Valor da mensalidade superior ao esperado |
| 9 | Telefone inválido | Telefone/e-mail não funcionam |
| 10 | Não localizado | Sem retorno após tentativas |
| 11 | Duplicado | Lead duplicado |
| 12 | Fora do perfil | Não se enquadra no perfil |
| 13 | Teste | Lead de teste |
| 14 | Outros | Outro motivo (observação) |

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Consultor vê apenas leads atribuídos a ele |
| RN-002 | Supervisor vê leads da equipe |
| RN-003 | Gestor vê todos os leads |
| RN-004 | Timeline mostra eventos em ordem cronológica decrescente |
| RN-005 | Telefone formatado para padrão brasileiro |
| RN-006 | Ações rápidas dependem de dados disponíveis |
| RN-007 | Visualização registra evento para analytics |
| RN-008 | Seções vazias mostram estado vazio com CTA |
| RN-009 | Score BANT exibido com barra de progresso |
| RN-010 | Valor FIPE é informativo, atualizado semanalmente |

---

## Ações Possíveis

| Ação | Trigger | Resultado |
|------|---------|-----------|
| Ligar | Click "Ligar" | Abre discador |
| WhatsApp | Click "WhatsApp" | Abre WhatsApp Web |
| E-mail | Click "E-mail" | Abre cliente de e-mail |
| Copiar | Click "Copiar" | Copia para clipboard |
| Editar | Click "Editar" | Abre página de edição |
| Arquivar | Click "Arquivar" | Abre modal de arquivamento |
| Qualificar | Click "Qualificar" | Abre formulário BANT |
| Reativar | Click "Reativar" | Reativa lead arquivado |
| Nova Interação | Click "Nova Interação" | Abre registro de atividade |
| Voltar | Click "Voltar" | Retorna para lista |

---

## Wireframe — Lead Arquivado

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  ◀ Voltar para lista                                                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────────┐│
│  │  ⚠️ LEAD ARQUIVADO                                    [🔄 Reativar]     ││
│  │  ─────────────────────────────────────────────────────────────────────  ││
│  │  Motivo: Contratou com concorrente (associação)                         ││
│  │  Arquivado por: Carlos Silva em 26/01/2026 às 15:30                     ││
│  │  Observação: Cliente optou pela concorrência por oferta promocional     ││
│  └─────────────────────────────────────────────────────────────────────────┘│
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────────┐│
│  │  João da Silva Santos                                                   ││
│  │  Status: 📦 ARQUIVADO                                                   ││
│  │  [📞 Ligar] [💬 WhatsApp]  ← Desabilitados para leads arquivados        ││
│  └─────────────────────────────────────────────────────────────────────────┘│
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 25/01/2026 | 1.0 | PO | Criação inicial com DDD (como LEAD-017) |
| 27/01/2026 | 1.1 | PO | Adicionar cenários e wireframe para lead arquivado com 14 motivos |
| 27/01/2026 | 2.0 | PO | Movido de CRM-Leads para CRM-Funil-Vendas |

---

**Identificador**: US-CRM-FUN-023  
**Módulo**: CRM-Funil-Vendas  
**Fase**: Pipeline de Vendas  
**Status**: ✅ Pronto  
**Versão**: 2.0
