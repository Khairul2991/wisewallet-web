# WiseWallet Landing Page & APK Distribution Portal

Halaman web resmi untuk **WiseWallet**, dibangun menggunakan **Flutter Web (Dart)** dan dirancang untuk dideploy ke GitHub Pages pada repositori publik `https://github.com/Khairul2991/wisewallet-web`.

Kode sumber aplikasi Android utama WiseWallet tetap aman berada di repositori Private terpisah, sementara repositori publik ini bertugas:
1. Menayangkan landing page interaktif via **GitHub Pages** (`https://khairul2991.github.io/wisewallet-web/`).
2. Menampung berkas rilis APK **split-per-ABI** (hingga 2 GB per berkas) via **GitHub Releases** publik.

## Menjalankan Secara Lokal

```bash
flutter pub get
flutter run -d chrome
```

## Verifikasi & Build Produksi

```bash
dart analyze
flutter test
flutter build web --release --base-href "/wisewallet-web/"
```

## Deploy ke GitHub Pages (`Khairul2991/wisewallet-web`)

1. Dari dalam folder `landing/`, inisialisasi git dan arahkan ke repo publik Anda:
   ```bash
   git init -b main
   git add .
   git commit -m "feat: initial WiseWallet landing page"
   git remote add origin https://github.com/Khairul2991/wisewallet-web.git
   git push -u origin main
   ```
2. Di GitHub (`Khairul2991/wisewallet-web`), buka **Settings > Pages > Build and deployment > Source** lalu pilih **GitHub Actions**.
3. Workflow `.github/workflows/deploy-pages.yml` akan otomatis menguji, membangun, dan mempublikasikan situs ke `https://khairul2991.github.io/wisewallet-web/`.

## Unggah APK Split-per-ABI ke GitHub Releases

1. Dari root proyek aplikasi Flutter WiseWallet (repo Private):
   ```bash
   flutter build apk --release --split-per-abi
   flutter build apk --release
   ```
2. Di repo publik `Khairul2991/wisewallet-web`, buka **Releases > Draft a new release**, buat tag (misal `v1.0.0`), lalu unggah 4 berkas APK dari `build/app/outputs/flutter-apk/`:
   - `app-arm64-v8a-release.apk`
   - `app-armeabi-v7a-release.apk`
   - `app-x86_64-release.apk`
   - `app-release.apk`
3. Setelah rilis dipublikasikan, seluruh tombol unduh per-ABI pada landing page akan langsung mengunduh berkas terbaru via `/releases/latest/download/<nama-apk>`.
4. Untuk memperbarui nomor versi atau ukuran berkas yang tampil di halaman, cukup sunting `lib/config/release_config.dart`.
