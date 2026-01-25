# CRM para Proteção Veicular - Histórias de Usuário

## Visão Geral do Projeto

Este documento organiza todas as histórias de usuário do sistema CRM desenvolvido especificamente para o setor de **Proteção Veicular**, baseado nos requisitos documentados no DRS (Documento de Requisitos do Sistema) e nos princípios de Domain-Driven Design (DDD).

## Contexto do Negócio

O CRM foi desenvolvido para atender às necessidades específicas de **consultores de proteção veicular**, facilitando:
- Captação e qualificação de leads
- Elaboração rápida e precisa de cotações
- Acompanhamento de negociações em funil de vendas
- Envio de propostas e contratos
- Gestão de pagamentos e vistorias
- Relacionamento pós-venda

## Fluxo Completo do CRM

```
┌─────────────┐
│ Captação de │ → Landing pages, campanhas, indicações
│    Leads    │
└──────┬──────┘
       ↓
┌─────────────┐
│Qualificação │ → Primeiro contato, identificação de necessidades
│  de Leads   │
└──────┬──────┘
       ↓
┌─────────────┐
│  Cotação    │ → Dados do veículo, condutor, cálculo de valores
│             │
└──────┬──────┘
       ↓
┌─────────────┐
│  Proposta   │ → Envio formal, negociação de condições
│             │
└──────┬──────┘
       ↓
┌─────────────┐
│  Vistoria   │ → Agendamento, realização, aprovação
│             │
└──────┬──────┘
       ↓
┌─────────────┐
│ Pagamento   │ → Geração de link, confirmação
│             │
└──────┬──────┘
       ↓
┌─────────────┐
│ Fechamento  │ → Geração de contrato, ativação
│             │
└──────┬──────┘
       ↓
┌─────────────┐
│ Pós-venda   │ → Acompanhamento, renovações, upsell
│             │
└─────────────┘
```

## Estrutura de Módulos

### 📁 [CRM-Autenticacao](CRM-Autenticacao/)
Gestão de acesso seguro ao sistema com controle de perfis e permissões.

**User Stories:**
- [US-CRM-AUT-001](CRM-Autenticacao/US-CRM-AUT-001.md) - Realizar Login no Sistema ⭐ Essencial
- [US-CRM-AUT-002](CRM-Autenticacao/US-CRM-AUT-002.md) - Realizar Logout do Sistema ⭐ Essencial
- US-CRM-AUT-003 - Recuperar Senha ⭐ Essencial
- US-CRM-AUT-004 - Controle de Permissões por Perfil ⭐ Essencial
- US-CRM-AUT-005 - Autenticação Multifator (MFA)
- US-CRM-AUT-006 - Controle de Horário de Acesso
- US-CRM-AUT-007 - Expiração de Senha

### 📁 [CRM-Dashboard](CRM-Dashboard/)
Painéis de visualização com métricas e indicadores de performance.

**User Stories:**
- US-CRM-DAS-001 - Visualizar Dashboard Principal ⭐ Essencial
- US-CRM-DAS-002 - Visualizar Métricas de Vendas
- US-CRM-DAS-003 - Visualizar Metas vs Realizado
- US-CRM-DAS-004 - Gráficos de Tendência
- US-CRM-DAS-005 - Alertas e Notificações

### 📁 [CRM-Leads](CRM-Leads/)
Captação, qualificação e gestão de leads (prospects).

**User Stories:**
- US-CRM-LEAD-001 - Cadastrar Novo Lead ⭐ Essencial
- US-CRM-LEAD-002 - Importar Leads em Massa
- US-CRM-LEAD-003 - Qualificar Lead
- US-CRM-LEAD-004 - Atribuir Lead a Consultor
- US-CRM-LEAD-005 - Captura via Landing Page
- US-CRM-LEAD-006 - Captura via Formulário Web
- US-CRM-LEAD-007 - Captura via WhatsApp
- US-CRM-LEAD-008 - Buscar e Filtrar Leads

### 📁 [CRM-Funil-Vendas](CRM-Funil-Vendas/)
Gestão visual do pipeline de vendas e negociações.

**User Stories:**
- [US-CRM-FUN-001](CRM-Funil-Vendas/US-CRM-FUN-001.md) - Visualizar Funil de Vendas ⭐ Essencial
- US-CRM-FUN-002 - Criar Nova Negociação ⭐ Essencial
- US-CRM-FUN-003 - Mover Negociação entre Etapas ⭐ Essencial
- US-CRM-FUN-004 - Adicionar Atividade/Tarefa ⭐ Essencial
- US-CRM-FUN-005 - Registrar Interação com Lead ⭐ Essencial
- US-CRM-FUN-006 - Filtrar e Buscar Negociações ⭐ Essencial
- US-CRM-FUN-007 - Visualizar Detalhes da Negociação ⭐ Essencial
- US-CRM-FUN-008 - Marcar Negociação como Ganha ⭐ Essencial
- US-CRM-FUN-009 - Marcar Negociação como Perdida ⭐ Essencial
- US-CRM-FUN-010 - Agendar Follow-up ⭐ Essencial
- US-CRM-FUN-011 - Configurar Funil Personalizado
- US-CRM-FUN-012 - Visualizar Métricas do Funil

