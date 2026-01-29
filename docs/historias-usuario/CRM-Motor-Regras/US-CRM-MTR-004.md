# US-CRM-MTR-004: Editor Visual Low-Code

> **Modulo**: CRM-Motor-Regras  
> **Versao**: 2.0  
> **Data**: 29/01/2026  
> **Status**: Pronto para Desenvolvimento  
> **Story Points**: 55

---

## Historia de Usuario

**Como** usuario de negocio sem experiencia em programacao,  
**Quero** criar e editar regras usando interface visual de arrastar e soltar (drag-and-drop),  
**Para** definir regras complexas de forma intuitiva, sem precisar aprender DSL ou JSON.

---

## Descricao

Esta historia implementa o **Editor Visual Low-Code** com:

1. **Canvas de Fluxo**: Area de trabalho visual
2. **Biblioteca de Componentes**: Blocos arrastáveis
3. **Conexoes Visuais**: Linhas conectando componentes
4. **Paineis de Propriedades**: Configuracao de cada bloco
5. **Validacao Visual**: Feedback em tempo real
6. **Geracao de Codigo**: Conversao para DSL/JSON

### Conceito Visual

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                                                                 │
│    ┌──────────────┐                                                             │
│    │   INICIO     │                                                             │
│    │  Contexto    │                                                             │
│    └──────┬───────┘                                                             │
│           │                                                                     │
│           ▼                                                                     │
│    ┌──────────────┐      ┌──────────────┐                                       │
│    │  AGREGACAO   │      │  AGREGACAO   │                                       │
│    │ Placas SP    │      │    Meta      │                                       │
│    └──────┬───────┘      └──────┬───────┘                                       │
│           │                     │                                               │
│           └──────────┬──────────┘                                               │
│                      │                                                          │
│                      ▼                                                          │
│               ┌──────────────┐                                                  │
│               │   FORMULA    │                                                  │
│               │ % Acima Meta │                                                  │
│               └──────┬───────┘                                                  │
│                      │                                                          │
│                      ▼                                                          │
│               ┌──────────────┐                                                  │
│               │   CONDICAO   │                                                  │
│               │  Acima Meta? │                                                  │
│               └──────┬───────┘                                                  │
│                      │                                                          │
│              ┌───────┴───────┐                                                  │
│              │               │                                                  │
│         [SIM]▼          [NAO]▼                                                  │
│       ┌──────────┐    ┌──────────┐                                              │
│       │  ACAO    │    │   FIM    │                                              │
│       │ Creditar │    │ Sem Acao │                                              │
│       └──────────┘    └──────────┘                                              │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Criterios de Aceitacao

### CA-001: Canvas de Trabalho

- [ ] Area de trabalho responsiva com zoom
- [ ] Grid para alinhamento de componentes
- [ ] Pan (arrastar canvas) com mouse/touch
- [ ] Zoom in/out (scroll, botoes, atalhos)
- [ ] Minimap de navegacao
- [ ] Centralizacao automatica do fluxo

### CA-002: Biblioteca de Componentes

- [ ] Painel lateral com componentes disponiveis
- [ ] Categorias: Dados, Calculos, Logica, Acoes
- [ ] Drag-and-drop para o canvas
- [ ] Preview ao passar o mouse
- [ ] Busca/filtro de componentes

**Componentes Disponiveis:**

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                         BIBLIOTECA DE COMPONENTES                               │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  📊 DADOS                                                                       │
│  ├─ [Inicio] - Define contexto da regra                                         │
│  ├─ [Input] - Variavel de entrada                                               │
│  ├─ [Constante] - Valor fixo                                                    │
│  ├─ [Agregacao] - Consulta agregada em Provider                                 │
│  └─ [Lookup] - Busca de valor em Provider                                       │
│                                                                                 │
│  🔢 CALCULOS                                                                    │
│  ├─ [Formula] - Calculo matematico                                              │
│  ├─ [Funcao] - Funcao pre-definida                                              │
│  ├─ [Arredondar] - Arredondamento                                               │
│  └─ [Comparar] - Comparacao de valores                                          │
│                                                                                 │
│  🔀 LOGICA                                                                      │
│  ├─ [Condicao] - Se/Entao/Senao                                                 │
│  ├─ [E] - Operador AND                                                          │
│  ├─ [Ou] - Operador OR                                                          │
│  └─ [Grupo] - Agrupamento de condicoes                                          │
│                                                                                 │
│  ⚡ ACOES                                                                        │
│  ├─ [Creditar] - Adicionar valor a conta                                        │
│  ├─ [Atualizar] - Modificar campo de entidade                                   │
│  ├─ [Notificar] - Enviar notificacao                                            │
│  ├─ [Tarefa] - Criar tarefa                                                     │
│  └─ [Fim] - Terminar sem acao                                                   │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### CA-003: Conexoes entre Componentes

