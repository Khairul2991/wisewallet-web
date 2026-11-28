# WiseWallet Landing Page & Portal Unduhan

Halaman web resmi dan portal unduhan APK Android untuk **WiseWallet**, dibangun dengan web statis ringan (**Vite + HTML5/CSS3/ES Modules + GSAP 3**) yang mendukung Bahasa Indonesia & Inggris serta tema Terang & Gelap.

- **Situs Resmi:** https://khairul2991.github.io/wisewallet/
- **Unduhan APK (GitHub Releases):** https://github.com/Khairul2991/wisewallet/releases

## Fitur Portal

- **Pratinjau Interaktif:** Simulasi fitur utama WiseWallet (Beranda, Kalender, Anggaran, Utang-Piutang, Catat Suara, dan Foto Struk).
- **Ukuran APK Otomatis & Cache 24 Jam:** Ukuran file untuk seluruh varian APK diambil langsung dari GitHub Releases terbaru, dilengkapi snapshot saat build (`src/data/release-sizes-snapshot.json`) dan cache persisten 24 jam di browser (`localStorage`).
- **Deploy Otomatis GitHub Pages:** Workflow `.github/workflows/deploy-pages.yml` berjalan pada setiap `push` ke `main`, jadwal harian (`02:00 UTC` / `09:00 WIB`), dan pemicu manual (`workflow_dispatch`) untuk memperbarui snapshot ukuran APK secara berkala.

## Menjalankan Secara Lokal

```bash
npm install
npm run dev
```

## Sinkronisasi Ukuran, Verifikasi & Build Produksi

```bash
npm run sync-sizes   # Ambil ukuran APK terbaru dari GitHub Releases ke snapshot lokal
npm run check        # Jalankan validasi otomatis (domain math, kontrak rilis, cache, HTML, kontras WCAG AA)
npm run build        # Build produksi ke folder dist/
npm run preview      # Pratinjau hasil build produksi
```

## Alur Rilis APK Baru

1. Buat **Release** baru di `https://github.com/Khairul2991/wisewallet/releases` dengan tag versi (mis. `v1.1.0`, tanpa centang *pre-release* atau *draft*) dan centang **Set as the latest release**.
2. Unggah keempat berkas APK rilis tanpa mengubah namanya:
   - `app-arm64-v8a-release.apk` (HP Android modern, direkomendasikan)
   - `app-armeabi-v7a-release.apk` (HP Android 32-bit lama)
   - `app-x86_64-release.apk` (Chromebook & emulator PC)
   - `app-release.apk` (Universal untuk semua perangkat)
3. Ukuran file di situs akan diperbarui otomatis oleh cache harian browser dan jadwal harian GitHub Actions (atau jalankan workflow **Deploy WiseWallet Landing Page to GitHub Pages** secara manual dari tab **Actions** pada branch `main` untuk pembaruan snapshot instan).
