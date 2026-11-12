#!/bin/bash
# Pardus GNOME - Masaüstü arka planını sabitler ve kilitler.
# Kullanım:  sudo bash arkaplan-kilitle.sh arkaplan.png
# Geri alma: sudo bash arkaplan-kilitle.sh --geri-al

set -e

if [ "$EUID" -ne 0 ]; then
  echo "Lütfen sudo ile çalıştırın: sudo bash $0 arkaplan.png"
  exit 1
fi

DB_DIR="/etc/dconf/db/local.d"
LOCK_DIR="$DB_DIR/locks"
AYAR_DOSYASI="$DB_DIR/00-arkaplan"
KILIT_DOSYASI="$LOCK_DIR/arkaplan"

if [ "$1" = "--geri-al" ]; then
  rm -f "$AYAR_DOSYASI" "$KILIT_DOSYASI"
  dconf update
  echo "Kilit kaldırıldı. Oturumu kapatıp açın."
  exit 0
fi

RESIM="$1"
if [ -z "$RESIM" ] || [ ! -f "$RESIM" ]; then
  echo "Hata: Görsel bulunamadı. Kullanım: sudo bash $0 arkaplan.png"
  exit 1
fi

HEDEF="/usr/share/backgrounds/okul-arkaplan.${RESIM##*.}"

# 1) Görseli sistem klasörüne kopyala
cp "$RESIM" "$HEDEF"
chmod 644 "$HEDEF"

# 2) dconf profili (mevcut dosyayı bozmadan system-db:local ekle)
mkdir -p /etc/dconf/profile
PROFIL="/etc/dconf/profile/user"
if [ ! -f "$PROFIL" ]; then
  printf 'user-db:user\nsystem-db:local\n' > "$PROFIL"
elif ! grep -q '^system-db:local' "$PROFIL"; then
  echo 'system-db:local' >> "$PROFIL"
fi

# 3) Arka plan ayarları
mkdir -p "$DB_DIR" "$LOCK_DIR"
cat > "$AYAR_DOSYASI" <<EOF
[org/gnome/desktop/background]
picture-uri='file://$HEDEF'
picture-uri-dark='file://$HEDEF'
picture-options='zoom'
primary-color='#000000'
secondary-color='#000000'

[org/gnome/desktop/screensaver]
picture-uri='file://$HEDEF'
picture-options='zoom'
EOF

# 4) Kilitler
cat > "$KILIT_DOSYASI" <<EOF
/org/gnome/desktop/background/picture-uri
/org/gnome/desktop/background/picture-uri-dark
/org/gnome/desktop/background/picture-options
/org/gnome/desktop/background/primary-color
/org/gnome/desktop/background/secondary-color
/org/gnome/desktop/screensaver/picture-uri
/org/gnome/desktop/screensaver/picture-options
EOF

# 5) Uygula
dconf update

echo "Tamam. Oturumu kapatıp açın (veya yeniden başlatın)."
echo "Kontrol: gsettings writable org.gnome.desktop.background picture-uri   (false görmelisiniz)"
