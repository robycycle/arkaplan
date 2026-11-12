# Pardus Lab - Arka Plan Kilitleme

Pardus 21 GNOME'da masaüstü arka planını sabitler ve öğrencilerin Ayarlar'dan değiştirmesini engeller.

## Kurulum

### 1. Öğrenci hesabında yetki kontrolü

Öğrenci hesabıyla giriş yapıp uçbirimi aç (`Ctrl+Alt+T`):

```bash
groups
```

Çıktıda `sudo` yazıyorsa öğrenci kilidi kaldırabilir. Bu durumda BT sorumlusuna haber ver.

### 2. Yönetici hesabıyla giriş yap

Sudo şifresi olan yönetici hesabıyla giriş yap ve uçbirimi aç.

### 3. İnternet kontrolü

```bash
ping -c 2 github.com
```

Cevap geliyorsa devam et.

### 4. Dosyaları indir

```bash
cd /tmp
wget -O arkaplan-kilitle.sh https://raw.githubusercontent.com/robycycle/arkaplan/main/arkaplan-kilitle.sh
wget -O arkaplan.png https://raw.githubusercontent.com/robycycle/arkaplan/main/arkaplan.png
```

### 5. Betiği incele ve çalıştır

```bash
cat arkaplan-kilitle.sh
sudo bash arkaplan-kilitle.sh arkaplan.png
```

Şifre sorar, sonunda "Tamam" yazısını görmelisin.

### 6. Oturumu kapat ve aç

Oturumu kapatıp tekrar aç (ya da bilgisayarı yeniden başlat).

### 7. Kontrol et

- Arka plan yeni görsel olmalı.
- Ayarlar > Arka Plan bölümünde seçenekler gri olmalı ya da değişiklik yapılamamalı.
- Uçbirimde şu komutla `false` görmelisin:

```bash
gsettings writable org.gnome.desktop.background picture-uri
```

### 8. Temizlik (isteğe bağlı)

```bash
rm /tmp/arkaplan-kilitle.sh /tmp/arkaplan.png
```

## Sorun giderme

- **`wget` hata veriyor:** İnternet bağlantısını ya da okul ağının GitHub'ı engelleyip engellemediğini kontrol et.
- **"Görsel bulunamadı" hatası:** Betik ve görsel aynı klasörde (`/tmp`) olmalı, görsel adı `arkaplan.png` olmalı (`ls /tmp`).
- **Arka plan değişti ama seçenekler hâlâ açık:** Oturumu kapatıp açmayı unutmuş olabilirsin ya da öğrenci hesabı `sudo` grubunda olabilir.
- **Geri alma:**

```bash
sudo bash arkaplan-kilitle.sh --geri-al
```

## Not

İlk bilgisayarda dene, çalıştığından emin olunca diğerlerine geç. İş bitince bu repoyu sil ya da Private yap.
