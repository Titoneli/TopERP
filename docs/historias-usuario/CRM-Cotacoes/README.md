# Módulo: Cotações (CRM-COT)

| Metadado | Valor |
|----------|-------|
| **Módulo** | CRM-Cotações |
| **Código** | CRM-COT |
| **Versão** | 2.0 |
| **Data** | 21/01/2026 |
| **Responsável** | Product Owner - CRM |
| **Tipo DDD** | Core Domain |

---

## 1. Visão Geral

O módulo de Cotações é o **Core Domain** responsável por calcular e apresentar valores de proteção veicular. É um dos contextos mais críticos do CRM, pois é onde o valor de negócio é calculado e apresentado ao cliente.

### 1.1 Objetivos

- Facilitar e agilizar o processo de cotação para consultores e prospects
- Garantir cálculos precisos baseados em tabelas personalizadas
- Permitir apresentação clara e profissional de propostas e comparativos de planos
- Flexibilizar opções de pagamento e planos
- Registrar histórico completo de cotações por lead

### 1.2 Fluxo de Cotação

```
Dados do Lead → Dados do Veículo → Dados do Local de Circulação → 
Comparativo de Planos → Seleção de Plano → Serviços Opcionais → 
Cálculo → Apresentação → Envio da Cotação
```

### 1.3 Atores

- **Consultor**: Realiza cotações para leads
- **Lead**: Recebe cotações e decide
- **Administrador**: Configura tabelas e planos
- **Sistema de Tabelas**: Fornece valores base

---

## 2. Domain-Driven Design

### 2.1 Bounded Context

O contexto **Cotações (CRM-COT)** é classificado como **Core Domain** por representar o cálculo de preços - diferencial competitivo da associação. Este contexto encapsula toda a lógica de precificação, descontos e formas de pagamento.

**Linguagem Ubíqua:**
- **Cotação**: Documento com valores calculados para proteção veicular
- **Plano**: Conjunto de coberturas e valores oferecidos
- **Cobertura**: Proteção específica incluída no plano
- **Franquia**: Valor de participação do associado em sinistros
- **Tabela de Preços**: Estrutura hierárquica de valores por região/consultor
- **Snapshot**: Registro imutável da tabela usada no cálculo

### 2.2 Agregados

#### Agregado: Cotação (Aggregate Root)

```
┌─────────────────────────────────────────────────────────────────┐
│                    <<Aggregate Root>>                           │
│                        COTAÇÃO                                  │
├─────────────────────────────────────────────────────────────────┤
│ - id: UUID                                                      │
│ - numero: NumeroCotacao                                         │
│ - leadId: UUID (FK CRM-LED)                                     │
│ - consultorId: UUID                                             │
│ - veiculo: Veiculo                                              │
│ - condutor: Condutor                                            │
│ - localizacao: Localizacao                                      │
│ - planoSelecionado: PlanoSelecionado                            │
│ - coberturas: List<CoberturaItem>                               │
│ - valores: ValoresCotacao                                       │
│ - desconto: Desconto?                                           │
│ - pagamento: CondicaoPagamento                                  │
│ - snapshotTabela: SnapshotTabela                                │
│ - status: StatusCotacao                                         │
│ - validade: Date                                                │
│ - criadoEm: DateTime                                            │
│ - atualizadoEm: DateTime                                        │
├─────────────────────────────────────────────────────────────────┤
│ + calcularValor(): ValoresCotacao                               │
│ + aplicarDesconto(desconto: Desconto): void                     │
│ + selecionarPlano(plano: PlanoSelecionado): void                │
│ + adicionarCobertura(cobertura: CoberturaItem): void            │
│ + removerCobertura(coberturaId: UUID): void                     │
│ + definirPagamento(pagamento: CondicaoPagamento): void          │
│ + gerarPDF(): DocumentoPDF                                      │
│ + duplicar(): Cotacao                                           │
│ + enviarPorWhatsApp(): void                                     │
│ + enviarPorEmail(): void                                        │
│ + estaValida(): boolean                                         │
│ + converter(): Proposta (→ CRM-PRO)                             │
└─────────────────────────────────────────────────────────────────┘
         │
         │ contém
         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    <<Entity>>                                   │
│                     VEÍCULO                                     │
├─────────────────────────────────────────────────────────────────┤
│ - placa: Placa                                                  │
│ - marca: string                                                 │
│ - modelo: string                                                │
│ - versao: string                                                │
│ - anoFabricacao: number                                         │
│ - anoModelo: number                                             │
│ - chassi: Chassi                                                │
│ - renavam: Renavam                                              │
│ - valorFIPE: Dinheiro                                           │
│ - combustivel: TipoCombustivel                                  │
│ - possuiKitGas: boolean                                         │
│ - blindado: boolean                                             │
│ - tipoUso: TipoUso                                              │
│ - possuiGaragem: boolean                                        │
│ - cepPernoite: CEP                                              │
└─────────────────────────────────────────────────────────────────┘
         │
         │ associado a
         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    <<Entity>>                                   │
│                    CONDUTOR                                     │
├─────────────────────────────────────────────────────────────────┤
│ - nome: string                                                  │
│ - cpf: CPF                                                      │
│ - dataNascimento: Date                                          │
│ - cnh: CNH                                                      │
│ - tempoHabilitacao: number (anos)                               │
│ - possuiSinistrosAnteriores: boolean                            │
│ - tipoResidencia: TipoResidencia                                │
└─────────────────────────────────────────────────────────────────┘
```

