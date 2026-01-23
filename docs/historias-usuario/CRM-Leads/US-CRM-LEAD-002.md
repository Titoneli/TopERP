# US-CRM-LEAD-002 — Comparativo de Planos de Proteção Veicular

## História de Usuário

**Como** visitante que completou a captação de dados,  
**Quero** visualizar planos de proteção adequados para meu veículo,  
**Para** comparar opções disponíveis e escolher a melhor proteção.

## Prioridade

Essencial

## Estimativa

13 SP

---

## Contexto de Negócio

Após a conclusão da Etapa 3 de captação, o lead deve ser imediatamente direcionado para uma tela de comparativo de planos. Essa etapa aumenta o engajamento ao apresentar soluções concretas com base nos dados coletados (marca, modelo, valor FIPE, cidade/estado), facilitando a tomada de decisão e a conversão para cliente.

---

## Dependência da Etapa Anterior

Este user story depende de:
- [US-CRM-LEAD-001](US-CRM-LEAD-001.md) - Captação de Lead via Landing Page (Etapa 3 completa)

---

## Fluxo de Transição

```
┌─────────────────────────────────────────────────────────────────┐
│              US-CRM-LEAD-001: ETAPA 3 COMPLETA                   │
│         (Lead qualificado com dados do veículo)                 │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    US-CRM-LEAD-002                               │
│              COMPARATIVO DE PLANOS                              │
│    (Busca e exibe planos conforme parâmetros do lead)           │
└─────────────────────────────────────────────────────────────────┘
```

---

## Critérios de Busca de Planos

A exibição de planos deve estar vinculada aos parâmetros coletados em US-CRM-LEAD-001:

| Parâmetro | Fonte | Descrição |
|-----------|-------|-----------|
| **Marca/Modelo** | Etapa 2 (Veículo) | Filtra planos por compatibilidade de veículo |
| **Valor FIPE** | Etapa 2 (Veículo) | Filtra planos por faixa de valor |
| **Cidade/Estado** | Etapa 3 (Localização) | Filtra planos por cobertura regional |
| **Tipo de Uso** | Etapa 2 (Veículo) | Passeio ou Comercial |

---

## Critérios de Aceitação

### Cenário 1 — Exibição de planos após Etapa 3
- **Dado que** completei a Etapa 3 e meu lead foi qualificado
- **Quando** a tela transiciona automaticamente
- **Então** visualizo comparativo com planos disponíveis, no máximo 3 planos, conforme ordenação no cadastro de tabela de preço
- **E** cada plano exibe nome, valor mensal e serviços principais, valor de adesão, valor de coparticipacao/franquia, obrigatoriedade de instalação do rastreador, valor da instalação do rastreador

### Cenário 2 — Visualização detalhada de plano
- **Dado que** estou visualizando o comparativo
- **Quando** clico em um plano específico
- **Então** visualizo detalhes completos: valores e limites
- **E** posso rolar/expandir para ver serviços opcionais e adicionar esses serviços

### Cenário 3 — Seleção de serviços adicionais
- **Dado que** adiciono um serviço adicional
- **Quando** clico em "Selecionar"
- **Então** o valor da mensalidade é atualizado, acrescentando ou reduzindo o valor do serviço adicional

### Cenário 4 — Seleção de plano
- **Dado que** visualizo um plano que desejo
- **Quando** clico em "Selecionar" ou "Aceitar"
- **Então** meu lead é registrado com o plano selecionado
- **E** sou direcionado para próxima etapa (formulário final)
- **E** o evento `PLAN_SELECTED` é disparado e os valores devem ser salvos e serão válidos durante o prazo de validade da cotação

### Cenário 5 — Nenhum plano disponível
- **Dado que** completei as etapas, mas não há planos disponíveis para meus parâmetros
- **Quando** a tela de comparativo carrega
- **Então** visualizo mensagem: "Desculpe, nenhum plano disponível para seu veículo ou região no momento"
- **E** posso solicitar para ser notificado quando planos estiverem disponíveis

### Cenário 6 — Informações de Contato com Consultor
- **Dado que** estou visualizando planos
- **Quando** clico em "Falar com Consultor"
- **Então** visualizo chat/telefone para atendimento
- **E** o consultor (se atribuído em US-CRM-LEAD-001) pode me auxiliar na escolha

---

## Regras de Negócio

| ID | Regra |
|----|-------|
| RN-001 | Planos exibidos devem estar ativos e habilitados no sistema |
| RN-002 | Planos devem ser filtrados conforme compatibilidade regional (cobertura por estado/cidade) |
| RN-003 | Planos devem respeitar faixa de valor FIPE do veículo informado |
| RN-004 | Planos cuja ordenação seja superior a 3 ou estejam indisponíveis para a região não devem ser exibidos" |
| RN-005 | Ordem padrão de exibição: Conforme cadastro da tabela de preços |
| RN-006 | Plano marcado como "Recomendado" deve ter destaque visual |
| RN-007 | Valores exibidos devem ser reais |
| RN-008 | Histórico de planos visualizados deve ser registrado para analytics |