### 📁 [CRM-Cotacoes](CRM-Cotacoes/)
Cálculo e apresentação de valores de proteção veicular.

**User Stories:**
- [US-CRM-COT-001](CRM-Cotacoes/US-CRM-COT-001.md) - Iniciar Nova Cotação ⭐ Essencial
- US-CRM-COT-002 - Informar Dados do Veículo ⭐ Essencial
- US-CRM-COT-003 - Informar Dados do Condutor ⭐ Essencial
- US-CRM-COT-004 - Selecionar Plano de Proteção ⭐ Essencial
- US-CRM-COT-005 - Adicionar Coberturas Opcionais ⭐ Essencial
- US-CRM-COT-006 - Calcular Valor da Cotação ⭐ Essencial
- US-CRM-COT-007 - Visualizar Comparativo de Planos ⭐ Essencial
- US-CRM-COT-008 - Salvar Cotação ⭐ Essencial
- US-CRM-COT-009 - Editar Cotação Existente ⭐ Essencial
- US-CRM-COT-010 - Gerar PDF da Cotação ⭐ Essencial
- US-CRM-COT-011 - Aplicar Desconto na Cotação
- US-CRM-COT-012 - Simular Formas de Pagamento
- US-CRM-COT-013 - Duplicar Cotação
- US-CRM-COT-014 - Enviar Cotação por WhatsApp
- US-CRM-COT-015 - Enviar Cotação por E-mail

### 📁 [CRM-Propostas](CRM-Propostas/)
Geração, envio e acompanhamento de propostas formais.

**User Stories:**
- US-CRM-PRO-001 - Gerar Proposta a partir de Cotação ⭐ Essencial
- US-CRM-PRO-002 - Personalizar Template de Proposta ⭐ Essencial
- US-CRM-PRO-003 - Enviar Proposta por E-mail ⭐ Essencial
- US-CRM-PRO-004 - Enviar Proposta por WhatsApp ⭐ Essencial
- US-CRM-PRO-005 - Rastrear Abertura de Proposta ⭐ Essencial
- US-CRM-PRO-006 - Aprovar/Recusar Proposta (Lead)
- US-CRM-PRO-007 - Assinar Proposta Digitalmente
- US-CRM-PRO-008 - Histórico de Versões da Proposta

### 📁 [CRM-Pagamentos](CRM-Pagamentos/)
Gestão de recebimentos e confirmação de pagamentos.

**User Stories:**
- US-CRM-PAG-001 - Gerar Link de Pagamento ⭐ Essencial
- US-CRM-PAG-002 - Enviar Link de Pagamento ⭐ Essencial
- US-CRM-PAG-003 - Confirmar Pagamento ⭐ Essencial
- US-CRM-PAG-004 - Visualizar Status de Pagamento ⭐ Essencial
- US-CRM-PAG-005 - Integração com Gateway de Pagamento ⭐ Essencial
- US-CRM-PAG-006 - Parcelamento de Valores
- US-CRM-PAG-007 - Boleto Bancário
- US-CRM-PAG-008 - PIX
- US-CRM-PAG-009 - Cartão de Crédito

### 📁 [CRM-Vistorias](CRM-Vistorias/)
Agendamento e acompanhamento de vistorias de veículos.

**User Stories:**
- US-CRM-VIS-001 - Solicitar Vistoria ⭐ Essencial
- US-CRM-VIS-002 - Enviar Link de Vistoria ⭐ Essencial
- US-CRM-VIS-003 - Agendar Data/Hora de Vistoria
- US-CRM-VIS-004 - Visualizar Status da Vistoria ⭐ Essencial
- US-CRM-VIS-005 - Integração com Vistocar ⭐ Essencial
- US-CRM-VIS-006 - Upload de Fotos do Veículo
- US-CRM-VIS-007 - Aprovar/Reprovar Vistoria

### 📁 [CRM-Pos-Venda](CRM-Pos-Venda/)
Acompanhamento de clientes após fechamento do contrato.

**User Stories:**
- US-CRM-POS-001 - Registrar Interação Pós-venda
- US-CRM-POS-002 - Pesquisa de Satisfação
- US-CRM-POS-003 - Alertas de Renovação
- US-CRM-POS-004 - Gestão de Sinistros
- US-CRM-POS-005 - Upsell e Cross-sell
- US-CRM-POS-006 - Programa de Indicação

## Épicos e Releases

### Release 1.0 - MVP (Q1/2026)
**Objetivo**: Lançar funcionalidades core para operação básica

