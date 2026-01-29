# Módulo Financeiro do Consultor (CRM-FIN)

**Guia Completo de Funcionamento**

| Informação | Valor |
|------------|-------|
| Versão | 2.2 |
| Data | 29/01/2026 |
| Funcionalidades | 63 |

---

## O que é este módulo?

O **Módulo Financeiro do Consultor** é a parte do sistema responsável por cuidar de todo o dinheiro que os consultores ganham com suas vendas. Desde o momento em que uma venda é fechada até o dinheiro cair na conta do consultor, este módulo controla tudo.

Pense nele como um "banco interno", que será chamado ContaTop, para os consultores: ele guarda os valores, emite nota fiscal, faz os pagamentos via PIX e mantém todo o histórico organizado. A emissão da nota fiscal ocorre através da integração o sistema contábil, para os consultores que aderirem ao serviço de contabilidade virtual, integrada ao CRM.

---

## Os Dois Tipos de Ganhos do Consultor

O consultor recebe dinheiro de **duas formas diferentes**, e cada uma tem seu próprio fluxo:

### COMISSÃO (sobre Valor da Adesão)

**O que é?**  
É o valor que o consultor ganha quando fecha uma venda. É calculado sobre o **Valor da Adesão** que o cliente paga para entrar no plano.

**Quando fica disponível?**  
Assim que o cliente paga a adesão e o sistema confirma a baixa do pagamento.

**Como sacar?**  
O consultor pode sacar **a qualquer momento** que quiser ou precisar. É só solicitar pelo sistema ou app.

**Exemplo:**  
- João fecha uma venda com adesão de R$ 300,00
- O cliente paga
- O sistema credita R$ 300,00 na conta do João
- João pode sacar esse valor quando quiser

---

### RESIDUAL (sobre Mensalidades Recebidas)

**O que é?**  
É o valor variável que o consultor ganha todo mês, calculado com base nas **mensalidades pagas pelos clientes** da sua carteira. O valor é definido pelo Motor de Regras da empresa.

**Quando fica disponível?**  
Os valores são calculados mensalmente com base em todas as mensalidades recebidas dos clientes que o consultor trouxe.

**Como sacar?**  
O fluxo do residual é **diferente e mais controlado**:

1. **Sistema gera o demonstrativo** — Todo mês, o sistema calcula os residuais e gera um demonstrativo financeiro
2. **Consultor confere** — O consultor acessa o demonstrativo financeiro analítico/sintético no App ou no sistema web
3. **Consultor confirma** — Após conferir o demonstrativo financeiro, o consultor clica em "Confirmar valores"
4. **NF é emitida automaticamente** — Só após a confirmação, o sistema emite a nota fiscal
5. **Solicitação de pagamento** — O sistema abre automaticamente uma solicitação no financeiro
6. **Ordem de pagamento** — O financeiro processa a ordem de pagamento
7. **PIX é realizado** — O valor cai na conta do consultor

**Importante:** O consultor **não pode sacar o residual a qualquer momento**. Ele precisa primeiro conferir e confirmar o demonstrativo.

**Exemplo:**  
- João tem 50 clientes na carteira
- Em janeiro, 45 clientes pagaram a mensalidade (total R$ 22.500)
- O sistema calcula: João ganha 1% = R$ 225,00 de residual
- João acessa o demonstrativo e confere cada valor
- João clica em "Confirmar que os valores estão corretos"
- Sistema emite a NF automaticamente
- Sistema abre solicitação de pagamento
- João recebe o PIX alguns dias depois ou na mesma hora, dependendo do banco

---

## Comparativo: Comissão vs Residual

| Característica | COMISSÃO | RESIDUAL |
|----------------|----------|----------|
| **Base de cálculo** | Valor da Adesão | Mensalidades recebidas |
| **Frequência** | Por venda | Mensal |
| **Disponibilidade** | Imediata (após baixa) | Após conferência do demonstrativo |
| **Pode sacar quando quiser?** | Sim | Não, precisa confirmar primeiro |
| **Precisa confirmar valores?** | Não | Sim, obrigatório |
| **NF emitida quando?** | No momento do saque | Após confirmação |
| **Contestação** | Pode contestar depois | Contesta antes de confirmar |

---

## Como funciona na prática?

