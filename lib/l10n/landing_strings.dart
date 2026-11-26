import 'package:flutter/foundation.dart';
import '../domain/finance_simulator.dart';

enum LandingLocale { id, en }

@immutable
class FaqItem {
  const FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

@immutable
class SpecRow {
  const SpecRow({required this.area, required this.detail});

  final String area;
  final String detail;
}

/// Complete Indonesian (default) and English copy derived strictly from PRD.md,
/// Database.md, and ExternalIntegrations.md. Zero em dashes, zero buzzwords.
@immutable
class LandingStrings {
  const LandingStrings({
    required this.locale,
    required this.brandName,
    required this.navCapture,
    required this.navFinance,
    required this.navReports,
    required this.navSecurity,
    required this.navSpecs,
    required this.navDownload,
    required this.menuLabel,
    required this.closeMenuLabel,
    required this.themeSwitchToDark,
    required this.themeSwitchToLight,
    required this.reducedMotionOn,
    required this.reducedMotionOff,
    required this.heroHeadline,
    required this.heroSubtitle,
    required this.heroPrimaryCta,
    required this.heroSecondaryCta,
    required this.heroFactOffline,
    required this.heroFactNoLogin,
    required this.heroFactAndroid,
    required this.simulationTag,
    required this.replaySplashLabel,
    required this.phoneTabHome,
    required this.phoneTabCalendar,
    required this.phoneTabBudget,
    required this.phoneTabDebts,
    required this.principlesPause,
    required this.principlesPlay,
    required this.principleItems,
    required this.captureTitle,
    required this.captureSubtitle,
    required this.captureTabManual,
    required this.captureTabVoice,
    required this.captureTabOcr,
    required this.manualHeading,
    required this.manualBody,
    required this.manualBullets,
    required this.voiceHeading,
    required this.voiceBody,
    required this.voiceHint,
    required this.voiceDraftTitle,
    required this.voiceDraftDisclaimer,
    required this.ocrHeading,
    required this.ocrBody,
    required this.ocrCropToggle,
    required this.ocrScanButton,
    required this.ocrScanningLabel,
    required this.ocrCleanupNotice,
    required this.coreTitle,
    required this.coreSubtitle,
    required this.coreTabTransfer,
    required this.coreTabBudget,
    required this.coreTabCalendar,
    required this.coreTabDebts,
    required this.coreTabProfiles,
    required this.uiStateLabel,
    required this.uiStateNormal,
    required this.uiStateEmpty,
    required this.uiStateLoading,
    required this.uiStateError,
    required this.emptyStateTitle,
    required this.emptyStateBody,
    required this.emptyStateAction,
    required this.loadingStateTitle,
    required this.loadingStateBody,
    required this.errorStateTitle,
    required this.errorStateBody,
    required this.errorStateAction,
    required this.reportsTitle,
    required this.reportsSubtitle,
    required this.reportsTopCategoryLabel,
    required this.reportsSavingsRateLabel,
    required this.reportsNetCashFlowLabel,
    required this.reportsPdfTab,
    required this.reportsCsvTab,
    required this.reportsPdfLangHint,
    required this.securityTitle,
    required this.securitySubtitle,
    required this.securityModePassword,
    required this.securityModeAccount,
    required this.securityPasswordExplain,
    required this.securityAccountExplain,
    required this.securityBoundaryAppLockTitle,
    required this.securityBoundaryAppLockBody,
    required this.securityBoundaryScreenshotTitle,
    required this.securityBoundaryScreenshotBody,
    required this.securityBoundaryRestoreTitle,
    required this.securityBoundaryRestoreBody,
    required this.specsTitle,
    required this.specsSubtitle,
    required this.specRows,
    required this.faqTitle,
    required this.faqSubtitle,
    required this.faqItems,
    required this.downloadTitle,
    required this.downloadSubtitle,
    required this.downloadRecommendedBadge,
    required this.downloadPrimaryCtaPrefix,
    required this.downloadAllReleasesCta,
    required this.downloadCheckAbiCta,
    required this.downloadAbiGuideTitle,
    required this.downloadAbiGuideBody,
    required this.downloadIosNote,
    required this.footerEthos,
    required this.footerCopyright,
  });

  final LandingLocale locale;
  final String brandName;
  final String navCapture;
  final String navFinance;
  final String navReports;
  final String navSecurity;
  final String navSpecs;
  final String navDownload;
  final String menuLabel;
  final String closeMenuLabel;
  final String themeSwitchToDark;
  final String themeSwitchToLight;
  final String reducedMotionOn;
  final String reducedMotionOff;
  final String heroHeadline;
  final String heroSubtitle;
  final String heroPrimaryCta;
  final String heroSecondaryCta;
  final String heroFactOffline;
  final String heroFactNoLogin;
  final String heroFactAndroid;
  final String simulationTag;
  final String replaySplashLabel;
  final String phoneTabHome;
  final String phoneTabCalendar;
  final String phoneTabBudget;
  final String phoneTabDebts;
  final String principlesPause;
  final String principlesPlay;
  final List<String> principleItems;
  final String captureTitle;
  final String captureSubtitle;
  final String captureTabManual;
  final String captureTabVoice;
  final String captureTabOcr;
  final String manualHeading;
  final String manualBody;
  final List<String> manualBullets;
  final String voiceHeading;
  final String voiceBody;
  final String voiceHint;
  final String voiceDraftTitle;
  final String voiceDraftDisclaimer;
  final String ocrHeading;
  final String ocrBody;
  final String ocrCropToggle;
  final String ocrScanButton;
  final String ocrScanningLabel;
  final String ocrCleanupNotice;
  final String coreTitle;
  final String coreSubtitle;
  final String coreTabTransfer;
  final String coreTabBudget;
  final String coreTabCalendar;
  final String coreTabDebts;
  final String coreTabProfiles;
  final String uiStateLabel;
  final String uiStateNormal;
  final String uiStateEmpty;
  final String uiStateLoading;
  final String uiStateError;
  final String emptyStateTitle;
  final String emptyStateBody;
  final String emptyStateAction;
  final String loadingStateTitle;
  final String loadingStateBody;
  final String errorStateTitle;
  final String errorStateBody;
  final String errorStateAction;
  final String reportsTitle;
  final String reportsSubtitle;
  final String reportsTopCategoryLabel;
  final String reportsSavingsRateLabel;
  final String reportsNetCashFlowLabel;
  final String reportsPdfTab;
  final String reportsCsvTab;
  final String reportsPdfLangHint;
  final String securityTitle;
  final String securitySubtitle;
  final String securityModePassword;
  final String securityModeAccount;
  final String securityPasswordExplain;
  final String securityAccountExplain;
  final String securityBoundaryAppLockTitle;
  final String securityBoundaryAppLockBody;
  final String securityBoundaryScreenshotTitle;
  final String securityBoundaryScreenshotBody;
  final String securityBoundaryRestoreTitle;
  final String securityBoundaryRestoreBody;
  final String specsTitle;
  final String specsSubtitle;
  final List<SpecRow> specRows;
  final String faqTitle;
  final String faqSubtitle;
  final List<FaqItem> faqItems;
  final String downloadTitle;
  final String downloadSubtitle;
  final String downloadRecommendedBadge;
  final String downloadPrimaryCtaPrefix;
  final String downloadAllReleasesCta;
  final String downloadCheckAbiCta;
  final String downloadAbiGuideTitle;
  final String downloadAbiGuideBody;
  final String downloadIosNote;
  final String footerEthos;
  final String footerCopyright;

