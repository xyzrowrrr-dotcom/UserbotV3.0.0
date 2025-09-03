#!/bin/bash
# Script update otomatis dari GitHub

echo "🔍 Mengecek update terbaru..."
git fetch origin

LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ $LOCAL = $REMOTE ]; then
    echo "✅ Sudah versi terbaru, tidak ada update."
else
    echo "⬇️ Ada update baru, sedang menarik perubahan..."
    git pull
    echo "🚀 Update selesai!"
fi