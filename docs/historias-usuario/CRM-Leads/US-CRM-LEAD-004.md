# US-CRM-LEAD-004 — Captura via Formulário Embarcado

## História de Usuário

**Como** parceiro ou afiliado da TopBrasil,  
**Quero** incorporar um formulário de captação de leads em meu site ou blog,  
**Para** capturar leads interessados em proteção veicular e receber comissão por conversões.

## Prioridade

Importante

## Estimativa

8 SP

---

## Contexto de Negócio

A captura via formulário embarcado permite expandir os canais de aquisição de leads através de parceiros, afiliados e sites de terceiros. O formulário é incorporado via iframe ou widget JavaScript, mantendo a identidade visual do parceiro enquanto envia os dados diretamente para o CRM TopBrasil.

### Benefícios

| Benefício | Descrição |
|-----------|-----------|
| **Escalabilidade** | Multiplica pontos de captação sem aumento de infraestrutura |
| **Rastreabilidade** | Cada parceiro tem código único para mensuração |
| **Conversão** | Usuário não precisa sair do site do parceiro |
| **Comissionamento** | Base para programa de afiliados |

---

## Fluxo de Integração

```
┌─────────────────────────────────────────────────────────────────────┐
│                    SITE DO PARCEIRO                                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │                    CONTEÚDO DO PARCEIRO                       │  │
│  │                                                               │  │
│  │  "Proteja seu veículo com a TopBrasil!"                       │  │
│  │                                                               │  │
│  │  ┌─────────────────────────────────────────────────────────┐  │  │
│  │  │              FORMULÁRIO EMBARCADO (iframe)              │  │  │
│  │  │  ┌─────────────────────────────────────────────────┐    │  │  │
│  │  │  │  Nome: [________________]                       │    │  │  │
│  │  │  │  Telefone: [________________]                   │    │  │  │
│  │  │  │  E-mail: [________________]                     │    │  │  │
│  │  │  │                                                 │    │  │  │
│  │  │  │  [      QUERO UMA COTAÇÃO      ]                │    │  │  │
│  │  │  └─────────────────────────────────────────────────┘    │  │  │
│  │  └─────────────────────────────────────────────────────────┘  │  │
│  │                                                               │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
                                │
                                │ POST /api/leads/embed
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         CRM TOPBRASIL                               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   ✓ Valida origem (CORS + token)                                    │
│   ✓ Registra cod_origem = 12 (FORMULARIO_EMBARCADO)                 │
│   ✓ Registra cod_parceiro (identificador do parceiro)               │
│   ✓ Cria Lead com status NOVO                                       │
│   ✓ Retorna confirmação ao parceiro                                 │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Modos de Integração

### Opção 1: Iframe (Recomendado)

```html
<iframe 
  src="https://crm.toptechbr.com.br/embed/lead-form?token=PARCEIRO_TOKEN"
  width="100%" 
  height="400" 
  frameborder="0"
  style="border: none; border-radius: 8px;">
</iframe>
```

### Opção 2: Widget JavaScript

```html
<div id="topbrasil-lead-form"></div>
<script src="https://crm.toptechbr.com.br/embed/widget.js" 
        data-token="PARCEIRO_TOKEN"
        data-theme="light">
</script>
```

### Opção 3: API Direta (Avançado)

```javascript
// POST https://crm.toptechbr.com.br/api/v1/leads/embed
{
  "token": "PARCEIRO_TOKEN",
  "lead": {
    "nome": "João da Silva",
    "telefone": "11999999999",
    "email": "joao@email.com"
  }
}
```

---

## Parâmetros do Formulário

| Parâmetro | Descrição | Obrigatório | Exemplo |
|-----------|-----------|-------------|---------|
| `token` | Token único do parceiro | Sim | `abc123xyz` |
| `theme` | Tema visual (light/dark) | Não | `light` |
| `color` | Cor primária do botão | Não | `#FF6600` |
| `redirect_url` | URL de redirecionamento pós-envio | Não | `https://parceiro.com/obrigado` |
| `callback_url` | Webhook para notificar conversão | Não | `https://parceiro.com/webhook` |

---

## Campos do Formulário Simplificado

| Campo | Tipo | Obrigatório | Validação |
|-------|------|-------------|-----------|
| Nome Completo | text | Sim | Mín. 3 caracteres |
| Telefone | tel | Sim | Formato brasileiro, DDD obrigatório |
| E-mail | email | Sim | Formato válido |

> **Nota**: O formulário embarcado é **simplificado** (apenas Etapa 1). O lead pode completar dados de veículo e localização posteriormente via link enviado por e-mail/WhatsApp.