  static const List<VoicePreset> voicePresets = [
    VoicePreset(
      id: 'coffee',
      spokenPhrase: 'Beli es kopi susu goceng pakai GoPay sore tadi',
      typeId: 'Pengeluaran',
      typeEn: 'Expense',
      isIncome: false,
      amount: 5000,
      categoryId: 'Makanan',
      categoryEn: 'Food',
      wallet: 'GoPay',
      dateLabelId: 'Hari ini (lokal)',
      dateLabelEn: 'Today (local)',
      timeLabel: '16:30',
      description: 'Es kopi susu',
      notes: '',
      reviewHintId: 'Jam diperkirakan dari frasa "sore tadi". Anda dapat mengubahnya sebelum simpan.',
      reviewHintEn: 'Time estimated from "sore tadi". Review or edit before saving.',
      isEstimatedTime: true,
    ),
    VoicePreset(
      id: 'salary',
      spokenPhrase: 'Terima proyek desain dua juta masuk Bank BCA catatan dp tahap satu',
      typeId: 'Pemasukan',
      typeEn: 'Income',
      isIncome: true,
      amount: 2000000,
      categoryId: 'Freelance',
      categoryEn: 'Freelance',
      wallet: 'Bank BCA',
      dateLabelId: 'Hari ini (lokal)',
      dateLabelEn: 'Today (local)',
      timeLabel: '14:10',
      description: 'Proyek desain',
      notes: 'dp tahap satu',
      reviewHintId: 'Seluruh 7 field cocok dengan kategori dan dompet aktif. Siap ditinjau dan disimpan.',
      reviewHintEn: 'All 7 fields matched active categories and wallets. Ready for confirmation.',
      isEstimatedTime: false,
    ),
    VoicePreset(
      id: 'dinner',
      spokenPhrase: 'Makan malam warteg kemarin malam ceban tunai',
      typeId: 'Pengeluaran',
      typeEn: 'Expense',
      isIncome: false,
      amount: 10000,
      categoryId: 'Makanan',
      categoryEn: 'Food',
      wallet: 'Tunai',
      dateLabelId: 'Kemarin (lokal)',
      dateLabelEn: 'Yesterday (local)',
      timeLabel: '20:00',
      description: 'Makan malam warteg',
      notes: '',
      reviewHintId: 'Disambiguasi waktu ganda: "kemarin malam" mengisi tanggal & jam, "Makan malam" tetap utuh di deskripsi.',
      reviewHintEn: 'Double-time disambiguation: "kemarin malam" sets date & time while "Makan malam" stays in description.',
      isEstimatedTime: true,
    ),
    VoicePreset(
      id: 'fuel',
      spokenPhrase: 'Isi bensin motor goban lewat Livin pagi ini',
      typeId: 'Pengeluaran',
      typeEn: 'Expense',
      isIncome: false,
      amount: 50000,
      categoryId: 'Transportasi',
      categoryEn: 'Transport',
      wallet: 'Bank Mandiri (Livin)',
      dateLabelId: 'Hari ini (lokal)',
      dateLabelEn: 'Today (local)',
      timeLabel: '08:00',
      description: 'Isi bensin motor',
      notes: '',
      reviewHintId: 'Alias dompet "Livin" dan nominal slang "goban" dikenali secara deterministik di perangkat.',
      reviewHintEn: 'Wallet alias "Livin" and slang amount "goban" parsed deterministically on-device.',
      isEstimatedTime: true,
    ),
  ];

  static const List<OcrReceiptPreset> ocrPresets = [
    OcrReceiptPreset(
      id: 'mart',
      labelId: 'Struk Minimarket',
      labelEn: 'Minimarket Receipt',
      merchant: 'Alfamart Sudirman',
      rawLines: [
        'ALFAMART SUDIRMAN 042',
        '20/10/2026  14:15',
        'ROTI TAWAR GANDUM     18.500',
        'SUSU UHT 1L           16.000',
        'TOTAL                 34.500',
        'TUNAI                 50.000',
      ],
      extractedDate: '2026-10-20',
      extractedTime: '14:15',
      totalAmount: 34500,
      categoryId: 'Belanja',
      categoryEn: 'Shopping',
      notes: 'Roti tawar gandum, Susu UHT 1L',
    ),
    OcrReceiptPreset(
      id: 'cafe',
      labelId: 'Struk Kedai Kopi',
      labelEn: 'Coffee Shop Receipt',
      merchant: 'Kopi Ruang Tengah',
      rawLines: [
        'KOPI RUANG TENGAH',
        '24/10/2026  09:42',
        'AMERICANO ICED        28.000',
        'CROISSANT BUTTER      24.000',
        'GRAND TOTAL           52.000',
      ],
      extractedDate: '2026-10-24',
      extractedTime: '09:42',
      totalAmount: 52000,
      categoryId: 'Makanan',
      categoryEn: 'Food',
      notes: 'Americano Iced, Croissant Butter',
    ),
  ];

