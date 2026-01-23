# US-CRM-LEAD-001 — Captação de Lead via Landing Page

## História de Usuário

**Como** visitante interessado em proteção veicular,  
**Quero** preencher um formulário de captação em etapas,  
**Para** receber uma cotação personalizada e ser atendido por um consultor.

## Prioridade

Essencial

## Estimativa

13 SP

---

## Contexto de Negócio

A captação de leads é a porta de entrada do funil comercial. O formulário multi-etapas aumenta a taxa de conversão ao solicitar informações progressivamente, cadastrando o lead já na primeira etapa para garantir o contato mesmo em caso de abandono.

---

## Fluxo Multi-Step Form

```
┌─────────────────────────────────────────────────────────────────┐
│                    LANDING PAGE                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐       │
│  │   ETAPA 1    │───▶│   ETAPA 2    │───▶│   ETAPA 3    │       │
│  │   Contato    │    │   Veículo    │    │  Localização │       │
│  └──────────────┘    └──────────────┘    └──────────────┘       │
│         │                   │                   │               │
│         ▼                   ▼                   ▼               │
│   [Cadastra Lead]    [Atualiza Lead]    [Finaliza Lead]         │
│                                                                 │
│  ════════════════════════════════════════════════════════════   │
└─────────────────────────────────────────────────────────────────┘
```

---

## Parâmetros da Landing Page (Query String)

A landing page deve capturar parâmetros da URL para rastreabilidade e direcionamento.

| Parâmetro | Descrição | Obrigatório | Exemplo |
|-----------|-----------|-------------|----------|
| `cod_origem` | Código da origem/campanha do lead | Não | `?cod_origem=2` |
| `cod_colaborador` | Código do consultor para direcionamento | Não | `?cod_colaborador=1234` |
| `utm_source` | Fonte de tráfego (padrão UTM) | Não | `?utm_source=google` |
| `utm_medium` | Meio de marketing | Não | `?utm_medium=cpc` |
| `utm_campaign` | Nome da campanha | Não | `?utm_campaign=black_friday` |

### Tabela de Códigos de Origem

| Código | Origem | Descrição |
|--------|--------|----------|
| 1 | `LINK_DIRETO` | Acesso direto à landing page |
| 2 | `INFLUENCER_INSTAGRAM` | Publicidade via influenciador no Instagram |
| 3 | `ADS_GOOGLE` | Anúncio no Google Ads |
| 4 | `ADS_META` | Anúncio no Facebook/Instagram Ads |
| 5 | `WHATSAPP` | Link compartilhado via WhatsApp |
| 6 | `INDICACAO` | Indicação de associado existente |
| 7 | `CONSULTOR_PROPRIO` | Link personalizado do consultor |
| 8 | `APP_CONSULTOR` | Cadastro via app do consultor |
| 9 | `APP_ASS_INDICACAO` | Indicação de um associado do consultor via app do associado |
| 10 | `VENDA_PROPRIA` | Lead cadastrado pelo próprio consultor diretamente no CRM |
| 11 | `AUTOMACAO` | Lead cadastrado via automação |
| 99 | `OUTROS` | Outras origens não mapeadas |

**Exemplo de URL completa:**
```
https://crm.toptechbr.com.br/cotacao?cod_origem=2&cod_colaborador=1234&utm_campaign=influencer_joao
```

---

## Inputs e Outputs

### Etapa 1 — Dados de Contato
| Campo | Tipo | Obrigatório | Validação |
|-------|------|-------------|-----------|
| Nome Completo | text | Sim | Mín. 3 caracteres |
| Telefone | tel | Sim | Formato brasileiro, DDD obrigatório, não pode ser telefone de consultor |
| E-mail | email | Sim | Mín. 3 caracteres |

#### Validação Especial do Telefone

