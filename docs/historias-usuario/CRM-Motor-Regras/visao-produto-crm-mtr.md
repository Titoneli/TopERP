# Motor de Regras - O que é e para que serve?

> **Documento para todos** - Escrito para que qualquer pessoa entenda.  
> Versão 2.0 | 29/01/2026

---

## Em uma frase

O Motor de Regras é uma **ferramenta que calcula comissões, bônus e premiações automaticamente**, sem precisar de programador.

---

## O problema que resolve

**Antes do Motor de Regras:**
- Cada cálculo de comissão estava "travado" no código
- Para mudar de 5% para 8%, precisava chamar o desenvolvedor
- Demorava dias ou semanas para alterar uma regra simples
- Ninguém sabia exatamente como o cálculo era feito

**Com o Motor de Regras:**
- Você mesmo configura as regras pela tela
- Mudanças em minutos, não em semanas
- Todo cálculo fica registrado e pode ser auditado
- Transparência total para a equipe comercial

---

## O que ele pode calcular?

| Tipo | Exemplo |
|------|---------|
| **Comissão** | "8% sobre o valor da venda" |
| **Bônus por meta** | "R$ 500 se bater a meta do mês" |
| **Residual** | "R$ 2 por placa ativa na carteira" |
| **Bônus especial** | "R$ 800 para cada 10% acima da meta" |
| **Comissão de gerente** | "2% sobre vendas da equipe" |
| **Campanha** | "+R$ 50 por venda do Plano X em Janeiro" |
| **Desconto** | "15% de desconto se pagar à vista" |
| **Score de lead** | "Pontuação automática para priorizar atendimento" |

---

## Como funciona na prática?

### Exemplo 1: Comissão simples

**Situação:** João vendeu um plano de R$ 500. Quanto ele ganha?

**Regra configurada:**
- SE o plano for Premium → comissão de 8%

**Cálculo automático:**
- R$ 500 × 8% = **R$ 40,00 de comissão**

---

### Exemplo 2: Bônus por meta

**Situação:** Maria tem meta de 10 vendas. Ela fez 12.

**Regra configurada:**
- SE vendas >= meta → ganha R$ 500 de bônus

**Resultado:**
- 12 vendas ≥ 10 (meta) → **R$ 500,00 de bônus**

---

### Exemplo 3: Bônus progressivo (a regra complexa)

**Situação:** "Para cada 10% que o consultor vender ACIMA da meta em automóveis de SP até R$ 50 mil, pagar R$ 800."

**Como o Motor resolve isso:**
1. Conta quantas placas o consultor fechou no mês
2. Filtra apenas: automóveis + SP + valor até R$ 50k
3. Compara com a meta dele
4. Calcula quanto ficou acima (em %)
5. Para cada faixa de 10%, paga R$ 800

**Exemplo numérico:**
- Carlos fechou 15 placas (SP, auto, até 50k)
- Meta dele era 10
- Ficou 50% acima da meta (5 placas a mais)
- São 5 faixas de 10%
- **Bônus: 5 × R$ 800 = R$ 4.000,00**

---

### Exemplo 4: Residual sobre boletos

**Situação:** "Se a carteira do consultor pagar mais de R$ 100 mil em boletos no mês, ele ganha 15% de residual."

**Como o Motor resolve:**
1. Soma todos os boletos PAGOS da carteira do consultor no mês
2. SE soma > R$ 100.000 → paga 15%

**Exemplo numérico:**
- Boletos pagos da carteira: R$ 150.000
- 150 mil > 100 mil? SIM
- **Residual: R$ 150.000 × 15% = R$ 22.500,00**

---

## Onde é usado?

| Área | Para que usa |
|------|--------------|
| **Financeiro** | Calcular comissões, residuais, bônus |
| **Comercial** | Definir metas e premiações |
| **Marketing** | Criar campanhas com incentivos |
| **RH/Gestão** | Configurar PLR e reconhecimentos |
| **Atendimento** | Priorizar leads automaticamente |

---

## Como criar uma regra?

Existem 3 formas, da mais fácil à mais avançada:

### 1. Usar um modelo pronto ⭐ Mais fácil

Escolha um template e preencha os valores:

| Template | Quando usar |
|----------|-------------|
| Comissão Simples | Percentual fixo sobre venda |
| Bônus por Meta | Valor fixo ao atingir meta |
| Comissão Escalonada | Percentual aumenta por faixa |
| Residual por Placa | Valor fixo por placa ativa |
| Campanha | Bônus por período/produto |
| Override (Gerente) | Comissão sobre equipe |

### 2. Editor visual (arrastar blocos)

Para quem prefere montar visualmente:
- Arraste blocos de "dados", "condições" e "ações"
- Conecte os blocos
- Configure os valores
- Pronto!

### 3. Escrever em texto (para regras complexas)

Para regras muito específicas, use palavras em português:

```
REGRA "Bônus SP Automóvel"

VARIÁVEIS
  placas = CONTAR placas ONDE estado = "SP" E tipo = "automóvel"
  meta = BUSCAR meta do consultor

QUANDO
  placas > meta

ENTÃO
  CREDITAR bônus calculado

FIM
```

---

## O que acontece quando uma regra roda?

1. **Busca os dados** - Vai no sistema e pega as informações
2. **Faz os cálculos** - Aplica as fórmulas configuradas
3. **Verifica condições** - Checa se deve aplicar a regra
4. **Executa a ação** - Credita o valor, envia aviso, etc.
5. **Registra tudo** - Guarda histórico para auditoria

---

## Posso testar antes de ativar?

**SIM!** O simulador permite:

- Testar com dados reais de um consultor
- Testar com dados que você digita
- Ver passo a passo como o cálculo foi feito
- Comparar versões diferentes da regra

---

## E se a regra der errado?

- **Desativa** a regra com um clique
- **Volta** para a versão anterior
- **Histórico completo** de todas as alterações
- **Auditoria** de quem mudou o quê

---

## Resumo dos benefícios

| Antes | Depois |
|-------|--------|
| Semanas para mudar | Minutos |
| Depende de TI | Negócio configura |
| Cálculo no escuro | Transparência total |
| Sem registro | Auditoria completa |
| Regras limitadas | Qualquer regra |

---

## Perguntas frequentes

**"Preciso saber programar?"**  
Não. Use os templates prontos ou o editor visual.

**"Quem pode criar regras?"**  
Quem tiver permissão. Normalmente gestores e analistas.

**"Toda regra precisa de aprovação?"**  
Sim. Uma pessoa cria, outra aprova antes de ativar.

**"Consigo ver como foi calculada a comissão do João?"**  
Sim. Todo cálculo fica registrado com todos os detalhes.

**"Dá para fazer regras muito complexas?"**  
Sim. Desde "8% fixo" até combinações elaboradas como o exemplo 3.

**"E se eu errar?"**  
Teste antes no simulador. Se algo passar, desativa e volta a versão anterior.

---

## Exemplos de regras suportadas

✅ Comissão de 8% sobre vendas  
✅ Bônus de R$ 500 ao bater meta  
✅ R$ 2,00 por placa ativa (residual)  
✅ Comissão escalonada (5%, 7%, 9%, 12% por faixa)  
✅ Bônus de campanha por período  
✅ Override de 2% para gerentes  
✅ Divisão de comissão entre 2 consultores  
✅ R$ 800 para cada 10% acima da meta  
✅ 15% de residual se carteira > R$ 100k  
✅ Pontuação automática de leads  
✅ Regras combinadas (meta + região + tipo)  
✅ Qualquer combinação das anteriores  

---

## Quer saber mais?

Para detalhes técnicos, consulte:
- [EXEMPLOS-REGRAS-COMPLEXAS.md](EXEMPLOS-REGRAS-COMPLEXAS.md) - Exemplos práticos
- [ESPECIFICACAO-DSL.md](ESPECIFICACAO-DSL.md) - Linguagem de regras
- [README.md](README.md) - Documentação técnica

---

> **Sugestões?** Este documento é vivo. Ajude a melhorá-lo!
