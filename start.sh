#!/bin/bash

# =======================
# Warna-warna keren
# =======================
CYAN="\033[0;36m"
YELLOW="\033[1;33m"
GREEN="\033[0;32m"
RED="\033[0;31m"
MAGENTA="\033[0;35m"
NC="\033[0m" # reset

# =======================
# Fungsi animasi titik
# =======================
loading() {
    msg=$1
    echo -ne "${CYAN}${msg}${NC}"
    for i in {1..3}; do
        sleep 0.5
        echo -ne "."
    done
    echo -e ""
}

# =======================
# Cek file
# =======================
if [ ! -f "junn.py" ]; then
    echo -e "${RED}[ERROR]${NC} File junn.py tidak ditemukan!"
    exit 1
fi

# =======================
# Clear dan animasi awal
# =======================
clear
loading "🌟 Memeriksa environment"
sleep 0.5
loading "📦 Menginstal module Python yang diperlukan"
pkg update && pkg upgrade -y  >/dev/null 2>&1
pkg install python -y  >/dev/null 2>&1
pkg install python3 -y  >/dev/null 2>&1
pip install -r requirements.txt >/dev/null 2>&1
sleep 0.5
clear

# =======================
# Penjelasan interaktif
# =======================
echo -e "${MAGENTA}══════════════════════════════════════════════${NC}"
echo -e "${YELLOW}📌 INFORMASI PENTING:${NC}"
echo -e "Saat login nanti, kamu harus:"
echo -e " - Input ${GREEN}nomor Telegram${NC}"
echo -e " - Input ${GREEN}kode OTP${NC}"
echo -e " - Input ${GREEN}password 2FA (jika ada)${NC}"
echo -e ""
echo -e "${RED}⚠️ Semua input tidak akan terlihat saat diketik.${NC}"
echo -e "Ketik langsung lalu tekan ENTER."
echo -e ""
echo -e "Jika sudah membaca, ketik ${CYAN}y${NC} untuk melanjutkan."
echo -e "${MAGENTA}══════════════════════════════════════════════${NC}"
echo -e ""
read -p "✅ Ketik 'y' untuk melanjutkan: " confirm

# =======================
# Eksekusi sesuai pilihan
# =======================
if [[ "$confirm" =~ ^[yY]$ ]]; then
    clear
    loading "✨ Menyiapkan Userbot"
    sleep 0.5
    echo -e "${GREEN}✅ Semua siap! Menjalankan Userbot...${NC}"
    python3 junn.py
else
    echo -e "${RED}❌ Dibatalkan.${NC}"
    exit 0
fi