# US-CRM-MTR-004: Editor Visual Low-Code

> **Modulo**: CRM-Motor-Regras  
> **Versao**: 1.0  
> **Data**: 29/01/2026  
> **Status**: Pronto para Desenvolvimento  
> **Story Points**: 34

---

## Historia de Usuario

**Como** gestor do sistema (usuario nao tecnico),  
**Quero** montar regras de calculo visualmente arrastando e conectando blocos,  
**Para** criar regras complexas sem precisar escrever formulas manualmente.

---

## Descricao

Esta historia implementa uma interface visual drag-and-drop para construcao de regras. Permite que usuarios sem conhecimento tecnico criem regras complexas de forma intuitiva, similar a ferramentas como Scratch, Node-RED ou Zapier.

---

## Conceito Visual

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  EDITOR VISUAL DE REGRAS                                                            │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  ┌──────────────────┐       CANVAS DE EDICAO                                       │
│  │ PALETA DE BLOCOS │  ┌───────────────────────────────────────────────────────┐   │
│  │                  │  │                                                       │   │
│  │ VARIAVEIS        │  │   ┌─────────────┐                                    │   │
│  │ ┌────────────┐   │  │   │  VARIAVEL   │                                    │   │
│  │ │ Valor Venda│   │  │   │ Valor Venda │                                    │   │
│  │ └────────────┘   │  │   └──────┬──────┘                                    │   │
│  │ ┌────────────┐   │  │          │                                           │   │
│  │ │ Tipo Plano │   │  │          ▼                                           │   │
│  │ └────────────┘   │  │   ┌─────────────┐     ┌─────────────┐                │   │
│  │                  │  │   │  CONDICAO   │────►│   SE NAO    │                │   │
│  │ CONDICOES        │  │   │Plano=Premium│     │   0.05      │                │   │
│  │ ┌────────────┐   │  │   └──────┬──────┘     └─────────────┘                │   │
│  │ │ SE/ENTAO   │   │  │          │ SE SIM                                    │   │
│  │ └────────────┘   │  │          ▼                                           │   │
│  │ ┌────────────┐   │  │   ┌─────────────┐                                    │   │
│  │ │ E/OU       │   │  │   │   FORMULA   │                                    │   │
│  │ └────────────┘   │  │   │ Valor × 8%  │                                    │   │
│  │                  │  │   └──────┬──────┘                                    │   │
│  │ OPERACOES        │  │          │                                           │   │
│  │ ┌────────────┐   │  │          ▼                                           │   │
│  │ │ Multiplicar│   │  │   ┌─────────────┐                                    │   │
│  │ └────────────┘   │  │   │    ACAO     │                                    │   │
│  │ ┌────────────┐   │  │   │  Creditar   │                                    │   │
│  │ │ Somar      │   │  │   └─────────────┘                                    │   │
│  │ └────────────┘   │  │                                                       │   │
│  │                  │  └───────────────────────────────────────────────────────┘   │
│  │ ACOES            │                                                              │
│  │ ┌────────────┐   │  FORMULA GERADA:                                            │
│  │ │ Creditar   │   │  IF(TIPO_PLANO = "PREMIUM") THEN VALOR_VENDA * 0.08         │
│  │ └────────────┘   │  ELSE VALOR_VENDA * 0.05                                    │
│  └──────────────────┘                                                              │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

---

## Criterios de Aceitacao

### CA-001: Paleta de Blocos

- [ ] Sistema exibe paleta lateral com blocos disponiveis
- [ ] Blocos organizados por categoria (Variaveis, Condicoes, Operacoes, Acoes)
- [ ] Blocos sao arrastáveis para o canvas
- [ ] Sistema permite buscar blocos por nome

### CA-002: Canvas de Edicao

- [ ] Sistema exibe area de edicao onde blocos sao posicionados
- [ ] Blocos podem ser movidos livremente no canvas
- [ ] Blocos podem ser conectados por linhas (fluxo)
- [ ] Sistema permite zoom in/out no canvas
- [ ] Sistema permite arrastar canvas (pan)

### CA-003: Blocos de Variavel

- [ ] Bloco de variavel mostra nome e tipo
- [ ] Bloco permite selecionar variavel existente
- [ ] Bloco permite criar nova variavel inline
- [ ] Bloco exibe valor padrao se definido

### CA-004: Blocos de Condicao

- [ ] Bloco SE/ENTAO com duas saidas (sim/nao)
- [ ] Bloco permite definir variavel e operador
- [ ] Bloco E/OU para agrupar condicoes
- [ ] Blocos de comparacao (igual, maior, menor, entre)

