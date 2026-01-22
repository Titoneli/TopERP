#!/bin/bash

# ============================================================
# TopERP - Script de Backup Automático Git
# ============================================================
# Este script faz commit automático de todas as alterações
# Executar via cron a cada hora ou manualmente
# ============================================================

# Configurações
REPO_DIR="/Users/user/Top/TopERP"
LOG_FILE="$REPO_DIR/scripts/backup.log"
BRANCH="main"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função de log
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Navegar para o diretório do repositório
cd "$REPO_DIR" || {
    log "ERRO: Não foi possível acessar $REPO_DIR"
    exit 1
}

# Verificar se é um repositório git
if [ ! -d ".git" ]; then
    log "ERRO: $REPO_DIR não é um repositório git"
    exit 1
fi

# Verificar se há alterações
if git diff --quiet && git diff --staged --quiet; then
    log "INFO: Nenhuma alteração detectada. Backup não necessário."
    exit 0
fi

# Adicionar todas as alterações
git add -A

# Contar arquivos modificados
MODIFIED=$(git diff --cached --numstat | wc -l | tr -d ' ')

# Criar mensagem de commit com timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
COMMIT_MSG="backup: Auto-backup $TIMESTAMP

📦 Backup automático do TopERP
📅 Data/Hora: $TIMESTAMP
📁 Arquivos alterados: $MODIFIED

Gerado automaticamente pelo script de backup."

# Fazer commit
if git commit -m "$COMMIT_MSG"; then
    log "✅ SUCESSO: Backup realizado com $MODIFIED arquivo(s) alterado(s)"
    echo -e "${GREEN}✅ Backup realizado com sucesso!${NC}"
else
    log "❌ ERRO: Falha ao realizar commit"
    echo -e "${RED}❌ Erro ao realizar backup${NC}"
    exit 1
fi

# Se houver remote configurado, fazer push
if git remote | grep -q "origin"; then
    log "INFO: Tentando push para origin..."
    if git push origin "$BRANCH" 2>/dev/null; then
        log "✅ SUCESSO: Push para origin realizado"
        echo -e "${GREEN}✅ Push para origin realizado!${NC}"
    else
        log "⚠️ AVISO: Push falhou ou não configurado. Backup local OK."
        echo -e "${YELLOW}⚠️ Push não realizado. Backup local OK.${NC}"
    fi
fi

log "----------------------------------------"
exit 0
