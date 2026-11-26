import 'package:flutter/foundation.dart';

@immutable
class ApkVariant {
  const ApkVariant({
    required this.id,
    required this.abiLabel,
    required this.fileName,
    required this.estimatedSizeLabel,
    required this.isRecommended,
    required this.titleId,
    required this.titleEn,
    required this.targetSummaryId,
    required this.targetSummaryEn,
    required this.deviceHintId,
    required this.deviceHintEn,
  });

  final String id;
  final String abiLabel;
  final String fileName;
  final String estimatedSizeLabel;
  final bool isRecommended;
  final String titleId;
  final String titleEn;
  final String targetSummaryId;
  final String targetSummaryEn;
  final String deviceHintId;
  final String deviceHintEn;
}

/// Centralized release distribution metadata for the public distribution repo.
/// Source code remains private; public GitHub Pages and Releases live here.
abstract final class ReleaseConfig {
  static const String appVersion = '1.0.0';
  static const String minAndroidLabel = 'Android 7.0+ (API 24)';
  static const String publicRepoUrl =
      'https://github.com/Khairul2991/wisewallet-web';
  static const String releasesPageUrl = '$publicRepoUrl/releases';
  static const String downloadBaseUrl = '$publicRepoUrl/releases/latest/download';

  static const List<ApkVariant> variants = [
    ApkVariant(
      id: 'arm64-v8a',
      abiLabel: 'arm64-v8a',
      fileName: 'app-arm64-v8a-release.apk',
      estimatedSizeLabel: '~103,6 MiB',
      isRecommended: true,
      titleId: 'Android Modern (64-bit ARM)',
      titleEn: 'Modern Android (64-bit ARM)',
      targetSummaryId:
          'Pilihan utama untuk sebagian besar ponsel Android keluaran 2018 ke atas. Lebih ramping daripada APK Universal.',
      targetSummaryEn:
          'Best fit for most Android phones from 2018 onward. Leaner download than the Universal APK.',
      deviceHintId: 'Samsung Galaxy, Pixel, Xiaomi, OPPO, Vivo, POCO, Realme modern',
      deviceHintEn: 'Modern Samsung Galaxy, Pixel, Xiaomi, OPPO, Vivo, POCO, Realme',
    ),
    ApkVariant(
      id: 'armeabi-v7a',
      abiLabel: 'armeabi-v7a',
      fileName: 'app-armeabi-v7a-release.apk',
      estimatedSizeLabel: '~96,0 MiB',
      isRecommended: false,
      titleId: 'Android Lama (32-bit ARM)',
      titleEn: 'Older Android (32-bit ARM)',
      targetSummaryId:
          'Untuk perangkat Android entry-level atau keluaran lama yang masih menjalankan OS 32-bit.',
      targetSummaryEn:
          'For entry-level or older Android devices running a 32-bit operating system.',
      deviceHintId: 'Ponsel Android 7 hingga 10 kelas pemula berarsitektur 32-bit',
      deviceHintEn: 'Entry-level Android 7 to 10 devices with 32-bit ABI',
    ),
    ApkVariant(
      id: 'x86_64',
      abiLabel: 'x86_64',
      fileName: 'app-x86_64-release.apk',
      estimatedSizeLabel: '~110,3 MiB',
      isRecommended: false,
      titleId: 'Intel / AMD 64-bit & Emulator',
      titleEn: 'Intel / AMD 64-bit & Emulators',
      targetSummaryId:
          'Khusus tablet Android berbasis prosesor Intel/AMD 64-bit, Chromebook, atau Android Emulator di PC.',
      targetSummaryEn:
          'Built for 64-bit Intel/AMD Android tablets, Chromebooks, and desktop Android Emulators.',
      deviceHintId: 'Android Emulator PC, Chromebook, tablet x86_64',
      deviceHintEn: 'Desktop Android Emulators, Chromebooks, x86_64 tablets',
    ),
    ApkVariant(
      id: 'universal',
      abiLabel: 'Universal',
      fileName: 'app-release.apk',
      estimatedSizeLabel: 'Semua ABI',
      isRecommended: false,
      titleId: 'Universal (Semua Arsitektur)',
      titleEn: 'Universal (All Architectures)',
      targetSummaryId:
          'Satu berkas APK yang memuat seluruh arsitektur CPU. Gunakan jika Anda tidak yakin dengan tipe prosesor perangkat.',
      targetSummaryEn:
          'Single APK bundling every supported CPU architecture. Pick this if you are unsure about your device ABI.',
      deviceHintId: 'Kompatibel dengan seluruh perangkat Android 7.0+',
      deviceHintEn: 'Compatible with all Android 7.0+ devices',
    ),
  ];

  static ApkVariant get recommendedVariant =>
      variants.firstWhere((v) => v.isRecommended);

  static String downloadUrlFor(ApkVariant variant) =>
      '$downloadBaseUrl/${variant.fileName}';
}