### CA-005: Blocos de Operacao

- [ ] Blocos matematicos: soma, subtracao, multiplicacao, divisao
- [ ] Blocos de funcao: MIN, MAX, ROUND, ABS
- [ ] Bloco permite inserir valor fixo ou referenciar variavel
- [ ] Blocos podem ser encadeados

### CA-006: Blocos de Acao

- [ ] Bloco Creditar (destino: conta)
- [ ] Bloco Notificar (tipo: email, push)
- [ ] Bloco Atualizar Status
- [ ] Bloco permite configurar parametros

### CA-007: Conexoes entre Blocos

- [ ] Sistema permite arrastar conexao de um bloco para outro
- [ ] Conexoes tem direcao (entrada → saida)
- [ ] Sistema valida compatibilidade de conexoes
- [ ] Sistema exibe erro se conexao invalida

### CA-008: Geracao de Formula

- [ ] Sistema gera formula textual a partir do fluxo visual
- [ ] Sistema exibe preview da formula em tempo real
- [ ] Sistema valida formula gerada
- [ ] Sistema permite alternar entre modo visual e textual

### CA-009: Salvar e Carregar

- [ ] Sistema salva posicao dos blocos no canvas
- [ ] Sistema permite carregar regra visual existente
- [ ] Sistema converte regras textuais para visual (quando possivel)
- [ ] Sistema permite exportar/importar layout

---

## Mockups

### Tela: Editor Visual Completo

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  EDITOR VISUAL - REG-COM-001                      [Salvar] [Simular] [Modo Texto]  │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│ ┌──────────────┐  ┌───────────────────────────────────────────────────────────────┐│
│ │ BLOCOS       │  │                                                               ││
│ │              │  │                      ┌───────────────┐                        ││
│ │ Buscar: [__] │  │     INICIO ──────────┤   VARIAVEL    │                        ││
│ │              │  │                      │ Valor Venda   │                        ││
│ │ ▼ Variaveis  │  │                      │   (DECIMAL)   │                        ││
│ │ ┌──────────┐ │  │                      └───────┬───────┘                        ││
│ │ │Valor Venda│ │  │                              │                               ││
│ │ └──────────┘ │  │                              ▼                                ││
│ │ ┌──────────┐ │  │                      ┌───────────────┐                        ││
│ │ │Tipo Plano│ │  │                      │   CONDICAO    │                        ││
│ │ └──────────┘ │  │                      │ Tipo = Premium│                        ││
│ │ ┌──────────┐ │  │                      └───┬───────┬───┘                        ││
│ │ │Qtd Vendas│ │  │                    SIM   │       │  NAO                       ││
│ │ └──────────┘ │  │                          ▼       ▼                            ││
│ │              │  │              ┌───────────────┐ ┌───────────────┐              ││
│ │ ▼ Condicoes  │  │              │   OPERACAO    │ │   OPERACAO    │              ││
│ │ ┌──────────┐ │  │              │  Valor × 8%   │ │  Valor × 5%   │              ││
│ │ │ SE/ENTAO │ │  │              └───────┬───────┘ └───────┬───────┘              ││
│ │ └──────────┘ │  │                      │                 │                      ││
│ │ ┌──────────┐ │  │                      └────────┬────────┘                      ││
│ │ │   E/OU   │ │  │                               ▼                               ││
│ │ └──────────┘ │  │                      ┌───────────────┐                        ││
│ │              │  │                      │     ACAO      │                        ││
│ │ ▼ Operacoes  │  │                      │   Creditar    │                        ││
│ │ ┌──────────┐ │  │                      │   em Conta    │                        ││
│ │ │ Somar +  │ │  │                      └───────────────┘                        ││
│ │ └──────────┘ │  │                                                               ││
│ │ ┌──────────┐ │  │  Zoom: [−] 100% [+]                 [Centralizar] [Limpar]   ││
│ │ │Multiplicar│ │  └───────────────────────────────────────────────────────────────┘│
│ │ └──────────┘ │                                                                    │
│ │ ┌──────────┐ │  FORMULA GERADA:                                                  │
│ │ │ Dividir ÷│ │  ┌─────────────────────────────────────────────────────────────┐  │
│ │ └──────────┘ │  │ IF(TIPO_PLANO = "PREMIUM")                                  │  │
│ │              │  │   THEN VALOR_VENDA * 0.08                                   │  │
│ │ ▼ Acoes      │  │   ELSE VALOR_VENDA * 0.05                                   │  │
│ │ ┌──────────┐ │  └─────────────────────────────────────────────────────────────┘  │
│ │ │ Creditar │ │  Status: Formula valida ✓                                         │
│ │ └──────────┘ │                                                                    │
│ └──────────────┘                                                                    │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### Blocos Detalhados

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│  TIPOS DE BLOCOS                                                                    │
├─────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                     │
│  BLOCO VARIAVEL                    BLOCO CONDICAO                                  │
│  ┌─────────────────────┐           ┌─────────────────────┐                         │
│  │ ○ VARIAVEL          │           │ ○ SE                │                         │
│  │ ┌─────────────────┐ │           │ ┌─────────────────┐ │                         │
│  │ │ Valor Venda ▼   │ │           │ │ Tipo Plano  ▼   │ │                         │
│  │ └─────────────────┘ │           │ │ = (igual)   ▼   │ │                         │
│  │ Tipo: DECIMAL       │           │ │ "PREMIUM"       │ │                         │
│  │                   ● │           │ └─────────────────┘ │                         │
│  └─────────────────────┘           │ ● SIM        ● NAO │                         │
│                                    └─────────────────────┘                         │
│                                                                                     │
│  BLOCO OPERACAO                    BLOCO ACAO                                      │
│  ┌─────────────────────┐           ┌─────────────────────┐                         │
│  │ ○ MULTIPLICAR       │           │ ○ CREDITAR          │                         │
│  │ ┌─────────────────┐ │           │                     │                         │
│  │ │ [Valor Venda] ○ │ │           │ Destino: Conta      │                         │
│  │ │      ×          │ │           │ Valor: [entrada]    │                         │
│  │ │ [  8  ] %    ○  │ │           │                     │                         │
│  │ └─────────────────┘ │           │ Notificar: [ ]      │                         │
│  │                   ● │           └─────────────────────┘                         │
│  └─────────────────────┘                                                           │
│                                                                                     │
│  LEGENDA:                                                                           │
│  ○ = Entrada (recebe conexao)                                                      │
│  ● = Saida (envia conexao)                                                         │
│                                                                                     │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

