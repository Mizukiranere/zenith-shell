#!/usr/bin/env bash
# ==============================================================================
# Zenith Shell Universal Installer (Linux, VPS, Termux, macOS, WSL)
# https://github.com/Mizukiranere/zenith-shell
# ==============================================================================

set -e

ZENITH_HOME="$HOME/.zenith"
REPO_URL="https://github.com/Mizukiranere/zenith-shell.git"

print_banner() {
  printf "\033[1;36m"
  cat << "EOF"
  ______           _ _   _        _____ _          _ _ 
 |___  /          (_) | | |      / ____| |        | | |
    / / ___ _ __   _| |_| |__   | (___ | |__   ___| | |
   / / / _ \ '_ \ | | __| '_ \   \___ \| '_ \ / _ \ | |
  / /_|  __/ | | || | |_| | | |  ____) | | | |  __/ | |
 /_____\___|_| |_||_|\__|_| |_| |_____/|_| |_|\___|_|_|
EOF
  printf "\033[0m\n"
  printf "  \033[1;35mUniversal Terminal Theme & Prompt Engine\033[0m\n"
  printf "  \033[0;37mLinux • VPS • Termux • macOS • WSL\033[0m\n\n"
}

print_banner

printf "🚀 Installing Zenith Shell...\n"

# Clone or Update Zenith repo
if [ -d "$ZENITH_HOME/.git" ]; then
  printf "🔄 Updating existing Zenith Shell installation...\n"
  git -C "$ZENITH_HOME" pull --quiet
else
  printf "📥 Downloading Zenith Shell to %s...\n" "$ZENITH_HOME"
  rm -rf "$ZENITH_HOME"
  git clone --depth 1 "$REPO_URL" "$ZENITH_HOME" --quiet
fi

# Ensure bin is executable
chmod +x "$ZENITH_HOME/bin/zenith" "$ZENITH_HOME/core/zenith.sh"

# Install binary to PATH
BIN_DIR="$HOME/.local/bin"
if [ -n "$PREFIX" ] && [ -d "$PREFIX/bin" ]; then
  BIN_DIR="$PREFIX/bin"
fi

mkdir -p "$BIN_DIR"
ln -sf "$ZENITH_HOME/bin/zenith" "$BIN_DIR/zenith"

# Hook into Shell configurations
SOURCE_CMD="[ -f \"$ZENITH_HOME/core/zenith.sh\" ] && source \"$ZENITH_HOME/core/zenith.sh\""
HOOK_COUNT=0

if [ -f "$HOME/.bashrc" ] || [ -n "$BASH_VERSION" ]; then
  touch "$HOME/.bashrc"
  if ! grep -q "zenith.sh" "$HOME/.bashrc" 2>/dev/null; then
    printf "\n# Zenith Shell Prompt\n%s\n" "$SOURCE_CMD" >> "$HOME/.bashrc"
    HOOK_COUNT=$((HOOK_COUNT + 1))
  fi
fi

if [ -f "$HOME/.zshrc" ] || [ -n "$ZSH_VERSION" ]; then
  touch "$HOME/.zshrc"
  if ! grep -q "zenith.sh" "$HOME/.zshrc" 2>/dev/null; then
    printf "\n# Zenith Shell Prompt\n%s\n" "$SOURCE_CMD" >> "$HOME/.zshrc"
    HOOK_COUNT=$((HOOK_COUNT + 1))
  fi
fi

# Set default theme if not set
if [ ! -f "$ZENITH_HOME/current_theme" ]; then
  echo "cyberpunk" > "$ZENITH_HOME/current_theme"
fi

printf "\n\033[1;32m✅ Zenith Shell successfully installed!\033[0m\n\n"
printf "👉 To activate right now, run:\n"
printf "   \033[1;33msource ~/.zenith/core/zenith.sh\033[0m\n\n"
printf "👉 To change themes anytime:\n"
printf "   \033[1;36mzenith list\033[0m            (view themes)\n"
printf "   \033[1;36mzenith set tokyonight\033[0m  (switch theme)\n\n"
