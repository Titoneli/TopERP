# Story Points — Explicação Completa

## O que é Story Points?

**Story Points** é uma unidade de medida usada em metodologias ágeis (principalmente Scrum) para **estimar a complexidade e o esforço necessário** para completar uma funcionalidade ou tarefa, ao invés de usar horas ou dias.

É uma estimativa **relativa**, não absoluta.

---

## Diferença: Story Points vs Horas

### Estimativa em Horas (Tradicional)
```
"Vou levar 40 horas para fazer essa funcionalidade"

Problemas:
- Muito precisa (normalmente errada)
- Cansaço afeta o tempo real
- Interrupções não são contabilizadas
- Cada pessoa trabalha em ritmo diferente
```

### Estimativa em Story Points (Ágil)
```
"Essa funcionalidade é 13 vezes mais complexa que uma funcionalidade simples"

Vantagens:
- Reconhece incerteza
- Relativa (comparativa)
- Menos dependente de quem faz
- Mais realista
```

---

## Escala de Story Points Comum

A maioria das equipes usa a **sequência de Fibonacci** ou variações:

```
1 → Muito simples
2 → Simples
3 → Simples/Médio
5 → Médio
8 → Complexo
13 → Muito Complexo
21 → Extremamente Complexo
```

**Por que Fibonacci?**
- Intervalos aumentam exponencialmente
- Reflete melhor a incerteza em tarefas maiores
- Força discussões entre estimativas próximas (8 vs 13)

---

## Como Story Points Funciona na Prática

### 1. Exemplo de Comparação (Baseline)

Suponha que sua equipe já completou essas histórias:

| História | Descrição | Story Points Reais |
|----------|-----------|-------------------|
| US-001 | Login simples | 2 SP |
| US-002 | Dashboard com 3 gráficos | 5 SP |
| US-003 | API com 5 endpoints | 8 SP |

### 2. Estimando uma Nova História

**Nova História:** "Captação de Lead via Landing Page (US-CRM-LED-001)"

**Análise:**
- Formulário com validações
- Integração com 2 APIs (FIPE + IBGE)
- Validação contra blacklist
- Captura de parâmetros URL
- 3 etapas sequenciais
- 8 cenários de teste
- Tratamento de erros

**Comparação:**
- É mais complexo que US-002 (5 SP) ✓
- É mais complexo que US-003 (8 SP) ✓
- É menos complexo que um sistema inteiro (21+ SP) ✓

**Estimativa Final:** 13 Story Points

---

## Por que US-CRM-LED-001 = 13 Story Points?

### Fatores que Aumentam a Complexidade

#### 1. Múltiplas Integrações (2 APIs)
- API FIPE (marcas/modelos/anos de veículos)
- API IBGE (estados/cidades)
```
Cada integração = +2 a 3 SP
Duas integrações = ~4-6 SP adicional
```

#### 2. Formulário Multi-Etapa (3 Etapas)
- Etapa 1: Captura de contato
- Etapa 2: Dados do veículo
- Etapa 3: Localização

Cada etapa requer:
- Validações específicas
- Salvamento parcial
- Controle de estado
- Transições
```
3 etapas = ~3-4 SP
```

#### 3. Regras de Negócio Complexas
- Validação contra blacklist de consultores
- Extração de DDD
- Captura de parâmetros URL (cod_origem, cod_colaborador, UTM)
- Lógica condicional de atribuição

```
Cada regra complexa = +1 SP
4 regras principais = ~4 SP
```

#### 4. Cenários de Teste (8 Cenários BDD)
- Requer testes para cada caminho
- Testes de erro/sucesso
- Validações especiais

```
8 cenários = ~2-3 SP
```

#### 5. Tratamento de Erros e Edge Cases
- Telefone bloqueado
- Parâmetros inválidos
- Campos vazios
- Erros de API

```
Edge cases = ~1-2 SP
```

### Cálculo Aproximado
```
Base (formulário simples): 3 SP
+ Integração FIPE: 2 SP
+ Integração IBGE: 2 SP
+ Regras de negócio: 3 SP
+ Validações especiais: 2 SP
+ Testes e QA: 1 SP
─────────────────────────
Total: 13 SP
```

---

## O que Realmente 13 Story Points Significa?