| Épico | Módulos | Status |
|-------|---------|--------|
| Autenticação e Segurança | CRM-Autenticacao | 🔄 Em planejamento |
| Gestão de Leads | CRM-Leads | 🔄 Em planejamento |
| Funil de Vendas | CRM-Funil-Vendas | 🔄 Em planejamento |
| Cotações Básicas | CRM-Cotacoes | 🔄 Em planejamento |

### Release 1.1 - Comercial Completo (Q2/2026)
**Objetivo**: Completar fluxo comercial com propostas e pagamentos

| Épico | Módulos | Status |
|-------|---------|--------|
| Propostas e Contratos | CRM-Propostas | 📋 Planejado |
| Pagamentos | CRM-Pagamentos | 📋 Planejado |
| Vistorias | CRM-Vistorias | 📋 Planejado |

### Release 1.2 - Gestão Avançada (Q3/2026)
**Objetivo**: Recursos de gestão e analytics

| Épico | Módulos | Status |
|-------|---------|--------|
| Dashboard e Métricas | CRM-Dashboard | 📋 Planejado |
| Pós-venda | CRM-Pos-Venda | 📋 Planejado |
| Automações | Todos | 📋 Planejado |

## Convenções Utilizadas

### Identificadores
- **US-[MÓDULO]-[NÚMERO]**: User Story (ex: US-CRM-FUN-001)
- **RN-[MÓDULO]-[NÚMERO]**: Regra de Negócio (ex: RN-CRM-COT-001)
- **REQ-[MÓDULO]-[NÚMERO]**: Requisito (ex: REQ-CRM-PAG-001)

### Prioridades (MoSCoW)
- ⭐ **Essencial**: Obrigatório para o MVP
- **Importante**: Relevante, mas não crítico
- **Desejável**: Interessante se houver tempo
- **Não Priorizado**: Fora do escopo atual

### Estimativas
- **Story Points**: Fibonacci (1, 2, 3, 5, 8, 13, 21)
- **T-Shirt**: P, M, G, GG

### Status
- 🔄 Em desenvolvimento
- ✅ Concluído
- 📋 Planejado
- ⏸️ Pausado
- ❌ Cancelado

## Métricas Globais do CRM

| Métrica | Meta | Atual |
|---------|------|-------|
| Taxa de Conversão Lead→Cliente | 25% | - |
| Tempo Médio de Fechamento | 15 dias | - |
| Ticket Médio | R$ 1.500 | - |
| Satisfação do Consultor | 4,5/5 | - |
| Cotações/Dia por Consultor | 10 | - |

## Glossário Específico do Setor

| Termo | Definição |
|-------|-----------|
| **Proteção Veicular** | Sistema de rateio de despesas para proteção de veículos (não é seguro) |
| **Associado** | Cliente que contratou proteção veicular |
| **Consultor** | Vendedor/representante que realiza vendas |
| **Lead** | Interessado em contratar proteção veicular |
| **Sinistro** | Evento coberto (roubo, furto, colisão, etc) |
| **Franquia** | Valor de participação do associado em sinistro |
| **Vistoria** | Inspeção prévia do veículo antes da contratação |
| **Rateio** | Divisão das despesas entre associados |
| **Cobertura** | Tipo de proteção oferecida (roubo, colisão, etc) |

## 📄 Geração de PDFs

User Stories com status **"✅ Pronto"** devem ser exportadas para PDF para distribuição e arquivamento.

### Ferramenta
- **mdpdf** via npx (não requer instalação global)

### Comando
```bash
cd docs/historias-usuario/[MODULO]
npx mdpdf [ARQUIVO].md --output [ARQUIVO].pdf
```

### Exemplo
```bash
cd docs/historias-usuario/CRM-Leads
npx mdpdf US-CRM-LEAD-005.md --output US-CRM-LEAD-005.pdf
```

### Convenções
- PDF deve ter o **mesmo nome** do arquivo .md
- PDF deve estar na **mesma pasta** do .md
- Atualizar PDF sempre que o .md for alterado
- Registrar no **CONTINUIDADE** do módulo com ✅

### Checklist
- [ ] User Story com status "✅ Pronto"
- [ ] Documento revisado (DDD, ortografia)
- [ ] Versão atualizada no documento
- [ ] PDF gerado com sucesso
- [ ] PDF verificado (formatação ok)
- [ ] CONTINUIDADE atualizado

---

## Referências

- **DRS CRM TOPBR.pdf**: Documento de Requisitos do Sistema
- **API FIPE**: https://veiculos.fipe.org.br/
- **Regulamentação SUSEP**: Superintendência de Seguros Privados
- **Código de Trânsito Brasileiro**: Lei nº 9.503/1997

---

**Versão**: 1.1  
**Data**: 21 de janeiro de 2026  
**Product Owner**: A definir  
**Status**: 📋 Em planejamento

**Contato**: Para dúvidas ou sugestões, entre em contato com o Product Owner.
