#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./git_prepare_and_push.sh <repo-name> [https|ssh] [github-username] [PAT]
# Defaults:
#   mode=https, username=kulwantgolan
# Examples:
#   ./git_prepare_and_push.sh kodekloudrag                   # HTTPS (will prompt unless PAT stored)
#   ./git_prepare_and_push.sh kodekloudrag https kulwantgolan MY_PAT_HERE
#   ./git_prepare_and_push.sh kodekloudrag ssh   kulwantgolan

REPO="${1:-}"
MODE="${2:-https}"                 # https | ssh
USER="${3:-kulwantgolan}"
PAT="${4:-}"                       # only used for https

if [[ -z "$REPO" ]]; then
  echo "Usage: $0 <repo-name> [https|ssh] [github-username] [PAT]" >&2
  exit 1
fi

echo "==> Using repo: $USER/$REPO over $MODE"

# 1) Git init
git init

# 2) .gitignore (only create if missing)
if [[ ! -f .gitignore ]]; then
cat > .gitignore <<'EOF'
__pycache__/
*.py[cod]
*.pyo
*.pyd
*.so
.python-version
venv/
.venv/
env/
*.log
.coverage
htmlcov/
.pytest_cache/
.mypy_cache/
.dmypy.json
.pyre/
.pytype/
build/
dist/
*.egg-info/
.vscode/
.idea/
.DS_Store
EOF
  echo "==> Wrote .gitignore"
fi

# 3) Add files
git add -A

# Git identity (global, once on this machine)
git config --global user.email "${USER}.com"
git config --global user.name  "${USER}"

# 4) Commit
git commit -m "Initial commit" || true

# 5) Branch main
git branch -M main

# 6) Remote
if [[ "$MODE" == "ssh" ]]; then
  REMOTE_URL="git@github.com:${USER}/${REPO}.git"
else
  REMOTE_URL="https://github.com/${USER}/${REPO}.git"
fi
git remote set-url origin "$REMOTE_URL" 2>/dev/null || git remote add origin "$REMOTE_URL"
echo "==> Remote set to: $REMOTE_URL"

# 7) If HTTPS + PAT provided, store it (plaintext)
if [[ "$MODE" == "https" && -n "$PAT" ]]; then
  git config --global credential.helper store
  printf "https://%s:%s@github.com\n" "$USER" "$PAT" > ~/.git-credentials
  chmod 600 ~/.git-credentials || true
  echo "==> Stored PAT in ~/.git-credentials"
fi

# 8) Push
echo "==> Pushing main ..."
if git push -u origin main; then
  echo "==> Push succeeded."
else
  echo "!! Push failed."
  if [[ "$MODE" == "https" ]]; then
    echo "   - If prompted repeatedly, ensure PAT is valid and has 'repo' (classic) or 'Contents: Read & write' (fine-grained)."
    echo "   - To save PAT later: git config --global credential.helper store; then push and enter creds once."
  else
    echo "   - For SSH, ensure a key is added to GitHub and try: ssh -T git@github.com"
  fi
fi
