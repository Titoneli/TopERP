# US-CRM-LED-005 — Captura via WhatsApp Business

## História de Usuário

**Como** visitante interessado em proteção veicular,  
**Quero** iniciar uma conversa via WhatsApp e ser cadastrado automaticamente como lead,  
**Para** receber atendimento rápido e personalizado pelo canal que prefiro.

## Prioridade

Importante

## Estimativa

13 SP

---

## Contexto de Negócio

O WhatsApp é o principal canal de comunicação no Brasil, com mais de 120 milhões de usuários ativos. A captura automática de leads via WhatsApp Business API permite:

- **Atendimento 24/7** via chatbot inicial
- **Qualificação automática** através de perguntas estruturadas
- **Integração com CRM** em tempo real
- **Redução de fricção** no processo de captação

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
┌─────────────────────────────────────────────────────────────────────────────┐
│                        FLUXO DE CAPTURA WHATSAPP                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌───────────────┐         ┌───────────────┐         ┌───────────────┐    │
│   │   CLIENTE     │         │   WHATSAPP    │         │    CRM        │    │
│   │   (Celular)   │         │   BUSINESS    │         │   TOPBRASIL   │    │
│   └───────┬───────┘         │      API      │         └───────┬───────┘    │
│           │                 └───────┬───────┘                 │            │
│           │                         │                         │            │
│   1. Inicia conversa ──────────────►│                         │            │
│      "Oi, quero cotação"            │                         │            │
│                                     │                         │            │
│           │◄──────────────── 2. Mensagem automática           │            │
│      "Olá! Qual seu nome?"          │                         │            │
│                                     │                         │            │
│   3. "João da Silva" ──────────────►│                         │            │
│                                     │                         │            │
│           │◄──────────────── 4. "Qual seu e-mail?"            │            │
│                                     │                         │            │
│   5. "joao@email.com" ─────────────►│                         │            │
│                                     │                         │            │
│           │                         │── 6. Webhook ──────────►│            │
│           │                         │    (cria lead)          │            │
│           │                         │                         │            │
│           │                         │◄── 7. Confirmação ──────│            │
│           │                         │                         │            │
│           │◄──────────────── 8. "Lead criado! Um             │            │
│      "consultor vai te atender"     │                         │            │
│                                     │                         │            │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Fluxo do Chatbot

### Trigger de Entrada

| Trigger | Ação |
|---------|------|
| Mensagem contendo "cotação", "proteção", "seguro", "preço" | Inicia fluxo de captação |
| Mensagem contendo "falar com atendente", "humano" | Transfere para consultor |
| Qualquer outra mensagem | Menu de opções |

### Fluxo de Captação

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLUXO DO CHATBOT                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  [INÍCIO]                                                       │
│     │                                                           │
│     ▼                                                           │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  "Olá! 👋 Sou o assistente virtual da TopBrasil.       │   │
│  │   Vou te ajudar a conseguir uma cotação de proteção    │   │
│  │   veicular. Para começar, qual é o seu nome completo?" │   │
│  └─────────────────────────────────────────────────────────┘   │
│     │                                                           │
│     │ [Usuário responde nome]                                   │
│     ▼                                                           │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  "Prazer, {nome}! 😊                                    │   │
│  │   Agora preciso do seu e-mail para enviar a cotação:"  │   │
│  └─────────────────────────────────────────────────────────┘   │
│     │                                                           │
│     │ [Usuário responde e-mail]                                 │
│     ▼                                                           │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  "Perfeito! Para finalizar, em qual estado você mora?" │   │
│  │                                                         │   │
│  │  1️⃣ São Paulo                                          │   │
│  │  2️⃣ Rio de Janeiro                                     │   │
│  │  3️⃣ Minas Gerais                                       │   │
│  │  4️⃣ Outro estado                                       │   │
│  └─────────────────────────────────────────────────────────┘   │
│     │                                                           │
│     │ [Usuário seleciona opção]                                 │
│     ▼                                                           │
│  [LEAD CRIADO NO CRM]                                           │
│     │                                                           │
│     ▼                                                           │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  "✅ Pronto, {nome}!                                    │   │
│  │                                                         │   │
│  │   Seu cadastro foi realizado com sucesso.              │   │
│  │   Um consultor especializado vai entrar em contato     │   │
│  │   em breve pelo WhatsApp.                              │   │
│  │                                                         │   │
│  │   Enquanto isso, quer saber mais sobre nossos planos?" │   │
│  │                                                         │   │
│  │   👉 Ver planos                                         │   │
│  │   👉 Falar com consultor agora                          │   │
│  └─────────────────────────────────────────────────────────┘   │
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

### Cenário 1 — Captura completa via chatbot
- **Dado que** envio uma mensagem para o WhatsApp da TopBrasil
- **Quando** respondo nome, e-mail e estado solicitados pelo chatbot
- **Então** um lead é criado no CRM com `cod_origem = 5` (WHATSAPP)
- **E** recebo confirmação de cadastro no chat

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

### Cenário 5 — Transferência para atendente humano
- **Dado que** estou no fluxo do chatbot
- **Quando** digito "falar com atendente" ou "humano"
- **Então** a conversa é transferida para a fila de consultores
- **E** recebo: "Aguarde, estou transferindo para um consultor..."

