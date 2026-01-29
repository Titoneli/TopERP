# Módulo de Captação de Leads (CRM-LEAD)

**Guia Completo de Funcionamento**

---

## O que é este módulo?

O **Módulo de Captação de Leads** é a porta de entrada do sistema comercial. Ele é responsável por capturar, armazenar e qualificar todos os potenciais associados (leads) que demonstram interesse em proteção veicular. Pense nele como uma "rede de pesca inteligente": ele captura interessados (prospects) de diversos canais (landing page, WhatsApp, Facebook, Google), organiza as informações, e direciona cada lead para o consultor certo ou permite que seja distribuido pelo gestor. Tudo de forma automática e rastreável.

---

## Por que este módulo é importante?

Sem leads, não há vendas. O módulo garante que:
- **Nenhum interessado seja perdido** — Mesmo quem abandona o formulário na primeira etapa já fica cadastrado
- **A origem seja rastreada** — Sabemos exatamente de onde cada lead veio (Google, Instagram, indicação, etc.)
- **O consultor certo receba o lead** — Distribuição automática/manual ou direcionamento por link personalizado
- **O tempo de resposta seja mínimo** — Notificações em tempo real para o consultor

---

## Como funciona na prática?

### A Jornada do Lead (do interesse à conversão)

Imagine que Maria está interessada em proteção veicular para seu carro. Veja o que acontece:

---

### ETAPA 1: Maria Encontra a Landing Page

**1. Acesso à página**
- Maria vê um anúncio no Instagram sobre proteção veicular
- Ela clica e é direcionada para a landing page da TopBrasil
- O sistema já captura: de onde ela veio (Instagram Ads), qual campanha, etc.

**2. Formulário em 3 passos**

O formulário é dividido em etapas para garantir a geração do lead:

**Passo 1 — Dados de Contato**
- Maria informa: nome, telefone e e-mail
- Ao clicar em "Continuar", o sistema já salva o lead
- Se Maria desistir aqui, já temos como entrar em contato depois

**Passo 2 — Dados do Veículo**
- Maria seleciona: marca, modelo, ano e tipo de uso do veículo
- Isso determina quais planos estão disponíveis para o modelo/ano informado

**Passo 3 — Localização**
- Maria informa: estado e cidade onde mora
- Isso determina quais planos estão disponíveis na região dela

**3. Comparativo de Planos**
- Após completar o formulário, Maria vê até 3 planos comparados, com um deles em destaque
- Cada plano mostra: valor mensal, cobertura, franquia, se precisa de rastreador
- Maria pode adicionar serviços extras e ver o valor atualizado

**4. Consultor é Notificado**
- O consultor responsável recebe uma notificação no whatsapp ou via push
- Ele vê todos os dados da Maria: nome, telefone, veículo, cidade de circulação
- Pode ligar ou mandar WhatsApp em poucos minutos

---

### Outros Canais de Captação

Além da landing page, o sistema captura leads de outros lugares:

**Via WhatsApp**
- Maria clica em um botão "Falar no WhatsApp"
- Se for o link do consultor: vai direto para o WhatsApp pessoal dele
- Se for o link geral da empresa: um chatbot coleta os dados e direciona para a fila

**Via Facebook/Instagram Ads**
- Maria preenche um formulário direto no Facebook (sem sair do app)
- O sistema recebe o lead automaticamente via webhook
- Em segundos, o consultor já é notificado por whatsapp ou push

**Via Google Ads**
- Funciona igual ao Facebook: formulário direto no Google
- Lead chega no sistema em tempo real

**Via Formulário Embarcado**
- Um site parceiro/indicador pode ter o formulário da TopBrasil embutido
- O lead é capturado e atribuído ao parceiro/indicador automaticamente 
- O lead é atribuido ao consultor que cadastrou o parceiro/indicador 
- o consultor é notificado por whatsapp ou push

**Via Cadastro Manual**
- O consultor conhece alguém interessado
- Cadastra o lead diretamente no sistema ou app
- Fica vinculado à carteira dele

---

## De onde vêm os leads?

O sistema rastreia a origem de cada lead para saber quais canais funcionam melhor:

