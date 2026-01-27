# Glossário - TopERP

Este documento contém os termos e definições utilizados no sistema TopERP.

## A

### Arquivamento de Lead
Processo de mover um lead para lista inativa, removendo-o da fila de atendimento. Requer seleção de um dos 14 motivos padronizados.

### Ativo
Bem ou direito que a empresa possui e que pode ser convertido em valor monetário.

### Almoxarifado
Local físico ou lógico onde são armazenados os produtos e materiais da empresa.

## B

### Backlog
Lista priorizada de funcionalidades, melhorias e correções a serem desenvolvidas.

### Baixa de Estoque
Registro da saída de produtos do estoque, seja por venda, consumo ou perda.

### Blacklist de Consultores
Lista de telefones de consultores ativos que não podem ser cadastrados como leads, evitando fraudes na captação.

## C

### Centro de Custo
Unidade organizacional para apropriação e controle de custos.

### CFOP
Código Fiscal de Operações e Prestações - identifica a natureza da operação fiscal.

### cod_colaborador
Parâmetro de URL utilizado na landing page para direcionar o lead a um consultor específico.

### cod_origem
Parâmetro de URL que identifica a fonte/campanha de captação do lead (1=Link Direto, 2=Influencer, 3=Google Ads, etc.). O valor recebido é gravado no campo `dom_ind_origem` da tabela `crm_negociacao`.

### Contas a Pagar
Obrigações financeiras da empresa com fornecedores e terceiros.

### Contas a Receber
Direitos de crédito da empresa sobre clientes e terceiros.

### Consultor
Colaborador responsável pela comercialização de proteção veicular e atendimento de leads.

### crm_negociacao
Tabela principal do módulo CRM que armazena os dados dos leads/negociações. Contém informações como nome, telefone, email, status, origem (`dom_ind_origem`), consultor responsável e histórico de interações.

## D

### DANFE
Documento Auxiliar da Nota Fiscal Eletrônica.

### DDD
Discagem Direta à Distância - código de área telefônica. Extraído do telefone do lead para análise regional de demanda.

### Depreciação
Redução do valor de um ativo ao longo do tempo devido ao uso ou obsolescência.

### dom_ind_origem
Campo da tabela `crm_negociacao` que armazena o indicador de origem do lead. Recebe o valor do parâmetro `cod_origem` da URL. Códigos padronizados para rastreabilidade de captação:
- 1: LINK_DIRETO
- 2: INFLUENCER_INSTAGRAM  
- 3: ADS_GOOGLE
- 4: ADS_META
- 5: WHATSAPP
- 6: INDICACAO
- 7: CONSULTOR_PROPRIO
- 8: APP_CONSULTOR
- 9: APP_ASS_INDICACAO
- 10: VENDA_PROPRIA
- 11: AUTOMACAO
- 12: FORMULARIO_EMBARCADO
- 99: OUTROS

## E

### ERP
Enterprise Resource Planning - Sistema integrado de gestão empresarial.

### Estoque Mínimo
Quantidade mínima de um produto que deve ser mantida em estoque.

## F

### Faturamento
Processo de emissão de documentos fiscais referentes às vendas realizadas.

### Fluxo de Caixa
Controle das entradas e saídas de recursos financeiros da empresa.

### Fornecedor
Pessoa física ou jurídica que fornece produtos ou serviços para a empresa.

## I

### Inventário
Processo de contagem e valorização dos itens em estoque.

### Item de Estoque
Produto, material ou mercadoria cadastrado no sistema de estoque.

## L

### Lançamento Contábil
Registro de uma transação nos livros contábeis da empresa.

### Landing Page
Página de destino otimizada para conversão, utilizada para captação de leads.

### Lead
Potencial cliente identificado pelo setor comercial.

### Lote
Conjunto de produtos fabricados ou recebidos em uma mesma ocasião.

## M

### Margem de Contribuição
Diferença entre o preço de venda e os custos variáveis de um produto.

### Motivo de Arquivamento
Razão padronizada pela qual um lead é removido da fila ativa de atendimento. O sistema oferece 14 motivos: Sem interesse, Concorrente, Seguradora, Região não coberta, Valor não coberto, Veículo não coberto, Adesão alta, Mensalidade alta, Telefone inválido, Não localizado, Duplicado, Fora do perfil, Teste e Outros.

### MVP
Minimum Viable Product - Produto mínimo viável com funcionalidades essenciais.

## N

### NCM
Nomenclatura Comum do Mercosul - código de classificação de mercadorias.