### Na Linguagem da Equipe

"13 Story Points significa que essa funcionalidade é aproximadamente:"

```
□ 6-7 vezes mais complexa que uma tarefa de 2 SP
□ 2-3 vezes mais complexa que uma tarefa de 5 SP
□ 1,6 vezes mais complexa que uma tarefa de 8 SP
□ Demanda esforço significativo de desenvolvimento
□ Requer coordenação e testes rigorosos
□ Pode ser completada por 1 desenvolvedor em 2-3 sprints (2 semanas cada)
```

### Duração Aproximada

Se sua equipe trabalha com **2 semanas por Sprint** (10 dias úteis):

```
Velocidade Média da Equipe: 40 SP por Sprint

13 SP ≈ 3-4 dias de trabalho de UM desenvolvedor

OU

≈ 25-30% de um Sprint para 1 desenvolvedor
```

---

## Como a Equipe Usa Story Points

### 1. Planning (Planejamento)
```
Sprint Duration: 2 semanas
Target Velocity: 40 SP

Histórias Disponíveis:
- US-CRM-LED-001: 13 SP ← Esta
- US-CRM-LED-003: 13 SP
- US-CRM-AUTH-001: 5 SP
- US-CRM-DASH-001: 21 SP

Decisão:
"Vamos fazer US-CRM-LED-001 (13 SP) + US-CRM-LED-003 (13 SP) 
+ US-CRM-AUTH-001 (5 SP) neste sprint = 26 SP"

Restam 14 SP de capacidade para tarefas extras/bugs.
```

### 2. Tracking (Acompanhamento)
```
Dia 1: US-CRM-LED-001 iniciada (13 SP em progresso)
Dia 4: Testes começam (ainda em progresso)
Dia 7: US-CRM-LED-001 COMPLETA (13 SP concluídos)

Burn-down (Progressão):
Sprint Capacity: 40 SP
Dia 1: 40 - 0 = 40 SP restantes
Dia 7: 40 - 13 = 27 SP restantes
```

### 3. Metrics (Métricas)
```
Velocity (Velocidade):
Sprint 1: 35 SP completados
Sprint 2: 38 SP completados
Sprint 3: 42 SP completados
Sprint 4: 41 SP completados
Média: 39 SP por Sprint

Próximo Sprint pode planejar: ~39 SP de histórias
```

---

## Diferença: 13 SP vs Outras Estimativas

### Comparativo na Mesma Equipe

| Tarefa  | Complexity  | Story Points | Dias Aprox | Exemplo |
|-------- |-----------  |--------------|----------- |---------|
| Simples | Baixa       | 1-2          | 0,5-1      | Corrigir typo, ajustar CSS |
| Pequena | Baixa-Média | 3-5          | 1-2        | Login básico, form simples |
| Média   | Média       | 8            | 2-3        | CRUD com validações |
| Grande  | Média-Alta  | **13**       | **3-4**    | **US-CRM-LED-001 (Esta)** |
| XL      | Alta        | 21           | 5-7        | Dashboard completo com 10+ gráficos |
| XXL     | Muito Alta  | 34+          | 8+         | Refatoração de legacy ou integração complexa |

---

## Por que não Usar Horas Diretamente?

### Problema 1: Imprecisão
```
Dev A: "Levo 40 horas"
Dev B: "Levo 60 horas" (mesmo projeto, pessoas diferentes)

Qual está certo? Ninguém sabe até fazer.
```

### Problema 2: Incerteza
```
"Se alguém cair doente, meu estimado de 40h se torna 60h"
"Se houver mudança de requisito, 40h vira 80h"

Story Points absorve essa incerteza naturalmente.
```

### Problema 3: Velocidade Variável
```
Hora 1: Pessoa alerta, produz muito
Hora 8: Pessoa cansada, produz pouco
Hora 40: Síndrome de segunda-feira, produz ainda menos

1 SP no dia 1 ≠ 1 SP no dia 8
Mas a complexidade é sempre a mesma.
```

### Problema 4: Contexto Diferente
```
Dev Junior demoraria 60 horas
Dev Senior demoraria 20 horas
Dev Arquiteto demoraria 15 horas

Qual usar? Story Points ignora isso:
"É complexo = 13 SP, independente de quem faz"
```

