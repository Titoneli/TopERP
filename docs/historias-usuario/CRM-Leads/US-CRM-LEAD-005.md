# US-CRM-LEAD-005 — Captura via WhatsApp Business

## História de Usuário

**Como** visitante interessado em proteção veicular,  
**Quero** iniciar uma conversa via WhatsApp e ser cadastrado automaticamente como lead,  
**Para** receber atendimento rápido e personalizado pelo canal que prefiro.

### Cenários de Acesso

| Origem | Número WhatsApp | Atendimento | cod_colaborador |
|--------|-----------------|-------------|------------------|
| **Landing Page Exclusiva** | Número pessoal do **CONSULTOR** (conectado ao TopCRM) | Conversa DIRETA com o consultor | Preenchido automaticamente |
| **Link Direto TopCRM** | Número oficial da **TOPBRASIL** | Atendimento via **CHATBOT** | NULL (fila de distribuição) |

## Prioridade

Importante

## Estimativa

13 SP

---

## Bounded Context (DDD)

| Elemento | Valor |
|----------|-------|
| **Bounded Context** | CRM-Leads (Captação e Qualificação) |
| **Aggregate Root** | Lead |
| **Entidades** | Lead, Colaborador, Conversa |
| **Value Objects** | Telefone (com DDD), Email, WhatsAppId, MensagemChat |
| **Domain Events** | `LeadCriadoViaWhatsApp`, `ConversaIniciada`, `ConsultorNotificado`, `LeadAbandonado` |
| **Relacionamento** | CRM-Leads → CRM-COT (Downstream) |

### Linguagem Ubíqua

| Termo | Definição |
|-------|-----------|
| **Lead** | Prospect que demonstrou interesse em proteção veicular |
| **Landing Page Exclusiva** | Página personalizada do consultor com botão que abre conversa no **número pessoal do consultor** |
| **Link Direto TopCRM** | Link na página principal do TopCRM que abre conversa no **número oficial da TopBrasil** |
| **Chatbot** | Assistente virtual que coleta dados e qualifica o lead (apenas no Link Direto TopCRM) |
| **Conversa Direta** | Atendimento humano imediato pelo consultor (apenas na Landing Page Exclusiva) |
| **cod_origem** | Código numérico que identifica o canal (5 = WHATSAPP) |
| **cod_colaborador** | Identificador do consultor (preenchido automaticamente se origem for Landing Page Exclusiva) |
| **Abandono** | Lead que não completou o fluxo após 24h sem resposta |

---

## Contexto de Negócio

O WhatsApp é o principal canal de comunicação no Brasil, com mais de 120 milhões de usuários ativos. A captura automática de leads via WhatsApp Business API ou Evolution API permite:

- **Atendimento direto** pelo consultor via seu número pessoal conectado (Landing Page Exclusiva)
- **Atendimento 24/7** via chatbot no número oficial TopBrasil (Link Direto TopCRM)
- **Qualificação automática** através de perguntas estruturadas (modo chatbot)
- **Integração com CRM** em tempo real
- **Redução de fricção** no processo de captação

### Dois Modos de Operação

