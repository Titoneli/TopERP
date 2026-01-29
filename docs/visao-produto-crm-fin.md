# Módulo Financeiro do Consultor (CRM-FIN)

**Guia Completo de Funcionamento**

| Informação | Valor |
|------------|-------|
| Versão | 2.1 |
| Data | 29/01/2026 |
| Funcionalidades | 63 |

---

## O que é este módulo?

O **Módulo Financeiro do Consultor** é a parte do sistema responsável por cuidar de todo o dinheiro que os consultores ganham com suas vendas. Desde o momento em que uma venda é fechada até o dinheiro cair na conta do consultor, este módulo controla tudo.

Pense nele como um "banco interno" da empresa para os consultores: ele guarda os valores, emite nota fiscal, faz os pagamentos via PIX e mantém todo o histórico organizado.

---

## Como funciona na prática?

### A Jornada do Dinheiro (do início ao fim)

Imagine que um consultor chamado João acabou de fechar uma venda de um plano de proteção veicular. Veja o que acontece com o dinheiro dele:

**1. A Venda é Concretizada**
- João fecha a proposta de um plano Ouro no valor de mensalidade de R$ 500,00 e o valor de adesão de R$ 300,00
- O valor da adesão, caso tenha sido recebido dentro do CRM, será creditado na "conta virtual" do João dentro do sistema quando o associado efetuar o pagamento.
- João receberá uma notificação: "Você ganhou R$ 300,00 de comissão!"
- Sobre o valor da mensalidade, o sistema automaticamente calcula quanto João vai ganhar de comissão (digamos, 8% = R$ 40,00)
- Esse valor será creditado na "conta virtual" do João dentro do sistema quando o associado efetuar o pagamento da primeira mensalidade.
- João receberá uma notificação: "Você ganhou R$ 40,00 de residual!"

**2. O Dinheiro Fica Disponível**
- João pode acessar o sistema a qualquer momento e ver seu saldo
- Ele vê um extrato com todas as entradas: comissões, bonificações, residuais
- O saldo vai acumulando conforme João faz mais vendas

**3. João Decide Sacar**
- Quando João quer receber o dinheiro, ele solicita um saque
- Ele pode sacar tudo, um valor específico, ou apenas o que ganhou em um período
- O sistema verifica se está tudo certo (dados bancários, documentos, etc.)

**4. Nota Fiscal é Emitida**
- Automaticamente, o sistema emite a nota fiscal de serviço
- Se João é MEI, sai uma NFS-e; se é empresa, sai uma NF-e
- O XML e PDF ficam guardados para João consultar quando quiser
- 

**5. O Pagamento é Processado**
- O sistema cria uma ordem de pagamento no financeiro da empresa
- O valor é transferido via PIX para a conta do João
- João recebe o comprovante e uma notificação de que o dinheiro caiu

**6. Tudo Fica Registrado**
- João pode ver todo o histórico: quando vendeu, quanto ganhou, quando sacou
- Se precisar, pode baixar demonstrativos e relatórios
- A contabilidade da empresa também recebe os lançamentos automaticamente

---

## As Funcionalidades em Detalhes

### Parte 1: A Conta do Consultor

Todo consultor tem uma "conta virtual" no sistema. É como uma conta bancária, mas interna. Nela, o consultor pode:

**Ver seu saldo disponível** — A qualquer momento, o consultor sabe exatamente quanto tem para sacar. O valor aparece na tela principal, sempre atualizado.

**Consultar o extrato** — Uma lista de todas as movimentações: entradas (comissões, bonificações, prêmios) e saídas (saques, estornos). Com data, valor e descrição de cada uma.

**Solicitar saque total** — Com um clique, o consultor pede para receber tudo que tem disponível. Simples e rápido.

**Solicitar saque parcial** — Se preferir, pode sacar apenas uma parte. Por exemplo: "Tenho R$ 1.000, mas quero sacar só R$ 500 agora".

**Solicitar saque por período** — Útil para organização: "Quero sacar só o que ganhei em janeiro" ou "Só as comissões do último trimestre".

**Receber créditos automaticamente** — O consultor não precisa fazer nada. Fechou a venda, a comissão entra na conta dele automaticamente.

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

**Aprovação de estornos maiores** — Para valores acima de R$ 500, um gestor precisa aprovar antes de processar. Isso evita erros.

---

### Parte 6: Motor de Regras de Comissão

Aqui é onde a mágica acontece. O sistema calcula automaticamente quanto cada consultor deve ganhar, baseado em regras configuráveis:

**Regras de comissão** — "Vendas do Plano Básico pagam 6%, Plano Premium paga 8%". O gestor configura, o sistema aplica.

**Regras de residual** — "Para cada mensalidade que o cliente pagar, o consultor ganha 1%". Renda recorrente para o consultor.

**Bonificação por metas** — "Se vender 10 planos no mês, ganha R$ 200 de bônus". Incentivo para bater metas.

**Campanhas de premiação** — "Campanha de Verão: quem vender mais em fevereiro ganha uma viagem". Período específico com regras especiais.

**Simulação antes de ativar** — O gestor pode testar uma regra antes de colocar em produção. "Se eu mudar a comissão para 10%, quanto isso impactaria?"

---

### Parte 7: Demonstrativos Financeiros

O consultor precisa saber exatamente o que ganhou e por quê:

**Demonstrativo analítico** — Mostra cada venda, cada comissão, cada bonificação. Linha por linha, com todos os detalhes.

**Demonstrativo sintético** — Um resumo: "Total de comissões: R$ X, Total de bonificações: R$ Y, Total geral: R$ Z".

