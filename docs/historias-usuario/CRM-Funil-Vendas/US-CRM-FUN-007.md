# US-CRM-FUN-007 — Visualizar Detalhes da Negociação

## História de Usuário

**Como** consultor de vendas,  
**Quero** visualizar todos os detalhes de uma negociação,  
**Para** ter contexto completo antes de interagir com o lead.

## Prioridade

Essencial

## Estimativa

5 SP

---

## Contexto DDD

### Bounded Context
- **Contexto**: Funil de Vendas (Sales Pipeline)
- **Módulo**: CRM-Funil-Vendas
- **Tipo**: Core Domain

### Aggregate Root
- **Negociação** (visualização completa)

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Detalhes** | Visão completa da negociação |
| **Timeline** | Histórico cronológico de eventos |
| **Contexto** | Informações para tomada de decisão |

---

## Contexto de Negócio

A tela de detalhes é onde o consultor passa a maior parte do tempo. Deve apresentar todas as informações relevantes de forma organizada e acessível.

### Seções da Tela de Detalhes

| Seção | Conteúdo |
|-------|----------|
| Cabeçalho | Nome, etapa, valor, data previsão |
| Dados do Lead | Contato, veículo, localização |
| Atividades | Lista de atividades pendentes/concluídas |
| Interações | Timeline de contatos |
| Documentos | Cotações, propostas, contratos |
| Histórico | Movimentações no funil |

---

## Critérios de Aceitação

### Cenário 1 — Acessar detalhes
- **Dado que** estou no funil de vendas
- **Quando** clico em uma negociação
- **Então** a tela de detalhes é aberta
- **E** todas as informações são carregadas

### Cenário 2 — Informações do lead
- **Dado que** estou nos detalhes
- **Então** vejo dados completos do lead:
  - Nome, telefone, e-mail
  - Veículo (marca, modelo, ano, placa)
  - Localização (UF, cidade)
  - Score BANT (se disponível)

### Cenário 3 — Ações rápidas
- **Dado que** estou nos detalhes
- **Então** tenho acesso rápido a:
  - Ligar (click-to-call)
  - WhatsApp
  - E-mail
  - Nova atividade
  - Registrar interação

### Cenário 4 — Navegação entre abas
- **Dado que** estou nos detalhes
- **Quando** navego entre abas (Atividades, Interações, Docs)
- **Então** o conteúdo de cada aba é carregado
- **E** a navegação é fluida

### Cenário 5 — Edição inline
- **Dado que** quero alterar valor estimado
- **Quando** clico no campo
- **Então** posso editar diretamente
- **E** alteração é salva automaticamente

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Consultor vê apenas suas negociações |
| RN-002 | Supervisor vê negociações da equipe |
| RN-003 | Admin vê todas as negociações |
| RN-004 | Dados sensíveis são mascarados conforme LGPD |
| RN-005 | Histórico é somente leitura |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  ← Voltar                          NEGOCIAÇÃO #NEG-202601-00123                 │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │  👤 João da Silva                            Etapa: [Cotação ▼]         │   │
│  │  📞 (11) 99999-1234  [📞] [💬] [📧]                                     │   │
│  │                                                                         │   │
│  │  🚗 Fiat Strada 2024 - ABC-1234              💰 R$ 1.500,00             │   │
│  │  📍 São Paulo - SP                           📅 Previsão: 15/02/2026    │   │
│  │                                                                         │   │
│  │  🌡️ Temperatura: 🔴 Quente    |    📊 Score BANT: 10/12                 │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │ [Atividades (3)] │ [Interações (5)] │ [Documentos (2)] │ [Histórico]    │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  ATIVIDADES PENDENTES                                    [+ Nova Atividade]   │
│  ─────────────────────────────────────────────────────────────────────────     │
│                                                                                 │
│  ⏰ HOJE 14:30                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │ 📞 Ligar para confirmar recebimento da cotação              [✓] [✏️]   │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  ⏰ AMANHÃ 10:00                                                               │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │ 📧 Enviar proposta formal                                   [✓] [✏️]   │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  ─────────────────────────────────────────────────────────────────────────     │
│  [🏆 Marcar como Ganha]  [❌ Marcar como Perdida]  [📋 Duplicar]  [🗑️]        │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Dependências

| Tipo | Módulo | Descrição |
|------|--------|-----------|
| Requer | FUN-002 | Negociação existente |
| Integra | CRM-Leads | Dados do lead |
| Integra | CRM-COT | Cotações vinculadas |
| Integra | CRM-PRO | Propostas vinculadas |

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 27/01/2026 | 1.0 | PO | Criação inicial com DDD |

---

**Identificador**: US-CRM-FUN-007  
**Módulo**: CRM-Funil-Vendas  
**Fase**: Essencial  
**Status**: ✅ Pronto  
**Versão**: 1.0
