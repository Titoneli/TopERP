# Requisitos Não-Funcionais - TopERP

## Visão Geral

Este documento especifica os requisitos não-funcionais do sistema TopERP.

---

## Desempenho

### RNF-001: Tempo de Resposta
- **Descrição**: O sistema deve responder a consultas simples em até 2 segundos
- **Métrica**: 95% das requisições devem ser atendidas dentro do tempo especificado
- **Prioridade**: Must Have

### RNF-002: Capacidade de Usuários Simultâneos
- **Descrição**: O sistema deve suportar pelo menos 100 usuários simultâneos
- **Métrica**: Sem degradação perceptível de performance
- **Prioridade**: Must Have

### RNF-003: Processamento em Lote
- **Descrição**: Processamentos em lote devem ser executados em horários de baixa utilização
- **Métrica**: Conclusão em até 4 horas para processos mensais
- **Prioridade**: Should Have

---

## Segurança

### RNF-010: Autenticação
- **Descrição**: O sistema deve exigir autenticação para acesso
- **Métrica**: Suporte a autenticação multifator (MFA)
- **Prioridade**: Must Have

### RNF-011: Autorização
- **Descrição**: O sistema deve implementar controle de acesso baseado em perfis
- **Métrica**: Granularidade em nível de funcionalidade
- **Prioridade**: Must Have

### RNF-012: Criptografia
- **Descrição**: Dados sensíveis devem ser criptografados
- **Métrica**: AES-256 para dados em repouso, TLS 1.3 para transmissão
- **Prioridade**: Must Have

### RNF-013: Auditoria
- **Descrição**: O sistema deve registrar todas as operações críticas
- **Métrica**: Log de quem, quando e o que foi alterado
- **Prioridade**: Must Have

---

## Disponibilidade

### RNF-020: Uptime
- **Descrição**: O sistema deve estar disponível 99,5% do tempo
- **Métrica**: Máximo de 3,65 horas de indisponibilidade por mês
- **Prioridade**: Must Have

### RNF-021: Backup
- **Descrição**: O sistema deve realizar backup diário dos dados
- **Métrica**: Retenção mínima de 30 dias
- **Prioridade**: Must Have

### RNF-022: Recuperação de Desastres
- **Descrição**: O sistema deve ter plano de recuperação de desastres
- **Métrica**: RTO de 4 horas, RPO de 1 hora
- **Prioridade**: Should Have

---

## Usabilidade

### RNF-030: Interface Responsiva
- **Descrição**: A interface deve se adaptar a diferentes tamanhos de tela
- **Métrica**: Suporte a desktop, tablet e smartphone
- **Prioridade**: Must Have

### RNF-031: Acessibilidade
- **Descrição**: O sistema deve atender padrões básicos de acessibilidade
- **Métrica**: WCAG 2.1 nível A
- **Prioridade**: Should Have

### RNF-032: Idioma
- **Descrição**: O sistema deve estar em Português Brasileiro
- **Métrica**: 100% das interfaces em pt-BR
- **Prioridade**: Must Have

---

## Manutenibilidade

### RNF-040: Documentação
- **Descrição**: O código deve ser documentado adequadamente
- **Métrica**: Cobertura de documentação de 80% das classes públicas
- **Prioridade**: Should Have

### RNF-041: Modularidade
- **Descrição**: O sistema deve ser desenvolvido de forma modular
- **Métrica**: Módulos independentes e baixo acoplamento
- **Prioridade**: Must Have

---

## Escalabilidade

### RNF-045: Capacidade de Usuários CRM
- **Descrição**: O módulo CRM deve suportar 10.000 usuários simultâneos
- **Métrica**: Performance estável com carga máxima
- **Prioridade**: Must Have
- **Origem**: visao-produto-crm.md (Seção 6.2)

### RNF-046: Escalabilidade Horizontal
- **Descrição**: A arquitetura deve permitir escalabilidade horizontal
- **Métrica**: Adicionar instâncias sem downtime
- **Prioridade**: Should Have

---

## Conformidade e Privacidade

### RNF-060: LGPD Compliance
- **Descrição**: O sistema deve estar em conformidade com a Lei Geral de Proteção de Dados
- **Métrica**: Consentimento explícito, direito ao esquecimento, portabilidade
- **Prioridade**: Must Have
- **Origem**: visao-produto-crm.md (Seção 6.2)

### RNF-061: Anonimização de Dados
- **Descrição**: Dados pessoais devem ser anonimizados em relatórios agregados
- **Métrica**: Nenhum dado identificável em exports de analytics
- **Prioridade**: Should Have

### RNF-062: Consentimento de Lead
- **Descrição**: O sistema deve registrar consentimento do lead para contato
- **Métrica**: Checkbox obrigatório com timestamp de aceite
- **Prioridade**: Must Have

---

## Integração

### RNF-050: APIs
- **Descrição**: O sistema deve disponibilizar APIs para integração
- **Métrica**: API REST com documentação OpenAPI 3.0
- **Prioridade**: Should Have

### RNF-051: Integração Fiscal
- **Descrição**: O sistema deve integrar com sistemas governamentais
- **Métrica**: SEFAZ (NF-e, NFC-e), eSocial, EFD
- **Prioridade**: Must Have

---

## Rastreabilidade

| Requisito | Documento Origem | Bounded Context |
|-----------|------------------|------------------|
| RNF-001 | visao-produto-crm.md | Todos |
| RNF-002 | Análise técnica | Todos |
| RNF-020 | visao-produto-crm.md | Todos |
| RNF-045 | visao-produto-crm.md | CRM-* |
| RNF-060 | visao-produto-crm.md | CRM-LED, CRM-CAD |

---

**Última Atualização**: 25 de janeiro de 2026  
**Versão**: 1.1

**Histórico de Alterações**

| Data | Versão | Alteração | Autor |
|------|--------|-----------|-------|
| 25/01/2026 | 1.1 | Adicionados requisitos de Escalabilidade e LGPD (origem: visao-produto-crm.md) | PO |
| 21/01/2026 | 1.0 | Versão inicial | PO |