```
┌──────────────────────────────────────────────────────────────────────────────────┐
│                        MODOS DE CAPTAÇÃO VIA WHATSAPP                            │
├─────────────────────────────────────────┬────────────────────────────────────────┤
│      MODO 1: LANDING PAGE EXCLUSIVA     │       MODO 2: LINK DIRETO TOPCRM       │
├─────────────────────────────────────────┼────────────────────────────────────────┤
│                                         │                                        │
│  📍 URL: joao.topbrasil.com.br          │  📍 URL: topbrasil.com.br               │
│  📱 Número: WhatsApp PESSOAL consultor  │  📱 Número: WhatsApp OFICIAL TopBrasil  │
│  👤 Atendimento: DIRETO pelo consultor  │  🤖 Atendimento: CHATBOT automático     │
│  🎯 cod_colaborador: PREENCHIDO         │  🎯 cod_colaborador: NULL (fila)        │
│  ⏱️ Disponibilidade: Horário consultor  │  ⏱️ Disponibilidade: 24/7               │
│                                         │                                        │
│  ┌───────────────────────────────────┐  │  ┌──────────────────────────────────┐  │
│  │  VISITANTE acessa Landing Page    │  │  │  VISITANTE acessa TopBrasil.com  │  │
│  │            ↓                      │  │  │            ↓                     │  │
│  │  Clica no botão "📲 WhatsApp"     │  │  │  Clica no botão "📲 WhatsApp"     │  │
│  │            ↓                      │  │  │            ↓                     │  │
│  │  Abre conversa com NÚMERO         │  │  │  Abre conversa com NÚMERO        │  │
│  │  PESSOAL DO CONSULTOR             │  │  │  OFICIAL DA TOPBRASIL            │  │
│  │            ↓                      │  │  │            ↓                     │  │
│  │  CONVERSA DIRETA (humano)         │  │  │  CHATBOT coleta dados            │  │
│  │            ↓                      │  │  │            ↓                     │  │
│  │  Lead VINCULADO ao consultor      │  │  │  Lead vai para FILA              │  │
│  └───────────────────────────────────┘  │  └──────────────────────────────────┘  │
│                                         │                                        │
└─────────────────────────────────────────┴────────────────────────────────────────┘
```

### Benefícios Esperados

| Benefício | Impacto |
|-----------|---------|
| Aumento de conversão | +30% comparado a formulário web |
| Tempo de resposta | < 1 minuto (chatbot) |
| Taxa de abertura | > 90% das mensagens |
| Engajamento | Canal preferido do público |

---

## Arquitetura de Integração

```
┌───────────────────────────────────────────────────────────────────────┐
│                    FLUXO DE CAPTURA WHATSAPP                          │
├───────────────────────────────────────────────────────────────────────┤
│                                                                       │
│   ┌─────────────┐       ┌─────────────┐       ┌─────────────┐         │
│   │   CLIENTE   │       │  WHATSAPP   │       │     CRM     │         │
│   │  (Celular)  │       │  BUSINESS   │       │  TOPBRASIL  │         │
│   └──────┬──────┘       │     API     │       └──────┬──────┘         │
│          │              └──────┬──────┘              │                │
│          │                     │                     │                │
│   1. Inicia conversa ─────────►│                     │                │
│      "Oi, quero cotação"       │                     │                │
│          │                     │                     │                │
│          │◄──── 2. Msg auto ───┤                     │                │
│      "Olá! Qual seu nome?"     │                     │                │
│          │                     │                     │                │
│   3. "João da Silva" ─────────►│                     │                │
│          │                     │                     │                │
│          │◄── 4. "Qual email?" ┤                     │                │
│          │                     │                     │                │
│   5. "joao@email.com" ────────►│                     │                │
│          │                     │                     │                │
│          │                     │── 6. Webhook ──────►│                │
│          │                     │   (cria lead)       │                │
│          │                     │                     │                │
│          │                     │◄─ 7. Confirmação ───┤                │
│          │                     │                     │                │
│          │◄── 8. "Lead criado!"┤                     │                │
│      "consultor vai atender"   │                     │                │
│          │                     │                     │                │
└──────────┴─────────────────────┴─────────────────────┴────────────────┘
```

---

## Fluxo do Chatbot

> ⚠️ **IMPORTANTE**: O fluxo de chatbot abaixo aplica-se **APENAS ao MODO 2 (Link Direto TopCRM)**.
> No **MODO 1 (Landing Page Exclusiva)**, a conversa é DIRETA com o consultor, sem chatbot.

### Trigger de Entrada (MODO 2 - Chatbot)

| Trigger | Ação |
|---------|------|
| Mensagem contendo "cotação", "proteção", "seguro", "preço" | Inicia fluxo de captação |
| Mensagem contendo "falar com atendente", "humano" | Transfere para fila de consultores |
| Qualquer outra mensagem | Menu de opções |

### Fluxo de Captação (MODO 2 - Chatbot)