### A Jornada do Dinheiro (do início ao fim)

Imagine que um consultor chamado João acabou de fechar uma venda de um plano de proteção veicular. Veja o que acontece com os dois tipos de ganho:

---

### FLUXO DA COMISSÃO (Adesão)

**1. A Venda é Fechada**
- João fecha uma proposta de um plano Ouro
- Valor da mensalidade: R$ 500,00
- Valor da adesão: R$ 300,00

**2. Cliente Paga a Adesão**
- O cliente faz o pagamento da adesão
- O sistema confirma a baixa do pagamento

**3. Comissão é Creditada**
- O sistema credita R$ 300,00 na conta virtual do João (conta de comissões)
- João recebe notificação: "Você recebeu R$ 300,00 de comissão!"

**4. João Pode Sacar Quando Quiser**
- João acessa o sistema ou app
- Vê que tem R$ 300,00 disponíveis em comissões
- Pode sacar agora, amanhã, ou quando precisar
- Não precisa esperar ninguém aprovar

**5. Processo de Saque (quando João decidir)**
- João clica em "Sacar"
- Sistema emite a NF automaticamente
- Sistema abre ordem de pagamento
- PIX cai na conta do João

---

### FLUXO DO RESIDUAL (Mensalidades)

**1. Mês se Passa, Clientes Pagam Mensalidades**
- João tem 50 clientes na carteira
- Durante janeiro, 45 clientes pagaram suas mensalidades
- Total de mensalidades: R$ 22.500,00

**2. Sistema Calcula os Residuais**
- No fechamento do período (ex: dia 5 de fevereiro)
- Sistema aplica as regras do Motor de Regras
- Calcula: João ganha 1% sobre mensalidades = R$ 225,00

**3. Demonstrativo é Gerado**
- Sistema gera o demonstrativo financeiro do João
- Lista cada cliente, cada mensalidade, cada cálculo
- Envia notificação: "Seu demonstrativo de janeiro está disponível"

**4. João Confere o Demonstrativo**
- João acessa o App do Consultor ou o sistema web
- Vê a lista completa: qual cliente pagou, quanto, qual o residual
- Confere se está tudo certo
- Se tiver dúvida, pode contestar antes de confirmar
- João tem até o dia 20 de fevereiro para acessar e confirmar o demonstrativo

**5. João Confirma os Valores**
- Após conferir tudo, João clica em "Confirmar valores"
- Isso significa: "Li, conferi e concordo com os valores"
- **Só após essa confirmação o processo continua**

**6. Sistema Emite NF Automaticamente**
- Imediatamente após a confirmação
- NF é gerada e enviada para João
- XML e PDF ficam disponíveis no sistema

**7. Solicitação de Pagamento**
- Sistema abre automaticamente uma solicitação no financeiro
- Anexa a NF e todos os documentos

**8. Ordem de Pagamento é Processada**
- Financeiro recebe a solicitação
- Processa a ordem de pagamento no MGF/Sankhya e banco digital "ContaTop"

**9. PIX é Realizado**
- Valor é transferido para a conta do João
- João recebe notificação: "Seu residual de R$ 225,00 foi pago!"
- Comprovante fica disponíveis no sistema


**10. Registro Contábil**
- Sistema gera os lançamentos automaticamente na contabilidade virtual
- Registros são analisados e processados pela contabilidade
- Obrigações fiscais são geradas e enviadas para o consulto
- Consultor autoriza o pagamento diretamente na conta virtual no banco digital "ContaTop"ou efetua os pagamettos como preferir
---

## A Conta Virtual do Consultor

Todo consultor tem **duas áreas separadas** na sua conta virtual:

### Saldo de Comissões
- Valores das adesões recebidas
- Pode sacar a qualquer momento
- Extrato próprio de comissões

### Saldo de Residuais
- Valores das mensalidades (após conferência)
- Só libera após confirmar demonstrativo
- Extrato próprio de residuais

