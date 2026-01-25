# TopERP - Instruções para Copilot

Este projeto contém as definições de Product Owner (PO) para o sistema TopERP utilizando sempre os princípios e conceitos de Data-Driven Design. Utilizar esse documentos para especificar os requisitos de design, fluxos de usuário e regras de negócio para o desenvolvimento e manutenção de qualquer funcionalidade.

## Contexto do Projeto

- **Nome**: TopERP
- **Tipo**: Sistema ERP (Enterprise Resource Planning)
- **Idioma**: Português Brasileiro
- **Propósito**: Documentação de requisitos, histórias de usuário e especificações de produto

## Estrutura do Projeto

```
TopERP/
├── docs/
│   ├── requisitos/           # Requisitos funcionais e não-funcionais
│   ├── historias-usuario/    # User Stories organizadas por módulo
│   ├── casos-uso/            # Casos de uso detalhados
│   ├── regras-negocio/       # Regras de negócio do sistema
│   ├── especificacoes/       # Especificações técnicas e funcionais
│   ├── criterios-aceitacao/  # Critérios de aceitação para QA
│   ├── backlog/              # Product Backlog e Sprint Planning
│   ├── releases/             # Planejamento de releases
│   ├── wireframes/           # Mockups e protótipos
│   └── glossario/            # Glossário de termos do sistema
├── templates/                # Templates reutilizáveis
└── stakeholders/             # Requisitos por stakeholder
```

## Convenções de Documentação

### Histórias de Usuário
- Formato: "Como [persona], eu quero [funcionalidade] para [benefício]"
- Incluir sempre critérios de aceitação
- Usar prioridade MoSCoW (Must, Should, Could, Won't)

### Identificadores
- Requisitos: REQ-[MÓDULO]-[NÚMERO] (ex: REQ-FIN-001)
- Histórias: US-[MÓDULO]-[NÚMERO] (ex: US-VEN-015)
- Casos de Uso: UC-[MÓDULO]-[NÚMERO] (ex: UC-EST-003)

### Módulos do ERP
- FIN: Financeiro
- VEN: Vendas
- COR: Corporativo
- ADM: Administrativo
- RAS: Rastreamento
- SIN: Eventos
- CRM: Gestão de Clientes

## Geração de PDFs

### Ferramenta Utilizada
- **mdpdf** via npx (não requer instalação global)

### Comando para Gerar PDF
```bash
# Navegar até a pasta do arquivo
cd docs/historias-usuario/CRM-Leads

# Gerar PDF
npx mdpdf US-CRM-LEAD-001.md --output US-CRM-LEAD-001.pdf
```

### Convenções de PDFs
- Gerar PDF sempre que uma User Story estiver com status "✅ Pronto"
- Nome do PDF deve ser idêntico ao arquivo .md (ex: `US-CRM-LEAD-001.md` → `US-CRM-LEAD-001.pdf`)
- PDFs devem estar na mesma pasta do arquivo .md correspondente
- Atualizar PDF sempre que o .md for alterado
- Registrar no CONTINUIDADE do módulo qual PDF foi gerado

### Checklist de Geração de PDF
- [ ] User Story com status "✅ Pronto"
- [ ] Documento revisado (DDD, ortografia, diagramas)
- [ ] Versão atualizada no documento
- [ ] Comando `npx mdpdf` executado com sucesso
- [ ] PDF verificado (abrir e conferir formatação)


## Regras de Edição

- Utilizando sempre os princípios e conceitos de Data-Driven Design (DDD). 
- Sempre manter a rastreabilidade entre requisitos e histórias
- Documentar decisões de negócio no histórico de alterações
- Usar português brasileiro formal na documentação
- Incluir data e autor em todas as alterações
- Revisar aplicação, analisar ultimas alterações e implementar tudo necessário para manter integridade e fidelidade de todo o projeto
- Garantir que todo o projeto esteja de acordo com o Product Backlog, acertar o que precisar ser acertado
- Não gerar arquivos duplicados, sempre atualizar os existentes
- Não gerar PDFs desatualizados, sempre atualizar os existentes
- Não gerar arquivos com versionamento inconsistente, sempre manter a versão correta
- Não deixar links internos quebrados, sempre validar todos os links
- Não deixar dependências sem rastreabilidade, sempre documentar dependências
- Não deixar atribuição de autoria faltando, sempre documentar o autor
- Não deixar histórico de alterações incompleto, sempre documentar todas as alterações
- Não deixar integridade do projeto comprometida, sempre validar a integridade geral
- Não deixar fidelidade do projeto comprometida, sempre validar a fidelidade geral
- Não deixar padrões de documentação inconsistentes, sempre seguir os padrões estabelecidos
- Não deixar métricas do projeto incompletas, sempre atualizar as métricas
- Não deixar checklist final incompleto, sempre completar o checklist
- Não deixar alterações confirmadas sem documentação, sempre documentar todas as alterações feitas mas sem duplicar arquivos, manter um unico arquivo atualizado
- Não gerar arquivos de auditoria incompletos, sempre documentar todas as validações em um unico arquivo por pasta
- Não gerar arquivos de consolidação incompletos, sempre documentar todas as ações em um unico arquivo por pasta
- Não deixar documentação de continuidade incompleta, sempre atualizar a documentação de continuidade em um unico arquivo 