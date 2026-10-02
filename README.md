<div align="center">

```text
  ______           _ _   _        _____ _          _ _ 
 |___  /          (_) | | |      / ____| |        | | |
    / / ___ _ __   _| |_| |__   | (___ | |__   ___| | |
   / / / _ \ '_ \ | | __| '_ \   \___ \| '_ \ / _ \ | |
  / /_|  __/ | | || | |_| | | |  ____) | | | |  __/ | |
 /_____\___|_| |_||_|\__|_| |_| |_____/|_| |_|\___|_|_|
```

### ⚡ Zenith Shell — Universal Terminal Theme, HUD Prompt & System Specs Engine
**Minimalist, blazing-fast (<5ms), cross-platform prompt customizer with built-in theme presets and native hardware fetcher.**

[![Platform: Linux](https://img.shields.io/badge/Platform-Linux%20%7C%20VPS-orange?style=flat-square&logo=linux)](https://github.com/Mizukiranere/zenith-shell)
[![Platform: Android Termux](https://img.shields.io/badge/Platform-Android%20Termux-green?style=flat-square&logo=android)](https://github.com/Mizukiranere/zenith-shell)
[![Platform: Windows PowerShell](https://img.shields.io/badge/Platform-Windows%20PowerShell-blue?style=flat-square&logo=powershell)](https://github.com/Mizukiranere/zenith-shell)
[![Platform: macOS](https://img.shields.io/badge/Platform-macOS%20%7C%20WSL-lightgrey?style=flat-square&logo=apple)](https://github.com/Mizukiranere/zenith-shell)
[![Shell: Bash & Zsh](https://img.shields.io/badge/Shell-Bash%20%7C%20Zsh-blueviolet?style=flat-square&logo=gnubash)](https://github.com/Mizukiranere/zenith-shell)

</div>

---

## 🌟 Apa Itu Zenith Shell?

Bosan dengan prompt terminal bawaan yang kaku dan membosankan, atau lelah mengonfigurasi *Oh My Zsh* / *Starship* yang berat dan lambat saat di VPS atau Termux?

**Zenith Shell** dirancang untuk menjadi solusi terminal satu pintu:
- 🚀 **Nol Dependensi Berat:** Berjalan murni menggunakan skrip shell POSIX dan native PowerShell (kecepatan render prompt < 5ms).
- 🖥️ **Tampilan HUD Cyberpunk:** Menggunakan format bingkai terminal modern (`╭─ ... ╰─ ...`) lengkap dengan path direktori, nama branch Git, status error, dan jam saat ini (`[HH:mm:ss]`).
- 📊 **Cek Spek Hardware Lengkap (`zenith fetch`):** Seperti *Neofetch* / *Fastfetch* tapi sudah terintegrasi langsung! Menampilkan OS, tipe/model mesin, prosesor CPU, penggunaan RAM dengan visual progress bar, uptime, shell, dan palet warna tema.
- 🌐 **Benar-benar Universal:** Berfungsi mulus di **Linux VPS, Android Termux, Windows PowerShell, WSL, macOS, hingga kontainer Docker**.
- 🎨 **7 Preset Tema Populer:** Siap pakai tema Cyberpunk, Tokyo Night, Catppuccin Mocha, Nord Arctic, Retro Matrix, Dracula, dan Minimalist.
- 📦 **Deteksi Lingkungan Otomatis:** Otomatis menampilkan badge penanda jika Anda sedang berada di server remote SSH (`[VPS]`), Android (`[TERMUX]`), Windows Subsystem (`[WSL]`), atau sebagai root (`[ADMIN]`).

---

## ⚡ Pratinjau Tampilan (Preview)

### 1. Tampilan Prompt HUD (Cyberpunk Style):
```text
╭─ [VPS] ~/projects/zenith-shell ⎇ main* [14:35:10]
╰─➜ ❯
```

### 2. Tampilan Spek Perangkat (`zenith fetch`):
```text
    ______           _ _   _           [USER] user@hostname
   |___  /          (_) | | |          --------------------------------------
      / / ___ _ __   _| |_| |__         [OS]    : Ubuntu 24.04 LTS (x86_64)
     / / / _ \ '_ \ | | __| '_ \        [HOST]  : KVM Virtual Machine
    / /_|  __/ | | || | |_| | | |       [CPU]   : AMD EPYC 7763 64-Core (4 Cores)
   /_____\___|_| |_||_|\__|_| |_|       [RAM]   : [====------] 3.24 GB / 8.00 GB (40%)
     ⚡ ZENITH SYSTEM SPECS ⚡         [UPTIME]: 14d 6h 30m
                                        [SHELL] : /bin/bash 5.2.21
                                        [THEME] : cyberpunk
                                        [██] [██] [██] [██] [██] [██] [██]
```

---

## 🚀 Instalasi Cepat (One-Line Commands)

### 🐧 Untuk Linux, VPS, Android Termux, macOS, atau WSL:
Buka terminal Anda dan jalankan perintah satu baris ini:
```bash
curl -sSL https://raw.githubusercontent.com/Mizukiranere/zenith-shell/main/install.sh | bash
```

Setelah selesai, aktifkan langsung di sesi saat ini dengan:
```bash
source ~/.zenith/core/zenith.sh
```

---

### 🪟 Untuk Windows PowerShell (PowerShell 5.1 & PowerShell 7+):
Buka PowerShell Anda dan jalankan:
```powershell
irm https://raw.githubusercontent.com/Mizukiranere/zenith-shell/main/install.ps1 | iex
```

---

## 🎨 Galeri Tema yang Tersedia

| Tema | Nuansa Warna | Deskripsi |
| :--- | :--- | :--- |
| **`cyberpunk`** *(Default)* | Cyan elektrik, Hot Pink, Kuning Neon | Terinspirasi dari gaya futuristik Night City |
| **`tokyonight`** | Soft Purple, Pastel Blue, Cyan | Tenang, modern, dan sangat nyaman di mata |
| **`catppuccin`** | Lavender, Flamingo, Sapphire | Estetika palet pastel Catppuccin Mocha |
| **`nord`** | Polar Frost, Aurora Green, Arctic Blue | Palet warna dingin Skandinavia dengan kontras bersih |
| **`matrix`** | Green Phosphor & Lime | Tampilan hacker retro klasik ala film The Matrix |
| **`dracula`** | Dracula Purple, Pink, Neon Green | Tema gelap legendaris yang kaya warna |
| **`minimal`** | Monokrom, Abu-abu lembut, Putih | Super bersih, fokus, dan tanpa distraksi |

---

## 🛠️ Perintah CLI (`zenith`)

Setelah terpasang, perintah `zenith` dapat langsung dipanggil di terminal mana pun:

```bash
# Menampilkan spesifikasi lengkap perangkat & sistem saat ini
zenith fetch

# Melihat daftar semua tema yang tersedia
zenith list

# Mengganti tema aktif
zenith set tokyonight
zenith set cyberpunk
zenith set matrix

# Menampilkan pratinjau warna semua tema di terminal
zenith preview

# Melihat informasi sistem dan shell yang terdeteksi
zenith info
```

---

## 📄 Lisensi
Dibuat dengan dedikasi oleh [Mizukiranere](https://github.com/Mizukiranere). Lisensi MIT.
