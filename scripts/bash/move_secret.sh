#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# move_secret.sh – Stash sensitive files in the project's secrets/ directory 🕵️‍♀️
# -----------------------------------------------------------------------------
# What it does
#   • Shows an interactive UI so you can pick any file inside the project
#     (except those already under secrets/ or .git/) and moves the selection
#     to $SECRET_DIR.
#   • Skips files that are already present in secrets/.
#   • Ensures secrets/ is in .gitignore so the goodies never get pushed.
#
# Requirements
#   • bash 4+
#   • GNU find
#   • One of: fzf  (preferred)  –or–  whiptail/dialog for a simple checklist UI.
#
# Usage
#   chmod +x move_secret.sh
#   ./move_secret.sh
# -----------------------------------------------------------------------------
set -euo pipefail

# ---- Configuration -----------------------------------------------------------
SECRET_DIR="$HOME/Documents/github/home-server/secrets"
PROJECT_DIR="$HOME/Documents/github/home-server" # adjust if your path differs

# ---- Prep --------------------------------------------------------------------
[[ -d "$SECRET_DIR" ]] || {
  echo "[+] Creating secrets directory at $SECRET_DIR"
  mkdir -p "$SECRET_DIR"
}

cd "$PROJECT_DIR"

# ---- Gather candidate files --------------------------------------------------
mapfile -t candidates < <(
  find . \( -path "./secrets" -o -path "./.git" \) -prune -o -type f -print |
    sed 's|^\./||'
)

if [[ ${#candidates[@]} -eq 0 ]]; then
  echo "[!] No files outside secrets/. Nada que mover."
  exit 0
fi

# ---- Interactive selector ----------------------------------------------------
selector() {
  local selections
  if command -v fzf >/dev/null 2>&1; then
    selections=$(printf '%s\n' "${candidates[@]}" |
      fzf --multi \
        --prompt="Select files to stash in secrets ➜ " \
        --preview="bat --style=numbers --color=always {} || cat {}")
  elif command -v whiptail >/dev/null 2>&1; then
    local checklist=()
    for f in "${candidates[@]}"; do
      checklist+=("$f" "$f" "OFF")
    done
    selections=$(whiptail --title "Choose files to hide in secrets" \
      --checklist "<space> to select" 25 78 15 \
      "${checklist[@]}" 3>&1 1>&2 2>&3)
  else
    echo "[✗] UI helper not found – install 'fzf' or 'whiptail'/'dialog'." >&2
    exit 1
  fi
  printf '%s' "$selections"
}

selected=$(selector)

# Normalize to array (handles both space‑separated and newline‑separated output)
IFS=$'\n' read -r -d '' -a files_to_move < <(printf '%s\0' $selected)

if [[ ${#files_to_move[@]} -eq 0 ]]; then
  echo "[i] No files chosen."
  exit 0
fi

# ---- Move them ---------------------------------------------------------------
echo
for src in "${files_to_move[@]}"; do
  dst="$SECRET_DIR/$(basename "$src")"
  if [[ -e "$dst" ]]; then
    echo "⚠️  $(basename "$src") already exists in secrets/, skipping."
  else
    echo "🔒 Moving $src → $dst"
    mv "$src" "$dst"
  fi
done

echo
# ---- Ensure .gitignore has an entry -----------------------------------------
if ! grep -qx "secrets/" .gitignore 2>/dev/null; then
  echo "secrets/" >>.gitignore
  echo "[+] Added 'secrets/' to .gitignore"
fi

echo "✅ Everything is in the secrets directory now. You can delete the original files."