  static LandingStrings of(LandingLocale locale) =>
      locale == LandingLocale.en ? _en : _id;

  List<String> allVisibleTexts() {
    return [
      brandName,
      navCapture,
      navFinance,
      navReports,
      navSecurity,
      navSpecs,
      navDownload,
      menuLabel,
      closeMenuLabel,
      themeSwitchToDark,
      themeSwitchToLight,
      reducedMotionOn,
      reducedMotionOff,
      heroHeadline,
      heroSubtitle,
      heroPrimaryCta,
      heroSecondaryCta,
      heroFactOffline,
      heroFactNoLogin,
      heroFactAndroid,
      simulationTag,
      replaySplashLabel,
      phoneTabHome,
      phoneTabCalendar,
      phoneTabBudget,
      phoneTabDebts,
      principlesPause,
      principlesPlay,
      ...principleItems,
      captureTitle,
      captureSubtitle,
      captureTabManual,
      captureTabVoice,
      captureTabOcr,
      manualHeading,
      manualBody,
      ...manualBullets,
      voiceHeading,
      voiceBody,
      voiceHint,
      voiceDraftTitle,
      voiceDraftDisclaimer,
      ocrHeading,
      ocrBody,
      ocrCropToggle,
      ocrScanButton,
      ocrScanningLabel,
      ocrCleanupNotice,
      coreTitle,
      coreSubtitle,
      coreTabTransfer,
      coreTabBudget,
      coreTabCalendar,
      coreTabDebts,
      coreTabProfiles,
      uiStateLabel,
      uiStateNormal,
      uiStateEmpty,
      uiStateLoading,
      uiStateError,
      emptyStateTitle,
      emptyStateBody,
      emptyStateAction,
      loadingStateTitle,
      loadingStateBody,
      errorStateTitle,
      errorStateBody,
      errorStateAction,
      reportsTitle,
      reportsSubtitle,
      reportsTopCategoryLabel,
      reportsSavingsRateLabel,
      reportsNetCashFlowLabel,
      reportsPdfTab,
      reportsCsvTab,
      reportsPdfLangHint,
      securityTitle,
      securitySubtitle,
      securityModePassword,
      securityModeAccount,
      securityPasswordExplain,
      securityAccountExplain,
      securityBoundaryAppLockTitle,
      securityBoundaryAppLockBody,
      securityBoundaryScreenshotTitle,
      securityBoundaryScreenshotBody,
      securityBoundaryRestoreTitle,
      securityBoundaryRestoreBody,
      specsTitle,
      specsSubtitle,
      ...specRows.expand((r) => [r.area, r.detail]),
      faqTitle,
      faqSubtitle,
      ...faqItems.expand((f) => [f.question, f.answer]),
      downloadTitle,
      downloadSubtitle,
      downloadRecommendedBadge,
      downloadPrimaryCtaPrefix,
      downloadAllReleasesCta,
      downloadCheckAbiCta,
      downloadAbiGuideTitle,
      downloadAbiGuideBody,
      downloadIosNote,
      footerEthos,
      footerCopyright,
    ];
  }

