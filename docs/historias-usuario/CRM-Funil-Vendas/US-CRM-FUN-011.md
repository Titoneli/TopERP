# US-CRM-FUN-011 — Configurar Funil Personalizado

## História de Usuário

**Como** administrador do CRM,  
**Quero** configurar as etapas do funil de vendas,  
**Para** adaptar o processo às necessidades da empresa.

## Prioridade

Importante

## Estimativa

13 SP

---

## Contexto DDD

### Bounded Context
- **Contexto**: Funil de Vendas (Sales Pipeline)
- **Módulo**: CRM-Funil-Vendas
- **Tipo**: Core Domain

### Aggregate Root
- **ConfiguracaoFunil** (configuração do pipeline)

### Domain Events
| Evento | Trigger | Assinantes |
|--------|---------|------------|
| `FunilConfigurado` | Alteração de etapas | Todos usuários |
| `EtapaAdicionada` | Nova etapa | Analytics |
| `EtapaRemovida` | Etapa excluída | Migração |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Etapa** | Fase do processo de vendas |
| **Funil** | Conjunto ordenado de etapas |
| **Automação** | Ação automática ao entrar na etapa |

---

## Contexto de Negócio

Cada empresa pode ter um processo de vendas diferente. A configuração do funil permite adaptar as etapas às necessidades específicas do negócio.

### Propriedades de uma Etapa

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| Nome | Text | Nome da etapa |
| Ordem | Number | Posição no funil |
| Cor | Color | Cor para visualização |
| Automação | Config | Ações automáticas |
| Campos Obrigatórios | List | Campos requeridos |
| Prazo Máximo | Number | Dias máximo na etapa |

---

## Critérios de Aceitação

### Cenário 1 — Adicionar nova etapa
- **Dado que** sou administrador
- **Quando** acesso configurações do funil
- **Então** posso adicionar nova etapa
- **E** definir nome, ordem e cor

### Cenário 2 — Reordenar etapas
- **Dado que** quero mudar a ordem das etapas
- **Quando** arrasto uma etapa para nova posição
- **Então** a ordem é atualizada
- **E** funil reflete nova sequência

### Cenário 3 — Remover etapa
- **Dado que** uma etapa não é mais usada
- **Quando** tento remover
- **Então** sistema verifica se há negociações
- **E** se houver, solicita migração para outra etapa

### Cenário 4 — Configurar automação
- **Dado que** configuro uma etapa
- **Quando** defino automação de entrada
- **Então** ação será executada automaticamente
- **E** ao mover negociação para essa etapa

### Cenário 5 — Campos obrigatórios por etapa
- **Dado que** quero exigir cotação na etapa "Proposta"
- **Quando** configuro campo obrigatório
- **Então** não é possível mover sem preencher

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Mínimo 3 etapas: Início, Ganho, Perdido |
| RN-002 | Etapas Ganho e Perdido são fixas |
| RN-003 | Máximo 15 etapas customizáveis |
| RN-004 | Nomes de etapas devem ser únicos |
| RN-005 | Remover etapa requer migração |
| RN-006 | Apenas Admin pode configurar |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────┐
│  ⚙️ CONFIGURAR FUNIL                                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ETAPAS DO FUNIL                           [+ Adicionar Etapa]  │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ ≡ │ 1. Novo Lead          │ 🔵 │ [⚙️] [🗑️]            │   │
│  ├─────────────────────────────────────────────────────────┤   │
│  │ ≡ │ 2. Contato Inicial    │ 🟡 │ [⚙️] [🗑️]            │   │
│  ├─────────────────────────────────────────────────────────┤   │
│  │ ≡ │ 3. Cotação            │ 🟠 │ [⚙️] [🗑️]            │   │
│  ├─────────────────────────────────────────────────────────┤   │
│  │ ≡ │ 4. Proposta Enviada   │ 🟣 │ [⚙️] [🗑️]            │   │
│  ├─────────────────────────────────────────────────────────┤   │
│  │ ≡ │ 5. Em Negociação      │ 🔴 │ [⚙️] [🗑️]            │   │
│  ├─────────────────────────────────────────────────────────┤   │
│  │ ≡ │ 6. Aguard. Vistoria   │ 🟤 │ [⚙️] [🗑️]            │   │
│  ├─────────────────────────────────────────────────────────┤   │
│  │ ≡ │ 7. Aguard. Pagamento  │ 🟢 │ [⚙️] [🗑️]            │   │
│  ├─────────────────────────────────────────────────────────┤   │
│  │ 🔒│ 8. Fechado (Ganho)    │ ⭐ │ [⚙️]      (fixo)      │   │
│  ├─────────────────────────────────────────────────────────┤   │
│  │ 🔒│ 9. Perdido            │ ⚫ │ [⚙️]      (fixo)      │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  💡 Arraste para reordenar | Clique em ⚙️ para configurar      │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│            [Cancelar]                    [💾 Salvar Funil]      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Dependências

| Tipo | Módulo | Descrição |
|------|--------|-----------|
| Requer | CRM-AUT | Permissão de Admin |
| Afeta | FUN-001 | Visualização do funil |
| Afeta | FUN-003 | Movimentação |

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 27/01/2026 | 1.0 | PO | Criação inicial com DDD |

---

**Identificador**: US-CRM-FUN-011  
**Módulo**: CRM-Funil-Vendas  
**Fase**: Importante  
**Status**: ✅ Pronto  
**Versão**: 1.0
