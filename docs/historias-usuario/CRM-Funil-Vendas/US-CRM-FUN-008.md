# US-CRM-FUN-008 — Marcar Negociação como Ganha

## História de Usuário

**Como** consultor de vendas,  
**Quero** marcar uma negociação como ganha,  
**Para** registrar o fechamento bem-sucedido e iniciar o processo de pós-venda.

## Prioridade

Essencial

## Estimativa

8 SP

---

## Contexto DDD

### Bounded Context
- **Contexto**: Funil de Vendas (Sales Pipeline)
- **Módulo**: CRM-Funil-Vendas
- **Tipo**: Core Domain

### Aggregate Root
- **Negociação** (transição de estado)

### Domain Events
| Evento | Trigger | Assinantes |
|--------|---------|------------|
| `NegociacaoGanha` | Marcação de ganho | Pós-venda, Comissão, Analytics |
| `ContratoGerado` | Documento criado | Assinatura Digital |
| `ClienteConvertido` | Lead vira cliente | CRM-Leads, Cadastros |

### Linguagem Ubíqua
| Termo | Definição |
|-------|-----------|
| **Negociação Ganha** | Venda fechada com sucesso |
| **Conversão** | Transformação de lead em cliente |
| **Fechamento** | Conclusão bem-sucedida da venda |
| **Win** | Resultado positivo |

---

## Contexto de Negócio

Marcar como ganha é o momento mais importante do funil. Dispara uma série de processos: geração de contrato, envio para assinatura, cálculo de comissão, início do pós-venda.

### Dados de Fechamento

| Campo | Tipo | Obrigatório |
|-------|------|-------------|
| Valor Final | Moeda | Sim |
| Plano Escolhido | Select | Sim |
| Data de Início | Date | Sim |
| Forma de Pagamento | Select | Sim |
| Observações | Text | Não |

---

## Critérios de Aceitação

### Cenário 1 — Marcar como ganha
- **Dado que** estou nos detalhes de uma negociação
- **Quando** clico em "Marcar como Ganha"
- **Então** modal de confirmação é exibido
- **E** solicita dados de fechamento

### Cenário 2 — Validação de dados
- **Dado que** estou confirmando o ganho
- **Quando** não preencho campos obrigatórios
- **Então** mensagem de erro é exibida
- **E** não permite confirmar

### Cenário 3 — Confirmação bem-sucedida
- **Dado que** preenchi todos os dados
- **Quando** confirmo o fechamento
- **Então** negociação é movida para "Fechado (Ganho)"
- **E** evento `NegociacaoGanha` é disparado
- **E** lead é convertido em cliente
- **E** processo de contrato é iniciado

### Cenário 4 — Geração automática de contrato
- **Dado que** a negociação foi marcada como ganha
- **Então** contrato é gerado automaticamente
- **E** enviado para assinatura digital

### Cenário 5 — Comissão calculada
- **Dado que** a negociação foi fechada
- **Então** comissão do consultor é calculada
- **E** aparece na fila de pagamentos

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Valor final não pode ser zero |
| RN-002 | Data de início deve ser futura ou hoje |
| RN-003 | Plano deve estar ativo no sistema |
| RN-004 | Negociação ganha não pode voltar para outra etapa |
| RN-005 | Contrato é gerado automaticamente |
| RN-006 | Comissão é calculada conforme regras vigentes |
| RN-007 | Lead é convertido em cliente no CRM |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────┐
│  🏆 CONFIRMAR FECHAMENTO                               [X]      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✅ Parabéns! Você está fechando uma venda!                     │
│                                                                 │
│  Lead: João da Silva                                            │
│  Veículo: Fiat Strada 2024                                      │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  Valor Final *                                                  │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ R$ 1.450,00                                             │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  Plano Escolhido *                                              │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Proteção Premium                                    ▼   │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  Data de Início da Proteção *                                   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ 01/02/2026                                    [📅]      │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  Forma de Pagamento *                                           │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Cartão de Crédito - 12x                             ▼   │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  📋 RESUMO                                                      │
│  • Comissão estimada: R$ 145,00                                │
│  • Contrato será gerado automaticamente                        │
│  • Cliente receberá link de assinatura por e-mail              │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│            [Cancelar]                    [🏆 Confirmar Ganho]   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Dependências

| Tipo | Módulo | Descrição |
|------|--------|-----------|
| Requer | FUN-007 | Detalhes da negociação |
| Dispara | CRM-PRO | Geração de contrato |
| Dispara | CRM-POS | Início do pós-venda |
| Dispara | CRM-COM | Cálculo de comissão |
| Atualiza | CRM-Leads | Conversão do lead |

---

## Histórico de Alterações

| Data | Versão | Autor | Descrição |
|------|--------|-------|-----------|
| 27/01/2026 | 1.0 | PO | Criação inicial com DDD |

---

**Identificador**: US-CRM-FUN-008  
**Módulo**: CRM-Funil-Vendas  
**Fase**: Essencial  
**Status**: ✅ Pronto  
**Versão**: 1.0