---

## Critérios de Aceitação

### Cenário 1 — Embed via iframe funcionando
- **Dado que** um parceiro incorporou o iframe em seu site
- **Quando** um visitante preenche nome, telefone e e-mail válidos
- **E** clica em "Quero uma Cotação"
- **Então** o lead é criado no CRM com `cod_origem = 12` (FORMULARIO_EMBARCADO)
- **E** o `cod_parceiro` é registrado para rastreabilidade
- **E** exibe mensagem de sucesso no iframe

### Cenário 2 — Embed via Widget JavaScript
- **Dado que** um parceiro incorporou o widget JS em seu site
- **Quando** o script carrega
- **Então** o formulário é renderizado no container especificado
- **E** respeita as configurações de tema e cor

### Cenário 3 — Validação de token
- **Dado que** o formulário é carregado com um token inválido
- **Quando** tento enviar os dados
- **Então** recebo erro "Token de parceiro inválido"
- **E** o lead não é criado

### Cenário 4 — Token expirado ou parceiro inativo
- **Dado que** o parceiro está com status inativo
- **Quando** o formulário tenta enviar dados
- **Então** recebo erro "Parceiro temporariamente indisponível"
- **E** o lead não é criado

### Cenário 5 — Validação de telefone
- **Dado que** informo um telefone já cadastrado como consultor
- **Quando** tento enviar o formulário
- **Então** recebo erro "Este telefone já está cadastrado"
- **E** o lead não é criado

### Cenário 6 — Redirecionamento pós-envio
- **Dado que** o parceiro configurou `redirect_url`
- **Quando** o lead é criado com sucesso
- **Então** o visitante é redirecionado para a URL configurada

### Cenário 7 — Webhook de notificação
- **Dado que** o parceiro configurou `callback_url`
- **Quando** o lead é criado com sucesso
- **Então** uma notificação POST é enviada para o webhook
- **E** contém o ID do lead e timestamp

### Cenário 8 — Proteção CORS
- **Dado que** uma requisição vem de um domínio não autorizado
- **Quando** tenta enviar dados via API
- **Então** a requisição é bloqueada por CORS
- **E** retorna erro 403

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Token de parceiro é obrigatório e validado em todas as requisições |
| RN-002 | Cada parceiro tem um token único e intransferível |
| RN-003 | Lead criado via embed recebe `cod_origem = 12` (FORMULARIO_EMBARCADO) |
| RN-004 | O `cod_parceiro` é registrado para comissionamento futuro |
| RN-005 | Validação de telefone contra blacklist de consultores é obrigatória |
| RN-006 | DDD é extraído e armazenado automaticamente |
| RN-007 | Parceiro inativo não pode captar novos leads |
| RN-008 | Rate limiting: máximo 100 leads/hora por token |
| RN-009 | CORS configurado apenas para domínios autorizados do parceiro |
| RN-010 | Lead embarcado inicia com status `NOVO` e `etapa_abandono = 'FORM_PROSPECT'` |

---

## Ações Possíveis

| Ação | Trigger | Resultado |
|------|---------|-----------|
| Criar Lead | Formulário submetido | Lead status `NOVO` no CRM |
| Notificar Parceiro | Lead criado | Webhook POST (se configurado) |
| Redirecionar | Lead criado | Navega para redirect_url (se configurado) |
| Bloquear | Token inválido/expirado | Erro 401/403 |
| Rate Limit | Excede 100 leads/hora | Erro 429 (Too Many Requests) |

---

## Wireframe Conceitual

### Formulário Embarcado (Tema Light)

```
┌─────────────────────────────────────────────────────────┐
│         🛡️ PROTEÇÃO VEICULAR TOPBRASIL                 │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Solicite uma cotação gratuita!                         │
│                                                         │
│  ┌───────────────────────────────────────────────────┐  │
│  │  Nome Completo *                                  │  │
│  │  ┌─────────────────────────────────────────────┐  │  │
│  │  │                                             │  │  │
│  │  └─────────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────┘  │
│                                                         │
│  ┌───────────────────────────────────────────────────┐  │
│  │  Telefone com DDD *                               │  │
│  │  ┌─────────────────────────────────────────────┐  │  │
│  │  │ (__)_____-____                              │  │  │
│  │  └─────────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────┘  │
│                                                         │
│  ┌───────────────────────────────────────────────────┐  │
│  │  E-mail *                                         │  │
│  │  ┌─────────────────────────────────────────────┐  │  │
│  │  │                                             │  │  │
│  │  └─────────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────┘  │
│                                                         │
│  ┌───────────────────────────────────────────────────┐  │
│  │         🚗  QUERO UMA COTAÇÃO                     │  │
│  └───────────────────────────────────────────────────┘  │
│                                                         │
│  ─────────────────────────────────────────────────────  │
│  Powered by TopBrasil • Política de Privacidade         │
└─────────────────────────────────────────────────────────┘
```

