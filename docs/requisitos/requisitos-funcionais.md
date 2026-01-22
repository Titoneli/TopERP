# Requisitos Funcionais - TopERP

## Visão Geral

Este documento lista os requisitos funcionais do sistema TopERP, organizados por módulo.

---

## Módulo Financeiro (FIN)

### REQ-FIN-001: Cadastro de Contas a Pagar
- **Descrição**: O sistema deve permitir o cadastro de títulos a pagar
- **Prioridade**: Must Have
- **Status**: Aprovado

### REQ-FIN-002: Cadastro de Contas a Receber
- **Descrição**: O sistema deve permitir o cadastro de títulos a receber
- **Prioridade**: Must Have
- **Status**: Aprovado

### REQ-FIN-003: Baixa de Títulos
- **Descrição**: O sistema deve permitir registrar o pagamento/recebimento de títulos
- **Prioridade**: Must Have
- **Status**: Aprovado

### REQ-FIN-004: Fluxo de Caixa
- **Descrição**: O sistema deve apresentar visão consolidada de entradas e saídas
- **Prioridade**: Must Have
- **Status**: Aprovado

---

## Módulo de Vendas (VEN)

### REQ-VEN-001: Cadastro de Clientes
- **Descrição**: O sistema deve permitir o cadastro completo de clientes
- **Prioridade**: Must Have
- **Status**: Aprovado

### REQ-VEN-002: Pedido de Venda
- **Descrição**: O sistema deve permitir o registro de pedidos de venda
- **Prioridade**: Must Have
- **Status**: Aprovado

### REQ-VEN-003: Faturamento
- **Descrição**: O sistema deve permitir o faturamento de pedidos
- **Prioridade**: Must Have
- **Status**: Aprovado

### REQ-VEN-004: Emissão de NF-e
- **Descrição**: O sistema deve permitir a emissão de notas fiscais eletrônicas
- **Prioridade**: Must Have
- **Status**: Aprovado

---

## Módulo de Compras (COM)

### REQ-COM-001: Cadastro de Fornecedores
- **Descrição**: O sistema deve permitir o cadastro completo de fornecedores
- **Prioridade**: Must Have
- **Status**: Aprovado

### REQ-COM-002: Pedido de Compra
- **Descrição**: O sistema deve permitir o registro de pedidos de compra
- **Prioridade**: Must Have
- **Status**: Aprovado

### REQ-COM-003: Entrada de Nota Fiscal
- **Descrição**: O sistema deve permitir o registro de notas fiscais de entrada
- **Prioridade**: Must Have
- **Status**: Aprovado

---

## Módulo de Estoque (EST)

### REQ-EST-001: Cadastro de Produtos
- **Descrição**: O sistema deve permitir o cadastro completo de produtos
- **Prioridade**: Must Have
- **Status**: Aprovado

### REQ-EST-002: Movimentação de Estoque
- **Descrição**: O sistema deve registrar todas as movimentações de estoque
- **Prioridade**: Must Have
- **Status**: Aprovado

### REQ-EST-003: Consulta de Saldos
- **Descrição**: O sistema deve permitir consultar saldos de estoque em tempo real
- **Prioridade**: Must Have
- **Status**: Aprovado

---

## Módulo CRM - Leads (CRM-LED)

### REQ-CRM-LED-001: Captação de Lead via Landing Page
- **Descrição**: O sistema deve permitir a captação de leads através de formulário multi-etapas em landing page
- **Prioridade**: Essencial
- **Status**: Em análise

### REQ-CRM-LED-002: Validação de Telefone contra Blacklist
- **Descrição**: O sistema deve validar se o telefone informado não pertence a um consultor ativo
- **Prioridade**: Essencial
- **Status**: Em análise

### REQ-CRM-LED-003: Extração e Armazenamento de DDD
- **Descrição**: O sistema deve extrair e armazenar o DDD do telefone para análise regional
- **Prioridade**: Essencial
- **Status**: Em análise

### REQ-CRM-LED-004: Rastreabilidade de Origem
- **Descrição**: O sistema deve capturar e armazenar o código de origem (`cod_origem`) via query string
- **Prioridade**: Essencial
- **Status**: Em análise

### REQ-CRM-LED-005: Direcionamento para Consultor
- **Descrição**: O sistema deve permitir direcionar lead para consultor específico via parâmetro `cod_colaborador`
- **Prioridade**: Essencial
- **Status**: Em análise

### REQ-CRM-LED-006: Cadastro Progressivo em Etapas
- **Descrição**: O sistema deve cadastrar o lead na Etapa 1, atualizando nas etapas subsequentes
- **Prioridade**: Essencial
- **Status**: Em análise

### REQ-CRM-LED-007: Métricas por DDD
- **Descrição**: O sistema deve fornecer dashboard com distribuição de leads por DDD
- **Prioridade**: Importante
- **Status**: Em análise

### REQ-CRM-LED-008: Métricas por Origem
- **Descrição**: O sistema deve fornecer dashboard com distribuição de leads por código de origem
- **Prioridade**: Importante
- **Status**: Em análise

---

## Matriz de Rastreabilidade

| Requisito | Histórias Relacionadas | Casos de Uso |
|-----------|----------------------|--------------|
| REQ-FIN-001 | US-FIN-001 | UC-FIN-001 |
| REQ-FIN-002 | US-FIN-002 | UC-FIN-002 |
| REQ-CRM-LED-001 | US-CRM-LED-001 | - |
| REQ-CRM-LED-002 | US-CRM-LED-001 | - |
| REQ-CRM-LED-003 | US-CRM-LED-001 | - |
| REQ-CRM-LED-004 | US-CRM-LED-001 | - |
| REQ-CRM-LED-005 | US-CRM-LED-001 | - |
| REQ-CRM-LED-006 | US-CRM-LED-001 | - |
| REQ-CRM-LED-007 | US-CRM-LED-001 | - |
| REQ-CRM-LED-008 | US-CRM-LED-001 | - |
| REQ-VEN-001 | US-VEN-001 | UC-VEN-001 |
| REQ-EST-001 | US-EST-001 | UC-EST-001 |

---

**Última Atualização**: 21 de janeiro de 2026  
**Versão**: 1.0