---

## Regras de Negocio

| Codigo | Regra | Validacao |
|--------|-------|-----------|
| RN-MTR-030 | Conexao valida | Saida numerica so conecta com entrada numerica |
| RN-MTR-031 | Fluxo completo | Regra deve ter pelo menos: variavel → operacao → acao |
| RN-MTR-032 | Sem loops | Sistema impede conexoes circulares |
| RN-MTR-033 | Bloco inicio | Toda regra deve ter um ponto de inicio |
| RN-MTR-034 | Formula gerada | Sistema gera formula valida do fluxo visual |

---

## Tecnologias Sugeridas

| Componente | Opcoes |
|------------|--------|
| Editor Drag-and-Drop | React Flow, Rete.js, GoJS |
| Renderizacao | SVG com D3.js ou Canvas |
| Estado | Redux ou Zustand |
| Validacao | Custom + Jest |

---

## Cenarios de Teste

### CT-001: Arrastar Bloco

```gherkin
Dado que estou no editor visual
Quando arrasto bloco "Valor Venda" da paleta para o canvas
Entao bloco aparece no canvas
E bloco pode ser movido livremente
```

### CT-002: Conectar Blocos

```gherkin
Dado que tenho bloco VARIAVEL e bloco OPERACAO no canvas
Quando arrasto linha da saida do VARIAVEL para entrada do OPERACAO
Entao conexao e criada entre os blocos
E formula preview e atualizada
```

### CT-003: Gerar Formula

```gherkin
Dado que tenho fluxo visual completo
E fluxo tem VARIAVEL → CONDICAO → OPERACAO → ACAO
Quando visualizo formula gerada
Entao formula reflete logica do fluxo visual
E formula e sintaticamente valida
```

---

## Dependencias

- **Depende de**: US-CRM-MTR-001 (modelo de dados de regras)
- **Dependentes**: Nenhum (funcionalidade standalone)

---

## Estimativa

| Componente | Story Points |
|------------|-------------|
| Frontend: Canvas/Paleta | 13 |
| Frontend: Blocos arrastaveis | 8 |
| Frontend: Conexoes | 5 |
| Backend: Salvar layout | 3 |
| Backend: Gerar formula | 5 |
| **TOTAL** | **34** |

---

## Historico de Alteracoes

| Versao | Data | Autor | Alteracao |
|--------|------|-------|-----------|
| 1.0 | 29/01/2026 | PO | Criacao inicial |