| Regra | Descrição | Ação |
|-------|-----------|------|
| Formato | (XX) 9XXXX-XXXX ou (XX) XXXX-XXXX | Aceita mesmo se inválido |
| DDD válido | DDD deve existir na tabela IBGE | Aceita mesmo se inválido |
| Blacklist de consultores | Telefone não pode constar na base de consultores ativos | Exibe erro: *"Este telefone já está cadastrado como consultor"* |
| Extração do DDD | Extrair e armazenar DDD separadamente para analytics | Registro automático |

**Output:** Lead criado com status `NOVO`, `cod_origem`, `cod_colaborador` e `ddd_telefone` registrados, atualizar etapa etapa_abandono 'FORM_PROSPECT'

### Etapa 2 — Dados do Veículo
| Campo | Tipo | Obrigatório | Validação |
|-------|------|-------------|-----------|
| Marca | select | Sim | Lista via API FIPE ou tabela própria COR_MARCA|
| Modelo | select | Sim | Filtrado por marca selecionada na tabela COR_MODELO |
| Ano Modelo | select | Sim | Últimos 30 anos ou retornado da API (Codigo Fipe) ou BD (Criar Tabela) |
| Tipo de Uso | select | Sim | Passeio ou Comercial |

**Output:** Lead atualizado com dados do veículo, atualizar etapa_abandono para 'FORM_VEICULO'

### Etapa 3 — Localização
| Campo | Tipo | Obrigatório | Validação |
|-------|------|-------------|-----------|
| Estado (UF) | select | Sim | Lista de UFs brasileiras |
| Cidade | select | Sim | Filtrada por UF selecionada |

**Output:** Lead finalizado com status `QUALIFICADO`, pronto para distribuição, atualizar etapa_abandono para 'FORM_LOCAL'

---

## Critérios de Aceitação

### Cenário 1 — Cadastro na Etapa 1
- **Dado que** preenchi nome, telefone e e-mail válidos
- **Quando** clico em "Continuar"
- **Então** o lead é cadastrado na base com status `NOVO` e registrada a etapa_abandono 'FORM_PROSPECT'
- **E** avanço para a Etapa 2

### Cenário 2 — Abandono na Etapa 2
- **Dado que** completei a Etapa 1
- **Quando** abandono o formulário na Etapa 2 
- **Então** o lead permanece cadastrado para follow-up e registrada a etapa_abandono 'FORM_VEICULO'

### Cenário 3 — Abandono na Etapa 3
- **Dado que** completei a Etapa 2
- **Quando** abandono o formulário na Etapa 3
- **Então** o lead permanece cadastrado para follow-up e registrada a etapa_abandono 'FORM_LOCAL'

### Cenário 4 — Preenchimento completo
- **Dado que** completei as 3 etapas
- **Quando** finalizo o formulário
- **Então** o lead é marcado como `QUALIFICADO` e registrada a etapa_abandono 'FORM_LOCAL'
- **E** não é atribuído automaticamente a um consultor

### Cenário 5 — Telefone de consultor bloqueado
- **Dado que** informo um telefone cadastrado como consultor
- **Quando** tento avançar da Etapa 1
- **Então** recebo mensagem de erro: *"Este telefone já está cadastrado como consultor"*
- **E** não avanço para a Etapa 2

### Cenário 6 — Captura de origem via URL
- **Dado que** acesso a landing page com `?cod_origem=2`
- **Quando** completo a Etapa 1
- **Então** o lead é criado com `cod_origem = 2` (Influencer Instagram)

### Cenário 7 — Direcionamento para consultor específico
- **Dado que** acesso a landing page com `?cod_colaborador=1234`
- **Quando** o lead é qualificado
- **Então** é atribuído diretamente ao consultor 1234

### Cenário 8 — Sem cod_colaborador na URL
- **Dado que** acesso a landing page **sem** `cod_colaborador`
- **Quando** o lead é qualificado
- **Então** o lead **NÃO é atribuído** a nenhum consultor
- **E** aguarda atribuição manual ou via automatição

