# TopERP - Configuração de Backup Automático

Este documento descreve como configurar o backup automático do projeto TopERP.

## Opção 1: Usar launchd (Recomendado para macOS)

### 1.1 Copiar o arquivo plist para LaunchAgents:

```bash
cp /Users/user/Top/TopERP/scripts/com.toperp.backup.plist ~/Library/LaunchAgents/
```

### 1.2 Carregar o serviço:

```bash
launchctl load ~/Library/LaunchAgents/com.toperp.backup.plist
```

### 1.3 Verificar se está rodando:

```bash
launchctl list | grep toperp
```

### 1.4 Para parar o serviço:

```bash
launchctl unload ~/Library/LaunchAgents/com.toperp.backup.plist
```

---

## Opção 2: Usar crontab

### 2.1 Editar crontab:

```bash
crontab -e
```

### 2.2 Adicionar a linha (backup a cada hora):

```cron
0 * * * * /Users/user/Top/TopERP/scripts/backup-git.sh
```

### 2.3 Verificar crontab:

```bash
crontab -l
```

---

## Opção 3: Backup Manual

Execute o script manualmente quando desejar:

```bash
/Users/user/Top/TopERP/scripts/backup-git.sh
```

---

## Logs

Os logs de backup são salvos em:
```
/Users/user/Top/TopERP/scripts/backup.log
```

Para visualizar os últimos backups:
```bash
tail -50 /Users/user/Top/TopERP/scripts/backup.log
```

---

## Configurar Repositório Remoto (Opcional)

Para fazer push automático para GitHub/GitLab:

```bash
cd /Users/user/Top/TopERP
git remote add origin https://github.com/seu-usuario/TopERP.git
git push -u origin main
```

---

## Verificar Status do Repositório

```bash
cd /Users/user/Top/TopERP
git log --oneline -10  # Últimos 10 commits
git status             # Status atual
```