  static const LandingStrings _id = LandingStrings(
    locale: LandingLocale.id,
    brandName: 'WiseWallet',
    navCapture: 'Pencatatan',
    navFinance: 'Keuangan',
    navReports: 'Laporan',
    navSecurity: 'Keamanan',
    navSpecs: 'Spesifikasi',
    navDownload: 'Unduh APK',
    menuLabel: 'Menu',
    closeMenuLabel: 'Tutup menu',
    themeSwitchToDark: 'Beralih ke tema gelap',
    themeSwitchToLight: 'Beralih ke tema terang',
    reducedMotionOn: 'Gerak dikurangi aktif',
    reducedMotionOff: 'Kurangi gerak',
    heroHeadline: 'Keuangan pribadi di perangkat Anda, cepat dan sepenuhnya offline.',
    heroSubtitle:
        'WiseWallet menyimpan seluruh pemasukan, pengeluaran, dompet, anggaran, utang-piutang, dan multi-profil di SQLite lokal tanpa login wajib. Dilengkapi dikte suara offline, pindai foto struk PaddleOCR, laporan PDF/CSV lokal, dan backup cloud terenkripsi AES-256-GCM opsional.',
    heroPrimaryCta: 'Unduh APK Android',
    heroSecondaryCta: 'Coba Simulasi Fitur',
    heroFactOffline: 'SQLite lokal (Drift), 100% jalan tanpa internet',
    heroFactNoLogin: 'Langsung pakai tanpa daftar akun',
    heroFactAndroid: 'Android 7.0+ (API 24) · ID & EN',
    simulationTag: 'Simulasi Interaktif',
    replaySplashLabel: 'Putar Ulang Animasi Logo',
    phoneTabHome: 'Beranda',
    phoneTabCalendar: 'Kalender',
    phoneTabBudget: 'Anggaran',
    phoneTabDebts: 'Utang',
    principlesPause: 'Jeda pita',
    principlesPlay: 'Putar pita',
    principleItems: [
      'SQLite Lokal = Sumber Kebenaran Utama',
      'Tanpa Login Wajib & Tanpa Server WiseWallet',
      'Dikte Suara Offline (SpeechRecognizer + whisper.cpp)',
      'Pindai Struk Offline (PaddleOCR PP-OCRv4)',
      'Backup Cloud Opsional, Bukan Sinkronisasi Otomatis',
      'Enkripsi AES-256-GCM + PBKDF2 600.000 Iterasi',
      'Multi-Profil Lokal Terisolasi (Schema v11)',
      'Dwibahasa Instan: Bahasa Indonesia & English',
    ],
    captureTitle: 'Tiga cara mencatat transaksi, semuanya diproses lokal di HP Anda.',
    captureSubtitle:
        'Pilih cara tercepat sesuai situasi. Baik input manual, dikte suara Bahasa Indonesia, maupun pindai foto struk selalu berakhir di draft yang Anda tinjau sebelum disimpan.',
    captureTabManual: '1. Form Manual',
    captureTabVoice: '2. Dikte Suara Offline',
    captureTabOcr: '3. Pindai Struk OCR',
    manualHeading: 'Catat secepat membuka aplikasi, dengan waktu kalender lokal presisi.',
    manualBody:
        'Transaksi memakai tanggal kalender lokal (YYYY-MM-DD) dan jam lokal (HH:mm) secara terpisah dari audit timestamp UTC, sehingga tanggal belanja tidak pernah bergeser saat berpindah zona waktu.',
    manualBullets: [
      'Validasi nominal integer Rupiah positif, deskripsi wajib, catatan opsional hingga 500 karakter.',
      'Pencarian lokal cepat dengan sorotan kata kunci (WiseHighlightedText), filter kombinasi tipe, kategori, dompet, dan rentang tanggal.',
      'Kategori bawaan dan kustom bisa diatur urutannya lewat drag-and-drop dan langsung konsisten di seluruh dropdown.',
    ],
    voiceHeading: 'Ucapkan transaksi dengan bahasa sehari-hari, tanpa internet dan tanpa cloud AI.',
    voiceBody:
        'Menggunakan arsitektur Hybrid Offline-Only: Tier 1 memakai SpeechRecognizer on-device Android 13+ (id-ID), dan Tier 2 memakai whisper.cpp v1.9.5 + maleo-ai/whisper-tiny-id terbundel di APK untuk Android 7 hingga 12. Audio hanya hidup di RAM dan langsung dibersihkan (zeroed) saat sesi selesai.',
    voiceHint: 'Pilih contoh ucapan di bawah untuk menguji parser deterministik:',
    voiceDraftTitle: 'Draft Transaksi Hasil Parser Lokal',
    voiceDraftDisclaimer:
        'Tidak pernah menyimpan otomatis. Data di atas adalah simulasi interaktif dari VoiceTransactionParser.',
    ocrHeading: 'Foto struk belanja, crop area penting, ekstrak nominal dengan PaddleOCR lokal.',
    ocrBody:
        'Mesin PaddleOCR PP-OCRv4 Mobile ONNX dibundel langsung di APK. Mendukung kamera maupun galeri, editor crop offline, normalisasi orientasi EXIF, dan rekonstruksi baris spasial agar nama item dan nominal tidak terputus.',
    ocrCropToggle: 'Aktifkan Crop Area Total',
    ocrScanButton: 'Pindai Struk Offline',
    ocrScanningLabel: 'Memindai baris teks secara lokal...',
    ocrCleanupNotice:
        'Privasi ketat: berkas gambar sementara (receipt_*) langsung dihapus dari cache begitu proses OCR selesai atau dibatalkan.',
    coreTitle: 'Mesin finansial lengkap dengan aturan akuntansi yang konsisten.',
    coreSubtitle:
        'Setiap angka pada saldo dompet, arus kas bersih, anggaran, kalender, dan utang-piutang dihitung ulang dari data transaksi sumber secara deterministik. Coba tiap modul di bawah ini.',
    coreTabTransfer: 'Dompet & Transfer',
    coreTabBudget: 'Anggaran',
    coreTabCalendar: 'Kalender & Berulang',
    coreTabDebts: 'Utang & Piutang',
    coreTabProfiles: 'Multi-Profil',
    uiStateLabel: 'Uji state UI aplikasi:',
    uiStateNormal: 'Data Simulasi',
    uiStateEmpty: 'State Kosong',
    uiStateLoading: 'State Memuat',
    uiStateError: 'State Galat',
    emptyStateTitle: 'Belum ada transaksi pada periode ini.',
    emptyStateBody:
        'Setiap layar inti WiseWallet menyediakan empty state yang menjelaskan langkah awal dengan satu tombol aksi langsung.',
    emptyStateAction: 'Kembali ke Simulasi Data',
    loadingStateTitle: 'Memuat ringkasan dari SQLite lokal...',
    loadingStateBody:
        'Antarmuka memakai indikator muat terstruktur agar tata letak tidak melonjak saat agregasi berlangsung.',
    errorStateTitle: 'Gagal memuat data lokal. Silakan coba lagi.',
    errorStateBody:
        'Pesan error selalu ramah pengguna dalam bahasa aktif tanpa pernah membocorkan stack trace, kueri SQL, atau token.',
    errorStateAction: 'Coba Lagi',
    reportsTitle: 'Laporan deterministik dan ekspor PDF/CSV langsung dari perangkat.',
    reportsSubtitle:
        'Pahami pola keuangan dari data aktual tanpa penilaian menghakimi. WiseWallet memakai istilah deskriptif seperti "Kategori dengan Pengeluaran Terbesar" dan "Batas harian tersisa".',
    reportsTopCategoryLabel: 'Kategori dengan Pengeluaran Terbesar',
    reportsSavingsRateLabel: 'Rasio Tabungan (Savings Rate)',
    reportsNetCashFlowLabel: 'Arus Kas Bersih Bulan Ini',
    reportsPdfTab: 'Laporan PDF Multi-Halaman',
    reportsCsvTab: 'Ekspor CSV (RFC 4180)',
    reportsPdfLangHint: 'Ubah bahasa dokumen PDF secara instan (Phase 19):',
    securityTitle: 'Privasi berlapis: keamanan akses lokal terpisah dari enkripsi backup cloud.',
    securitySubtitle:
        'Cloud Firestore hanya dipakai sebagai repositori backup terenkripsi opsional saat Anda menautkan akun Google. Tidak ada sinkronisasi otomatis dan tidak ada server backend milik WiseWallet.',
    securityModePassword: 'Dengan Password (Zero-Knowledge)',
    securityModeAccount: 'Tanpa Password (Account Recovery v2)',
    securityPasswordExplain:
        'Two-Tier Key Architecture: payload dienkripsi dengan kunci acak 256-bit (BEK) memakai AES-256-GCM (nonce 96-bit, tag 128-bit), lalu BEK dibungkus dengan KEK hasil PBKDF2-HMAC-SHA256 sebanyak 600.000 iterasi dari kata sandi pemulihan Anda. Tanpa backdoor; Google maupun admin Firebase tidak dapat membaca isi cadangan tanpa sandi Anda.',
    securityAccountExplain:
        'Payload tetap dienkripsi dengan AES-256-GCM memakai kunci acak 256-bit baru per cadangan, disimpan atomik pada dokumen users/{uid}/backups/{backupId} yang dilindungi Firebase Auth dan Firestore Security Rules per UID. Cukup login Google yang sama saat ganti HP, namun mode ini bukan zero-knowledge terhadap admin proyek.',
    securityBoundaryAppLockTitle: 'App Lock: PIN & Biometrik Native',
    securityBoundaryAppLockBody:
        'PIN 4 digit di-hash dengan salted HMAC-SHA256 (16-byte salt acak) di Android KeyStore / iOS Keychain, tidak pernah masuk SQLite atau file backup. Mendukung biometrik perangkat dengan auto-lock saat pindah ke background.',
    securityBoundaryScreenshotTitle: 'Blokir Screenshot Terpisah (FLAG_SECURE)',
    securityBoundaryScreenshotBody:
        'Preferensi lokal perangkat yang langsung memasang FLAG_SECURE pada window utama Android untuk membatasi tangkapan layar dan pratinjau Recent Apps, terpisah penuh dari App Lock.',
    securityBoundaryRestoreTitle: 'Restore Atomik + Retensi Cerdas',
    securityBoundaryRestoreBody:
        'Validasi envelope, SHA-256 checksum, dekripsi AES-GCM, skema, dan foreign key dijalankan sebelum menyentuh SQLite. Penggantian berjalan di dalam satu db.transaction dengan rollback penuh bila gagal. 1 Backup Utama berkala kebal pruning + maksimal 5 Backup Sampingan terbaru.',
    specsTitle: 'Spesifikasi arsitektur yang terverifikasi.',
    specsSubtitle:
        'Ringkasan teknis aktual berdasarkan baseline implementasi WiseWallet di PRD 2.0, Database v11, dan ExternalIntegrations 3.0.',
    specRows: [
      SpecRow(area: 'Platform & Distribusi', detail: 'Android 7.0+ (API 24, targetSdk 36) distribusi langsung APK split-per-ABI; fondasi iOS 13.0+ siap (Keychain, Face ID, Darwin Notifications).'),
      SpecRow(area: 'Database & State', detail: 'SQLite lokal melalui Drift (Schema v11, PRAGMA foreign_keys = ON, WAL mode) dengan Riverpod.'),
      SpecRow(area: 'Pencatatan Suara Offline', detail: 'Hybrid: Android 13+ on-device SpeechRecognizer (id-ID) + whisper.cpp v1.9.5 (maleo-ai/whisper-tiny-id, 41,52 MiB) terbundel untuk Android 7 hingga 12.'),
      SpecRow(area: 'OCR Foto Struk Offline', detail: 'PaddleOCR PP-OCRv4 Mobile ONNX terbundel (arm64-v8a, armeabi-v7a, x86_64) dengan editor crop offline dan hapus otomatis cache gambar.'),
      SpecRow(area: 'Ekspor & Berbagi Lokal', detail: 'PDF multi-halaman offline (ID & EN) + CSV UTF-8 RFC 4180 tahan formula-injection via Native Share Sheet tanpa izin storage eksternal.'),
      SpecRow(area: 'Keamanan & Cloud Backup', detail: 'App Lock PIN HMAC-SHA256 + Biometrik, FLAG_SECURE opsional, serta Cloud Firestore .wwbak terenkripsi AES-256-GCM + PBKDF2 600K.'),
      SpecRow(area: 'Bahasa & Tampilan', detail: 'Bahasa Indonesia (default) & English reaktif instan; tema Modern Tactile Fintech (Terang / Gelap / Sistem).'),
    ],
    faqTitle: 'Pertanyaan yang paling sering ditanyakan soal WiseWallet.',
    faqSubtitle:
        'Jawaban lugas berdasarkan cara kerja aktual aplikasi di perangkat Anda.',
    faqItems: [
      FaqItem(
        question: 'Apakah WiseWallet membutuhkan koneksi internet atau login untuk dipakai sehari-hari?',
        answer: 'Tidak. Seluruh fitur inti (transaksi manual, suara offline, foto struk OCR, dompet, transfer, anggaran, kalender, transaksi berulang, utang-piutang, laporan, dan ekspor PDF/CSV) berjalan 100% offline di SQLite lokal tanpa perlu daftar atau login.',
      ),
      FaqItem(
        question: 'Apa bedanya Cloud Backup WiseWallet dengan sinkronisasi otomatis antar perangkat?',
        answer: 'WiseWallet menerapkan model Backup dan Restore manual/berkala, bukan real-time multi-device sync. Tidak ada penggabungan data otomatis di latar belakang yang rawan konflik saldo. Anda memegang kendali penuh kapan membuat cadangan (.wwbak) dan kapan memulihkannya secara atomik.',
      ),
      FaqItem(
        question: 'Bagaimana jika saya lupa kata sandi backup pada mode Zero-Knowledge?',
        answer: 'Pada mode Dengan Password, kata sandi pemulihan tidak pernah disimpan di server dan tidak ada backdoor reset. Akun Google saja tidak dapat mendekripsi file cadangan tersebut. Jika Anda ingin pemulihan cukup lewat akun Google tanpa mengingat sandi terpisah, gunakan mode Tanpa Password (Account Recovery v2).',
      ),
      FaqItem(
        question: 'Apakah rekaman suara atau foto struk belanja saya dikirim ke layanan AI di cloud?',
        answer: 'Tidak pernah. Pengenalan suara memakai layanan on-device OS Android 13+ atau whisper.cpp terbundel dengan buffer RAM yang langsung dihapus setelah selesai. Foto struk dipindai lokal oleh PaddleOCR PP-OCRv4 ONNX dan berkas gambar sementaranya segera dihapus dari cache.',
      ),
      FaqItem(
        question: 'Mengapa transfer antar dompet dan utang-piutang tidak masuk hitungan Pengeluaran?',
        answer: 'Secara akuntansi, memindahkan dana dari Bank ke Tunai bersifat net-zero terhadap total kekayaan Anda. Begitu juga pinjaman utang/piutang dipisahkan dari Pemasukan, Pengeluaran, Arus Kas Bersih, dan Anggaran agar grafik belanja bulanan Anda tetap akurat.',
      ),
      FaqItem(
        question: 'APK split-per-ABI mana yang harus saya pilih saat mengunduh?',
        answer: 'Sebagian besar ponsel Android modern (keluaran 2018 ke atas) menggunakan arm64-v8a. Pilih armeabi-v7a untuk HP Android lama 32-bit, x86_64 untuk Chromebook atau emulator PC, atau Universal jika Anda ragu dengan arsitektur prosesor perangkat Anda.',
      ),
    ],
    downloadTitle: 'Unduh WiseWallet langsung melalui APK split-per-ABI.',
    downloadSubtitle:
        'WiseWallet didistribusikan langsung melalui rilis publik GitHub tanpa perantara toko aplikasi. Pilih arsitektur prosesor perangkat Android Anda agar ukuran unduhan lebih ramping.',
    downloadRecommendedBadge: 'Direkomendasikan',
    downloadPrimaryCtaPrefix: 'Unduh APK',
    downloadAllReleasesCta: 'Buka Semua Rilis di GitHub',
    downloadCheckAbiCta: 'Cara Cek Arsitektur HP',
    downloadAbiGuideTitle: 'Cara Cek Arsitektur CPU & Pasang APK Android',
    downloadAbiGuideBody:
        '1. Sebagian besar ponsel Android 2018 ke atas memakai arm64-v8a.\n'
        '2. Jika instalasi arm64-v8a ditolak oleh sistem ("Aplikasi tidak terpasang"), coba unduh varian armeabi-v7a atau Universal.\n'
        '3. Saat memasang APK pertama kali dari browser, izinkan "Instal aplikasi yang tidak dikenal" khusus untuk browser yang Anda pakai, lalu buka WiseWallet tanpa perlu login.',
    downloadIosNote:
        'Status iOS: fondasi cross-platform iOS 13.0+ (Keychain, Face ID / Touch ID, Darwin Notifications) tersedia pada kode sumber, namun rilis publik saat ini difokuskan pada distribusi APK Android.',
    footerEthos: 'Local-first. Offline-first. Data keuangan Anda tetap di perangkat Anda.',
    footerCopyright: 'WiseWallet · Rilis Publik via GitHub Pages & GitHub Releases',
  );

