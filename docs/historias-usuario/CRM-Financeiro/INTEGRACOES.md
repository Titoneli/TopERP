# Integrações Externas - CRM-Financeiro (CRM-FIN)

| Metadado | Valor |
|----------|-------|
| **Módulo** | CRM-Financeiro |
| **Código** | CRM-FIN-INT |
| **Versão** | 1.0 |
| **Data** | 29/01/2026 |
| **Responsável** | Product Owner - CRM |
| **Status** | Planejado |

---

## 1. Visão Geral das Integrações

O módulo CRM-Financeiro requer integrações com **6 sistemas externos** para automatizar o fluxo completo de pagamentos aos consultores.

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                         MAPA DE INTEGRAÇÕES CRM-FIN                                 │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│                              ┌───────────────┐                                      │
│                              │   CRM-FIN     │                                      │
│                              │  (Core)       │                                      │
│                              └───────┬───────┘                                      │
│                                      │                                              │
│          ┌───────────────────────────┼───────────────────────────┐                  │
│          │                           │                           │                  │
│          ▼                           ▼                           ▼                  │
│   ┌──────────────┐           ┌──────────────┐           ┌──────────────┐           │
│   │   BANCO      │           │    SEFAZ     │           │  PREFEITURA  │           │
│   │   DIGITAL    │           │   (NF-e)     │           │   (NFS-e)    │           │
│   │              │           │              │           │              │           │
│   │ • Tickets    │           │ • Emissão    │           │ • Emissão    │           │
│   │ • PIX        │           │ • Consulta   │           │ • Consulta   │           │
│   │ • Saldo      │           │ • Cancelar   │           │ • Cancelar   │           │
│   └──────────────┘           └──────────────┘           └──────────────┘           │
│          │                           │                           │                  │
│          │                           ▼                           │                  │
│          │                   ┌──────────────┐                    │                  │
│          │                   │   SISTEMA    │                    │                  │
│          │                   │   CONTÁBIL   │◄───────────────────┘                  │
│          │                   │              │                                       │
│          │                   │ • Lançamentos│                                       │
│          │                   │ • Estornos   │                                       │
│          │                   └──────────────┘                                       │
│          │                           │                                              │
│          ▼                           ▼                                              │
│   ┌──────────────┐           ┌──────────────┐                                       │
│   │  MFG/SANKHYA │◄─────────►│ APP CONSULTOR│                                       │
│   │              │           │              │                                       │
│   │ • Ordens     │           │ • Extrato    │                                       │
│   │ • Pagamentos │           │ • Push       │                                       │
│   │ • Anexos     │           │ • Aprovações │                                       │
│   └──────────────┘           └──────────────┘                                       │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Integração: Banco Digital

### 2.1 Visão Geral

| Atributo | Valor |
|----------|-------|
| **Sistema** | Banco Digital (ContaTop ou White-label) |
| **Protocolo** | REST API + Webhooks |
| **Autenticação** | OAuth 2.0 / API Key |
| **Ambiente** | Sandbox + Produção |

### 2.2 Funcionalidades

| Funcionalidade | Método | Endpoint | Descrição |
|----------------|--------|----------|-----------|
| Abrir Ticket de Saque | POST | `/api/v1/tickets` | Cria solicitação de saque |
| Consultar Saldo | GET | `/api/v1/accounts/{id}/balance` | Retorna saldo disponível |
| Executar PIX | POST | `/api/v1/pix/transfer` | Inicia transferência PIX |
| Consultar PIX | GET | `/api/v1/pix/{txid}` | Status da transferência |
| Webhook Pagamento | - | Callback | Notificação de PIX efetivado |

### 2.3 Payloads

#### Request: Executar PIX
```json
{
  "amount": 1500.00,
  "currency": "BRL",
  "recipient": {
    "pixKey": "12345678901",
    "pixKeyType": "CPF",
    "name": "João Consultor",
    "document": "12345678901"
  },
  "description": "Pagamento de comissões - Ref: SOL-2026-00001",
  "externalId": "crm-fin-saque-12345"
}
```

