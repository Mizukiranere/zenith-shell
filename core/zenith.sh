#!/usr/bin/env bash
# ==============================================================================
# Zenith Shell - Universal Prompt Engine for Bash, Zsh, Termux, and VPS
# https://github.com/Mizukiranere/zenith-shell
# ==============================================================================

# Detect Shell
if [ -n "$ZSH_VERSION" ]; then
  ZENITH_SHELL="zsh"
elif [ -n "$BASH_VERSION" ]; then
  ZENITH_SHELL="bash"
else
  ZENITH_SHELL="sh"
fi

# Detect Environment
zenith_detect_env() {
  if [ -n "$PREFIX" ] && [ -d "$PREFIX/bin" ] && [ -f "/data/data/com.termux/files/usr/bin/termux-info" ]; then
    echo "TERMUX"
  elif [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] || [ -n "$SSH_CONNECTION" ]; then
    echo "VPS"
  elif grep -qi microsoft /proc/version 2>/dev/null; then
    echo "WSL"
  elif [ -f /.dockerenv ]; then
    echo "DOCKER"
  else
    echo "LOCAL"
  fi
}

# Load Active Theme Config
ZENITH_DIR="${ZENITH_DIR:-$HOME/.zenith}"
ZENITH_THEME_FILE="$ZENITH_DIR/current_theme"

if [ -f "$ZENITH_THEME_FILE" ]; then
  ZENITH_THEME=$(cat "$ZENITH_THEME_FILE" 2>/dev/null | tr -d ' \n\r')
fi
ZENITH_THEME="${ZENITH_THEME:-cyberpunk}"

# Color Palette Definitions (ANSI 256 / TrueColor compatible)
zenith_load_colors() {
  case "$ZENITH_THEME" in
    tokyonight)
      C_FRAME="\033[38;5;60m"
      C_ENV="\033[38;5;141m"       # Soft Purple
      C_USER="\033[38;5;111m"      # Pastel Blue
      C_DIR="\033[38;5;117m"       # Soft Cyan
      C_GIT="\033[38;5;215m"       # Orange / Peach
      C_GIT_DIRTY="\033[38;5;203m" # Coral Red
      C_TIME="\033[38;5;103m"
      C_SUCCESS="\033[38;5;120m"   # Light Green
      C_ERR="\033[38;5;196m"       # Red
      C_RESET="\033[0m"
      C_ARROW="\033[38;5;141m"
      ;;
    catppuccin)
      C_FRAME="\033[38;5;239m"
      C_ENV="\033[38;5;183m"       # Lavender
      C_USER="\033[38;5;217m"      # Flamingo
      C_DIR="\033[38;5;153m"       # Sapphire Blue
      C_GIT="\033[38;5;223m"       # Peach
      C_GIT_DIRTY="\033[38;5;210m" # Maroon
      C_TIME="\033[38;5;246m"
      C_SUCCESS="\033[38;5;150m"   # Green
      C_ERR="\033[38;5;203m"       # Red
      C_RESET="\033[0m"
      C_ARROW="\033[38;5;183m"
      ;;
    nord)
      C_FRAME="\033[38;5;238m"
      C_ENV="\033[38;5;110m"       # Frost Blue
      C_USER="\033[38;5;109m"      # Polar Frost
      C_DIR="\033[38;5;152m"       # Ice White/Cyan
      C_GIT="\033[38;5;179m"       # Aurora Yellow
      C_GIT_DIRTY="\033[38;5;131m" # Aurora Red
      C_TIME="\033[38;5;243m"
      C_SUCCESS="\033[38;5;108m"   # Aurora Green
      C_ERR="\033[38;5;131m"       # Red
      C_RESET="\033[0m"
      C_ARROW="\033[38;5;110m"
      ;;
    matrix)
      C_FRAME="\033[38;5;22m"
      C_ENV="\033[38;5;46m"        # Neon Green
      C_USER="\033[38;5;34m"       # Mid Green
      C_DIR="\033[38;5;82m"        # Lime Green
      C_GIT="\033[38;5;118m"       # Pale Green
      C_GIT_DIRTY="\033[38;5;196m" # Glitch Red
      C_TIME="\033[38;5;28m"
      C_SUCCESS="\033[38;5;46m"    # Bright Green
      C_ERR="\033[38;5;160m"       # Dark Red
      C_RESET="\033[0m"
      C_ARROW="\033[38;5;46m"
      ;;
    dracula)
      C_FRAME="\033[38;5;60m"
      C_ENV="\033[38;5;141m"       # Dracula Purple
      C_USER="\033[38;5;212m"      # Pink
      C_DIR="\033[38;5;117m"       # Cyan
      C_GIT="\033[38;5;228m"       # Yellow
      C_GIT_DIRTY="\033[38;5;203m" # Red
      C_TIME="\033[38;5;103m"
      C_SUCCESS="\033[38;5;84m"    # Green
      C_ERR="\033[38;5;196m"       # Red
      C_RESET="\033[0m"
      C_ARROW="\033[38;5;212m"
      ;;
    minimal)
      C_FRAME="\033[38;5;238m"
      C_ENV="\033[38;5;244m"       # Muted Grey
      C_USER="\033[38;5;250m"      # Light Grey
      C_DIR="\033[38;5;255m"       # Pure White
      C_GIT="\033[38;5;248m"       # Grey
      C_GIT_DIRTY="\033[38;5;203m" # Red
      C_TIME="\033[38;5;240m"
      C_SUCCESS="\033[38;5;255m"   # White
      C_ERR="\033[38;5;196m"       # Red
      C_RESET="\033[0m"
      C_ARROW="\033[38;5;250m"
      ;;
    cyberpunk|*)
      C_FRAME="\033[38;5;239m"
      C_ENV="\033[38;5;51m"        # Electric Cyan
      C_USER="\033[38;5;198m"      # Hot Pink / Magenta
      C_DIR="\033[38;5;226m"       # Neon Yellow
      C_GIT="\033[38;5;201m"       # Vivid Purple
      C_GIT_DIRTY="\033[38;5;196m" # Red
      C_TIME="\033[38;5;245m"
      C_SUCCESS="\033[38;5;48m"    # Mint Green
      C_ERR="\033[38;5;196m"       # Hot Red
      C_RESET="\033[0m"
      C_ARROW="\033[38;5;51m"
      ;;
  esac
}