```
┌─────────────────────────────────────────────────────────────────┐
│                      FLUXO DO CHATBOT                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  [INÍCIO]                                                       │
│     │                                                           │
│     ▼                                                           │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  "Olá! 👋 Sou o assistente virtual da TopBrasil.          │  │
│  │   Vou te ajudar a conseguir uma cotação de proteção       │  │
│  │   veicular. Para começar, qual é o seu nome completo?"    │  │
│  └───────────────────────────────────────────────────────────┘  │
│     │                                                           │
│     │ [Usuário responde nome]                                   │
│     ▼                                                           │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  "Prazer, {nome}! 😊                                      │  │
│  │   Agora preciso do seu e-mail para enviar a cotação:"     │  │
│  └───────────────────────────────────────────────────────────┘  │
│     │                                                           │
│     │ [Usuário responde e-mail]                                 │
│     ▼                                                           │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  "Perfeito! Em qual cidade/uf você circula com o veiculo?"│  │
│  │                                                           │  │
│  └───────────────────────────────────────────────────────────┘  │
│     │                                                           │
│     │ [Usuário informa nome da cidade/estado]                   │
│     ▼                                                           │
│  [LEAD CRIADO NO CRM]                                           │
│     │                                                           │
│     ▼                                                           │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  "✅ Pronto, {nome}!                                      │  │
│  │                                                           │  │
│  │   Seu cadastro foi realizado com sucesso.                 │  │
│  │   Um consultor especializado vai entrar em contato        │  │
│  │   em breve pelo WhatsApp.                                 │  │
│  │                                                           │  │
│  │   Enquanto isso, quer saber mais sobre nossos planos?"    │  │
│  │                                                           │  │
│  │   👉 Ver planos    👉 Falar com consultor agora            │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Dados Capturados

### Dados do Lead

| Campo | Origem | Obrigatório |
|-------|--------|-------------|
| Nome Completo | Resposta do usuário | Sim |
| Telefone | Número do WhatsApp | Sim (automático) |
| E-mail | Resposta do usuário | Sim |
| Placa ou Marca | Placa ou Marca/Modelo/Ano Modelo | Não |
| Modelo | Modelo do Veiculo | Não |
| Ano Modelo | Ano do Veiculo | Não |
| Tipo de Uso | Uso passeio ou comercial | Não |
| Estado (UF) | Seleção de opção | Sim |
| Cidade | DDD do telefone (inferido) | Não |

### Metadados

| Campo | Descrição |
|-------|-----------|
| `cod_origem` | 5 (WHATSAPP) |
| `whatsapp_id` | ID da conversa no WhatsApp |
| `ddd_telefone` | Extraído automaticamente do número |
| `primeira_mensagem` | Texto inicial do usuário |
| `hora_primeiro_contato` | Timestamp da primeira mensagem |
| `etapa_abandono` | Última etapa completada no fluxo |

---

## Critérios de Aceitação

### Cenário 1A — Captura via Landing Page Exclusiva (Conversa Direta)
- **Dado que** acesso a landing page exclusiva de um consultor
- **Quando** clico no botão WhatsApp
- **Então** abre conversa com o **número pessoal do consultor**
- **E** a conversa é DIRETA (sem chatbot)
- **E** ao enviar primeira mensagem, um lead é criado com `cod_origem = 5` e `cod_colaborador` preenchido
- **E** o consultor é notificado sobre o novo lead

### Cenário 1B — Captura via Link Direto TopCRM (Chatbot)
- **Dado que** acesso a página principal do TopCRM
- **Quando** clico no botão WhatsApp
- **Então** abre conversa com o **número oficial da TopBrasil**
- **E** o chatbot inicia o fluxo de qualificação
- **Quando** respondo nome, e-mail e estado solicitados pelo chatbot
- **Então** um lead é criado com `cod_origem = 5` e `cod_colaborador = NULL`
- **E** o lead entra na fila de distribuição

### Cenário 2 — Telefone capturado automaticamente
- **Dado que** inicio uma conversa do número (11) 99999-9999
- **Quando** o lead é criado
- **Então** o telefone é registrado como `11999999999`
- **E** o DDD `11` é extraído e armazenado separadamente

### Cenário 3 — Telefone de consultor bloqueado
- **Dado que** inicio conversa de um telefone cadastrado como consultor
- **Quando** o sistema valida o número
- **Então** recebo mensagem: "Identificamos que você é consultor TopBrasil. Acesse o app do consultor para mais informações."
- **E** nenhum lead é criado

### Cenário 4 — Abandono no meio do fluxo
- **Dado que** informei meu nome mas não respondi o e-mail
- **Quando** 24 horas se passam sem resposta
- **Então** um lead parcial é criado com `etapa_abandono = 'WHATSAPP_NOME'`
- **E** o lead recebe status `ABANDONADO`

### Cenário 5 — Transferência para atendente humano (MODO 2 apenas)
- **Dado que** estou no fluxo do chatbot (Link Direto TopCRM)
- **Quando** digito "falar com atendente" ou "humano"
- **Então** a conversa é transferida para a fila de consultores
- **E** recebo: "Aguarde, estou transferindo para um consultor..."

### Cenário 6 — Fora do horário comercial
- **Dado que** envio mensagem às 23h (fora do expediente)
- **Se** origem for Link Direto TopCRM (MODO 2)
  - **Então** o chatbot responde: "Nosso horário de atendimento humano é das 8h às 18h. Mas posso coletar seus dados agora!"
  - **E** o chatbot continua o fluxo de captação
- **Se** origem for Landing Page Exclusiva (MODO 1)
  - **Então** a mensagem chega diretamente ao consultor
  - **E** o consultor pode configurar mensagem automática de ausência
- **E** o lead é criado normalmente em ambos os casos

### Cenário 7 — Webhook recebido da API WhatsApp
- **Dado que** a WhatsApp Business API envia um webhook
- **Quando** o CRM recebe os dados
- **Então** valida a assinatura do webhook
- **E** processa a mensagem conforme o estágio do fluxo
- **E** responde em menos de 5 segundos

### Cenário 8 — Múltiplas conversas do mesmo número
- **Dado que** já existe um lead com telefone 11999999999
- **Quando** o mesmo número inicia nova conversa
- **Então** o sistema identifica o lead existente
- **E** informa: "Olá {nome}! Vi que você já iniciou um cadastro conosco. Quer continuar de onde parou?"

### Cenário 9 — Abandono no meio do fluxo
- **Dado que** informei a placa do veículo
- **Então** não precisa solicitar Marca/Modelo/Ano Modelo
- **E** consultar API específica para buscar os dados Marca/Modelo/Ano Modelo e valor FIPE do veículo pela placa

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Telefone é capturado automaticamente do número do WhatsApp |
| RN-002 | DDD é extraído do telefone para analytics regional |
| RN-003 | Lead via WhatsApp recebe `cod_origem = 5` |
| RN-004 | Lead via Landing Page Exclusiva recebe `cod_colaborador` do consultor |
| RN-005 | Validação contra blacklist de consultores é obrigatória |
| RN-006 | Lead é criado mesmo em caso de abandono (dados parciais) |
| RN-007 | Timeout entre mensagens: 5 minutos para lembrete, 24h para abandono |
| RN-008 | Horário de atendimento humano: 8h às 18h (dias úteis) |
| RN-009 | Chatbot funciona 24/7 (modo Link Direto TopCRM) |
| RN-010 | Máximo de 3 tentativas para cada pergunta antes de oferecer ajuda humana |
| RN-011 | Todas as mensagens são logadas para auditoria |

---

## Ações do Chatbot

| Ação | Trigger | Resultado |
|------|---------|-----------|
| Iniciar Captação | Palavras-chave detectadas | Inicia fluxo de perguntas |
| Solicitar Nome | Início do fluxo | Aguarda resposta textual |
| Solicitar E-mail | Nome recebido | Aguarda resposta com @ |
| Solicitar Placa ou Marca/Modelo/Ano Modelo | Placa ou dados válidos recebidos | Aguarda resposta textual |
| Solicitar Estado | E-mail válido recebido | Apresenta opções numeradas |
| Criar Lead | Estado selecionado | Lead criado no CRM |
| Transferir | "atendente", "humano" | Encaminha para fila |
| Lembrete | 5 min sem resposta | Envia mensagem de follow-up |
| Abandono | 24h sem resposta | Cria lead parcial |

---

## Wireframe - Templates de Mensagem

### Mensagem de Boas-vindas

```
┌─────────────────────────────────────────────────────────┐
│  🛡️ *TopBrasil Proteção Veicular*                       │
│                                                         │
│  Olá! 👋 Sou o assistente virtual da TopBrasil.         │
│                                                         │
│  Proteger seu veículo nunca foi tão fácil!              │
│                                                         │
│  Como posso te ajudar?                                  │
│                                                         │
│  1️⃣ Quero uma cotação                                   │
│  2️⃣ Já sou associado                                    │
│  3️⃣ Falar com atendente                                 │
│                                                         │
│  _Digite o número da opção desejada_                    │
└─────────────────────────────────────────────────────────┘
```

### Solicitação de Nome

```
┌─────────────────────────────────────────────────────────┐
│  Ótima escolha! 🚗                                      │
│                                                         │
│  Para começar sua cotação personalizada, preciso de     │
│  algumas informações.                                   │
│                                                         │
│  *Qual é o seu nome completo?*                          │
└─────────────────────────────────────────────────────────┘
```

### Solicitação de E-mail

```
┌─────────────────────────────────────────────────────────┐
│  Prazer em te conhecer, *{nome}*! 😊                    │
│                                                         │
│  Agora preciso do seu e-mail para enviar a cotação      │
│  detalhada.                                             │
│                                                         │
│  *Qual seu melhor e-mail?*                              │
└─────────────────────────────────────────────────────────┘
```

### Solicitação de Placa ou Marca/Modelo/Ano

```
┌─────────────────────────────────────────────────────────┐
│  Otimo! 📍                                              │
│                                                         │
│  *Qual a placa ou marca/modelo/ano do veículo?*         │
└─────────────────────────────────────────────────────────┘
``````