**Na tela principal, o consultor vê:**
```
┌─────────────────────────────────────────┐
│         MINHA CONTA FINANCEIRA          │
├─────────────────────────────────────────┤
│                                         │
│   COMISSÕES DISPONÍVEIS                 │
│   R$ 1.250,00                           │
│   [Sacar Agora]                         │
│                                         │
├─────────────────────────────────────────┤
│                                         │
│   RESIDUAIS                             │
│   R$ 450,00 (pendente confirmação)      │
│   [Ver Demonstrativo]                   │
│                                         │
│   R$ 225,00 (confirmado, aguardando)    │
│   Status: Processando pagamento         │
│                                         │
└─────────────────────────────────────────┘
```

---

## As Funcionalidades em Detalhes

### Parte 1: A Conta do Consultor

Todo consultor tem uma "conta virtual" no sistema, dividida em **duas áreas**:

#### Área de Comissões (Adesões)
- Recebe os valores das adesões automaticamente
- Consultor pode sacar a qualquer momento
- Não precisa de aprovação prévia

#### Área de Residuais (Mensalidades)
- Recebe os valores calculados sobre mensalidades
- Consultor precisa conferir e confirmar o demonstrativo
- Só libera para pagamento após confirmação

**O que o consultor pode fazer:**

**Ver saldos separados** — O consultor vê claramente quanto tem de comissões (pode sacar agora) e quanto tem de residuais (precisa confirmar).

**Consultar extratos por tipo** — Uma lista separada para cada tipo de recebimento, com data, valor e descriçáos.

**Solicitar saque de comissões** — A qualquer momento, o consultor pode sacar suas comissões. Total, parcial ou por período.

**Conferir demonstrativo de residuais** — Todo mês, o consultor acessa o demonstrativo, confere os valores e confirma.

**Receber créditos automaticamente** — Fechou a venda e cliente pagou a adesão? Comissão entra na conta. Mensalidade foi paga? Residual é calculado no fechamento do período.

---

### Parte 2: Notas Fiscais

Para pagar o consultor, a empresa precisa de nota fiscal. O sistema cuida de tudo:

**Emissão automática** — Quando o saque é aprovado, a nota fiscal é emitida automaticamente. Sem ninguém precisar digitar nada.

**Arquivamento seguro** — O XML (arquivo oficial) e o PDF (para visualização) ficam guardados no sistema. O consultor pode baixar a qualquer momento.

**Consulta fácil** — Uma lista de todas as notas emitidas, com filtros por período, valor, status.

**Cancelamento quando necessário** — Se algo deu errado, a nota pode ser cancelada (dentro do prazo legal) e o sistema cuida de todos os ajustes.

---

### Parte 3: Pagamentos

Depois da nota fiscal, vem o pagamento:

**Criação da ordem de pagamento** — O sistema gera automaticamente a ordem no sistema financeiro da empresa (MGF/Sankhya), já com a nota fiscal anexada.

**Pagamento via PIX** — O valor é transferido diretamente para a conta PIX do consultor. Rápido e sem taxas.

**Acompanhamento em tempo real** — O consultor vê em qual etapa está seu pagamento: "Aguardando NF", "Em processamento", "Pago".

**Notificação de conclusão** — Quando o PIX é efetivado, o consultor recebe uma notificação e pode ver o comprovante no sistema.

---

### Parte 4: Contabilidade

Para a empresa manter tudo em ordem:

**Lançamentos automáticos** — Cada nota fiscal gera automaticamente um lançamento no sistema contábil. Débito e crédito certinhos.

**Estorno quando necessário** — Se uma nota é cancelada, o lançamento contábil também é estornado automaticamente.

---

### Parte 5: Cancelamentos e Estornos

Quando uma venda é cancelada, o sistema cuida de desfazer tudo:

**Débito automático do consultor** — Se João ganhou R$ 40 de comissão e a venda foi cancelada, esse valor é debitado da conta dele.

**Devolução para o cliente** — Se o cliente pagou algo, o valor é devolvido via PIX automaticamente.

**Cancelamento completo** — Nota fiscal cancelada, ordem de pagamento estornada, lançamento contábil revertido.

**Aprovação de estornos** — Para todos os valores, um gestor precisa aprovar antes de processar. Isso evita erros.

---

### Parte 6: Motor de Regras de Comissão

Aqui é onde a mágica acontece. O sistema calcula automaticamente quanto cada consultor deve ganhar, baseado em regras configuráveis:

**Regras de comissão** — "Vendas do Plano Outro pagam 6%, Plano PLatinum paga 8%". O gestor configura, o sistema aplica. Cada consultor pode ter uma configuração ou regra especifica.

**Regras de residual** — "Para cada mensalidade que o cliente pagar, o consultor ganha 15%". Renda recorrente para o consultor.

**Bonificação por metas** — "Se vender 10 planos no mês, ganha R$ 200 de bônus". Incentivo para bater metas. Cada consultos pode ter uma regra especifica.

**Campanhas de premiação** — "Campanha de Verão: quem vender mais em fevereiro ganha uma viagem". Período específico com regras especiais. Cada consultor pode ter uma configuração ou regra especifica.

**Descontos de Ratreametno** — O sistema identifica de acordo com a região de venda e de acordo com a regra nas cotas de cada tabela, se um veículo necessita da instalacao do rastreador. Cada regional/região tem uma regra especifica, com valores a descontar por tipo de veiculo. Por exemplo: moto no ceara desconta 50,00, moto em SP desconta 100,00, carro em MG desconta R$ 150,00 por cada venda efetuada. O consultor recebe junto com a adesão, mas o sistema desconta dos residuais a receber.

**Simulação antes de ativar** — O gestor pode testar uma regra antes de colocar em produção. "Se eu mudar a comissão para 10%, quanto isso impactaria?"


**Clonagem ou replicação de regras** — O gestor pode Clonar uma regra de um consultor para outro ou replicar uma regra especifica para varios consultores

---

### Parte 7: Demonstrativos Financeiros e Conferência de Residuais

O demonstrativo é fundamental, especialmente para os **residuais**:

**Demonstrativo de Residuais Analíticos (mensal)** — Lista todos os clientes da carteira, quais pagaram, quanto pagou cada um, e quanto o consultor ganha de residual. **O consultor DEVE conferir e confirmar este demonstrativo para receber.**

**Demonstrativo de Residuais Sintéticos (mensal)** — Lista todos os valores a receber de forma agrupada. **O consultor DEVE conferir e confirmar este demonstrativo para receber.**

**Demonstrativo de Comissões** — Histórico de todas as comissões recebidas sobre adesões. Para consulta e controle.

**Conferência obrigatória** — Para residuais, o consultor precisa acessar o demonstrativo (no App ou sistema) e clicar em "Confirmar valores". Só depois disso o sistema emite a NF e libera o pagamento.

**Contestação de valores** — Se o consultor encontrar algo errado, pode contestar **antes de confirmar**. O gestor analisa e corrige se necessário.

**Prazo para conferência** — O consultor tem um prazo (configurável) para conferir. Se não conferir, o gestor é avisado.

**Envio automático** — O demonstrativo é enviado por whatsapp e push notification assim que fica disponível.

**Histórico completo** — Todos os demonstrativos ficam guardados. O consultor pode consultar meses anteriores a qualquer momento.

---

### Parte 8: Funcionalidades Avançadas

**Acesso pelo App** — O consultor pode ver seus saldos (comissões e residuais separados), conferir demonstrativos e confirmar valores pelo celular.

**Notificações push e whatsapp** — "Você recebeu R$ 300,00 de comissão!" ou "Seu demonstrativo de residuais está pronto para conferência!" direto no celular.

**Dashboard do gestor** — Visão consolidada: quanto a equipe ganhou de comissões, quanto de residuais, quem já confirmou demonstrativo, quem está pendente.

**Cálculo automático de residuais** — No fechamento do período, o sistema calcula automaticamente os residuais de todos os consultores com base nas mensalidades recebidas utilizando um motor de regras configuravel.

**Alertas de pendência** — Se um consultor não conferiu o demonstrativo em X dias, o gestor recebe um alerta.

**Exportação de relatórios** — Excel, PDF, CSV. Para quem precisa analisar os dados em outras ferramentas.

---

### Parte 9: Motor de Regras Avançado

**Incentivo Pontual** — "Essa semana, quem vender o Plano Ouro ganha R$ 50 extra por venda". Incentivos de curto prazo.

**Participação nos Resultados da Carteira** — Fórmulas complexas que consideram o resultado da carteira de clientes com base em cálculos atuariais e distribuem entre os consultores.