| Código | Origem | Descrição |
|--------|--------|-----------|
| 1 | Link Direto | Acesso direto à landing page |
| 2 | Influencer Instagram | Publicidade via influenciador |
| 3 | Google Ads | Anúncio pago no Google |
| 4 | Meta Ads | Anúncio no Facebook/Instagram |
| 5 | WhatsApp | Link compartilhado via WhatsApp |
| 6 | Indicação | Indicação de associado existente |
| 7 | Consultor Próprio | Link personalizado do consultor |
| 8 | App Consultor | Cadastro direto pelo app |
| 9 | App Associado | Indicação via app do associado |
| 10 | Venda Própria | Consultor cadastra manualmente |
| 11 | Automação | Cadastro via integração |
| 12 | Formulário Embarcado | Formulário em site parceiro |

---

## O Ciclo de Vida do Lead

Todo lead passa por estados que mostram onde ele está no processo:

```
   [NOVO]
     |
     v
[QUALIFICADO] --> [NEGOCIAÇÃO] --> [CONVERTIDO]
     |                 |
     v                 v
 [ARQUIVADO] <---- [PERDIDO]
     |
     v
  [INATIVO]
```

**NOVO** — Acabou de entrar no sistema, aguardando primeiro contato

**QUALIFICADO** — Consultor fez contato e confirmou interesse real

**NEGOCIAÇÃO** — Lead está analisando propostas (passa para o módulo Funil de Vendas)

**CONVERTIDO** — Fechou contrato e virou cliente

**PERDIDO** — Desistiu ou fechou com concorrente

**ARQUIVADO** — Sem interesse agora, mas pode retornar no futuro

**INATIVO** — Muito tempo sem interação

---

## As Funcionalidades em Detalhes

### Parte 1: Captação via Landing Page

A landing page é o principal canal de entrada:

**Formulário em 3 etapas** — Divide as informações para não sobrecarregar o visitante. Cada etapa já salva os dados, garantindo que mesmo quem abandona fique cadastrado.

**Validação inteligente do telefone** — O sistema extrai o DDD automaticamente para analytics regionais. Também verifica se o telefone não é de um consultor (evita leads falsos ou com ocultação de dados).

**Integração com FIPE** — Ao informar o veículo, o sistema busca automaticamente o valor de mercado.

**Parâmetros de rastreamento** — A URL pode conter códigos que identificam a campanha, o consultor responsável e a origem do tráfego.

---

### Parte 2: Comparativo de Planos

Após o formulário, o lead vê os planos disponíveis:

**Filtro automático** — Baseado no veículo e localização, o sistema mostra apenas planos válidos para aquele perfil.

**Até 3 planos comparados** — Exibe lado a lado: valor mensal, adesão, franquia, coberturas e se precisa de rastreador. Um dos planos fica em destaque direcionando o fluxo.

**Serviços adicionais** — O lead pode marcar serviços extras e ver o valor atualizado em tempo real.

**Seleção simplificada** — Um clique em "Quero este plano" e um consultor é acionado ou o lead é qualificado.

---

### Parte 3: Dashboard e Analytics

O gestor precisa entender de onde vêm os leads e quais canais funcionam:

**Leads por DDD** — Mapa de calor mostrando quais regiões geram mais interesse. Ajuda a decidir onde investir em marketing.

**Leads por Origem** — Gráfico comparando Google Ads, Facebook, WhatsApp, etc. Mostra o ROI de cada canal.

**Taxa de Conversão** — Quantos leads viraram clientes? E em quanto tempo?

**Funil de Captação** — Quantos completaram cada etapa do formulário? Onde está o maior abandono?

---

### Parte 4: Captura via WhatsApp

O WhatsApp é o canal preferido dos brasileiros:

**Dois modos de operação:**

**Modo Landing Page Exclusiva:**
- O consultor tem sua própria landing page (ex: joao.topbrasilpv.com.br)
- O botão de WhatsApp vai direto para o número pessoal do consultor
- O lead já fica vinculado a ele automaticamente

**Modo Link Direto TopCRM:**
- A página principal da empresa (topbrasilpv.com.br)
- O botão vai para o número oficial da empresa
- Um chatbot coleta os dados e distribui para a fila de atendimento

**Cadastro automático** — Ao iniciar a conversa, o sistema já cria o lead com os dados do WhatsApp.

**Atendimento 24/7** — O chatbot pode atender fora do horário comercial e agendar contato.

**Whatsapp conectado ao CRM** — O consultor pode conectar o proprio whatsapp ao sistema para que o mesmo faça as notificações e follow-ups automaticamente.

---

### Parte 5: Integrações com Ads

Leads direto do Facebook e Google:

**Facebook/Instagram Lead Ads:**
- O usuário preenche um formulário sem sair do app
- O Meta envia os dados automaticamente para o sistema (webhook)
- Em segundos, o consultor é notificado via whatsapp e push
- Origem registrada como "ADS_META"