  static const LandingStrings _en = LandingStrings(
    locale: LandingLocale.en,
    brandName: 'WiseWallet',
    navCapture: 'Capture',
    navFinance: 'Core Finance',
    navReports: 'Reports',
    navSecurity: 'Security',
    navSpecs: 'Specs',
    navDownload: 'Download APK',
    menuLabel: 'Menu',
    closeMenuLabel: 'Close menu',
    themeSwitchToDark: 'Switch to dark theme',
    themeSwitchToLight: 'Switch to light theme',
    reducedMotionOn: 'Reduced motion active',
    reducedMotionOff: 'Reduce motion',
    heroHeadline: 'Personal finance on your device, fast and completely offline.',
    heroSubtitle:
        'WiseWallet keeps your income, expenses, wallets, budgets, debts, and local profiles inside on-device SQLite with no mandatory sign-in. Includes offline voice capture, on-device PaddleOCR receipt scanning, local PDF/CSV exports, and optional AES-256-GCM cloud backup.',
    heroPrimaryCta: 'Download Android APK',
    heroSecondaryCta: 'Try Feature Simulation',
    heroFactOffline: 'Local SQLite (Drift), 100% offline core',
    heroFactNoLogin: 'Start immediately without an account',
    heroFactAndroid: 'Android 7.0+ (API 24) · ID & EN',
    simulationTag: 'Interactive Simulation',
    replaySplashLabel: 'Replay Logo Reveal',
    phoneTabHome: 'Home',
    phoneTabCalendar: 'Calendar',
    phoneTabBudget: 'Budgets',
    phoneTabDebts: 'Debts',
    principlesPause: 'Pause strip',
    principlesPlay: 'Play strip',
    principleItems: [
      'Local SQLite = Single Source of Truth',
      'No Mandatory Login & Zero WiseWallet Backend',
      'Offline Voice Capture (SpeechRecognizer + whisper.cpp)',
      'Offline Receipt OCR (PaddleOCR PP-OCRv4)',
      'Optional Cloud Backup, Not Auto-Sync',
      'AES-256-GCM + PBKDF2 600,000 Iterations',
      'Isolated Local Multi-Profile (Schema v11)',
      'Instant Bilingual UI: Indonesian & English',
    ],
    captureTitle: 'Three ways to log transactions, all processed on your phone.',
    captureSubtitle:
        'Pick the fastest entry method for the moment. Manual forms, Indonesian offline voice dictation, and receipt photo scanning always produce a draft you review before saving.',
    captureTabManual: '1. Manual Form',
    captureTabVoice: '2. Offline Voice',
    captureTabOcr: '3. Receipt OCR',
    manualHeading: 'Fast local entry with timezone-safe calendar dates.',
    manualBody:
        'Transactions store local calendar date (YYYY-MM-DD) and local clock time (HH:mm) separately from UTC audit timestamps, so your purchase date never shifts across timezones.',
    manualBullets: [
      'Strict positive integer currency validation, required description, optional notes up to 500 characters.',
      'Instant local search with keyword highlighting (WiseHighlightedText) plus combined filters for type, category, wallet, and date range.',
      'Drag-and-drop category ordering saved per profile and reflected consistently across every picker.',
    ],
    voiceHeading: 'Speak naturally in Indonesian, fully offline with zero cloud AI.',
    voiceBody:
        'Hybrid Offline-Only speech architecture: Tier 1 uses Android 13+ on-device SpeechRecognizer (id-ID), while Tier 2 bundles whisper.cpp v1.9.5 + maleo-ai/whisper-tiny-id for Android 7 to 12. Audio stays strictly in RAM and is zeroed immediately after capture.',
    voiceHint: 'Select a spoken example below to test the deterministic parser:',
    voiceDraftTitle: 'Parsed Transaction Draft (Local)',
    voiceDraftDisclaimer:
        'Never auto-saves without confirmation. This preview simulates VoiceTransactionParser locally.',
    ocrHeading: 'Snap a receipt, crop the total, extract text locally with PaddleOCR.',
    ocrBody:
        'Bundled PaddleOCR PP-OCRv4 Mobile ONNX runs directly on Android. Supports camera and gallery import, an offline interactive crop editor, EXIF rotation normalization, and spatial line reconstruction.',
    ocrCropToggle: 'Enable Total Area Crop',
    ocrScanButton: 'Scan Receipt Offline',
    ocrScanningLabel: 'Running on-device text recognition...',
    ocrCleanupNotice:
        'Ephemeral privacy: temporary receipt images (receipt_*) are deleted from cache immediately after OCR finishes or is cancelled.',
    coreTitle: 'Complete personal finance engine built on strict accounting invariants.',
    coreSubtitle:
        'Wallet balances, net cash flow, budget progress, calendar summaries, and debts are derived deterministically from source records. Explore each module interactively below.',
    coreTabTransfer: 'Wallets & Transfer',
    coreTabBudget: 'Budgets',
    coreTabCalendar: 'Calendar & Recurring',
    coreTabDebts: 'Debts & Receivables',
    coreTabProfiles: 'Multi-Profile',
    uiStateLabel: 'Inspect app UI state:',
    uiStateNormal: 'Simulated Data',
    uiStateEmpty: 'Empty State',
    uiStateLoading: 'Loading State',
    uiStateError: 'Error State',
    emptyStateTitle: 'No transactions recorded in this period.',
    emptyStateBody:
        'Every core WiseWallet screen provides a clear empty state explaining the next action with a direct button.',
    emptyStateAction: 'Return to Simulated Data',
    loadingStateTitle: 'Loading summary from local SQLite...',
    loadingStateBody:
        'Structured loading states keep layouts stable without jarring shifts during local aggregations.',
    errorStateTitle: 'Could not load local data. Please try again.',
    errorStateBody:
        'Error messages stay human-readable in the active language and never leak stack traces, SQL, or tokens.',
    errorStateAction: 'Retry',
    reportsTitle: 'Deterministic reports and offline PDF/CSV exports directly from your device.',
    reportsSubtitle:
        'Understand spending patterns from actual records without judgmental labels. WiseWallet uses factual terms like "Top Spending Category" and "Daily Remaining Limit".',
    reportsTopCategoryLabel: 'Top Spending Category',
    reportsSavingsRateLabel: 'Savings Rate',
    reportsNetCashFlowLabel: 'Monthly Net Cash Flow',
    reportsPdfTab: 'Multi-Page PDF Report',
    reportsCsvTab: 'CSV Export (RFC 4180)',
    reportsPdfLangHint: 'Switch generated PDF document language live (Phase 19):',
    securityTitle: 'Layered privacy: local app protection separated from encrypted cloud backup.',
    securitySubtitle:
        'Cloud Firestore acts solely as an optional encrypted backup repository when you connect a Google account. There is no background sync and no custom WiseWallet server.',
    securityModePassword: 'With Password (Zero-Knowledge)',
    securityModeAccount: 'Without Password (Account Recovery v2)',
    securityPasswordExplain:
        'Two-Tier Key Architecture: financial payload is encrypted with a random 256-bit BEK using AES-256-GCM (96-bit nonce, 128-bit tag), then the BEK is wrapped by a KEK derived via PBKDF2-HMAC-SHA256 at 600,000 iterations from your recovery password. Zero backdoor; neither Google nor project admins can read it without your password.',
    securityAccountExplain:
        'Payload remains encrypted with AES-256-GCM using a fresh 256-bit random key stored atomically in users/{uid}/backups/{backupId}, protected by Firebase Auth and per-UID Firestore Security Rules. Signing into the same Google account restores your data, though this mode is not zero-knowledge against project admins.',
    securityBoundaryAppLockTitle: 'App Lock: Salted PIN & Native Biometrics',
    securityBoundaryAppLockBody:
        '4-digit PIN hashed with salted HMAC-SHA256 (16-byte random salt) inside Android KeyStore / iOS Keychain, never stored in SQLite or backups. Supports device biometrics with automatic re-lock on backgrounding.',
    securityBoundaryScreenshotTitle: 'Independent Screenshot Block (FLAG_SECURE)',
    securityBoundaryScreenshotBody:
        'Device-local toggle that applies Android FLAG_SECURE directly to MainActivity to restrict screenshots and Recent Apps previews, completely independent from App Lock.',
    securityBoundaryRestoreTitle: 'Atomic Restore & Smart Retention',
    securityBoundaryRestoreBody:
        'Envelope, SHA-256 transport checksum, AES-GCM tag, schema, and foreign keys are validated before touching SQLite. Replacement runs inside one db.transaction with full rollback on failure. 1 Primary scheduled backup exempt from pruning + up to 5 recent manual secondary backups.',
    specsTitle: 'Verified architecture specifications.',
    specsSubtitle:
        'Factual engineering baseline documented in PRD 2.0, Database Schema v11, and ExternalIntegrations 3.0.',
    specRows: [
      SpecRow(area: 'Platform & Distribution', detail: 'Android 7.0+ (API 24, targetSdk 36) direct split-per-ABI APK distribution; iOS 13.0+ cross-platform foundation prepared (Keychain, Face ID, Darwin Notifications).'),
      SpecRow(area: 'Database & State', detail: 'Local SQLite via Drift (Schema v11, PRAGMA foreign_keys = ON, WAL mode) paired with Riverpod.'),
      SpecRow(area: 'Offline Voice Engine', detail: 'Hybrid: Android 13+ on-device SpeechRecognizer (id-ID) + bundled whisper.cpp v1.9.5 (maleo-ai/whisper-tiny-id, 41.52 MiB) for Android 7 to 12.'),
      SpecRow(area: 'Offline Receipt OCR', detail: 'Bundled PaddleOCR PP-OCRv4 Mobile ONNX (arm64-v8a, armeabi-v7a, x86_64) with offline crop editor and immediate temp cache cleanup.'),
      SpecRow(area: 'Local Export & Sharing', detail: 'Offline multi-page PDF (ID & EN) + UTF-8 RFC 4180 CSV with spreadsheet formula protection via Native Share Sheet.'),
      SpecRow(area: 'Security & Cloud Backup', detail: 'Salted HMAC-SHA256 App Lock + Biometrics, optional FLAG_SECURE, and Cloud Firestore .wwbak encrypted with AES-256-GCM + PBKDF2 600K.'),
      SpecRow(area: 'Languages & Theme', detail: 'Indonesian (default) & English reactive switch; Modern Tactile Fintech Light / Dark / System theme.'),
    ],
    faqTitle: 'Real questions about how WiseWallet works.',
    faqSubtitle:
        'Direct answers grounded in the actual on-device architecture.',
    faqItems: [
      FaqItem(
        question: 'Does WiseWallet require an internet connection or login for daily use?',
        answer: 'No. Every core feature (manual entry, offline voice, PaddleOCR receipt scan, wallets, transfers, budgets, calendar, recurring rules, debts, reports, and PDF/CSV export) runs 100% offline on local SQLite without signing up.',
      ),
      FaqItem(
        question: 'How is WiseWallet Cloud Backup different from automatic multi-device sync?',
        answer: 'WiseWallet uses explicit manual or scheduled Backup and Restore rather than live multi-device sync. There is no background conflict merging that can corrupt balances; you decide when to create an encrypted .wwbak snapshot and when to restore it atomically.',
      ),
      FaqItem(
        question: 'What happens if I forget my recovery password in Zero-Knowledge mode?',
        answer: 'In With Password mode, your password is never uploaded and there is no reset backdoor. Your Google account alone cannot decrypt the backup. If you prefer recovery with just your Google login, choose Without Password (Account Recovery v2).',
      ),
      FaqItem(
        question: 'Are my voice recordings or receipt photos sent to any cloud AI service?',
        answer: 'Never. Voice recognition uses Android 13+ on-device speech or bundled whisper.cpp in private RAM that is zeroed on completion. Receipt photos are scanned locally by PaddleOCR PP-OCRv4 ONNX and deleted from temp cache immediately afterward.',
      ),
      FaqItem(
        question: 'Why are wallet transfers and debts excluded from Expense totals?',
        answer: 'Moving funds from Bank to Cash is net-zero for your net worth. Likewise, debts and receivables are isolated from Income, Expense, Net Cash Flow, and Budgets so your spending reports reflect actual consumption.',
      ),
      FaqItem(
        question: 'Which split-per-ABI APK should I download for my phone?',
        answer: 'Most modern Android phones (2018 onward) run arm64-v8a. Choose armeabi-v7a for older 32-bit Android phones, x86_64 for Chromebooks or desktop emulators, or Universal if you are unsure about your CPU architecture.',
      ),
    ],
    downloadTitle: 'Download WiseWallet directly via split-per-ABI APK.',
    downloadSubtitle:
        'WiseWallet is distributed directly through public GitHub Releases. Pick the CPU architecture matching your Android device for a smaller download.',
    downloadRecommendedBadge: 'Recommended',
    downloadPrimaryCtaPrefix: 'Download APK',
    downloadAllReleasesCta: 'View All GitHub Releases',
    downloadCheckAbiCta: 'How to Check Device ABI',
    downloadAbiGuideTitle: 'Check Your Android ABI & Install the APK',
    downloadAbiGuideBody:
        '1. Most Android phones from 2018 onward use arm64-v8a.\n'
        '2. If Android rejects the arm64-v8a package ("App not installed"), download armeabi-v7a or the Universal APK.\n'
        '3. On first sideload from your browser, allow "Install unknown apps" for that browser, then open WiseWallet with no sign-in required.',
    downloadIosNote:
        'iOS status: cross-platform iOS 13.0+ foundation (Keychain, Face ID / Touch ID, Darwin Notifications) is prepared in source, while current public releases ship as Android APKs.',
    footerEthos: 'Local-first. Offline-first. Your financial records stay on your device.',
    footerCopyright: 'WiseWallet · Public Releases via GitHub Pages & GitHub Releases',
  );
}