#### Agregado: TabelaPrecos

```
┌─────────────────────────────────────────────────────────────────┐
│                    <<Aggregate Root>>                           │
│                   TABELA_PRECOS                                 │
├─────────────────────────────────────────────────────────────────┤
│ - id: UUID                                                      │
│ - nome: string                                                  │
│ - nivel: NivelTabela                                            │
│ - referenciaId: UUID (Nacional/Regional/Filial/Consultor)       │
│ - tabelaPai: UUID?                                              │
│ - planos: List<PlanoTabela>                                     │
│ - vigenciaInicio: Date                                          │
│ - vigenciaFim: Date?                                            │
│ - ativa: boolean                                                │
├─────────────────────────────────────────────────────────────────┤
│ + obterPlano(planoId: UUID): PlanoTabela                        │
│ + calcularValor(veiculo, condutor, plano): ValoresCotacao       │
│ + aplicarFatorRegional(fator: number): void                     │
│ + gerarSnapshot(): SnapshotTabela                               │
│ + estaVigente(): boolean                                        │
└─────────────────────────────────────────────────────────────────┘
         │
         │ contém
         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    <<Entity>>                                   │
│                   PLANO_TABELA                                  │
├─────────────────────────────────────────────────────────────────┤
│ - id: UUID                                                      │
│ - nome: string                                                  │
│ - coberturas: List<CoberturaPlano>                              │
│ - valorAdesao: Dinheiro                                         │
│ - valorMensalidade: Dinheiro                                    │
│ - franquiaPadrao: Dinheiro                                      │
│ - valorInstalacaoRastreador: Dinheiro                           │
│ - ativo: boolean                                                │
└─────────────────────────────────────────────────────────────────┘
```

### 2.3 Entidades

| Entidade | Descrição | Identificador |
|----------|-----------|---------------|
| **Cotacao** | Documento principal com cálculo de valores | UUID |
| **Veiculo** | Dados do veículo a ser protegido | Placa + Chassi |
| **Condutor** | Dados do condutor principal | CPF |
| **TabelaPrecos** | Estrutura de preços por nível hierárquico | UUID |
| **PlanoTabela** | Plano dentro de uma tabela de preços | UUID |
| **CoberturaPlano** | Cobertura específica de um plano | UUID |

### 2.4 Value Objects

| Value Object | Propriedades | Validações |
|--------------|--------------|------------|
| **NumeroCotacao** | numero: string | Formato COT-AAAA-NNNNNN |
| **Placa** | valor: string | Padrão Mercosul ou antigo |
| **Chassi** | valor: string | 17 caracteres alfanuméricos |
| **Renavam** | valor: string | 11 dígitos numéricos |
| **Dinheiro** | valor: decimal, moeda: string | >= 0, BRL |
| **CPF** | valor: string | 11 dígitos válidos |
| **CNH** | numero, categoria, emissao, validade | Categoria A-E, validade futura |
| **CEP** | valor: string | 8 dígitos numéricos |
| **Localizacao** | cidade: string, estado: UF | UF válida (2 chars) |
| **StatusCotacao** | valor: enum | RASCUNHO, CALCULADA, ENVIADA, EXPIRADA, CONVERTIDA |
| **TipoUso** | valor: enum | PASSEIO, COMERCIAL |
| **TipoCombustivel** | valor: enum | GASOLINA, ETANOL, FLEX, DIESEL, GNV, ELETRICO, HIBRIDO |
| **NivelTabela** | valor: enum | NACIONAL, REGIONAL, FILIAL, ESCRITORIO, CONSULTOR |
| **Desconto** | percentual: decimal, motivo: string | 0-20%, motivo obrigatório se >10% |
| **CondicaoPagamento** | tipo, parcelas, valorParcela, juros | À vista ou 1-12x, juros se >6x |
| **SnapshotTabela** | dados: JSON, dataCaptura: DateTime | Imutável após criação |
| **ValoresCotacao** | adesao, mensalidade, franquia, instalacao, total | Todos >= 0 |