### Cenário 4 — Não existe plano para o veículo/local
- **Dado que** completei as 3 etapas
- **Quando** finalizo o formulário
- **Então** não é encontrado nenhum plano para os dados informados
- **E** não é atribuído automaticamente a um consultor e é exibida uma mensagem informando que um consultor entrará em contato


### Cenário 10 — Consultor inválido no parâmetro
- **Dado que** acesso com `?cod_colaborador=9999` (inexistente ou inativo)
- **Quando** o lead é qualificado
- **Então** o lead **NÃO é atribuído** a nenhum consultor
- **E** aguarda atribuição manual ou via automatição

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Lead é criado na Etapa 1, independente de completar as demais |
| RN-002 | Pode haver quantos leads duplicados forem necessários |
| RN-003 | Lead duplicado cria novo registro |
| RN-004 | Origem do lead deve ser rastreável via `cod_origem` ou UTM parameters |
| RN-006 | Dados do veículo devem seguir tabela FIPE válida ou tabela própria COR_MARCA, COR_MODELO |
| RN-007 | **Telefone não pode pertencer a consultor ativo** (validar contra blacklist) |
| RN-008 | **DDD do telefone deve ser extraído e armazenado** para analytics regional |
| RN-009 | Se `cod_colaborador` válido e ativo, lead é atribuído diretamente ao consultor |
| RN-010 | Se `cod_colaborador` nulo, inválido ou inativo, lead **NÃO é atribuído** a nenhum consultor |
| RN-011 | Parâmetros `cod_origem` e `cod_colaborador` sem valor = registrar como nulo |

---

## Ações Possíveis

| Ação | Trigger | Resultado |
|------|---------|-----------|
| Criar Lead | Etapa 1 completa | Lead status `NOVO` |
| Atualizar Veículo | Etapa 2 completa | Lead com dados do veículo |
| Finalizar Captação | Etapa 3 completa | Lead status `QUALIFICADO` |
| Voltar Etapa | Botão "Voltar" | Retorna etapa anterior, mantém dados |
| Abandonar | Fechar página | Lead permanece no status atual |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────┐
│  ○ ● ○   ETAPA 1 DE 3 - SEUS DADOS                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Nome Completo *                                    │    │
│  │  ┌─────────────────────────────────────────────────┐│    │
│  │  │ João da Silva                                   ││    │
│  │  └─────────────────────────────────────────────────┘│    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Telefone com DDD *                                 │    │
│  │  ┌─────────────────────────────────────────────────┐│    │
│  │  │ (11) 99999-9999                                 ││    │
│  │  └─────────────────────────────────────────────────┘│    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  E-mail *                                           │    │
│  │  ┌─────────────────────────────────────────────────┐│    │
│  │  │ joao@email.com                                  ││    │
│  │  └─────────────────────────────────────────────────┘│    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │              CONTINUAR  ────────▶                   │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  ● ● ○   ETAPA 2 DE 3 - SEU VEÍCULO                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────────────┐  ┌──────────────────────┐         │
│  │  Marca *             │  │  Modelo *            │         │
│  │  ┌────────────────┐  │  │  ┌────────────────┐  │         │
│  │  │ Volkswagen  ▼  │  │  │  │ Gol         ▼  │  │         │
│  │  └────────────────┘  │  │  └────────────────┘  │         │
│  └──────────────────────┘  └──────────────────────┘         │
│                                                             │
│  ┌──────────────────────┐  ┌──────────────────────┐         │
│  │  Ano Modelo *        │  │  Tipo de Uso *       │         │
│  │  ┌────────────────┐  │  │  ┌────────────────┐  │         │
│  │  │ 2024        ▼  │  │  │  │ ○ Passeio      │  │         │
│  │  └────────────────┘  │  │  │ ○ Comercial    │  │         │
│  └──────────────────────┘  │  └────────────────┘  │         │
│                            └──────────────────────┘         │
│                                                             │
│  ┌────────────┐  ┌─────────────────────────────────────┐    │
│  │ ◀ VOLTAR   │  │              CONTINUAR  ────────▶   │    │
│  └────────────┘  └─────────────────────────────────────┘    │
│                                                             │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  ● ● ●   ETAPA 3 DE 3 - LOCALIZAÇÃO                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────────────┐  ┌──────────────────────┐         │
│  │  Estado *            │  │  Cidade *            │         │
│  │  ┌────────────────┐  │  │  ┌────────────────┐  │         │
│  │  │ São Paulo   ▼  │  │  │  │ São Paulo   ▼  │  │         │
│  │  └────────────────┘  │  │  └────────────────┘  │         │
│  └──────────────────────┘  └──────────────────────┘         │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  ℹ️  A cidade é usada para calcular o valor da      │    │
│  │     proteção baseado na região de circulação.       │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  ┌────────────┐  ┌─────────────────────────────────────┐    │
│  │ ◀ VOLTAR   │  │         SOLICITAR COTAÇÃO  ✓        │    │
│  └────────────┘  └─────────────────────────────────────┘    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Métricas Capturadas