**Google Ads (Lead Form Extensions):**
- Funciona igual: formulário nativo do Google
- Dados chegam em tempo real
- Origem registrada como "ADS_GOOGLE"

**Rastreabilidade completa** — Nome da campanha, conjunto de anúncios e anúncio específico ficam gravados.

---

### Parte 6: Gestão de Leads

Funcionalidades para organizar a base:

**Importação em massa** — Upload de CSV/Excel com leads de outras fontes. Ideal para migração de sistemas ou eventos.

**Exportação** — Gera planilha com leads filtrados. Para análises externas ou backup.

**Arquivamento** — Leads sem interesse agora podem ser arquivados. Ficam separados da lista ativa, mas não são perdidos.

**Cadastro manual** — Consultor pode cadastrar leads que conheceu pessoalmente. Fica vinculado à carteira dele.

**Atribuição a consultor** — O gestor pode direcionar um lead para um consultor específico e o sistema notifica o consultor via whatsapp e push.

---

### Parte 7: Qualificação de Leads

Nem todo lead é igual. O sistema ajuda a identificar os melhores:

**Qualificação BANT:**
- **B**udget (Orçamento): O lead tem condição de pagar?
- **A**uthority (Autoridade): É quem decide a compra?
- **N**eed (Necessidade): Tem urgência real?
- **T**iming (Prazo): Quando pretende fechar?

O consultor responde essas perguntas e o sistema calcula um score de 0 a 100.

---

### Parte 8: Inteligência Artificial

Funcionalidades avançadas com IA:

**Enriquecimento de Dados:**
- APIs externas complementam informações do lead
- Dados do veículo, histórico de multas, perfil de crédito, históricos juridicos (PuxaCapivara)
- Ajuda o consultor a se preparar melhor para a abordagem

**Score Automático (Machine Learning):**
- O sistema aprende com leads anteriores
- Calcula automaticamente a probabilidade de conversão
- Leads com score alto são priorizados na fila

**Detecção de Duplicados:**
- Se o mesmo telefone ou e-mail aparecer novamente
- O sistema avisa e permite mesclar os cadastros
- Evita trabalho duplicado e confusão

---

## Sistemas que Conversam com este Módulo

| Sistema | Para que serve |
|---------|----------------|
| **API FIPE** | Buscar valor de mercado do veículo |
| **IBGE** | Lista de estados e cidades |
| **PUXACAPIVARA** | Busca restrições judiciais |
| **WhatsApp Business API** | Receber mensagens e criar leads |
| **Meta (Facebook/Instagram)** | Receber leads de anúncios |
| **Google Ads** | Receber leads de anúncios |
| **Google Analytics** | Rastrear conversões no site |
| **CRM-Funil-Vendas** | Passa leads qualificados para negociação |

---

## Regras Importantes

Algumas regras que o sistema sempre respeita:

**Para captação:**
- Lead é salvo já na Etapa 1 (mesmo se abandonar depois)
- Telefone de consultor não pode ser cadastrado como lead
- DDD é extraído automaticamente para analytics

**Para rastreamento:**
- Toda origem deve ter um código (`cod_origem`)
- Parâmetros UTM são capturados quando presentes
- Consultor responsável é gravado quando vem de link personalizado

**Para qualificação:**
- Score BANT varia de 0 a 100
- Leads com score alto devem ser priorizados
- Score ML é recalculado quando novos dados chegam

**Para integrações:**
- Webhooks do Facebook/Google devem ser processados em até 5 segundos
- Leads de ads recebem origem automática
- Falhas no webhook são registradas para retry

---

## Resumo Geral

Este módulo é essencial para abastecer o funil comercial com leads de qualidade. Ele automatiza todo o processo de captação:

**Captação multicanal:**
- Landing page com formulário em 3 etapas
- WhatsApp (chatbot, direto com consultor ou conexão direta)
- Facebook/Instagram Lead Ads
- Google Ads Lead Form
- Formulário embarcado em parceiros
- Cadastro manual pelo consultor

**Qualificação inteligente:**
- Score BANT preenchido pelo consultor
- Score ML calculado automaticamente
- Enriquecimento de dados via APIs
- Detecção de leads duplicados

**Rastreabilidade completa:**
- Origem de cada lead registrada
- Campanhas e anúncios identificados
- Dashboard com analytics por região e canal
- Histórico completo de interações

**Resumoo Final: Funcionalidades que garantem que nenhum interessado seja perdido e que os consultores tenham todas as informações para converter leads em associados.**