### 2.5 Eventos de Domínio

| Evento | Trigger | Payload | Consumidores |
|--------|---------|---------|--------------|
| **CotacaoIniciada** | Nova cotação criada | cotacaoId, leadId, consultorId | AUD, ANA |
| **VeiculoInformado** | Dados veículo preenchidos | cotacaoId, placaInfo, valorFIPE | ANA |
| **PlanoSelecionado** | Plano escolhido | cotacaoId, planoId, coberturas | AUD |
| **CotacaoCalculada** | Cálculo concluído | cotacaoId, valores, snapshotId | AUD, ANA |
| **DescontoAplicado** | Desconto concedido | cotacaoId, percentual, motivo | AUD |
| **CotacaoEnviada** | Cotação enviada ao lead | cotacaoId, canal, destinatario | AUD, FUN |
| **CotacaoExpirada** | Validade expirou | cotacaoId, dataExpiracao | FUN |
| **CotacaoConvertida** | Convertida em proposta | cotacaoId, propostaId | PRO, FUN, AUD |
| **TabelaPrecosAtualizada** | Tabela modificada | tabelaId, nivel, alteracoes | AUD |

### 2.6 Repositórios

```typescript
interface CotacaoRepository {
  salvar(cotacao: Cotacao): Promise<void>;
  buscarPorId(id: UUID): Promise<Cotacao | null>;
  buscarPorNumero(numero: NumeroCotacao): Promise<Cotacao | null>;
  buscarPorLead(leadId: UUID): Promise<Cotacao[]>;
  buscarPorConsultor(consultorId: UUID, filtros?: FiltroCotacao): Promise<Cotacao[]>;
  buscarExpiradas(): Promise<Cotacao[]>;
  excluir(id: UUID): Promise<void>;
}

interface TabelaPrecosRepository {
  salvar(tabela: TabelaPrecos): Promise<void>;
  buscarPorId(id: UUID): Promise<TabelaPrecos | null>;
  buscarVigente(nivel: NivelTabela, referenciaId: UUID): Promise<TabelaPrecos | null>;
  buscarHierarquia(consultorId: UUID): Promise<TabelaPrecos[]>;
  listarPorNivel(nivel: NivelTabela): Promise<TabelaPrecos[]>;
}
```

---

## 3. Integrações

### 3.1 Upstream (Dependências)

| Contexto | Tipo | Dados Consumidos |
|----------|------|------------------|
| **CRM-Leads (LED)** | Customer/Supplier | Lead, Pessoa, Veículo do Lead |
| **API FIPE** | ACL (Anti-Corruption Layer) | Valor de mercado do veículo |
| **TopERP-Tabelas** | Shared Kernel | Estrutura de tabelas base |

### 3.2 Downstream (Dependentes)

| Contexto | Tipo | Dados Fornecidos |
|----------|------|------------------|
| **CRM-Propostas (PRO)** | Customer/Supplier | Cotação calculada para conversão |
| **CRM-Funil (FUN)** | Event-Driven | Eventos de cotação para atualizar negociação |
| **CRM-Análise (ANA)** | Published Language | Métricas de cotação para BI |

---

## 4. Histórias de Usuário

### 4.1 Essenciais (Must Have)

| ID | História | Story Points |
|----|----------|--------------|
| [US-CRM-COT-001](US-CRM-COT-001.md) | Iniciar Nova Cotação | 5 |
| [US-CRM-COT-002](US-CRM-COT-002.md) | Informar Dados do Veículo | 8 |
| [US-CRM-COT-003](US-CRM-COT-003.md) | Informar Dados do Condutor | 5 |
| [US-CRM-COT-004](US-CRM-COT-004.md) | Selecionar Plano de Proteção | 5 |
| [US-CRM-COT-005](US-CRM-COT-005.md) | Adicionar Coberturas Opcionais | 3 |
| [US-CRM-COT-006](US-CRM-COT-006.md) | Calcular Valor da Cotação | 13 |
| [US-CRM-COT-007](US-CRM-COT-007.md) | Visualizar Comparativo de Planos | 8 |
| [US-CRM-COT-008](US-CRM-COT-008.md) | Salvar Cotação | 3 |
| [US-CRM-COT-009](US-CRM-COT-009.md) | Editar Cotação Existente | 5 |
| [US-CRM-COT-010](US-CRM-COT-010.md) | Gerar PDF da Cotação | 8 |