### Solicitação de Cidade/Estado

```
┌─────────────────────────────────────────────────────────┐
│  Perfeito! 📍                                           │
│                                                         │
│  *Em qual cidade/estado você circula com o veiculo?*    │
└─────────────────────────────────────────────────────────┘
```

### Confirmação de Cadastro

```
┌─────────────────────────────────────────────────────────┐
│  ✅ *Pronto, {nome}!*                                   │
│                                                         │
│  Seu cadastro foi realizado com sucesso!                │
│  Um consultor especializado vai entrar em contato       │
│  em breve pelo WhatsApp. 📱                             │
│                                                         │
│  Enquanto isso, quer conhecer nossos planos?            │
│                                                         │
│  👉 [Ver Planos de Proteção]                            │
└─────────────────────────────────────────────────────────┘
```

---

## Integração Técnica

### Webhook - Mensagem Recebida

**Endpoint:** `POST /api/v1/webhooks/whatsapp/message`

```json
{
  "object": "whatsapp_business_account",
  "entry": [{
    "id": "WHATSAPP_BUSINESS_ACCOUNT_ID",
    "changes": [{
      "value": {
        "messaging_product": "whatsapp",
        "metadata": {
          "display_phone_number": "5511999999999",
          "phone_number_id": "PHONE_NUMBER_ID"
        },
        "contacts": [{
          "profile": { "name": "João" },
          "wa_id": "5511888888888"
        }],
        "messages": [{
          "from": "5511888888888",
          "id": "wamid.xxx",
          "timestamp": "1674567890",
          "text": { "body": "Quero uma cotação" },
          "type": "text"
        }]
      },
      "field": "messages"
    }]
  }]
}
```