#### Response: PIX Efetivado
```json
{
  "txid": "E12345678901234567890123456789012345",
  "endToEndId": "E1234567820260129120000000001",
  "status": "EFETIVADO",
  "amount": 1500.00,
  "effectiveDate": "2026-01-29T12:00:00Z",
  "receipt": {
    "url": "https://banco.digital/comprovantes/abc123.pdf"
  }
}
```

### 2.4 Webhooks

| Evento | Payload | Ação CRM-FIN |
|--------|---------|--------------|
| `pix.completed` | txid, status, endToEndId | Atualizar status para PAGO |
| `pix.failed` | txid, errorCode, message | Marcar como REJEITADO, notificar |
| `pix.returned` | txid, returnId, reason | Processar devolução |

### 2.5 Esforço Estimado

| Atividade | Story Points |
|-----------|--------------|
| Configuração e autenticação | 5 SP |
| Integração de transferência PIX | 13 SP |
| Webhooks e callbacks | 8 SP |
| Tratamento de erros e retry | 8 SP |
| Testes e homologação | 6 SP |
| **TOTAL** | **40 SP** |

---

## 3. Integração: SEFAZ (NF-e)

### 3.1 Visão Geral

| Atributo | Valor |
|----------|-------|
| **Sistema** | SEFAZ Estadual |
| **Protocolo** | Web Service SOAP (NF-e 4.0) |
| **Certificado** | A1 Digital (e-CNPJ) |
| **Ambiente** | Homologação + Produção |

### 3.2 Serviços Web

| Serviço | WSDL | Descrição |
|---------|------|-----------|
| NfeAutorizacao | `NfeAutorizacao4.wsdl` | Emissão de NF-e |
| NfeRetAutorizacao | `NfeRetAutorizacao4.wsdl` | Consulta lote |
| NfeConsultaProtocolo | `NfeConsultaProtocolo4.wsdl` | Consulta por chave |
| NfeStatusServico | `NfeStatusServico4.wsdl` | Status do serviço |
| RecepcaoEvento | `RecepcaoEvento4.wsdl` | Cancelamento |

### 3.3 Fluxo de Emissão

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLUXO EMISSÃO NF-e                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   1. Montar XML da NF-e                                         │
│        │                                                        │
│        ▼                                                        │
│   2. Assinar digitalmente (Certificado A1)                      │
│        │                                                        │
│        ▼                                                        │
│   3. Transmitir lote (NfeAutorizacao)                           │
│        │                                                        │
│        ▼                                                        │
│   4. Aguardar processamento (NfeRetAutorizacao)                 │
│        │                                                        │
│        ├──► Autorizada (100) ──► Gerar DANFE PDF                │
│        │                                                        │
│        └──► Rejeitada (xxx) ──► Tratar erro, reenviar           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 3.4 Cancelamento de NF-e

| Regra | Descrição |
|-------|-----------|
| Prazo | Até 24 horas após autorização |
| Justificativa | Mínimo 15 caracteres |
| Protocolo | Evento tipo 110111 |

### 3.5 Esforço Estimado

| Atividade | Story Points |
|-----------|--------------|
| Configuração certificado A1 | 5 SP |
| Geração de XML NF-e | 13 SP |
| Assinatura digital | 8 SP |
| Comunicação SOAP SEFAZ | 13 SP |
| Geração DANFE PDF | 8 SP |
| Cancelamento de NF-e | 8 SP |
| Testes em homologação | 5 SP |
| **TOTAL** | **60 SP** |

---

## 4. Integração: Prefeituras (NFS-e)

### 4.1 Visão Geral

| Atributo | Valor |
|----------|-------|
| **Sistema** | WebISS, Ginfes, ABRASF, Betha, outros |
| **Protocolo** | REST ou SOAP (varia por município) |
| **Certificado** | A1 Digital ou Login/Senha |
| **Complexidade** | Alta (cada município é diferente) |

### 4.2 Padrões Suportados

| Padrão | Municípios | Protocolo |
|--------|------------|-----------|
| ABRASF 2.04 | SP Capital, RJ, MG | SOAP |
| Ginfes | +2000 municípios | SOAP |
| WebISS | +1000 municípios | REST |
| Betha | +500 municípios | REST |
| Próprio | Varia | Varia |

### 4.3 Abstração Multi-Prefeitura