- [ ] Arrastar linha de saida para entrada
- [ ] Conexoes com curvas suaves (bezier)
- [ ] Cores diferentes por tipo de dado
- [ ] Animacao de fluxo de dados
- [ ] Deletar conexao com click/tecla
- [ ] Reconexao por drag

### CA-004: Painel de Propriedades

- [ ] Abre ao selecionar componente
- [ ] Formulario especifico por tipo
- [ ] Validacao em tempo real
- [ ] Selecao de Provider (para agregacao)
- [ ] Builder de filtros (para agregacao)
- [ ] Editor de expressao (para formula)

**Exemplo - Propriedades de Agregacao:**

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  PROPRIEDADES: Agregacao                                                        │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  Nome da Variavel                                                               │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │ placas_sp_auto_50k                                                      │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  Data Provider                                                                  │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │ PLACA                                                              ▼   │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  Funcao de Agregacao                                                           │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │ CONTAR                                                             ▼   │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  FILTROS                                                        [+ Adicionar]   │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │ consultor_id     │   =    │ @consultor_atual            │ [X]          │   │
│  │ tipo_veiculo     │   =    │ "AUTOMOVEL"                 │ [X]          │   │
│  │ uf_veiculo       │   =    │ "SP"                        │ [X]          │   │
│  │ valor_veiculo    │   <    │ 50000                       │ [X]          │   │
│  │ data_fechamento  │ ENTRE  │ @periodo_inicio @periodo_fim│ [X]          │   │
│  │ status           │   =    │ "FECHADA"                   │ [X]          │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  [Aplicar] [Cancelar]                                                          │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### CA-005: Builder de Filtros Visual

- [ ] Interface de construcao de filtros
- [ ] Selecao de campo via dropdown
- [ ] Selecao de operador via dropdown
- [ ] Input de valor ou selecao de contexto
- [ ] Adicionar/remover filtros
- [ ] Reordenar filtros via drag

### CA-006: Builder de Formula Visual

- [ ] Editor de expressao matematica
- [ ] Autocomplete de variaveis
- [ ] Autocomplete de funcoes
- [ ] Preview do resultado
- [ ] Validacao de sintaxe

**Exemplo - Builder de Formula:**

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│  BUILDER DE FORMULA                                                             │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │ (placas_sp_auto_50k - meta_mes) / meta_mes * 100                        │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  VARIAVEIS DISPONIVEIS         FUNCOES DISPONIVEIS                             │
│  ┌───────────────────────┐    ┌───────────────────────┐                        │
│  │ placas_sp_auto_50k    │    │ MAIOR_ENTRE(a, b)     │                        │
│  │ meta_mes              │    │ MENOR_ENTRE(a, b)     │                        │
│  │ @consultor_atual      │    │ ARREDONDAR(n, casas)  │                        │
│  │ @periodo_inicio       │    │ ARREDONDAR_BAIXO(n)   │                        │
│  │ @periodo_fim          │    │ ARREDONDAR_CIMA(n)    │                        │
│  └───────────────────────┘    │ SE(cond, v_sim, v_nao)│                        │
│                               └───────────────────────┘                        │
│                                                                                 │
│  PREVIEW (com dados de teste)                                                  │
│  placas_sp_auto_50k = 15, meta_mes = 10                                        │
│  Resultado: 50                                                                 │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### CA-007: Validacao Visual

- [ ] Componentes com erro em vermelho
- [ ] Conexoes faltantes destacadas
- [ ] Tooltip com descricao do erro
- [ ] Lista de erros no painel inferior
- [ ] Link para componente com erro

### CA-008: Geracao de Codigo

- [ ] Botao "Ver DSL" mostra codigo gerado
- [ ] Botao "Ver JSON" mostra schema v2.0
- [ ] Edicao no DSL reflete no visual
- [ ] Sincronizacao bidirecional
- [ ] Exportar DSL/JSON para arquivo

### CA-009: Recursos de Edicao

- [ ] Undo/Redo (Ctrl+Z, Ctrl+Y)
- [ ] Copiar/Colar componentes (Ctrl+C, Ctrl+V)
- [ ] Deletar componente (Delete)
- [ ] Selecao multipla (Shift+Click)
- [ ] Duplicar componente (Ctrl+D)
- [ ] Alinhar componentes

### CA-010: Salvamento e Versionamento

- [ ] Salvar rascunho automatico
- [ ] Salvar versao (criar nova versao)
- [ ] Comparar versoes visualmente
- [ ] Restaurar versao anterior
- [ ] Historico de alteracoes

---

## Mockups

