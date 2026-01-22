# US-CRM-FUN-001 — Visualizar Funil de Vendas

## História de Usuário

**Como** consultor de proteção veicular,  
**Quero** visualizar minhas negociações organizadas por etapa do funil,  
**Para** acompanhar o andamento e priorizar minhas ações comerciais.

## Prioridade

Essencial

## Estimativa

8 SP

---

## Critérios de Aceitação

### Cenário 1 — Visualizar funil
- **Dado que** estou autenticado como consultor
- **Quando** acesso o funil de vendas
- **Então** visualizo minhas negociações organizadas por etapas do funil

### Cenário 2 — Informações mínimas da negociação
- **Dado que** visualizo uma negociação no funil
- **Então** vejo, no mínimo:
  - Nome do lead
  - Valor estimado
  - Etapa atual
  - Data prevista de fechamento

### Cenário 3 — Movimentação entre etapas
- **Dado que** visualizo o funil
- **Quando** movo uma negociação para outra etapa
- **Então** a etapa da negociação é atualizada no sistema

### Cenário 4 — Restrição de visibilidade
- **Dado que** estou logado como consultor
- **Então** visualizo apenas negociações sob minha responsabilidade

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Cada negociação está vinculada a um único lead |
| RN-002 | Uma negociação só pode existir em uma etapa por vez |
| RN-003 | A movimentação entre etapas deve ser registrada no histórico |
| RN-004 | O consultor só pode visualizar suas próprias negociações |

---

## Definição de Pronto

- Funil exibindo negociações por etapa
- Movimentação entre etapas funcional
- Regras de visibilidade respeitadas
- Dados persistidos corretamente
- Validação do PO

---

**Criado por**: Gustavo Titoneli (Product Owner)  
**Data**: 21/01/2026  
**Versão**: 2.0