# Git Branch & Dirty Check (Lightning Fast)
zenith_git_prompt() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --always 2>/dev/null)
  [ -z "$branch" ] && return

  local git_status=""
  local git_diff
  git_diff=$(git status --porcelain 2>/dev/null | tail -n 5)

  if [ -n "$git_diff" ]; then
    git_status="${C_GIT_DIRTY}*${C_RESET}"
  fi

  printf " ${C_GIT} %s%s${C_RESET}" "$branch" "$git_status"
}

# Working Directory Formatter (Shortened Path)
zenith_formatted_pwd() {
  local p="$PWD"
  local home="$HOME"
  if [ "$p" = "$home" ]; then
    printf "~"
  elif [[ "$p" == "$home"* ]]; then
    printf "~%s" "${p#$home}"
  else
    printf "%s" "$p"
  fi
}

# Build the Universal Zenith HUD Prompt
zenith_render_prompt() {
  local exit_code=$?
  zenith_load_colors

  local env_type
  env_type=$(zenith_detect_env)
  local env_badge=""

  if [ "$env_type" != "LOCAL" ]; then
    env_badge="[${env_type}] "
  fi

  local user_host=""
  if [ "$EUID" -eq 0 ]; then
    user_host="${C_ERR}[ROOT]${C_RESET} "
  elif [ "$env_type" = "VPS" ] || [ -n "$SSH_CONNECTION" ]; then
    user_host="${C_USER}${USER}@\h${C_RESET}:"
  fi

  local status_indicator
  if [ $exit_code -eq 0 ]; then
    status_indicator="${C_SUCCESS}➜${C_RESET}"
  else
    status_indicator="${C_ERR}✘${C_RESET}"
  fi

  local time_str="${C_TIME}[$(date +%H:%M:%S)]${C_RESET}"
  local dir_str="${C_DIR}$(zenith_formatted_pwd)${C_RESET}"
  local git_str
  git_str=$(zenith_git_prompt)

  # Assemble 2-line HUD prompt:
  # ╭─ [ENV] user@host ~/path  branch [HH:MM:SS]
  # ╰─➜ ❯
  if [ "$ZENITH_SHELL" = "bash" ]; then
    PS1="\n${C_FRAME}╭─${C_RESET} ${C_ENV}${env_badge}${C_RESET}${user_host}${dir_str}${git_str} ${time_str}\n${C_FRAME}╰─${C_RESET}${status_indicator} ${C_ARROW}❯${C_RESET} "
  elif [ "$ZENITH_SHELL" = "zsh" ]; then
    PROMPT=$'\n'"${C_FRAME}╭─${C_RESET} ${C_ENV}${env_badge}${C_RESET}${user_host}${dir_str}${git_str} ${time_str}"$'\n'"${C_FRAME}╰─${C_RESET}${status_indicator} ${C_ARROW}❯${C_RESET} "
  fi
}

# Hook into Bash / Zsh
if [ "$ZENITH_SHELL" = "bash" ]; then
  PROMPT_COMMAND=zenith_render_prompt
elif [ "$ZENITH_SHELL" = "zsh" ]; then
  precmd_functions+=(zenith_render_prompt)
fi
