# 📋 PROCEDIMENTOS - Dashboard TopBrasil

> **📌 Este é o arquivo ÚNICO de documentação de procedimentos do projeto.**  
> Última atualização: 23/01/2026

---

## 📑 Índice

1. [Credenciais](#-credenciais)
2. [Padrão de Commits](#-padrão-de-commits-obrigatório)
3. [Regras de Desenvolvimento](#-regras-de-desenvolvimento)
4. [Fluxo de Desenvolvimento](#-fluxo-de-desenvolvimento)
5. [Deploy para Cloud Run](#-deploy-para-cloud-run)
6. [Estrutura do Projeto](#-estrutura-do-projeto)
7. [Materialized Views](#-materialized-views)
8. [Logs de Desenvolvimento](#-logs-de-desenvolvimento)
9. [Erros Comuns e Soluções](#-erros-comuns-e-soluções)
10. [Comandos Úteis](#-comandos-úteis)
11. [Funcionalidades](#-funcionalidades)
12. [Guia de Desenvolvimento](#-guia-de-desenvolvimento)

---

## 🔐 Credenciais

### Google Cloud
| Campo | Valor |
|-------|-------|
| Email | gustavo.titoneli@topbrasilpv.com.br |
| Senha | Tito@8282 |
| Projeto | dashboard-boletos-dup |
| Região | us-central1 |

### Banco de Dados PostgreSQL
| Campo | Valor |
|-------|-------|
| Host | 130.211.194.51 |
| Porta | 5432 |
| Database | topbrasil_crm |
| Usuário | topbrasil_admin |
| Senha | Wxin8tfc7ErTxW1iSX40wGWq2Uj3eT3WAJ/lUd76/kU= |

### URL de Produção
```
https://dashboard-boletos-647424983256.us-central1.run.app
```

---

## 📝 Padrão de Commits (OBRIGATÓRIO)

### ⚠️ IMPORTANTE: Todo commit DEVE seguir este padrão

O projeto utiliza **Conventional Commits** com validação automática via **commitlint** + **husky**.

### Formato Obrigatório

```
<tipo>(<escopo>): <descrição>

[corpo opcional]

[rodapé opcional]
```

### Tipos Permitidos

| Tipo | Emoji | Descrição | Exemplo |
|------|-------|-----------|---------|
| `feat` | ⭐ | Nova funcionalidade | `feat(dashboard): adicionar filtro por técnico` |
| `fix` | 🐛 | Correção de bug | `fix(api): corrigir erro de SQL` |
| `refactor` | 🔧 | Refatoração de código | `refactor(service): extrair lógica de cache` |
| `docs` | 📝 | Documentação | `docs: atualizar PROCEDIMENTOS` |
| `style` | 🎨 | Estilo/formatação | `style(css): ajustar cores do tema` |
| `perf` | 🚀 | Otimização de performance | `perf(query): adicionar índices` |
| `test` | ✅ | Testes | `test(api): adicionar testes unitários` |
| `chore` | 📦 | Manutenção/configuração | `chore: atualizar dependências` |
| `ci` | 🔄 | CI/CD | `ci: configurar GitHub Actions` |
| `build` | 🏗️ | Build/compilação | `build: atualizar Dockerfile` |
| `revert` | ⏪ | Reverter commit | `revert: reverter commit abc123` |

### Escopos Sugeridos

| Escopo | Descrição |
|--------|-----------|
| `dashboard` | Componente principal do dashboard |
| `api` | Endpoints e rotas da API |
| `service` | Services do backend |
| `frontend` | Componentes React |
| `database` | Queries e configurações do banco |
| `rastreamento` | Setor Rastreamento |
| `processos` | Setor Processos |
| `config` | Arquivos de configuração |
| `docker` | Docker e containerização |

### Regras

1. ✅ **Tipo em minúsculas**: `feat`, não `Feat` ou `FEAT`
2. ✅ **Sem ponto final**: `adicionar filtro`, não `adicionar filtro.`
3. ✅ **Modo imperativo**: `adicionar`, não `adicionado` ou `adicionando`
4. ✅ **Máximo 100 caracteres** no header
5. ✅ **Descrição clara e concisa**

### Exemplos Corretos ✅

```bash
feat(dashboard): adicionar switcher de setores Processos/Rastreamento
fix(api): corrigir precedência de operadores SQL na query de OS
style(frontend): alterar cores para teal no setor Rastreamento
refactor(service): separar lógica de cache em função dedicada
docs: atualizar PROCEDIMENTOS com padrão de commits
chore: configurar commitlint e husky
perf(database): adicionar índices na tabela de ordens de serviço
```

### Exemplos Incorretos ❌

```bash
# ❌ Falta o tipo
adicionar nova funcionalidade

# ❌ Tipo em maiúsculas
FEAT: nova funcionalidade

# ❌ Com ponto final
feat: adicionar funcionalidade.

# ❌ Muito longo (mais de 100 caracteres)
feat: adicionar uma funcionalidade muito complexa que faz muitas coisas...

# ❌ Passado em vez de imperativo
feat: adicionado novo filtro
```

### 🎯 Boas Práticas: Commits Pequenos e Focados

> **⚠️ REGRA IMPORTANTE**: Sempre fazer commits menores e mais focados, um para cada tipo de alteração.

#### Por que commits pequenos?

| Vantagem | Descrição |
|----------|-----------|
| 📖 **Histórico legível** | Fácil entender o que mudou e quando |
| 🔍 **Revisão fácil** | Code review mais simples e rápido |
| ⏪ **Reversão precisa** | Pode reverter uma alteração específica sem perder outras |
| 🐛 **Debug facilitado** | `git bisect` funciona melhor com commits atômicos |

#### ❌ Evitar: Um commit gigante com tudo

```bash
# ❌ ERRADO - Mistura muitos tipos de alteração
git add .
git commit -m "docs: atualizar documentação"
# Commit com 50 arquivos: features + styles + docs + builds
```

#### ✅ Correto: Vários commits focados

```bash
# ✅ CERTO - Separar por tipo de alteração

# 1. Primeiro commit: feature
git add src/services/nova-feature.ts src/controllers/nova-feature.controller.ts
git commit -m "feat(rastreamento): adicionar OS por cidade"

# 2. Segundo commit: estilos
git add frontend/src/index.css frontend/src/components/Dashboard.tsx
git commit -m "style(theme): implementar cores teal para Rastreamento"

# 3. Terceiro commit: configuração
git add .commitlintrc.json .husky/ package.json
git commit -m "chore(hooks): configurar commitlint e husky"

# 4. Quarto commit: documentação
git add PROCEDIMENTOS.md README.md
git commit -m "docs: unificar documentação em PROCEDIMENTOS.md"

# 5. Por último: build (se necessário versionar)
git add public/
git commit -m "build(frontend): gerar assets de produção"
```

#### 📋 Checklist antes de commitar

- [ ] Estou commitando apenas UM tipo de alteração?
- [ ] A mensagem descreve exatamente o que este commit faz?
- [ ] Se eu precisar reverter, este commit é independente?
- [ ] Arquivos de build (`public/assets/`) estão em commit separado?

### Validação Automática

Ao tentar fazer commit com formato incorreto:
```bash
⧗   input: mensagem incorreta
✖   subject may not be empty [subject-empty]
✖   type may not be empty [type-empty]

✖   found 2 problems, 0 warnings
```

---

## 📄 Geração de PDFs

### Ferramenta

| Item | Valor |
|------|-------|
| **Ferramenta** | mdpdf (via npx) |
| **Versão** | 3.1.0+ |
| **Instalação** | Não requer (usa npx) |

### Comando Básico

```bash
# Navegar até a pasta do arquivo
cd docs/historias-usuario/CRM-Leads

# Gerar PDF (nome igual ao .md)
npx mdpdf US-CRM-LEAD-001.md --output US-CRM-LEAD-001.pdf
```

### Gerar Todos os PDFs de uma Pasta

```bash
# Gerar PDF para todos os arquivos .md da pasta
for file in US-CRM-LEAD-*.md; do
  npx mdpdf "$file" --output "${file%.md}.pdf"
done
```

### Convenções

| Regra | Descrição |
|-------|----------|
| **Nome** | PDF deve ter mesmo nome do .md |
| **Local** | PDF na mesma pasta do .md |
| **Timing** | Gerar quando US estiver "✅ Pronto" |
| **Atualização** | Regerar PDF após alterações no .md |

### Checklist de Geração

- [ ] User Story com status "✅ Pronto"
- [ ] Documento revisado (DDD, ortografia, diagramas)
- [ ] Versão atualizada no documento
- [ ] Comando `npx mdpdf` executado com sucesso
- [ ] PDF verificado (abrir e conferir formatação)
- [ ] Registrado no CONTINUIDADE do módulo

### Exemplos de Uso

```bash
# Exemplo 1: Gerar PDF de uma User Story
cd /Users/user/Top/TopERP/docs/historias-usuario/CRM-Leads
npx mdpdf US-CRM-LEAD-005.md --output US-CRM-LEAD-005.pdf

# Exemplo 2: Verificar se PDF foi gerado
ls -la US-CRM-LEAD-005.pdf

# Exemplo 3: Gerar vários PDFs
for i in 001 002 003 004 005 006; do
  npx mdpdf US-CRM-LEAD-$i.md --output US-CRM-LEAD-$i.pdf
done
```

### Troubleshooting

| Problema | Solução |
|----------|--------|
| "command not found: npx" | Instalar Node.js |
| PDF não gerado | Verificar se arquivo .md existe |
| Formatação quebrada | Verificar diagramas ASCII no .md |
| Emojis não aparecem | Normal em alguns visualizadores |

---

## ⚠️ Regras de Desenvolvimento

### ✅ Obrigatório

| Regra | Descrição |
|-------|-----------|
| 📝 **Comentar código** | Funções e métodos devem ter comentários explicando sua finalidade |
| 📦 **Modularizar** | Separar código em arquivos por responsabilidade |
| 🏷️ **Nomenclatura** | Usar padrões consistentes (camelCase para JS/TS, kebab-case para arquivos) |
| ✔️ **Validar entradas** | Sempre validar dados de entrada em APIs e formulários |
| 📖 **Documentar APIs** | Endpoints devem ter documentação clara |
| 🧪 **Testar antes** | Testar funcionalidades localmente antes de commit |
| 📋 **Consultar docs** | Verificar PROCEDIMENTOS.md antes de começar |
| 🔍 **Verificar erros** | Consultar seção de erros solucionados antes de debugar |

### ❌ Proibido

| Proibição | Motivo |
|-----------|--------|
| 🚫 **Arquivos duplicados** | Não criar arquivos para resolver o mesmo problema |
| 🚫 **Implementar sem consultar** | Sempre verificar documentação e decisões técnicas |
| 🚫 **Pular etapas** | Seguir o fluxo: desenvolver → build → testar → commit |
| 🚫 **Não documentar erros** | Todo erro resolvido deve ser registrado |
| 🚫 **Ignorar decisões** | Respeitar decisões técnicas já tomadas |
| 🚫 **Commit gigante** | Um commit por tipo de alteração |
| 🚫 **`git add .` direto** | Separar arquivos por tipo antes de commitar |

### 📋 Checklist Mental (Antes de Começar)

```
□ Consultei PROCEDIMENTOS.md?
□ Verifiquei erros solucionados similares?
□ Há decisões técnicas que afetam esta tarefa?
□ Sei qual tipo de commit será (feat/fix/style/etc)?
□ Servidor local está rodando para testar?
```

---

## 🔄 Fluxo de Desenvolvimento

### Ciclo Completo de Desenvolvimento

```
┌─────────────────────────────────────────────────────────────────┐
│  1. DESENVOLVER  →  2. BUILD  →  3. TESTAR  →  4. COMMIT/PUSH  │
└─────────────────────────────────────────────────────────────────┘
```

### 1️⃣ ANTES de começar

**⚠️ OBRIGATÓRIO: Verificações antes de iniciar qualquer desenvolvimento**

```
□ Consultei PROCEDIMENTOS.md para entender o contexto?
□ Verifiquei a seção "Erros Solucionados" para problemas similares?
□ Há decisões técnicas que afetam esta tarefa?
□ Sei qual tipo de commit será (feat/fix/style/refactor/docs)?
□ Entendo qual setor será afetado (Processos/Rastreamento)?
```

```bash
# Atualizar branch principal
git checkout main
git pull origin main

# Criar branch para a feature/fix (opcional para pequenas alterações)
git checkout -b feat/nome-da-feature
# ou
git checkout -b fix/nome-do-bug
```

### 2️⃣ DURANTE o desenvolvimento

**📝 Manter durante todo o desenvolvimento:**
- Documentar erros encontrados na seção "Erros Solucionados"
- Registrar decisões técnicas na seção correspondente
- Testar funcionalidades localmente antes de avançar

```bash
# Iniciar servidor local
cd /Users/user/Documents/dashboard_automacao/dashboard-boletos-duplicados
npm run dev
```

### 3️⃣ APÓS finalizar (Build + Commit)

**⚠️ IMPORTANTE: Sempre que o build finalizar SEM ERROS, fazer commit!**

**🎯 LEMBRETE: Commits pequenos e focados! Um commit para cada tipo de alteração.**

```bash
# 1. Build do frontend
cd frontend && npm run build && cp -r dist/* ../public/

# 2. Verificar se build teve sucesso
echo "✅ Build OK - Pronto para commit"

# 3. Verificar arquivos alterados
git status

# 4. ⚠️ SEPARAR commits por tipo de alteração:
#    - Features: arquivos de código novo
#    - Fixes: arquivos corrigidos
#    - Styles: CSS e componentes visuais
#    - Docs: arquivos de documentação
#    - Build: pasta public/ (assets compilados)

# 5. Adicionar arquivos DO MESMO TIPO
git add src/services/arquivo.ts src/controllers/arquivo.ts
git commit -m "feat(escopo): descrição da feature"

# 6. Repetir para outros tipos de alteração
git add frontend/src/index.css
git commit -m "style(theme): descrição do estilo"

git add PROCEDIMENTOS.md README.md
git commit -m "docs: descrição da documentação"

# 7. Push para o repositório
git push origin main
```

### Script Rápido: Build + Commits Separados

```bash
# 1. Primeiro: Build do frontend
cd /Users/user/Documents/dashboard_automacao/dashboard-boletos-duplicados/frontend && \
npm run build && \
cp -r dist/* ../public/ && \
cd .. && \
echo "✅ Build OK!"

# 2. Ver o que mudou
git status

# 3. Fazer commits SEPARADOS por tipo:

# Feature/Fix (código)
git add src/
git commit -m "feat(escopo): descrição"

# Estilo (CSS/visual)
git add frontend/src/index.css frontend/src/components/
git commit -m "style(escopo): descrição"

# Documentação
git add *.md
git commit -m "docs: descrição"

# Build (assets)
git add public/
git commit -m "build(frontend): gerar assets de produção"

# 4. Push tudo de uma vez
git push origin main
```

### 4️⃣ Deploy para Produção

Após push bem-sucedido, fazer deploy:

```bash
# Deploy para Cloud Run
gcloud run deploy dashboard-boletos-dup \
  --source . \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars="DB_HOST=130.211.194.51,DB_PORT=5432,DB_NAME=topbrasil_crm,DB_USER=read_only_web,DB_PASSWORD=D3v@cc3ss2025\$WebR0"
```

---

## 🚀 Deploy para Cloud Run

### 1. Autenticar no GCloud
```bash
gcloud auth login
# Use: gustavo.titoneli@topbrasilpv.com.br / Tito@8282
```

### 2. Configurar projeto
```bash
gcloud config set project dashboard-boletos-dup
```

### 3. Build e Deploy Completo
```bash
# Build completo
./build-all.sh

# Deploy
gcloud run deploy dashboard-boletos-dup \
  --source . \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars="DB_HOST=130.211.194.51,DB_PORT=5432,DB_NAME=topbrasil_crm,DB_USER=read_only_web,DB_PASSWORD=D3v@cc3ss2025\$WebR0"
```

**⚠️ IMPORTANTE**: Não incluir `PORT` nas variáveis de ambiente (Cloud Run define automaticamente).

---

## 📁 Estrutura do Projeto

```
dashboard-boletos-duplicados/
├── src/                          # Backend (Node.js + Express)
│   ├── app.ts                    # Entry point
│   ├── config/database.ts        # Conexão PostgreSQL
│   ├── controllers/              # Controllers
│   │   ├── boletos.controller.ts
│   │   ├── dashboard.controller.ts
│   │   ├── ordens-servico.controller.ts
│   │   └── programacao-envios.controller.ts
│   ├── services/                 # Services
│   │   ├── boletos.service.ts
│   │   ├── ordens-servico.service.ts
│   │   └── programacao-envios.service.ts
│   └── routes/index.ts           # Rotas da API
├── frontend/                     # Frontend (React + Vite)
│   └── src/
│       ├── components/
│       │   └── Dashboard.tsx     # Componente principal
│       ├── services/api.ts       # Chamadas de API
│       ├── types/index.ts        # TypeScript types
│       └── index.css             # Estilos
├── public/                       # Frontend build (servido pelo backend)
├── dist/                         # Backend build
├── .husky/                       # Git hooks
│   └── commit-msg                # Validação de commits
├── .commitlintrc.json            # Regras do commitlint
├── PROCEDIMENTOS.md              # 📌 Este arquivo (documentação principal)
└── README.md                     # Visão geral do projeto
```

---

## 🗄️ Materialized Views

| View | Descrição | Refresh |
|------|-----------|---------|
| mv_veiculos_sem_fechamento_mes_atual | Veículos sem boleto no mês | 15 min |
| mv_os_abertas_por_cidade | OS abertas agrupadas por cidade | Manual |

### Refresh manual:
```sql
REFRESH MATERIALIZED VIEW mv_veiculos_sem_fechamento_mes_atual;
REFRESH MATERIALIZED VIEW mv_os_abertas_por_cidade;
```

---

## 📋 Logs de Desenvolvimento

### 📝 Decisões Técnicas

> Registre aqui decisões arquiteturais importantes para não serem esquecidas.

| Data | Decisão | Motivo |
|------|---------|--------|
| 23/01/2026 | Usar Conventional Commits + commitlint | Padronizar histórico git e facilitar changelog |
| 23/01/2026 | Separar setores Processos/Rastreamento | Organização visual e diferentes domínios de negócio |
| 23/01/2026 | Cores: Laranja (Processos) / Teal (Rastreamento) | Identidade visual distinta por setor |
| 23/01/2026 | Filtros locais no frontend (não server-side) | Performance - dados já carregados, evitar requests |
| 23/01/2026 | Materialized Views para queries pesadas | Performance - cache de queries complexas |
| 23/01/2026 | PROCEDIMENTOS.md como fonte única | Evitar documentação duplicada/desatualizada |

### 🐛 Erros Solucionados (Histórico)

> Quando resolver um bug, documente aqui para referência futura.

| Data | Erro | Causa | Solução |
|------|------|-------|---------|
| 23/01/2026 | Filtro por técnico retornava OS de outros | Precedência SQL: `OR` sem parênteses | Adicionar `()`: `WHERE (A OR B) AND C` |
| 23/01/2026 | Build do frontend não atualizava | Arquivos não copiados para `public/` | Sempre rodar `cp -r dist/* ../public/` |
| 22/01/2026 | Cloud Run: PORT reserved variable | Variável PORT nas env vars | Remover PORT, Cloud Run define auto |

### 📊 Progresso e Funcionalidades Implementadas

| Data | Feature | Status |
|------|---------|--------|
| 23/01/2026 | Switcher de setores (Processos/Rastreamento) | ✅ Concluído |
| 23/01/2026 | OS por Cidade (Rastreamento) | ✅ Concluído |
| 23/01/2026 | Tema Teal para Rastreamento | ✅ Concluído |
| 23/01/2026 | Conventional Commits + commitlint | ✅ Concluído |
| 23/01/2026 | Documentação unificada (PROCEDIMENTOS.md) | ✅ Concluído |

---

## ⚠️ Erros Comuns e Soluções

### 1. "PORT is a reserved variable"
**Causa**: Variável PORT incluída no deploy  
**Solução**: Remover PORT das env vars, Cloud Run define automaticamente

### 2. "Permission denied accessing secret"
**Causa**: Service account sem permissão no Secret Manager  
**Solução**: Usar env vars diretas ao invés de secrets

### 3. "Query read timeout"
**Causa**: Query muito lenta no banco  
**Solução**: Verificar índices nas MVs ou aumentar timeout

### 4. "EADDRINUSE: address already in use"
**Causa**: Porta já em uso localmente  
**Solução**: `lsof -ti:3000 | xargs kill -9`

### 5. Commit rejeitado pelo commitlint
**Causa**: Mensagem não segue o padrão Conventional Commits  
**Solução**: Usar formato `tipo(escopo): descrição`

### 6. Filtro retornando dados incorretos (OR sem parênteses)
**Causa**: Precedência de operadores SQL incorreta  
**Solução**: Sempre usar parênteses em cláusulas OR: `WHERE (A OR B) AND C`

---

## 🔧 Comandos Úteis

### Processos e Portas
```bash
# Matar processos nas portas
lsof -ti:3000 | xargs kill -9
lsof -ti:5173 | xargs kill -9

# Verificar o que está rodando
lsof -i:3000
```

### Build
```bash
# Build completo
./build-all.sh

# Build apenas frontend
cd frontend && npm run build && cp -r dist/* ../public/

# Iniciar servidor local
npm run dev
```

### Git
```bash
# Status
git status --short

# Commit seguindo padrão
git commit -m "feat(escopo): descrição"

# Push
git push origin main

# Ver histórico
git log --oneline -10
```

### Cloud Run
```bash
# Ver logs
gcloud run services logs read dashboard-boletos-dup --region=us-central1

# Ver revisões
gcloud run revisions list --service=dashboard-boletos-dup --region=us-central1

# Testar health
curl https://dashboard-boletos-647424983256.us-central1.run.app/health
```

### Testar API
```bash
# Health check
curl http://localhost:3000/health

# Boletos
curl http://localhost:3000/api/boletos/summary | head -c 200

# OS por cidade com filtro
curl "http://localhost:3000/api/ordens-servico/por-cidade?tecnico=VIGICAR"
```

---

## 📊 Funcionalidades

### Setor Processos (🟠 Laranja)
- Boletos duplicados
- Veículos sem boletos (com cores por dias)
- Programação de envios

### Setor Rastreamento (🟢 Teal)
- Ordens de Serviço por cidade
- Filtros por técnico e cidade
- Filtro "Sem técnico"
- Ordenação por quantidade, cidade, data
- Debounce nos filtros (500ms)

---

## 🎯 Guia de Desenvolvimento

### Regras Obrigatórias

| ✅ Obrigatório | ❌ Proibido |
|---------------|------------|
| Comentar funções explicando propósito | Criar arquivos duplicados |
| Modularizar código em arquivos separados | Implementar sem testar |
| Seguir padrões de nomenclatura | Pular etapas do fluxo |
| Implementar validações de entrada | Não documentar erros |
| Fazer commit após build bem-sucedido | Ignorar padrão de commits |
| Testar localmente antes de deploy | Push sem build |

### Checklist Pré-Commit

- [ ] Build do frontend executou sem erros?
- [ ] Testei a funcionalidade localmente?
- [ ] A mensagem de commit segue o padrão?
- [ ] Adicionei todos os arquivos necessários?

### Checklist Pré-Deploy

- [ ] Commit feito e push realizado?
- [ ] Testei em ambiente local?
- [ ] Variáveis de ambiente corretas?
- [ ] Não incluí PORT nas env vars?

---

## 📜 Histórico de Atualizações

| Data | Tipo | Descrição |
|------|------|-----------|
| 23/01/2026 | feat | Adicionado padrão de commits (commitlint + husky) |
| 23/01/2026 | feat | Unificado CONTRIBUTING.md neste arquivo |
| 23/01/2026 | fix | Corrigido filtro por técnico (precedência SQL) |
| 23/01/2026 | feat | Adicionado setor Rastreamento com tema teal |
| 23/01/2026 | feat | Implementado debounce nos filtros de OS |

---

> **📌 Lembre-se**: Este arquivo é a fonte única de verdade para procedimentos do projeto.  
> Sempre consulte aqui antes de desenvolver ou fazer deploy.
