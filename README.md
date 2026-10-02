<div align="center">

```text
  ______           _ _   _        _____ _          _ _ 
 |___  /          (_) | | |      / ____| |        | | |
    / / ___ _ __   _| |_| |__   | (___ | |__   ___| | |
   / / / _ \ '_ \ | | __| '_ \   \___ \| '_ \ / _ \ | |
  / /_|  __/ | | || | |_| | | |  ____) | | | |  __/ | |
 /_____\___|_| |_||_|\__|_| |_| |_____/|_| |_|\___|_|_|
```

### ⚡ Zenith Shell — Universal Terminal Theme & Prompt Engine
**Minimalist, blazing-fast (<5ms), cross-platform prompt customizer with built-in theme presets.**

[![Platform: Linux](https://img.shields.io/badge/Platform-Linux%20%7C%20VPS-orange?style=flat-square&logo=linux)](https://github.com/Mizukiranere/zenith-shell)
[![Platform: Android Termux](https://img.shields.io/badge/Platform-Android%20Termux-green?style=flat-square&logo=android)](https://github.com/Mizukiranere/zenith-shell)
[![Platform: Windows PowerShell](https://img.shields.io/badge/Platform-Windows%20PowerShell-blue?style=flat-square&logo=powershell)](https://github.com/Mizukiranere/zenith-shell)
[![Platform: macOS](https://img.shields.io/badge/Platform-macOS%20%7C%20WSL-lightgrey?style=flat-square&logo=apple)](https://github.com/Mizukiranere/zenith-shell)
[![Shell: Bash & Zsh](https://img.shields.io/badge/Shell-Bash%20%7C%20Zsh-blueviolet?style=flat-square&logo=gnubash)](https://github.com/Mizukiranere/zenith-shell)

</div>

---

## 🌟 Mengapa Zenith Shell?

Bosan dengan prompt terminal bawaan yang kaku dan membosankan, atau lelah mengonfigurasi Oh My Zsh / Starship yang berat dan lambat saat di VPS atau Termux?

**Zenith Shell** dirancang untuk menjadi solusi universal satu pintu:
- 🚀 **Nol Dependensi Berat:** Berjalan murni menggunakan skrip shell POSIX dan native PowerShell (kecepatan render render prompt < 5ms).
- 🌐 **Benar-benar Universal:** Berfungsi mulus di **Linux VPS, Android Termux, Windows PowerShell, WSL, macOS, hingga kontainer Docker**.
- 🎨 **Preset Tema Populer:** Siap pakai tema Cyberpunk, Tokyo Night, Catppuccin Mocha, Nord Arctic, Retro Matrix, Dracula, dan Minimalist.
- 📦 **Deteksi Lingkungan Otomatis:** Otomatis menampilkan badge penanda jika Anda sedang berada di server remote SSH (`[VPS]`), Android (`[TERMUX]`), Windows Subsystem (`[WSL]`), atau sebagai root (`[ADMIN]`).
- 🌿 **Git Status Instan:** Menampilkan nama branch aktif beserta indikator status perubahannya (`*` untuk uncommitted changes).
- 🔄 **CLI Ganti Tema Cepat:** Cukup jalankan `zenith set <nama-tema>` untuk berganti suasana tanpa ribet edit file konfigurasi.

---

## ⚡ Instalasi Cepat (One-Line Commands)

### 🐧 Untuk Linux, VPS, Android Termux, macOS, atau WSL:
Buka terminal Anda dan jalankan perintah satu baris ini:
```bash
curl -sSL https://raw.githubusercontent.com/Mizukiranere/zenith-shell/main/install.sh | bash
```

Setelah selesai, aktifkan langsung dengan:
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

## 🛠️ Cara Penggunaan CLI (`zenith`)

Setelah terpasang, perintah `zenith` dapat langsung dipanggil di shell mana pun:

```bash
# Melihat daftar semua tema yang tersedia
zenith list

# Mengganti tema aktif
zenith set tokyonight
zenith set cyberpunk
zenith set catppuccin

# Menampilkan pratinjau warna semua tema di terminal
zenith preview

# Melihat informasi sistem dan shell yang terdeteksi
zenith info
```

---

## ⚙️ Cara Kerja & Arsitektur

```text
[ Terminal Prompt Execution ]
         │
         ├── Deteksi Lingkungan: VPS? Termux? WSL? Local?
         ├── Deteksi Git: Cabang HEAD & Dirty Tree (*)
         ├── Baca Tema Aktif: ~/.zenith/current_theme
         └── Render ANSI 2-Line Prompt:
             Line 1: [ENV] user@host ~/path  branch*
             Line 2: ➜ ❯ <kursor pengguna>
```

---

## 🗑️ Cara Uninstall (Jika Diperlukan)

**Di Linux / Termux / VPS:**
```bash
rm -rf ~/.zenith ~/.local/bin/zenith
# Hapus baris 'source ~/.zenith/core/zenith.sh' di ~/.bashrc atau ~/.zshrc
```

**Di Windows PowerShell:**
```powershell
Remove-Item -Recurse -Force "$HOME\.zenith"
# Hapus baris 'zenith.ps1' dari profil Anda ($PROFILE)
```

---

## 📄 Lisensi
Dibuat dengan dedikasi oleh [Mizukiranere](https://github.com/Mizukiranere). Lisensi MIT.