---

## Exemplo Prático: US-CRM-LED-001 em Ação

### Cenário 1: Planning do Sprint 1

```
Time tem capacidade de 40 SP

Histórias disponíveis:
1. US-CRM-LED-001 (13 SP) ← Esta
2. US-CRM-CONS-005 (5 SP) - Validar Consultor
3. US-CRM-AUT-002 (8 SP) - Two-Factor Authentication
4. US-CRM-NOTI-001 (21 SP) - Sistema de Notificações

Decisão do PO:
"Vamos fazer: US-CRM-LED-001 (13) + US-CRM-CONS-005 (5) 
+ US-CRM-AUT-002 (8) = 26 SP no Sprint"

Por quê?
- US-CRM-LED-001 e US-CRM-CONS-005 são dependência de tudo
- US-CRM-AUT-002 é importante para segurança
- US-CRM-NOTI-001 (21 SP) é muito grande, deixa para próximo sprint
```

### Cenário 2: Durante o Sprint

```
Dia 1 (Segunda):
- Dev A começa US-CRM-LED-001
- Dev B começa US-CRM-CONS-005
- Dev C começa US-CRM-AUT-002

Dia 3 (Quarta):
- Dev A achei um problema: "IBGE API está retornando dados diferentes"
  Story Points muda? NÃO! Continua 13 SP.
  Por quê? Porque era incerteza conhecida, está sendo resolvido agora.

Dia 7 (Próxima Segunda):
- Dev A completa US-CRM-LED-001 (13 SP Done)
- Dev B completa US-CRM-CONS-005 (5 SP Done)
- Dev C está 80% em US-CRM-AUT-002 (8 SP, 80% progresso)

Total alcançado: 13 + 5 = 18 SP completos
Previsão: +6.4 SP na próxima segunda (80% de 8 SP)
```

### Cenário 3: Retrospectiva do Sprint

```
Sprint 1 Resultado:
- Planejado: 26 SP
- Alcançado: 24 SP (92% - Dev A foi de férias 2 dias)
- Completed Stories: 3 (LED-001, CONS-005, AUT-002)

Velocity: 24 SP completados

Sprint 2 Planning:
PO: "Nossa velocity é 24 SP, então esse sprint 
     vou planejar ~24 SP de histórias também"

Histórias selecionadas:
- US-CRM-DASH-001 (21 SP)
- US-CRM-VALID-001 (3 SP)
= 24 SP (match perfeito com velocity)
```

---

## Comparação Rápida: 13 SP em Diferentes Contextos

### Equipe A (Experiente, Produtiva)
```
Velocity: 50 SP/Sprint

13 SP = 26% do Sprint
     = Aproximadamente 2-3 dias de trabalho
     = Prioridade Alta (cabe num Sprint)
```

### Equipe B (Iniciante)
```
Velocity: 20 SP/Sprint

13 SP = 65% do Sprint
     = Aproximadamente 5 dias de trabalho
     = Praticamente um Sprint inteiro
```

### Equipe C (Corporativa)
```
Velocity: 35 SP/Sprint

13 SP = 37% do Sprint
     = Aproximadamente 3-4 dias de trabalho
     = Tamanho médio-grande
```

**Conclusão:** 13 SP é "grande" para qualquer equipe, mas proporcional.

---

## Resumo Executivo

| Aspecto | Explicação |
|---------|-----------|
| **O que é** | Medida relativa de complexidade e esforço |
| **Unidade** | Story Points (SP) |
| **Escala** | Fibonacci: 1, 2, 3, 5, 8, 13, 21, 34... |
| **13 SP significa** | Funcionalidade complexa, requer 3-4 dias para 1 dev |
| **Não significa** | Exatamente 40 horas ou 3 dias específicos |
| **Por quê 13 em LED-001** | 3 APIs, 3 etapas, validações, 8 cenários teste, regras negócio |
| **Usado para** | Planejamento de sprints, previsão, tracking |
| **Vantagem** | Absorve incerteza, independente de pessoa, velocidade |

---

## Criado por: Gustavo Titoneli (Product Owner TopERP)
## Data: 21/01/2026
## Referência: US-CRM-LED-001 = 13 Story Points