### Tela: Editor Visual Completo

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  EDITOR VISUAL DE REGRAS              [Salvar] [Testar] [DSL] [JSON] [Publicar]    │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  COMPONENTES  │                    CANVAS                    │    PROPRIEDADES     │
│  ────────────  │  ─────────────────────────────────────────   │   ───────────────   │
│               │                                               │                     │
│  📊 DADOS     │     ┌──────────┐                              │   Agregacao        │
│  [Inicio]     │     │  INICIO  │                              │   ───────────      │
│  [Input]      │     │ Contexto │                              │                     │
│  [Constante]  │     └────┬─────┘                              │   Nome:            │
│  [Agregacao]  │          │                                    │   [placas_sp...]   │
│  [Lookup]     │          ▼                                    │                     │
│               │     ┌──────────┐     ┌──────────┐             │   Provider:        │
│  🔢 CALCULOS   │     │ AGREGAR  │     │ AGREGAR  │             │   [PLACA ▼]        │
│  [Formula]    │     │ Placas   │◄───►│  Meta    │             │                     │
│  [Funcao]     │     └────┬─────┘     └────┬─────┘             │   Funcao:          │
│  [Arredondar] │          │                │                   │   [CONTAR ▼]       │
│               │          └────────┬───────┘                   │                     │
│  🔀 LOGICA    │                   │                           │   Filtros:         │
│  [Condicao]   │                   ▼                           │   [+ Adicionar]    │
│  [E]          │            ┌──────────┐                       │                     │
│  [Ou]         │            │ FORMULA  │ ← Selecionado         │   ...              │
│               │            │ % Acima  │                       │                     │
│  ⚡ ACOES     │            └────┬─────┘                       │                     │
│  [Creditar]   │                 │                             │                     │
│  [Atualizar]  │                 ▼                             │                     │
│  [Notificar]  │           ┌──────────┐                        │                     │
│  [Fim]        │           │ CONDICAO │                        │                     │
│               │           │ > Meta?  │                        │                     │
│               │           └────┬─────┘                        │                     │
│               │         Sim ┌──┴──┐ Nao                       │                     │
│               │             ▼     ▼                           │                     │
│               │        ┌──────┐ ┌─────┐                       │                     │
│               │        │CREDIT│ │ FIM │                       │                     │
│               │        │Bonus │ │     │                       │                     │
│               │        └──────┘ └─────┘                       │                     │
│               │                                               │                     │
├───────────────┴───────────────────────────────────────────────┴─────────────────────┤
│  VALIDACAO: ✓ Regra valida | 6 componentes | 5 conexoes                            │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

---

## Cenarios de Teste

### CT-001: Criar Regra por Drag-and-Drop

**Dado** canvas vazio  
**Quando** usuario arrasta componente "Inicio" para canvas  
**E** arrasta "Agregacao" e conecta ao "Inicio"  
**E** configura propriedades da agregacao  
**Entao** conexao visual criada  
**E** fluxo de dados indicado  
**E** DSL/JSON atualizados

### CT-002: Validacao em Tempo Real

**Dado** componente "Formula" no canvas  
**E** formula referencia variavel inexistente  
**Quando** usuario sai do campo de edicao  
**Entao** componente fica vermelho  
**E** tooltip mostra "Variavel X nao definida"  
**E** lista de erros atualizada

### CT-003: Sincronizacao DSL-Visual

**Dado** regra criada visualmente  
**Quando** usuario clica "Ver DSL"  
**E** edita o DSL manualmente  
**E** salva alteracoes  
**Entao** editor visual atualizado  
**E** novos componentes adicionados se necessario  
**E** propriedades atualizadas

### CT-004: Undo/Redo

**Dado** regra com 5 componentes  
**Quando** usuario deleta um componente  
**E** pressiona Ctrl+Z  
**Entao** componente restaurado  
**E** conexoes restauradas

---

## Regras de Negocio

| Codigo | Regra | Validacao |
|--------|-------|-----------|
| RN-001 | Inicio obrigatorio | Toda regra deve ter componente Inicio |
| RN-002 | Fluxo conectado | Todos componentes devem estar conectados |
| RN-003 | Fim necessario | Todo caminho deve terminar em Acao ou Fim |
| RN-004 | Variaveis antes de uso | Agregacao/Formula antes de Condicao |
| RN-005 | Auto-save | Rascunho salvo a cada 30 segundos |

---

## Estimativa Detalhada

| Item | Horas | SP |
|------|-------|-----|
| Canvas (zoom, pan, grid) | 32h | 8 |
| Biblioteca de Componentes | 24h | 8 |
| Sistema de Conexoes | 32h | 8 |
| Painel de Propriedades | 32h | 8 |
| Builder de Filtros | 24h | 5 |
| Builder de Formula | 24h | 5 |
| Validacao Visual | 16h | 5 |
| Geracao DSL/JSON | 24h | 5 |
| Testes | 16h | 3 |
| **TOTAL** | **224h** | **55** |

---

## Historico de Alteracoes

| Versao | Data | Autor | Alteracao |
|--------|------|-------|-----------|
| 1.0 | 29/01/2026 | PO | Versao inicial |
| 2.0 | 29/01/2026 | PO | Reescrita para arquitetura de alta abstracao |