### NF-e
Nota Fiscal Eletrônica - documento fiscal digital.

### Nota de Entrada
Documento que registra o recebimento de mercadorias de fornecedores.

## O

### Ordem de Compra
Documento que formaliza a solicitação de compra junto ao fornecedor.

### Ordem de Produção
Documento que autoriza a fabricação de um produto.

### Ordem de Serviço
Documento que registra a solicitação e execução de um serviço.

## P

### Pedido de Venda
Documento que registra a intenção de compra de um cliente.

### Plano de Contas
Estrutura de contas contábeis utilizadas para classificar transações.

### PO (Product Owner)
Responsável por definir e priorizar os requisitos do produto.

### Provisão
Reserva de recursos para obrigações futuras.

## R

### Rastreabilidade
Capacidade de identificar a origem e o histórico de um produto.

### Reativação de Lead
Processo de restaurar um lead arquivado para a fila ativa de atendimento, retornando-o ao status anterior ao arquivamento.

### Requisição de Compra
Solicitação interna para aquisição de materiais ou serviços.

### Romaneio
Lista detalhada dos itens contidos em uma remessa.

## S

### SKU
Stock Keeping Unit - código único de identificação de um produto.

### Sprint
Ciclo de desenvolvimento com duração fixa (geralmente 2 semanas).

### Stakeholder
Pessoa ou grupo interessado ou afetado pelo projeto.

## T

### Título
Documento que representa um direito de crédito ou uma obrigação de pagamento.

### Tributação
Conjunto de impostos e contribuições incidentes sobre operações comerciais.

## U

### Unidade de Medida
Padrão utilizado para quantificar produtos (un, kg, m, etc.).

### User Story
História de usuário - descrição de uma funcionalidade do ponto de vista do usuário.

## V

### VistorIA
Aplicativo de vistorias de última geração da TopBrasil. Utilizado para realizar inspeção prévia do veículo antes da contratação, integrando com gateways de validação de dados (Detran, Denatran, Renavam). O nome combina "Vistoria" + "IA" (Inteligência Artificial).

### Vistoria
Inspeção prévia do veículo antes da contratação da proteção veicular, realizada através do App VistorIA ou presencialmente.

---

## Termos DDD (Domain-Driven Design)

### Aggregate (Agregado)
Cluster de objetos de domínio tratados como unidade. Ex: `Lead` é o Aggregate Root do CRM-LED.

### Anti-Corruption Layer (ACL)
Camada de proteção contra modelos externos. Ex: `FipeAdapter`, `VistoriaAdapter`.

### Bounded Context
Fronteira explícita onde um modelo de domínio é definido e aplicável. Ex: CRM-LED (Leads), CRM-COT (Cotações).

### CQRS (Command Query Responsibility Segregation)
Separação entre comandos (escrita) e consultas (leitura). Usado em CRM-DAS e CRM-REL.

### Domain Event
Registro de algo que aconteceu no domínio. Ex: `LeadCaptado`, `PagamentoConfirmado`.

### Entity (Entidade)
Objeto com identidade única e ciclo de vida. Ex: Lead, Cotação, Proposta.

### Repository
Abstração para persistência de agregados.

### Shared Kernel
Código/modelo compartilhado entre contextos. Ex: tabelas `COR_PESSOA`, `COR_CLIENTE`.

### Ubiquitous Language
Linguagem comum compartilhada entre desenvolvedores e especialistas de domínio.

### Value Object
Objeto imutável sem identidade própria. Ex: Telefone, Email, DDD, UTM Parameters.

---

## Personas do CRM

### Consultor (Persona)
Vendedor externo responsável pela comercialização de proteção veicular. Aggregate: `Colaborador` (CRM-CAD).

### Coordenador (Persona)
Gestor comercial que gerencia equipes de consultores. Aggregates: `Colaborador` + `Equipe` (CRM-CAD).

### Lead (Persona)
Potencial cliente interessado em proteção veicular. Aggregate: `Lead` (CRM-LED).

---

## V

### Valor Presente
Valor atual de um montante futuro, considerando uma taxa de desconto.

### Vendedor
Colaborador responsável pela comercialização de produtos ou serviços.

---

**Última Atualização**: 25 de janeiro de 2026  
**Versão**: 1.1

**Histórico de Alterações**

| Data | Versão | Alteração | Autor |
|------|--------|-----------|-------|
| 25/01/2026 | 1.1 | Adicionados termos DDD e Personas do CRM | PO |
| 21/01/2026 | 1.0 | Versão inicial | PO |