**Envio automático** — Todo mês (ou na frequência configurada), o consultor recebe seu demonstrativo por e-mail.

**Contestação de valores** — Se o consultor discordar de algum valor, pode contestar pelo sistema. O gestor analisa e responde.

---

### Parte 8: Funcionalidades Avançadas

Para quem quer ir além do básico:

**Acesso pelo App** — O consultor pode ver seus demonstrativos e saldos pelo celular, a qualquer hora.

**Notificações push** — "Você recebeu R$ 40,00 de comissão!" direto no celular do consultor.

**Dashboard do gestor** — Visão consolidada: quanto a equipe toda ganhou, quanto foi pago, tendências.

**Residuais automáticos** — Quando um cliente paga a mensalidade, o residual do consultor é creditado automaticamente.

**Exportação de relatórios** — Excel, PDF, CSV. Para quem precisa analisar os dados em outras ferramentas.

---

### Parte 9: Motor de Regras Avançado

Para empresas que precisam de comissionamento mais sofisticado:

**SPIFF (Incentivo Pontual)** — "Essa semana, quem vender o Plano Gold ganha R$ 50 extra por venda". Incentivos de curto prazo.

**PLR (Participação nos Lucros)** — Fórmulas complexas que consideram o lucro da empresa e distribuem entre os consultores.

**Aceleradores** — "Quem bater 100% da meta ganha 1.2x na comissão, quem bater 120% ganha 1.5x". Quanto mais vende, mais ganha por venda.

**Comissão Escalonada** — "Até 5 vendas: 5%, de 6 a 10 vendas: 7%, acima de 10: 10%". Premia o alto volume.

**Override (Comissão sobre Equipe)** — "O gerente ganha 2% sobre tudo que sua equipe vender". Incentivo para formar e treinar o time.

**Split de Comissão** — "Essa venda foi feita por dois consultores, dividir a comissão 60/40". Para vendas em parceria.

**Templates prontos** — Modelos de regras pré-configurados. O gestor escolhe um template e ajusta os valores.

**Editor visual** — Interface amigável para criar regras arrastando blocos, sem precisar saber programar.

---

### Parte 10: Gestão de Metas

Para acompanhar o desempenho dos consultores:

**Metas individuais** — Cada consultor tem sua meta. Com três níveis:
- *Floor*: o mínimo aceitável
- *Target*: o esperado
- *Stretch*: a superação (bônus extra!)

**Metas de equipe** — A equipe do gerente João tem meta de R$ 100.000 no mês. O sistema soma as vendas de todos.

**Metas compostas** — "Vender R$ 50.000 E ter NPS acima de 8 E reter 90% dos clientes". Múltiplos indicadores.

**Atingimento em tempo real** — O consultor vê na tela: "Você está em 75% da meta, faltam R$ 5.000".

**Projeção** — "No ritmo atual, você vai bater 110% da meta até o fim do mês". Ajuda no planejamento.

**Alertas de desvio** — Se o consultor está muito abaixo da meta na metade do mês, o sistema avisa o gestor.

---

### Parte 11: Portal de Transparência

O consultor precisa entender exatamente como sua comissão foi calculada:

**Detalhamento do cálculo** — "Venda #12345: R$ 500,00. Comissão base (8%): R$ 40,00. Bônus plano Premium: R$ 10,00. Acelerador 1.2x. Total: R$ 60,00".

**Simulador "E se..."** — O consultor digita: "Se eu vender mais 3 planos Premium este mês..." e o sistema mostra quanto ele ganharia.

**Ranking da equipe** — "Você está em 3º lugar no ranking da sua regional". Gamificação saudável.

---

### Parte 12: Aceite Digital de Políticas

Para garantir que todos conhecem as regras:

**Publicação de políticas** — O gestor cria um documento explicando as regras de comissionamento e publica no sistema.

**Aceite com validade jurídica** — O consultor lê o documento e clica em "Li e aceito". O sistema registra tudo: data, hora, IP, para valer legalmente.

**Lembretes automáticos** — Se alguém não aceitou a política em 3 dias, recebe um lembrete.

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

**Para sacar:**
- Saldo mínimo de R$ 50,00
- Dados bancários e PIX cadastrados
- Dados fiscais completos (CPF/CNPJ)
- Só pode ter um saque em andamento por vez

**Para notas fiscais:**
- MEI e autônomo emitem NFS-e
- Empresas emitem NF-e
- Cancelamento até 24h (NF-e) ou conforme regra municipal (NFS-e)

**Para estornos:**
- Cancelou a venda = estorno automático
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

- ✅ Calcula comissões automaticamente
- ✅ Emite notas fiscais sem intervenção humana
- ✅ Paga via PIX em menos de 24h
- ✅ Mantém histórico completo para auditoria
- ✅ Oferece transparência total para o consultor
- ✅ Permite regras flexíveis de comissionamento
- ✅ Distribui valores corretamente em estruturas hierárquicas

**Total: 63 funcionalidades que transformam um processo manual e propenso a erros em algo totalmente automatizado, transparente e confiável.**

---

## Histórico de Versões

| Versão | Data | O que mudou |
|--------|------|-------------|
| 1.0 | 29/01/2026 | Versão inicial com conta, NF, pagamento e motor básico |
| 2.0 | 29/01/2026 | Adicionado motor avançado, metas, transparência e políticas |
| 2.1 | 29/01/2026 | Adicionada distribuição hierárquica (filiação) |

---

*Documento elaborado pelo Product Owner — CRM*  
*Última atualização: 29/01/2026*