**Aceleradores** — "Quem bater 100% da meta ganha 1.2x na comissão, quem bater 120% ganha 1.5x". Quanto mais vende, mais ganha por venda.

**Comissão Escalonada** — "Até 5 vendas: 5%, de 6 a 10 vendas: 7%, acima de 10: 10%". Premia o alto volume.

**Comissão sobre Equipe** — "O gerente ganha 2% sobre tudo que sua equipe vender". Incentivo para formar e treinar o time.

**Divisão da Comissão** — "Essa venda foi feita por dois consultores, dividir a comissão 60/40". Para vendas em parceria.

**Modelos prontos** — Modelos de regras pré-configurados. O gestor escolhe um template e ajusta os valores.

**Editor visual** — Interface amigável para criar regras arrastando blocos, sem precisar saber programar.

---

### Parte 10: Gestão de Metas

Para acompanhar o desempenho dos consultores:

**Metas individuais** — Cada consultor tem sua meta. Com três níveis:
- *Minimo*: o mínimo aceitável
- *Objetivo*: o esperado
- *Extra*: a superação (bônus extra!)

**Metas de equipe** — A equipe do gerente João tem meta de 40 placas no mês. O sistema soma as propostas fechadas de todos.

**Metas compostas** — "Fechar 50 placas E ter NPS acima de 8 E reter 90% dos clientes". Múltiplos indicadores.

**Atingimento em tempo real** — O consultor vê na tela: "Você está em 75% da meta, faltam 10 placas".

**Projeção** — "No ritmo atual, você vai bater 110% da meta até o fim do mês". Ajuda no planejamento.

**Alertas de desvio** — Se o consultor está muito abaixo da meta na metade do mês, o sistema avisa o gestor.

---

### Parte 11: Portal de Transparência

O consultor precisa entender exatamente como sua comissão foi calculada:

**Detalhamento do cálculo** — "Placas 50: R$ 500,00. Comissão base (8%): R$ 40,00. Bônus plano Ouro: R$ 10,00. Acelerador 1.2x. Total: R$ 60,00".

**Simulador "E se..."** — O consultor digita: "Se eu fechar mais 3 placas no plano Ouro este mês..." e o sistema mostra quanto ele ganharia.

**Ranking da equipe** — "Você está em 3º lugar no ranking da sua regional". Gamificação saudável.

---

### Parte 12: Aceite Digital de Políticas

Para garantir que todos conhecem as regras:

**Publicação de políticas** — O gestor cria um documento explicando as regras de comissionamento e publica no sistema.

**Aceite com validade jurídica** — O consultor lê o documento e clica em "Li e aceito". O sistema registra tudo: data, hora, IP, para valer legalmente.

**Lembretes automáticos** — Se alguém não aceitou a política em 3 dias, recebe um lembrete via whatsapp e/ou pusj.

**Histórico completo** — "Fulano aceitou a Política v3 em 15/01/2026 às 14:32, do IP 192.168.1.1". Auditoria completa.

---

### Parte 13: Distribuição Hierárquica (Filiação)

Quando um novo associado é captado, o valor da adesão é dividido entre vários níveis da organização:

**Os 5 níveis fixos** — A estrutura é sempre a mesma, de baixo para cima:
1. **Vendedor** — o consultor que fez a venda
2. **Gerente** — o gestor da equipe do vendedor
3. **Cooperativa** — a unidade/filial
4. **Regional** — a coordenação regional
5. **Associação** — a matriz

**Como funciona a distribuição** — Imagine uma adesão de R$ 500:
- Vendedor recebe 8% = R$ 40 (comissão dele)
- Gerente recebe 1,5% = R$ 7,50 (repasse)
- Cooperativa recebe 0,5% = R$ 2,50 (repasse)
- Regional recebe 1% = R$ 5,00 (repasse)
- Associação recebe 2% = R$ 10,00 (repasse)
- Sobram 87% = R$ 435,00 → vai para o "destinatário do restante" (configurável)

**Configuração flexível** — O gestor define o percentual de cada nível. O sistema garante que a soma não passe de 100%.

**Comissão vs Repasse** — Para cada usuário, define-se se ele recebe como "Comissão" (vai para a conta dele) ou "Repasse" (passa para outro nível).

**Imutabilidade** — Depois que o pagamento é feito, os valores são travados. Ninguém pode alterar. Isso evita confusões.

