#!/usr/bin/env bash
# ==============================================================================
# Zenith Shell - Hardware & System Specs Fetcher for Linux, VPS & Termux
# https://github.com/Mizukiranere/zenith-shell
# ==============================================================================

show_zenith_fetch() {
  local theme="cyberpunk"
  if [ -f "$HOME/.zenith/current_theme" ]; then
    theme=$(cat "$HOME/.zenith/current_theme" 2>/dev/null | tr -d ' \n\r')
  fi

  local user="${USER:-$(whoami)}"
  local host="${HOSTNAME:-$(hostname 2>/dev/null || echo 'localhost')}"

  # Detect OS & Model
  local os_name="Linux"
  local model="Standard Host"

  if [ -n "$PREFIX" ] && [ -d "$PREFIX/bin" ] && command -v getprop >/dev/null 2>&1; then
    local android_ver
    android_ver=$(getprop ro.build.version.release 2>/dev/null || echo "")
    os_name="Android Termux ${android_ver}"
    model=$(getprop ro.product.model 2>/dev/null || echo "Android Device")
  elif [ -f /etc/os-release ]; then
    os_name=$(grep -E '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
    if [ -f /sys/devices/virtual/dmi/id/product_name ]; then
      model=$(cat /sys/devices/virtual/dmi/id/product_name 2>/dev/null)
    elif [ -f /sys/firmware/devicetree/base/model ]; then
      model=$(cat /sys/firmware/devicetree/base/model 2>/dev/null)
    fi
  elif command -v sw_vers >/dev/null 2>&1; then
    os_name=$(sw_vers -productName) $(sw_vers -productVersion)
    model=$(sysctl -n hw.model 2>/dev/null || echo "Mac")
  fi

  [ -z "$model" ] && model="Virtual / Generic System"

  # Detect CPU
  local cpu_name="Processor"
  local cpu_cores=1
  if [ -f /proc/cpuinfo ]; then
    cpu_name=$(grep -m1 "model name" /proc/cpuinfo | cut -d: -f2 | sed -e 's/^[ \t]*//' | tr -s ' ')
    [ -z "$cpu_name" ] && cpu_name=$(grep -m1 "Hardware" /proc/cpuinfo | cut -d: -f2 | sed -e 's/^[ \t]*//')
    cpu_cores=$(grep -c "^processor" /proc/cpuinfo 2>/dev/null || echo 1)
  elif command -v sysctl >/dev/null 2>&1; then
    cpu_name=$(sysctl -n machdep.cpu.brand_string 2>/dev/null)
    cpu_cores=$(sysctl -n hw.ncpu 2>/dev/null || echo 1)
  fi

  # Detect RAM
  local ram_used_mb=0
  local ram_total_mb=0
  local ram_percent=0

  if [ -f /proc/meminfo ]; then
    local total_kb
    local avail_kb
    total_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    avail_kb=$(grep -m1 -E "MemAvailable|MemFree" /proc/meminfo | awk '{print $2}')
    if [ -n "$total_kb" ] && [ -n "$avail_kb" ]; then
      ram_total_mb=$(( total_kb / 1024 ))
      local used_kb=$(( total_kb - avail_kb ))
      ram_used_mb=$(( used_kb / 1024 ))
      if [ $ram_total_mb -gt 0 ]; then
        ram_percent=$(( ram_used_mb * 100 / ram_total_mb ))
      fi
    fi
  fi

  local used_gb
  local total_gb
  used_gb=$(awk "BEGIN {printf \"%.2f\", $ram_used_mb/1024}")
  total_gb=$(awk "BEGIN {printf \"%.2f\", $ram_total_mb/1024}")

  # Visual 10-segment RAM bar
  local filled=$(( ram_percent / 10 ))
  local empty=$(( 10 - filled ))
  [ $empty -lt 0 ] && empty=0
  local ram_bar=""
  for ((i=0; i<filled; i++)); do ram_bar="${ram_bar}="; done
  for ((i=0; i<empty; i++)); do ram_bar="${ram_bar}-"; done

  # Detect Uptime
  local uptime_str="Available"
  if [ -f /proc/uptime ]; then
    local up_sec
    up_sec=$(cut -d. -f1 /proc/uptime)
    local days=$(( up_sec / 86400 ))
    local hours=$(( (up_sec % 86400) / 3600 ))
    local mins=$(( (up_sec % 3600) / 60 ))
    if [ $days -gt 0 ]; then
      uptime_str="${days}d ${hours}h ${mins}m"
    else
      uptime_str="${hours}h ${mins}m"
    fi
  fi

  # Colors
  local b="\033[38;5;51m"   # Cyan
  local p="\033[38;5;198m"  # Pink
  local k="\033[38;5;141m"  # Purple
  local v="\033[38;5;255m"  # White
  local g="\033[38;5;46m"   # Green
  local y="\033[38;5;226m"  # Yellow
  local r="\033[0m"

  local palette="\033[48;5;196m  \033[48;5;208m  \033[48;5;226m  \033[48;5;46m  \033[48;5;51m  \033[48;5;141m  \033[48;5;201m  \033[0m"

  echo ""
  printf "  %b  ______           _ _   _        %b   %b[USER]%b %s@%s\n" "$b" "$r" "$p" "$r" "$user" "$host"
  printf "  %b |___  /          (_) | | |       %b   %b--------------------------------------%b\n" "$b" "$r" "$b" "$r"
  printf "  %b    / / ___ _ __   _| |_| |__      %b   %b[OS]    :%b %b%s%b\n" "$b" "$r" "$k" "$r" "$v" "$os_name" "$r"
  printf "  %b   / / / _ \\ '_ \\ | | __| '_ \\     %b   %b[HOST]  :%b %b%s%b\n" "$b" "$r" "$k" "$r" "$v" "$model" "$r"
  printf "  %b  / /_|  __/ | | || | |_| | | |    %b   %b[CPU]   :%b %b%s (%s Cores)%b\n" "$b" "$r" "$k" "$r" "$v" "$cpu_name" "$cpu_cores" "$r"
  printf "  %b /_____\\___|_| |_||_|\\__|_| |_|    %b   %b[RAM]   :%b %b[%s]%b %b%s GB / %s GB (%s%%)%b\n" "$b" "$r" "$k" "$r" "$g" "$ram_bar" "$r" "$v" "$used_gb" "$total_gb" "$ram_percent" "$r"
  printf "  %b   ⚡ ZENITH SYSTEM SPECS ⚡      %b   %b[UPTIME]:%b %b%s%b\n" "$p" "$r" "$k" "$r" "$v" "$uptime_str" "$r"
  printf "  %b                                   %b   %b[SHELL] :%b %b%s%b\n" "$b" "$r" "$k" "$r" "$v" "$SHELL" "$r"
  printf "  %b                                   %b   %b[THEME] :%b %b%s%b\n" "$b" "$r" "$k" "$r" "$y" "$theme" "$r"
  printf "                                       %b\n\n" "$palette"
}

# If run directly:
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  show_zenith_fetch
fi