### Cenário 6 — Fora do horário comercial
- **Dado que** envio mensagem às 23h (fora do expediente)
- **Quando** o chatbot responde
- **Então** recebo: "Nosso horário de atendimento é das 8h às 18h. Mas não se preocupe, seu cadastro será realizado e um consultor entrará em contato no próximo dia útil."
- **E** o lead é criado normalmente

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

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Telefone é capturado automaticamente do número do WhatsApp |
| RN-002 | DDD é extraído do telefone para analytics regional |
| RN-003 | Lead via WhatsApp recebe `cod_origem = 5` |
| RN-004 | Validação contra blacklist de consultores é obrigatória |
| RN-005 | Lead parcial é criado após 24h de abandono |
| RN-006 | Timeout entre mensagens: 5 minutos para lembrete, 24h para abandono |
| RN-007 | Horário de atendimento humano: 8h às 18h (dias úteis) |
| RN-008 | Chatbot funciona 24/7 |
| RN-009 | Máximo de 3 tentativas para cada pergunta antes de oferecer ajuda humana |
| RN-010 | Todas as mensagens são logadas para auditoria |

---

## Ações do Chatbot

| Ação | Trigger | Resultado |
|------|---------|-----------|
| Iniciar Captação | Palavras-chave detectadas | Inicia fluxo de perguntas |
| Solicitar Nome | Início do fluxo | Aguarda resposta textual |
| Solicitar E-mail | Nome recebido | Aguarda resposta com @ |
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
│  🛡️ *TopBrasil Proteção Veicular*                      │
│                                                         │
│  Olá! 👋 Sou o assistente virtual da TopBrasil.        │
│                                                         │
│  Proteger seu veículo nunca foi tão fácil!             │
│                                                         │
│  Como posso te ajudar?                                  │
│                                                         │
│  1️⃣ Quero uma cotação                                  │
│  2️⃣ Já sou associado                                   │
│  3️⃣ Falar com atendente                                │
│                                                         │
│  _Digite o número da opção desejada_                   │
└─────────────────────────────────────────────────────────┘
```

### Solicitação de Nome

```
┌─────────────────────────────────────────────────────────┐
│  Ótima escolha! 🚗                                      │
│                                                         │
│  Para começar sua cotação personalizada, preciso de    │
│  algumas informações.                                   │
│                                                         │
│  *Qual é o seu nome completo?*                         │
└─────────────────────────────────────────────────────────┘
```

### Solicitação de E-mail

```
┌─────────────────────────────────────────────────────────┐
│  Prazer em te conhecer, *{nome}*! 😊                   │
│                                                         │
│  Agora preciso do seu e-mail para enviar a cotação     │
│  detalhada.                                             │
│                                                         │
│  *Qual seu melhor e-mail?*                             │
└─────────────────────────────────────────────────────────┘
```

### Solicitação de Estado

```
┌─────────────────────────────────────────────────────────┐
│  Perfeito! 📍                                          │
│                                                         │
│  *Em qual estado você mora?*                           │
│                                                         │
│  1️⃣ São Paulo                                          │
│  2️⃣ Rio de Janeiro                                     │
│  3️⃣ Minas Gerais                                       │
│  4️⃣ Paraná                                             │
│  5️⃣ Rio Grande do Sul                                  │
│  6️⃣ Santa Catarina                                     │
│  7️⃣ Outro estado                                       │
│                                                         │
│  _Digite o número da opção_                            │
└─────────────────────────────────────────────────────────┘
```

### Confirmação de Cadastro

```
┌─────────────────────────────────────────────────────────┐
│  ✅ *Pronto, {nome}!*                                  │
│                                                         │
│  Seu cadastro foi realizado com sucesso!               │
│                                                         │
│  📋 *Resumo:*                                          │
│  • Nome: {nome}                                         │
│  • E-mail: {email}                                      │
│  • Estado: {estado}                                     │
│                                                         │
│  Um consultor especializado vai entrar em contato      │
│  em breve pelo WhatsApp. 📱                            │
│                                                         │
│  Enquanto isso, quer conhecer nossos planos?           │
│                                                         │
│  👉 [Ver Planos de Proteção]                           │
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
- [ ] Fluxo de chatbot implementado (nome → e-mail → estado)
- [ ] Validação de telefone contra blacklist funcionando
- [ ] Extração automática de DDD implementada
- [ ] Lead criado no CRM com `cod_origem = 5`
- [ ] Tratamento de abandono após 24h
- [ ] Transferência para atendente humano funcionando
- [ ] Templates de mensagem aprovados pela Meta
- [ ] Logs de todas as mensagens implementados
- [ ] Rate limiting configurado
- [ ] Testes de integração realizados
- [ ] Métricas sendo capturadas no analytics

---

## Dependências

| Dependência | Tipo | Status |
|-------------|------|--------|
| US-CRM-LED-001 | Interna | ✅ Disponível |
| WhatsApp Business API | Externa | Pendente |
| Meta Business Account | Externa | Pendente |
| Blacklist de Consultores | Interna | ✅ Disponível |
| Infraestrutura de Webhooks | Interna | Pendente |
| Templates aprovados pela Meta | Externa | Pendente |

---

## Custos Estimados

| Item | Custo | Observação |
|------|-------|------------|
| WhatsApp Business API | $0.05/conversa | Modelo conversation-based |
| Infraestrutura webhook | Incluso | Cloud Run existente |
| Armazenamento logs | Incluso | PostgreSQL existente |

---

**Criado por**: Gustavo Titoneli (Product Owner)  
**Data**: 23/01/2026  
**Versão**: 1.0

**Histórico de Alterações:**
| Versão | Data | Alteração |
|--------|------|----------|
| 1.0 | 23/01/2026 | Versão inicial |