### Enviar Mensagem

**Endpoint:** `POST https://graph.facebook.com/v17.0/{phone-number-id}/messages`

```json
{
  "messaging_product": "whatsapp",
  "to": "5511888888888",
  "type": "text",
  "text": {
    "body": "Olá! Qual é o seu nome completo?"
  }
}
```

---

## Domain Events (DDD)

| Evento | Trigger | Payload | Consumers |
|--------|---------|---------|----------|
| `ConversaIniciada` | Primeira mensagem recebida | `{ whatsapp_id, telefone, timestamp, origem }` | Analytics, Chatbot |
| `LeadCriadoViaWhatsApp` | Fluxo completo ou abandono 24h | `{ lead_id, cod_origem, cod_colaborador, dados_coletados }` | CRM, Notificações |
| `ConsultorNotificado` | Lead criado com cod_colaborador | `{ colaborador_id, lead_id, canal }` | Push, WhatsApp |
| `LeadAbandonado` | 24h sem resposta | `{ lead_id, etapa_abandono, dados_parciais }` | CRM, Re-engajamento |
| `TransferenciaParaHumano` | Usuário solicita atendente | `{ whatsapp_id, lead_id, fila_destino }` | Fila de Atendimento |
| `MensagemRecebida` | Webhook WhatsApp | `{ whatsapp_id, mensagem, tipo, timestamp }` | Chatbot, Logs |
| `MensagemEnviada` | Resposta do sistema | `{ whatsapp_id, template, conteudo, timestamp }` | Logs, Analytics |

