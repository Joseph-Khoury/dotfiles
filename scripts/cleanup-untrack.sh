#!/usr/bin/env bash
set -euo pipefail

# Always run from the dotfiles repo root
ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

echo "Repo root: $ROOT"
echo "Removing generated/secret/noisy files from Git tracking..."
echo

git rm --cached git_instructions.secret 2>/dev/null || true
git rm --cached -r .config/nvim/test 2>/dev/null || true
git rm --cached -r .config/tmux/plugins 2>/dev/null || true

git rm --cached .DS_Store 2>/dev/null || true
git rm --cached .config/.DS_Store 2>/dev/null || true
git rm --cached .config/nvim/.DS_Store 2>/dev/null || true
git rm --cached .config/nvim/lua/.DS_Store 2>/dev/null || true

git rm --cached nohup.out 2>/dev/null || true
git rm --cached tree.txt 2>/dev/null || true
git rm --cached neovide/neovide-stable.sock 2>/dev/null || true

echo
echo "Done. These files were removed from Git tracking if they were tracked."
echo "They were not deleted from your disk."
echo
echo "Now check:"
echo "  git status --short"