Esta user story é responsável apenas pela **captura** das métricas. A visualização em dashboards está documentada em outro documento.

### Dados Capturados por Lead

| Dado | Descrição | Uso Analítico |
|------|-----------|---------------|
| `ddd_telefone` | DDD extraído do telefone | Análise regional de demanda |
| `cod_origem` | Código da origem/campanha | Análise de efetividade de canais |
| `cod_colaborador` | Consultor vinculado (se houver) | Análise de performance |
| `etapa_abandono` | Última etapa completada | Análise de funil |
| `data_criacao` | Timestamp da criação | Análise temporal |
| `utm_source` | Fonte de tráfego | Análise de marketing |
| `utm_medium` | Meio de marketing | Análise de marketing |
| `utm_campaign` | Nome da campanha | Análise de marketing |

### Eventos Registrados

| Evento | Momento | Dados |
|--------|---------|-------|
| `LEAD_CREATED` | Etapa 1 completa | Todos os dados de contato |
| `LEAD_VEHICLE_ADDED` | Etapa 2 completa | Dados do veículo |
| `LEAD_QUALIFIED` | Etapa 3 completa | Localização |
| `LEAD_ABANDONED` | Abandono detectado | Última etapa |

---

## Definição de Pronto

- Lead criado na Etapa 1 com status NOVO
- Formulário 3 etapas funcional
- Integração com API FIPE funcionando ou Tabelas COR_MARCA/COR_MODELO atualizadas
- Validação de telefone contra blacklist de consultores
- Extração e armazenamento do DDD do telefone
- Captura de cod_origem via query string
- Captura de cod_colaborador via query string
- Atribuição direta ao consultor quando cod_colaborador válido
- Lead não atribuído quando cod_colaborador nulo/inválido
- Rastreamento UTM funcionando
- Métricas sendo capturadas corretamente
- Testes de usabilidade realizados

---

## Dependências

| Dependência | Tipo | Status |
|-------------|------|--------|
| API FIPE | Externa | Pendente |
| Cadastro de Colaboradores/Consultores | Interno | Disponível |
| Cadastro de Marcas COR_MARCA / Modelos COR_MODELO, Anos Modelos | Interno | Disponível |
| Blacklist de Telefones (Consultores) | Interno | Disponível |
| Tabela de Origens (COR_VAL_DOMINIO) | Interno | Disponível |
| Sistema de Notificações e Automações | Interno | Pendente |

---

**Criado por**: Gustavo Titoneli (Product Owner)  
**Data**: 21/01/2026  
**Versão**: 1.0

**Histórico de Alterações:**
| Versão | Data | Alteração |
|--------|------|----------|
| 1.0 | 21/01/2026 | Versão inicial |
