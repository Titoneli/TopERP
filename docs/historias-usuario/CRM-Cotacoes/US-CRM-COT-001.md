# US-CRM-COT-001: Iniciar Nova Cotação

## História de Usuário

**Como** consultor de proteção veicular,  
**Eu quero** iniciar uma nova cotação de forma rápida e intuitiva,  
**Para que** eu possa apresentar valores e planos ao meu lead durante o atendimento.

## Prioridade

Essencial

## Estimativa

13 SP

## Critérios de Aceitação

### Cenário 1: Iniciar cotação a partir de uma negociação
- **Dado que** estou visualizando os detalhes de uma negociação
- **Quando** clico no botão "Nova Cotação"
- **Então** sou redirecionado para o formulário de cotação
- **E** os dados do lead são pré-preenchidos automaticamente:
  - Nome completo
  - CPF/CNPJ
  - Telefone
  - E-mail
  - Endereço
- **E** o formulário está dividido em etapas (wizard):
  1. Dados do Veículo
  2. Dados do Condutor
  3. Seleção de Plano
  4. Coberturas Opcionais
  5. Revisão e Cálculo

### Cenário 2: Buscar veículo por placa (integração FIPE)
- **Dado que** estou na etapa "Dados do Veículo"
- **Quando** informo a placa do veículo (ex: ABC1D23)
- **E** clico em "Buscar"
- **Então** o sistema consulta dados do veículo via API
- **E** preenche automaticamente:
  - Marca (ex: Volkswagen)
  - Modelo (ex: Gol)
  - Versão (ex: 1.0 12V MPI Totalflex Trendline 4P)
  - Ano fabricação/modelo (ex: 2020/2021)
  - Valor FIPE sugerido (ex: R$ 45.000,00)
  - Combustível (Flex)
- **E** posso ajustar manualmente qualquer campo se necessário

### Cenário 3: Informar dados do veículo manualmente
- **Dado que** a placa não retornou dados ou preciso ajustar
- **Quando** preencho os campos manualmente:
  - Marca (dropdown com lista)
  - Modelo (dropdown filtrado por marca)
  - Versão (texto livre)
  - Ano fabricação/modelo (dropdowns)
  - Valor do veículo (R$)
  - Combustível (Gasolina/Etanol/Flex/Diesel/GNV/Elétrico)
  - Placa
  - Chassi (opcional)
  - RENAVAM
  - ☐ Possui kit gás instalado
  - ☐ Veículo blindado
  - Uso: (•) Particular  ( ) Comercial/App
  - ☐ Tem garagem/estacionamento
  - CEP de pernoite
- **Então** todos os campos são validados em tempo real
- **E** vejo mensagens de erro claras para campos inválidos

### Cenário 4: Validações de dados do veículo
- **Dado que** estou preenchendo dados do veículo
- **Então** o sistema valida:
  - Placa: formato válido (Mercosul ou antigo)
  - Ano: entre 1990 e ano atual + 1
  - Valor: entre R$ 5.000,00 e R$ 500.000,00
  - RENAVAM: 9 ou 11 dígitos numéricos
  - Chassi: 17 caracteres alfanuméricos (se informado)
- **E** se valor > R$ 200.000, mostro aviso: "Veículos acima de R$ 200.000 requerem aprovação especial"

### Cenário 5: Informar dados do condutor principal
- **Dado que** avancei para a etapa "Dados do Condutor"
- **Quando** preencho:
  - Nome completo
  - CPF (pode estar pré-preenchido do lead)
  - Data de nascimento (campo de data)
  - CNH número
  - CNH categoria (A/B/C/D/E/AB)
  - CNH data de emissão
  - CNH validade
  - Estado civil (dropdown)
  - Profissão (texto livre ou dropdown)
  - ☐ Possui sinistros nos últimos 3 anos
  - ☐ Residência própria  ( ) Alugada
- **Então** sistema calcula automaticamente:
  - Idade (a partir da data de nascimento)
  - Tempo de habilitação (a partir da CNH)
- **E** valida CNH dentro da validade