---

## Métricas Capturadas

| Métrica | Descrição | KPI |
|---------|-----------|-----|
| Conversas iniciadas | Total de pessoas que enviaram primeira mensagem | Volume |
| Taxa de conclusão | % que completaram o fluxo | > 60% |
| Tempo médio de resposta | Segundos entre pergunta e resposta | < 30s |
| Taxa de abandono | % que abandonaram no meio | < 30% |
| Transferências | % que pediram atendente humano | < 20% |
| Leads criados | Total de leads via WhatsApp | Volume |
| Conversão | Leads WhatsApp que converteram | > 15% |

---

## Definição de Pronto

- [ ] Webhook da WhatsApp Business API configurado
- [ ] Fluxo de chatbot implementado (nome → e-mail → placa/marca/modelo → cidade/estado)
- [ ] Validação de telefone contra blacklist funcionando
- [ ] Extração automática de DDD implementada
- [ ] Lead criado no CRM com `cod_origem = 5`
- [ ] Tratamento de abandono após 24h
- [ ] Transferência para atendente humano funcionando
- [ ] Templates de mensagem aprovados pela Meta ou utilizar EvolutionAPI/Similar
- [ ] Logs de todas as mensagens implementados
- [ ] Testes de integração realizados
- [ ] Métricas sendo capturadas no analytics

---

## Dependências

| Dependência | Tipo | Status |
|-------------|------|--------|
| US-CRM-LEAD-001 | Interna | ✅ Disponível |
| WhatsApp Business API  / EvolutionAPI/Similar| Externa | Pendente |
| Meta Business Account | Externa | Pendente |
| Blacklist de Consultores | Interna | ✅ Disponível |
| Infraestrutura de Webhooks | Interna | Pendente |
| Templates aprovados pela Meta | Externa | Pendente |

---

## Custos Estimados

| Item | Custo | Observação |
|------|-------|------------|
| WhatsApp Business API | $0.06/conversa | Modelo conversation-based |
| Infraestrutura webhook | Incluso | Cloud Run existente |
| Armazenamento logs | Incluso | PostgreSQL existente |

---

**Criado por**: Gustavo Titoneli (Product Owner)  
**Data**: 23/01/2026  
**Versão**: 1.2

**Histórico de Alterações:**
| Versão | Data | Alteração |
|--------|------|----------|
| 1.2 | 25/01/2026 | Clarificação dos 2 modos: MODO 1 (número consultor, conversa direta) vs MODO 2 (número TopBrasil, chatbot); cenários de aceitação separados por modo |
| 1.1 | 25/01/2026 | Revisão DDD: Bounded Context, Domain Events, Linguagem Ubíqua; correção de typos e RN duplicada |
| 1.0 | 23/01/2026 | Versão inicial |