### Tela de Sucesso

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│                    ✅ PRONTO!                           │
│                                                         │
│   Recebemos sua solicitação de cotação.                 │
│                                                         │
│   Em breve um consultor entrará em contato              │
│   pelo telefone informado.                              │
│                                                         │
│   📱 Fique atento ao WhatsApp!                          │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Gestão de Parceiros

### Cadastro de Parceiro

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| Nome do Parceiro | text | Sim | Nome comercial |
| CNPJ/CPF | text | Sim | Documento do parceiro |
| Domínios Autorizados | array | Sim | URLs onde o embed pode ser usado |
| E-mail de Contato | email | Sim | Para notificações |
| Webhook URL | url | Não | Para notificação de leads |
| Redirect URL | url | Não | Redirecionamento pós-envio |
| Token | uuid | Auto | Gerado automaticamente |
| Status | enum | Auto | ATIVO, INATIVO, SUSPENSO |

### Tabela de Origem Atualizada

| Código | Origem | Descrição |
|--------|--------|-----------|
| ... | ... | ... |
| 12 | `FORMULARIO_EMBARCADO` | Lead captado via formulário embarcado em site de parceiro |

---

## Métricas Capturadas

| Dado | Descrição | Uso Analítico |
|------|-----------|---------------|
| `cod_origem` | Sempre 12 para embarcado | Identificar canal |
| `cod_parceiro` | ID do parceiro | Comissionamento e performance |
| `dominio_origem` | Domínio de onde veio o lead | Análise de fontes |
| `ddd_telefone` | DDD extraído | Análise regional |
| `data_criacao` | Timestamp | Análise temporal |
| `tempo_preenchimento` | Segundos para preencher | UX do formulário |

---

## API Endpoints

### POST /api/v1/leads/embed

**Request:**
```json
{
  "token": "abc123xyz",
  "lead": {
    "nome": "João da Silva",
    "telefone": "11999999999",
    "email": "joao@email.com"
  },
  "meta": {
    "domain": "parceiro.com.br",
    "page_url": "https://parceiro.com.br/cotacao",
    "user_agent": "Mozilla/5.0..."
  }
}
```

**Response Success (201):**
```json
{
  "success": true,
  "lead_id": "uuid-do-lead",
  "message": "Lead criado com sucesso",
  "redirect_url": "https://parceiro.com/obrigado"
}
```

**Response Error (401):**
```json
{
  "success": false,
  "error": "TOKEN_INVALID",
  "message": "Token de parceiro inválido"
}
```

---

## Definição de Pronto

- [ ] Endpoint POST /api/v1/leads/embed funcionando
- [ ] Validação de token de parceiro implementada
- [ ] CORS configurado por domínio de parceiro
- [ ] Iframe responsivo criado e testado
- [ ] Widget JavaScript criado e testado
- [ ] Validação de telefone contra blacklist funcionando
- [ ] Extração de DDD implementada
- [ ] Webhook de notificação funcionando
- [ ] Redirecionamento pós-envio funcionando
- [ ] Rate limiting implementado (100 leads/hora)
- [ ] CRUD de parceiros implementado (admin)
- [ ] Documentação de integração para parceiros
- [ ] Testes de integração realizados

---

## Dependências

| Dependência | Tipo | Status |
|-------------|------|--------|
| US-CRM-LEAD-001 | Interna | ✅ Disponível |
| Blacklist de Consultores | Interna | ✅ Disponível |
| Sistema de Tokens (JWT/UUID) | Interna | Pendente |
| Cadastro de Parceiros | Interna | Pendente |
| Infraestrutura CORS | Interna | Pendente |

---

## Integrações Futuras

| Integração | Descrição | Prioridade |
|------------|-----------|------------|
| Google Tag Manager | Eventos de conversão | Importante |
| Facebook Pixel | Tracking de conversão | Importante |
| Programa de Afiliados | Comissionamento | Desejável |

---

**Criado por**: Gustavo Titoneli (Product Owner)  
**Data**: 23/01/2026  
**Versão**: 1.0

**Histórico de Alterações:**
| Versão | Data | Alteração |
|--------|------|----------|
| 1.0 | 23/01/2026 | Versão inicial |