### Cenário 6: Adicionar condutores adicionais
- **Dado que** estou na etapa "Dados do Condutor"
- **Quando** clico em "+ Adicionar condutor adicional"
- **Então** posso adicionar até 3 condutores adicionais
- **E** para cada um informo:
  - Nome
  - CPF
  - Data de nascimento
  - Relação com titular (Cônjuge/Filho/Pai/Mãe/Outro)
  - CNH número e categoria
- **E** sistema calcula acréscimo automático baseado na idade

### Cenário 7: Validações de condutor
- **Dado que** estou informando dados do condutor
- **Então** o sistema valida:
  - Idade entre 18 e 75 anos
  - CPF válido (algoritmo de validação)
  - CNH dentro da validade (data > hoje)
  - Tempo mínimo de habilitação: 1 ano
- **E** se idade < 25 ou > 65, mostro aviso: "Acréscimo de 15% por perfil de risco"

### Cenário 8: Salvar cotação em progresso
- **Dado que** estou preenchendo a cotação
- **Quando** clico em "Salvar Rascunho"
- **Então** a cotação é salva com status "Em Elaboração"
- **E** vejo mensagem de confirmação "Cotação salva com sucesso"
- **E** posso retomar posteriormente do ponto onde parei

### Cenário 9: Navegação entre etapas
- **Dado que** estou preenchendo uma etapa
- **Quando** clico em "Próximo"
- **Então** sistema valida campos obrigatórios da etapa atual
- **E** se houver erros, não permite avançar e destaca campos inválidos
- **E** se válido, avança para próxima etapa
- **E** posso voltar para etapas anteriores clicando em "Anterior"
- **E** vejo progresso visual (stepper) indicando etapa atual

### Cenário 10: Integração com dados do lead
- **Dado que** o lead já possui dados cadastrados
- **Então** o sistema pré-preenche:
  - Dados pessoais do condutor
  - Endereço e CEP
  - Telefones e e-mail
- **E** se lead já tem veículo cadastrado, pré-preenche dados do veículo
- **E** posso editar qualquer dado pré-preenchido

## Regras de Negócio Relacionadas
- **RN-CRM-COT-001**: Placa deve ser válida
- **RN-CRM-COT-002**: Ano entre 1990 e atual+1
- **RN-CRM-COT-003**: Valor entre R$ 5k e R$ 500k
- **RN-CRM-COT-004**: Veículos > R$ 200k requerem aprovação
- **RN-CRM-COT-010**: Idade condutor entre 18-75 anos
- **RN-CRM-COT-011**: CNH dentro da validade
- **RN-CRM-COT-012**: Acréscimo de 15% para idade < 25 ou > 65

## Requisitos Relacionados
- **REQ-CRM-COT-001**: Integração com API FIPE para consulta de veículos
- **REQ-CRM-COT-002**: Validação de placa em formato Mercosul e antigo
- **REQ-CRM-COT-003**: Validação de CPF com dígitos verificadores
- **REQ-CRM-COT-004**: Sistema deve salvar auto-save a cada 2 minutos

## Dependências
- US-CRM-FUN-002 (Criar Negociação) implementado
- US-CRM-LED-001 (Cadastro de Lead) implementado
- Integração com API FIPE configurada
- Tabelas de marcas e modelos cadastradas

## Notas Técnicas

### Frontend
- Wizard multi-step com validação por etapa
- Auto-complete para campos de marca/modelo
- Máscaras para inputs (placa, CPF, telefone, valor R$)
- Auto-save a cada 2 minutos (salvar rascunho)
- Debounce na busca de veículos (500ms)

### Backend
- API FIPE para consulta de veículos: `https://veiculos.fipe.org.br/`
- Validação server-side de todos os campos
- Endpoint: `POST /api/crm/cotacoes/iniciar`
- Armazenar snapshot dos dados do lead no momento da cotação

### Performance
- Busca de veículo deve retornar em < 3 segundos
- Transição entre etapas instantânea (< 100ms)
- Auto-save não deve bloquear UI

### Integrações
- API FIPE para dados de veículos
- CRM-Leads para dados do lead
- TopERP-Tabelas para validar marcas/modelos

## Mockups/Wireframes

