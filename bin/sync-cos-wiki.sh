#!/bin/bash
# Auto-sync COS Obsidian wiki via git
# Runs on cron every 5 min; also safe to call manually
VAULT_DIR="$HOME/.local/state/cos/COS/COS"
cd "$VAULT_DIR" || exit 1

# Pull if remote exists (rebase for linear history)
git remote get-url origin &>/dev/null && git pull --rebase --autostash 2>/dev/null

# Exit if nothing changed
if [[ -z $(git status --porcelain) ]]; then
    exit 0
fi

git add -A
git commit -m "auto: vault sync $(date '+%Y-%m-%d %H:%M')"
git remote get-url origin &>/dev/null && git push 2>/dev/null