```
┌─────────────────────────────────────────────────────────────────┐
│                    ADAPTER PATTERN - NFS-e                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │              INfseService (Interface)                   │   │
│   │                                                         │   │
│   │  + emitir(nfse: NfseDTO): ResultadoEmissao              │   │
│   │  + consultar(chave: string): NfseDTO                    │   │
│   │  + cancelar(chave: string, motivo: string): boolean     │   │
│   └─────────────────────────────────────────────────────────┘   │
│                           △                                     │
│                           │                                     │
│       ┌───────────────────┼───────────────────┐                 │
│       │                   │                   │                 │
│       ▼                   ▼                   ▼                 │
│   ┌─────────┐       ┌─────────┐       ┌─────────┐               │
│   │ ABRASF  │       │ Ginfes  │       │ WebISS  │               │
│   │ Adapter │       │ Adapter │       │ Adapter │               │
│   └─────────┘       └─────────┘       └─────────┘               │
│                                                                 │
│   Factory: NfseServiceFactory.create(codigoMunicipio)           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 4.4 Esforço Estimado

| Atividade | Story Points |
|-----------|--------------|
| Interface abstrata NFS-e | 8 SP |
| Adapter ABRASF (SP, RJ) | 21 SP |
| Adapter Ginfes | 21 SP |
| Adapter WebISS | 13 SP |
| Factory e configuração | 5 SP |
| Testes por município | 12 SP |
| **TOTAL** | **80 SP** |

---

## 5. Integração: Sistema Contábil

### 5.1 Visão Geral

| Atributo | Valor |
|----------|-------|
| **Sistema** | Contabilidade (a definir) |
| **Protocolo** | REST API |
| **Autenticação** | API Key / OAuth |

### 5.2 Funcionalidades

| Funcionalidade | Método | Endpoint | Descrição |
|----------------|--------|----------|-----------|
| Criar Lançamento | POST | `/api/v1/lancamentos` | Registra débito/crédito |
| Estornar Lançamento | POST | `/api/v1/lancamentos/{id}/estorno` | Estorna lançamento |
| Consultar Lançamento | GET | `/api/v1/lancamentos/{id}` | Status do registro |

### 5.3 Mapeamento Contábil

| Operação CRM-FIN | Conta Débito | Conta Crédito |
|------------------|--------------|---------------|
| Crédito Comissão | 3.1.1.01 (Despesa Comissões) | 2.1.4.01 (Comissões a Pagar) |
| Pagamento Comissão | 2.1.4.01 (Comissões a Pagar) | 1.1.1.01 (Banco) |
| Estorno Comissão | 2.1.4.01 (Comissões a Pagar) | 3.1.1.01 (Despesa Comissões) |

### 5.4 Esforço Estimado

| Atividade | Story Points |
|-----------|--------------|
| Mapeamento de contas | 5 SP |
| Integração API | 13 SP |
| Tratamento de estornos | 8 SP |
| Testes e validação | 4 SP |
| **TOTAL** | **30 SP** |

---

## 6. Integração: MFG/Sankhya (ERP)

### 6.1 Visão Geral

| Atributo | Valor |
|----------|-------|
| **Sistema** | MFG ou Sankhya |
| **Protocolo** | REST API / Web Service |
| **Autenticação** | Token / Sessão |

### 6.2 Funcionalidades

| Funcionalidade | Método | Endpoint | Descrição |
|----------------|--------|----------|-----------|
| Criar Ordem Pagamento | POST | `/api/titulos` | Gera título a pagar |
| Anexar Documento | POST | `/api/titulos/{id}/anexos` | Anexa NF XML/PDF |
| Aprovar Ordem | PUT | `/api/titulos/{id}/aprovar` | Aprova para pagamento |
| Consultar Ordem | GET | `/api/titulos/{id}` | Status do título |
| Cancelar Ordem | DELETE | `/api/titulos/{id}` | Cancela título |

### 6.3 Payload: Criar Ordem de Pagamento

```json
{
  "tipoParceiro": "FORNECEDOR",
  "codigoParceiro": "CONS-12345",
  "tipoTitulo": "COMISSAO",
  "valorBruto": 1500.00,
  "descontos": [
    { "tipo": "IRRF", "valor": 45.00 },
    { "tipo": "ISS", "valor": 75.00 }
  ],
  "valorLiquido": 1380.00,
  "dataVencimento": "2026-01-30",
  "historico": "Pagamento comissões - SOL-2026-00001",
  "anexos": [
    { "tipo": "NF_XML", "url": "https://storage/nf-12345.xml" },
    { "tipo": "NF_PDF", "url": "https://storage/nf-12345.pdf" }
  ]
}
```

### 6.4 Esforço Estimado

| Atividade | Story Points |
|-----------|--------------|
| Configuração e autenticação | 5 SP |
| Criação de ordens | 13 SP |
| Anexação de documentos | 8 SP |
| Aprovação e cancelamento | 8 SP |
| Testes e validação | 6 SP |
| **TOTAL** | **40 SP** |

---

## 7. Integração: App Consultor

### 7.1 Visão Geral

| Atributo | Valor |
|----------|-------|
| **Sistema** | App Mobile (iOS/Android) |
| **Protocolo** | REST API + Push Notifications |
| **Autenticação** | JWT Token |

### 7.2 Funcionalidades

| Funcionalidade | Método | Endpoint | Descrição |
|----------------|--------|----------|-----------|
| Obter Saldo | GET | `/api/v1/consultor/saldo` | Saldo disponível |
| Obter Extrato | GET | `/api/v1/consultor/extrato` | Movimentações |
| Solicitar Saque | POST | `/api/v1/consultor/saques` | Nova solicitação |
| Demonstrativo | GET | `/api/v1/consultor/demonstrativo` | Analítico/Sintético |
| Push Notification | FCM/APNS | - | Notificações de crédito |

### 7.3 Push Notifications

| Evento | Título | Corpo |
|--------|--------|-------|
| `comissao.creditada` | 💰 Comissão Creditada | Você recebeu R$ 150,00 de comissão |
| `saque.aprovado` | ✅ Saque Aprovado | Sua solicitação foi aprovada |
| `pix.efetivado` | 🎉 PIX Recebido | R$ 1.380,00 transferido para sua conta |

### 7.4 Esforço Estimado

| Atividade | Story Points |
|-----------|--------------|
| Endpoints de consulta | 8 SP |
| Push Notifications | 8 SP |
| Testes e validação | 4 SP |
| **TOTAL** | **20 SP** |

---

## 8. Resumo de Esforço

| Integração | Story Points | Prioridade |
|------------|--------------|------------|
| Banco Digital (PIX) | 40 SP | Alta |
| SEFAZ (NF-e) | 60 SP | Alta |
| Prefeituras (NFS-e) | 80 SP | Alta |
| Sistema Contábil | 30 SP | Média |
| MFG/Sankhya | 40 SP | Alta |
| App Consultor | 20 SP | Média |
| **TOTAL INTEGRAÇÕES** | **270 SP** | - |

---

## 9. Cronograma Sugerido

| Fase | Integrações | Duração | Dependências |
|------|-------------|---------|--------------|
| **Fase 1** | Banco Digital + MFG/Sankhya | 4 sprints | Core CRM-FIN |
| **Fase 2** | SEFAZ (NF-e) | 3 sprints | Fase 1 |
| **Fase 3** | Sistema Contábil | 2 sprints | Fase 2 |
| **Fase 4** | Prefeituras (NFS-e) principais | 4 sprints | Fase 2 |
| **Fase 5** | App Consultor | 2 sprints | Fase 1 |

**Total Estimado**: 15 sprints (~7,5 meses)

---

## 10. Riscos e Mitigações

| Risco | Impacto | Probabilidade | Mitigação |
|-------|---------|---------------|-----------|
| Variação de APIs de prefeituras | Alto | Alta | Adapter Pattern + Factory |
| Indisponibilidade SEFAZ | Médio | Média | Contingência, retry automático |
| Mudanças em APIs de banco | Médio | Média | Versionamento de integrações |
| Certificado A1 expirado | Alto | Baixa | Alertas de expiração |

---

**Versão**: 1.0  
**Data**: 29/01/2026  
**Responsável**: Product Owner - CRM