### Wizard - Etapa 1: Dados do Veículo
```
┌────────────────────────────────────────────────────────────────┐
│ Nova Cotação - João Silva                          [X Fechar]  │
├────────────────────────────────────────────────────────────────┤
│ ①──────● ②────── ③────── ④────── ⑤──────                      │
│ Veículo  Condutor  Plano   Opcionais Revisão                   │
├────────────────────────────────────────────────────────────────┤
│ DADOS DO VEÍCULO                                               │
│                                                                │
│ Placa *                         [Buscar Dados]                 │
│ [ABC1D23_____]                                                 │
│                                                                │
│ Marca *                    Modelo *                            │
│ [Volkswagen ▼]             [Gol ▼]                             │
│                                                                │
│ Versão                                                         │
│ [1.0 12V MPI Totalflex Trendline 4P_________________]         │
│                                                                │
│ Ano Fabricação *  Ano Modelo *  Valor do Veículo *            │
│ [2020 ▼]          [2021 ▼]      [R$ 45.000,00]                │
│                                                                │
│ Combustível *               Tipo de Uso *                      │
│ [Flex ▼]                    (•) Particular  ( ) Comercial/App  │
│                                                                │
│ RENAVAM *                                                      │
│ [___________]                                                  │
│                                                                │
│ CEP de Pernoite *          ☐ Possui Garagem/Estacionamento    │
│ [88015-100___]             ☐ Possui Kit Gás                   │
│                            ☐ Veículo Blindado                 │
│                                                                │
│ Informações Adicionais (opcional)                              │
│ [____________________________________________]                 │
│ [____________________________________________]                 │
│                                                                │
├────────────────────────────────────────────────────────────────┤
│ [Salvar Rascunho]  [Cancelar]          [Anterior]  [Próximo →]│
└────────────────────────────────────────────────────────────────┘
```

### Validações em Tempo Real
```
┌────────────────────────────────────────┐
│ Placa *                                │
│ [ABC-123_] ❌ Formato inválido         │
│ Use: ABC1D23 ou ABC-1234              │
└────────────────────────────────────────┘

┌────────────────────────────────────────┐
│ Valor do Veículo *                     │
│ [R$ 3.000,00] ⚠️                       │
│ Valor mínimo: R$ 5.000,00              │
└────────────────────────────────────────┘
```

### Busca Automática por Placa (Loading)
```
┌────────────────────────────────────────┐
│ Placa *              [🔄 Buscando...]  │
│ [ABC1D23_____]                         │
│ ⏳ Consultando dados do veículo...     │
└────────────────────────────────────────┘
```

### Dados Encontrados
```
┌────────────────────────────────────────┐
│ ✅ Dados do veículo encontrados!       │
│                                        │
│ Volkswagen Gol 1.0 Trendline          │
│ 2020/2021 - Flex                       │
│ Valor FIPE: R$ 45.000,00               │
│                                        │
│ [Usar esses dados]  [Editar manual]   │
└────────────────────────────────────────┘
```

## Definição de Pronto

- Wizard multi-step implementado
- Etapa 1 (Veículo) funcional com todas validações
- Etapa 2 (Condutor) funcional com todas validações
- Integração com API FIPE funcional
- Busca automática de veículo por placa
- Validação de placa, CPF, CNH
- Pré-preenchimento de dados do lead
- Auto-save a cada 2 minutos
- Navegação entre etapas validando campos
- [x] Indicador visual de progresso (stepper)
- [x] Mensagens de erro claras e em português
- [x] Interface responsiva (desktop e tablet)
- [x] Testes unitários cobertura > 80%
- [x] Testes E2E do fluxo completo
- [x] Testes de integração com API FIPE
- [x] Performance: busca veículo < 3s
- [x] Documentação de API atualizada
- [x] Code review aprovado
- [x] QA validou todos os cenários
- [x] Testes de usabilidade realizados
- [x] Deploy em homologação
- [x] Aprovação do PO

---

**Criado por**: Gustavo Titoneli (Product Owner - CRM)  
**Data de Criação**: 21/01/2026  
**Última Atualização**: 21/01/2026  
**Versão**: 1.0  
**Epic**: Cotações e Propostas  
**Sprint**: A definir  
**Módulo**: CRM-Cotacoes