---

## Ações Possíveis

| Ação | Trigger | Resultado |
|------|---------|-----------|
| Visualizar Plano | Página carrega ou usuário clica em plano | Detalhes completos do plano exibidos |
| Comparar Planos | Usuário visualiza o comparativo de 3 planos | Tabela comparativa exibida |
| Selecionar Plano | Usuário clica "Selecionar/Contratar" | Lead vinculado ao plano, finaliza fluxo |
| Registrar Interesse | Usuário clica "Notificar-me" | E-mail registrado para futuras ofertas |

---

## Wireframe Conceitual

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  ← Voltar                    COMPARATIVO DE PLANOS                         ℹ    │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  🚗 Volkswagen Gol 2024 | FIPE: R$ 45.000 | São Paulo, SP                       │
│                                                                                 │
│  Valor Franquia: R$ 1.200 | Rastreador R$ 150,00 | Rastreador Obrigatório       │
│                                                                                 │
│  ┌──────────────────────────┬──────────────────────────┬──────────────────────┐ │
│  │                          │ ⭐ RECOMENDADO           │                      │ │
│  │                          │                          │                      │ │
│  │ Proteção Básica Plus     │ Proteção Intermediária   │ Proteção Premium     │ │
│  │ R$ 89,90/mês             │ R$ 149,90/mês            │ R$ 249,90/mês        │ │
│  │                          │                          │                      │ │
│  │ Serviços:                │ Serviços:                │ Serviços:            │ │
│  │ ✓ Roubo/Furto            │ ✓ Tudo acima +           │ ✓ Todos anteriores   │ │
│  │ ✓ Vidros/Lanternas       │ ✓ Rastreador             │ ✓ Reboque (Am. do S) │ │
│  │ ✓ Colisão                │ ✓ Reboque                │ ✓ Parceiros          │ │
│  │ ✓ Terceiros              │ ✓ Assistência 24h        │                      │ │
│  │                          │                          │                      │ │
│  │ Limite: R$ 45.000        │ Limite: R$ 60.000        │ Limite: R$ 100.000   │ │
│  │ Vigência: 12 meses       │ Vigência: 12 meses       │ Vigência: 12 meses   │ │
│  │                          │                          │                      │ │
│  │    [Selecionar ►]        │    [Selecionar ►]        │    [Selecionar ►]    │ │
│  │                          │                          │                      │ │
│  └──────────────────────────┴──────────────────────────┴──────────────────────┘ │
│                                                                                 │
│ Válido por 10 dias.                                                             │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Métricas Capturadas

Esta user story é responsável pela captura de métricas de visualização e seleção de planos.

### Dados Capturados por Interação

| Dado | Descrição | Uso Analítico |
|------|-----------|---------------|
| `plano_visualizado` | IDs dos planos consultados | Análise de interesse |
| `tempo_visualizacao` | Tempo gasto na tela | Taxa de engajamento |
| `plano_selecionado` | ID do plano escolhido | Análise de preferência |
| `data_selecao` | Timestamp da seleção | Análise temporal |
| `ordenacao_utilizada` | Critério de ordenação aplicado | Preferência de usuário |
| `comparativo_usado` | Sim/Não | Uso da funcionalidade |

### Eventos Registrados

| Evento | Momento | Dados |
|--------|---------|-------|
| `PLAN_PAGE_LOADED` | Página carrega | planos_exibidos |
| `PLAN_VIEWED` | Usuário visualiza detalhes | tempo_visualizacao |
| `PLAN_COMPARED` | Usuário ativa comparativo | planos_comparados |
| `PLAN_SELECTED` | Usuário seleciona plano | valor_mensal |
| `PLAN_ABANDONED` | Usuário sai sem selecionar | ultimo_plano_visualizado |

---

## Definição de Pronto

- Tela de comparativo implementada e responsiva
- Integração com banco de planos realizada
- Visualização detalhada de planos funcional
- Funcionalidade de comparação lado-a-lado funcionando
- Eventos sendo disparados corretamente
- Testes de usabilidade realizados
- Documentação de integração com backend atualizada

---

## Dependências

| Dependência | Tipo | Status |
|-------------|------|--------|
| US-CRM-LEAD-001 (Lead Qualificado) | Interna | Essencial |
| Base de Dados de Planos (CRM_TABELA_PLANO) | Interna | Disponível |
| Integração com Motor de Preços CRM_TAB_PLANO_VALOR | Interno | Pendente |
| Sistema de Notificações Automatizadas | Interno | Pendente |
| Analytics/Eventos | Interno | Pendente |

---

**Criado por**: Gustavo Titoneli (Product Owner)  
**Data**: 21/01/2026  
**Versão**: 1.1

**Histórico de Alterações:**
| Versão | Data | Alteração |
|--------|------|----------|
| 1.1 | 21/01/2026 | Atualização terminológica (cobertura→serviços) e layout wireframe (3 colunas). Refletindo melhor a proposta de valor e usabilidade visual. |
| 1.0 | 21/01/2026 | Versão inicial - Continuidade de US-CRM-LEAD-001 |
