# WiseWallet Landing Page & Portal Unduhan

Halaman web resmi **WiseWallet**, dibangun dengan web statis ringan (**Vite + HTML5/CSS3/ES Modules + GSAP 3**) agar terbuka instan tanpa loading lama dan mulus saat di-scroll di HP maupun desktop.

Dirancang untuk dideploy otomatis ke GitHub Pages pada repositori publik `https://github.com/Khairul2991/wisewallet-web`.

## Menjalankan Secara Lokal

```bash
npm install
npm run dev
```

## Verifikasi & Build Produksi

```bash
npm run check
npm run build
npm run preview
```

## Deploy ke GitHub Pages (`Khairul2991/wisewallet-web`)

1. Dari dalam folder `landing/`:
   ```bash
   git init -b main
   git add .
   git commit -m "feat: WiseWallet landing page"
   git remote add origin https://github.com/Khairul2991/wisewallet-web.git
   git push -u origin main
   ```
2. Di GitHub **`Khairul2991/wisewallet-web`**, buka **Settings > Pages > Source** lalu pilih **GitHub Actions**. Situs langsung tayang di `https://khairul2991.github.io/wisewallet-web/`.
3. Untuk mengaktifkan tombol unduh APK, buat **Release** di `Khairul2991/wisewallet-web` dan unggah 4 file APK rilis (`app-arm64-v8a-release.apk`, `app-armeabi-v7a-release.apk`, `app-x86_64-release.apk`, `app-release.apk`).
