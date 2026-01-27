# US-CRM-FUN-022 — Editar Dados da Negociação/Lead

## História de Usuário

**Como** consultor de vendas,  
**Quero** editar os dados de uma negociação/lead,  
**Para** corrigir informações incorretas ou complementar dados faltantes.

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
| `LeadUpdated` | Lead editado | Auditoria, Analytics |
| `LeadPhoneChanged` | Telefone alterado | Validações |
| `LeadStatusChanged` | Status alterado | Notificações, Workflow |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Edição** | Alteração de dados do lead |
| **Histórico de Alterações** | Log de todas as modificações |
| **Campos Editáveis** | Dados que podem ser modificados |

---

## Contexto de Negócio

Durante o processo de vendas, informações do lead podem precisar de correção ou complementação. A edição deve ser simples mas manter rastreabilidade das alterações.

### Cenários de Edição

| Cenário | Exemplo |
|---------|---------|
| Correção | Telefone digitado errado |
| Complemento | Adicionar e-mail que não tinha |
| Atualização | Mudança de veículo de interesse |
| Enriquecimento | Adicionar dados de veículo/localização |

---

## Campos Editáveis

### Dados de Contato

| Campo | Editável | Validação ao Editar |
|-------|----------|---------------------|
| Nome | Sim | Mín. 3 caracteres |
| Telefone | Sim | Formato válido, não consultor |
| E-mail | Sim | Formato válido |

### Dados do Veículo

| Campo | Editável | Validação ao Editar |
|-------|----------|---------------------|
| Marca | Sim | Lista válida |
| Modelo | Sim | Pertence à marca |
| Ano Modelo | Sim | Últimos 30 anos |
| Tipo de Uso | Sim | Passeio/Comercial |

### Localização

| Campo | Editável | Validação ao Editar |
|-------|----------|---------------------|
| UF | Sim | UF válida |
| Cidade | Sim | Cidade da UF |

### Status e Qualificação

| Campo | Editável | Restrição |
|-------|----------|-----------|
| Status | Sim | Apenas próximo status válido |
| Temperatura | Via BANT | Calculado automaticamente |
| Score BANT | Via formulário | Não editável diretamente |

### Observações

| Campo | Editável | Validação |
|-------|----------|-----------|
| Observações | Sim | Máx. 2000 caracteres |

---

## Campos NÃO Editáveis

| Campo | Motivo |
|-------|--------|
| ID | Identificador único |
| Data Criação | Registro histórico |
| Origem | Rastreabilidade |
| Criado Por | Auditoria |
| DDD (extraído) | Calculado do telefone |

---

## Critérios de Aceitação

### Cenário 1 — Editar nome
- **Dado que** acesso a edição de um lead
- **Quando** altero o nome e salvo
- **Então** o nome é atualizado
- **E** registro de alteração é criado no histórico

### Cenário 2 — Editar telefone
- **Dado que** altero o telefone do lead
- **Quando** salvo a alteração
- **Então** o telefone é atualizado
- **E** o DDD é recalculado automaticamente
- **E** evento `LeadPhoneChanged` é disparado

### Cenário 3 — Telefone de consultor bloqueado
- **Dado que** tento alterar para telefone de consultor ativo
- **Quando** tento salvar
- **Então** recebo erro: "Este telefone pertence a um consultor ativo"
- **E** a alteração não é salva

### Cenário 4 — Adicionar dados de veículo
- **Dado que** o lead não tem dados de veículo
- **Quando** preencho marca, modelo e ano
- **E** salvo a edição
- **Então** os dados de veículo são adicionados

### Cenário 5 — Visualizar histórico de alterações
- **Dado que** um lead foi editado várias vezes
- **Quando** acesso o histórico de alterações
- **Então** vejo lista de todas as modificações
- **E** cada item mostra: campo, valor anterior, valor novo, quem alterou, quando

### Cenário 6 — Edição inline na lista
- **Dado que** estou na lista de leads
- **Quando** dou duplo-clique em um campo editável
- **Então** posso editar diretamente na lista
- **E** a alteração é salva ao sair do campo

### Cenário 7 — Cancelar edição
- **Dado que** estou editando um lead
- **Quando** clico em "Cancelar"
- **Então** as alterações são descartadas
- **E** os dados originais são mantidos

### Cenário 8 — Validação de campos obrigatórios
- **Dado que** tento limpar um campo obrigatório (nome, telefone)
- **Quando** tento salvar
- **Então** recebo erro de validação
- **E** a alteração não é salva

### Cenário 9 — Alterar status do lead
- **Dado que** quero avançar o lead de NOVO para CONTATADO
- **Quando** altero o status e salvo
- **Então** o status é atualizado
- **E** evento `LeadStatusChanged` é disparado

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Consultor pode editar leads atribuídos a ele |
| RN-002 | Supervisor pode editar leads da equipe |
| RN-003 | Gestor pode editar qualquer lead |
| RN-004 | Toda alteração gera registro de auditoria |
| RN-005 | Telefone alterado recalcula DDD |
| RN-006 | Telefone de consultor ativo é bloqueado |
| RN-007 | Campos de origem e criação não são editáveis |
| RN-008 | Status só pode avançar (exceto ARQUIVADO que retorna) |
| RN-009 | Histórico de alterações é permanente |
| RN-010 | Edição inline disponível para campos simples |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────┐
│  ✏️ EDITAR LEAD                                       [X]       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ID: LEAD-12345 | Criado em: 25/01/2026 | Origem: Landing Page  │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  📋 DADOS DE CONTATO                                            │
│                                                                 │
│  Nome *                                                         │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ João da Silva Santos                                    │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  Telefone *                        E-mail                       │
│  ┌──────────────────────────┐     ┌──────────────────────────┐  │
│  │ (11) 99999-8888          │     │ joao.silva@email.com     │  │
│  └──────────────────────────┘     └──────────────────────────┘  │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  🚗 DADOS DO VEÍCULO                                            │
│                                                                 │
│  Marca                 Modelo                  Ano              │
│  ┌──────────────┐     ┌──────────────┐        ┌──────────┐      │
│  │ ▼ Fiat       │     │ ▼ Strada     │        │ ▼ 2024   │      │
│  └──────────────┘     └──────────────┘        └──────────┘      │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  📍 LOCALIZAÇÃO                                                 │
│                                                                 │
│  Estado                            Cidade                       │
│  ┌──────────────────────────┐     ┌──────────────────────────┐  │
│  │ ▼ São Paulo              │     │ ▼ Campinas               │  │
│  └──────────────────────────┘     └──────────────────────────┘  │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  📝 OBSERVAÇÕES                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ Cliente interessado em plano completo. Veículo novo.    │    │
│  │ Prefere contato no período da tarde.                    │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  📜 [Ver Histórico de Alterações]                               │
│                                                                 │
│                                    [Cancelar]  [Salvar]         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 25/01/2026 | 1.0 | PO | Criação inicial com DDD (como LEAD-016) |
| 27/01/2026 | 2.0 | PO | Movido de CRM-Leads para CRM-Funil-Vendas |

---

**Identificador**: US-CRM-FUN-022  
**Módulo**: CRM-Funil-Vendas  
**Fase**: Pipeline de Vendas  
**Status**: ✅ Pronto  
**Versão**: 2.0