**Relatórios por nível** — "Quanto a Regional Sul recebeu de repasses este mês?" O sistema mostra tudo consolidado.

---

## Sistemas que Conversam com este Módulo

Para funcionar completamente, o módulo se conecta com:

| Sistema | Para que serve |
|---------|----------------|
| **Banco Digital** | Executar os pagamentos PIX |
| **SEFAZ** | Emitir notas fiscais eletrônicas (NF-e) |
| **Prefeituras** | Emitir notas de serviço (NFS-e) |
| **MGF/Sankhya** | Criar ordens de pagamento no financeiro |
| **Sistema Contábil** | Registrar os lançamentos contábeis |
| **App do Consultor** | Mostrar saldos e notificações no celular |

---

## Regras Importantes

Algumas regras que o sistema sempre respeita:

**Para COMISSÕES (Adesões):**
- Valor disponível assim que cliente paga e sistema confirma a baixa
- Consultor pode sacar a qualquer momento
- Saldo mínimo de R$ 50,00 para saque
- Dados bancários e PIX cadastrados
- NF emitida no momento do saque

**Para RESIDUAIS (Mensalidades):**
- Calculado no fechamento do período (mensal)
- Consultor DEVE conferir o demonstrativo (App ou sistema)
- Consultor DEVE confirmar que valores estão corretos
- NF emitida SOMENTE após confirmação do consultor
- Se não conferir, pagamento não é processado
- Pode contestar ANTES de confirmar

**Para notas fiscais:**
- MEI e autônomo emitem NFS-e
- Empresas emitem NF-e
- Cancelamento até 24h (NF-e) ou conforme regra municipal (NFS-e)

**Para estornos:**
- Cancelou a venda = estorno automático na conta de comissões
- Estornos acima de R$ 500 precisam de aprovação
- Cliente recebe devolução via PIX

**Para metas:**
- Sempre três níveis: floor < target < stretch
- Se o consultor está muito abaixo na metade do mês, gestor é avisado

**Para distribuição hierárquica:**
- Soma dos percentuais nunca pode passar de 100%
- Depois do pagamento, valores não mudam mais
- Não pode transferir saldo entre pessoas

---

## Métricas de Sucesso

Como sabemos se o módulo está funcionando bem:

| O que medimos | Meta |
|---------------|------|
| Tempo do saque até o PIX cair | Menos de 24 horas |
| Notas fiscais emitidas sem erro | Mais de 98% |
| PIX efetivados com sucesso | Mais de 99% |
| Taxa de estornos | Menos de 5% |
| Consultores que batem a meta | Mais de 70% |
| Políticas aceitas no prazo | Mais de 95% |

---

## Resumo Geral

Este módulo é essencial para manter os consultores motivados e pagos corretamente. Ele automatiza todo o processo que antes era manual:

**Para COMISSÕES (Adesões):**
- Credita automaticamente quando cliente paga
- Consultor saca quando quiser
- NF emitida no momento do saque
- PIX em menos de 24h

**Para RESIDUAIS (Mensalidades):**
- Calcula automaticamente no fechamento do período
- Gera demonstrativo detalhado para conferência
- Consultor confere e confirma pelo App/Sistema
- NF emitida automaticamente após confirmação
- Pagamento processado sem intervenção manual

**Para ambos:**
- Mantém histórico completo para auditoria
- Oferece transparência total para o consultor
- Permite regras flexíveis de comissionamento
- Distribui valores corretamente em estruturas hierárquicas

**Total: 63 funcionalidades que transformam um processo manual e propenso a erros em algo totalmente automatizado, transparente e confiável.**

---

## Histórico de Versões

| Versão | Data | O que mudou |
|--------|------|-------------|
| 1.0 | 29/01/2026 | Versão inicial com conta, NF, pagamento e motor básico |
| 2.0 | 29/01/2026 | Adicionado motor avançado, metas, transparência e políticas |
| 2.1 | 29/01/2026 | Adicionada distribuição hierárquica (filiação) |
| 2.2 | 29/01/2026 | Separação clara entre Comissões (adesão) e Residuais (mensalidade) |

---

*Documento elaborado pelo Product Owner — CRM*  
*Última atualização: 29/01/2026*