### 4.2 Importantes (Should Have)

| ID | História | Story Points |
|----|----------|--------------|
| [US-CRM-COT-011](US-CRM-COT-011.md) | Aplicar Desconto na Cotação | 5 |
| [US-CRM-COT-012](US-CRM-COT-012.md) | Simular Formas de Pagamento | 5 |
| [US-CRM-COT-013](US-CRM-COT-013.md) | Duplicar Cotação | 3 |
| [US-CRM-COT-014](US-CRM-COT-014.md) | Enviar Cotação por WhatsApp | 5 |
| [US-CRM-COT-015](US-CRM-COT-015.md) | Enviar Cotação por E-mail | 5 |

### 4.3 Desejáveis (Could Have)

| ID | História | Story Points |
|----|----------|--------------|
| [US-CRM-COT-016](US-CRM-COT-016.md) | Cotação Rápida (simplificada) | 8 |
| [US-CRM-COT-017](US-CRM-COT-017.md) | Histórico de Cotações do Lead | 3 |
| [US-CRM-COT-018](US-CRM-COT-018.md) | Comparar com Concorrência | 5 |
| [US-CRM-COT-019](US-CRM-COT-019.md) | Análise de Sensibilidade de Preço | 8 |

---

## 5. Regras de Negócio

### 5.1 Veículo

| Código | Regra | Validação |
|--------|-------|-----------|
| RN-CRM-COT-001 | Placa válida | Padrão Mercosul ou antigo |
| RN-CRM-COT-002 | Ano do veículo | Entre 1990 e ano atual + 1 |
| RN-CRM-COT-003 | Valor do veículo | R$ 5.000 a R$ 500.000 |
| RN-CRM-COT-004 | Veículos premium | Acima de R$ 200.000 requerem aprovação |

### 5.2 Condutor

| Código | Regra | Validação |
|--------|-------|-----------|
| RN-CRM-COT-010 | Idade do condutor | Entre 18 e 75 anos |
| RN-CRM-COT-011 | CNH válida | Dentro da validade |
| RN-CRM-COT-012 | Fator idade | <25 ou >65 anos: +15% |

### 5.3 Planos e Cálculo

| Código | Regra | Validação |
|--------|-------|-----------|
| RN-CRM-COT-020 | Coberturas base | Obrigatórias por plano |
| RN-CRM-COT-021 | Variação regional | Tabela por região/consultor |
| RN-CRM-COT-022 | Desconto máximo | 20% (exceto com aprovação) |
| RN-CRM-COT-030 | Tabela vigente | Usar tabela do dia do cálculo |
| RN-CRM-COT-031 | Franquia padrão | R$ 500 populares, R$ 1.000 demais |
| RN-CRM-COT-032 | Validade cotação | 7 dias |
| RN-CRM-COT-033 | Snapshot | Registrar tabela usada |

### 5.4 Pagamento

| Código | Regra | Validação |
|--------|-------|-----------|
| RN-CRM-COT-040 | Parcelamento | Até 12x |
| RN-CRM-COT-041 | Sem juros | Até 6x |
| RN-CRM-COT-042 | Com juros | 7-12x a 1,99% a.m. |
| RN-CRM-COT-043 | Primeira parcela | Vence em até 5 dias |

---

## 6. Estrutura Hierárquica de Tabelas

```
Nacional
  └── Regional (Sul, Sudeste, etc.)
        └── Filial (São Paulo, Curitiba, etc.)
              └── Escritório
                    └── Consultor
```

Cada nível pode ter tabela personalizada que sobrescreve a superior.

---

## 7. Métricas de Sucesso

| KPI | Meta | Descrição |
|-----|------|-----------|
| Cotações/Dia por Consultor | 8-12 | Produtividade |
| Tempo Médio de Cotação | < 5 min | Eficiência |
| Conversão Cotação→Proposta | > 40% | Qualidade |
| Taxa de Acurácia | 100% | Precisão do cálculo |
| Satisfação com Clareza | > 4,5/5 | Experiência |
| Taxa de Rejeição | < 5% | Erros de cálculo |

---

## 8. Histórico de Alterações

| Data | Versão | Autor | Alteração |
|------|--------|-------|-----------|
| 21/01/2026 | 1.0 | Product Owner | Versão inicial |
| 21/01/2026 | 2.0 | Product Owner | Reestruturação completa para padrão DDD |

---

**Versão**: 2.0  
**Data**: 21/01/2026  
**Responsável**: Product Owner - CRM  
**Tipo DDD**: Core Domain
