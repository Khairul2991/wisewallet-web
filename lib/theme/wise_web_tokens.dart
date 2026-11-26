import 'package:flutter/material.dart';

/// Exact web port of WiseWallet's Modern Tactile Fintech design tokens
/// from ART_DIRECTION.md and lib/src/core/theme/wise_tokens.dart.
@immutable
class WiseWebTokens extends ThemeExtension<WiseWebTokens> {
  const WiseWebTokens({
    required this.brandPrimary,
    required this.brandOnPrimary,
    required this.brandAccentCyan,
    required this.primaryContainer,
    required this.income,
    required this.incomeContainer,
    required this.expense,
    required this.expenseContainer,
    required this.warning,
    required this.warningContainer,
    required this.info,
    required this.infoContainer,
    required this.canvas,
    required this.surfaceCard,
    required this.surfaceElevated,
    required this.contrastBandBg,
    required this.contrastBandSurface,
    required this.contrastBandText,
    required this.contrastBandMuted,
    required this.borderSubtle,
    required this.borderStrong,
    required this.borderFocus,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.ambientShadow,
  });

  final Color brandPrimary;
  final Color brandOnPrimary;
  final Color brandAccentCyan;
  final Color primaryContainer;
  final Color income;
  final Color incomeContainer;
  final Color expense;
  final Color expenseContainer;
  final Color warning;
  final Color warningContainer;
  final Color info;
  final Color infoContainer;
  final Color canvas;
  final Color surfaceCard;
  final Color surfaceElevated;
  final Color contrastBandBg;
  final Color contrastBandSurface;
  final Color contrastBandText;
  final Color contrastBandMuted;
  final Color borderSubtle;
  final Color borderStrong;
  final Color borderFocus;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color ambientShadow;

  static const double radiusXs = 6.0;
  static const double radiusSm = 10.0;
  static const double radiusMd = 14.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 28.0;

  static const WiseWebTokens light = WiseWebTokens(
    brandPrimary: Color(0xFF1E5CD9),
    brandOnPrimary: Color(0xFFFFFFFF),
    brandAccentCyan: Color(0xFF03C8F8),
    primaryContainer: Color(0xFFEEF4FF),
    income: Color(0xFF047857),
    incomeContainer: Color(0xFFECFDF5),
    expense: Color(0xFFB91C1C),
    expenseContainer: Color(0xFFFEF2F2),
    warning: Color(0xFFB45309),
    warningContainer: Color(0xFFFFFBEB),
    info: Color(0xFF0369A1),
    infoContainer: Color(0xFFF0F9FF),
    canvas: Color(0xFFF8FAFC),
    surfaceCard: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFF1F5F9),
    contrastBandBg: Color(0xFF0F172A),
    contrastBandSurface: Color(0xFF1E293B),
    contrastBandText: Color(0xFFF8FAFC),
    contrastBandMuted: Color(0xFFCBD5E1),
    borderSubtle: Color(0x140F172A),
    borderStrong: Color(0x260F172A),
    borderFocus: Color(0xFF1E5CD9),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    textMuted: Color(0xFF5B6B82),
    ambientShadow: Color(0x0D0F172A),
  );

  static const WiseWebTokens dark = WiseWebTokens(
    brandPrimary: Color(0xFF60A5FA),
    brandOnPrimary: Color(0xFF0F172A),
    brandAccentCyan: Color(0xFF38BDF8),
    primaryContainer: Color(0xFF1E293B),
    income: Color(0xFF34D399),
    incomeContainer: Color(0xFF064E3B),
    expense: Color(0xFFFCA5A5),
    expenseContainer: Color(0xFF7F1D1D),
    warning: Color(0xFFFBBF24),
    warningContainer: Color(0xFF78350F),
    info: Color(0xFF7DD3FC),
    infoContainer: Color(0xFF0C4A6E),
    canvas: Color(0xFF0F172A),
    surfaceCard: Color(0xFF1E293B),
    surfaceElevated: Color(0xFF152136),
    contrastBandBg: Color(0xFF09101E),
    contrastBandSurface: Color(0xFF152136),
    contrastBandText: Color(0xFFF8FAFC),
    contrastBandMuted: Color(0xFFCBD5E1),
    borderSubtle: Color(0x1AFFFFFF),
    borderStrong: Color(0x33FFFFFF),
    borderFocus: Color(0xFF60A5FA),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFFCBD5E1),
    textMuted: Color(0xFF94A3B8),
    ambientShadow: Color(0x33000000),
  );

  static WiseWebTokens of(BuildContext context) {
    final ext = Theme.of(context).extension<WiseWebTokens>();
    if (ext != null) return ext;
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  @override
  WiseWebTokens copyWith({Color? brandPrimary}) => this;

  @override
  WiseWebTokens lerp(ThemeExtension<WiseWebTokens>? other, double t) {
    if (other is! WiseWebTokens) return this;
    return WiseWebTokens(
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      brandOnPrimary: Color.lerp(brandOnPrimary, other.brandOnPrimary, t)!,
      brandAccentCyan: Color.lerp(brandAccentCyan, other.brandAccentCyan, t)!,
      primaryContainer:
          Color.lerp(primaryContainer, other.primaryContainer, t)!,
      income: Color.lerp(income, other.income, t)!,
      incomeContainer: Color.lerp(incomeContainer, other.incomeContainer, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
      expenseContainer:
          Color.lerp(expenseContainer, other.expenseContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer:
          Color.lerp(warningContainer, other.warningContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      contrastBandBg: Color.lerp(contrastBandBg, other.contrastBandBg, t)!,
      contrastBandSurface:
          Color.lerp(contrastBandSurface, other.contrastBandSurface, t)!,
      contrastBandText:
          Color.lerp(contrastBandText, other.contrastBandText, t)!,
      contrastBandMuted:
          Color.lerp(contrastBandMuted, other.contrastBandMuted, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      borderFocus: Color.lerp(borderFocus, other.borderFocus, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      ambientShadow: Color.lerp(ambientShadow, other.ambientShadow, t)!,
    );
  }
}

class WiseWebTypography {
  static const String headingFamily = 'Plus Jakarta Sans';
  static const String bodyFamily = 'IBM Plex Sans';
  static const String monoFamily = 'IBM Plex Mono';

  static TextStyle display(BuildContext context, {Color? color}) {
    final width = MediaQuery.sizeOf(context).width;
    final size = width >= 1100
        ? 54.0
        : width >= 720
            ? 42.0
            : 32.0;
    return TextStyle(
      fontFamily: headingFamily,
      fontSize: size,
      fontWeight: FontWeight.w800,
      height: 1.12,
      letterSpacing: -1.1,
      color: color ?? WiseWebTokens.of(context).textPrimary,
    );
  }

  static TextStyle sectionTitle(BuildContext context, {Color? color}) {
    final width = MediaQuery.sizeOf(context).width;
    final size = width >= 900 ? 34.0 : 26.0;
    return TextStyle(
      fontFamily: headingFamily,
      fontSize: size,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.6,
      color: color ?? WiseWebTokens.of(context).textPrimary,
    );
  }

  static TextStyle cardTitle(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: headingFamily,
      fontSize: 19,
      fontWeight: FontWeight.w700,
      height: 1.3,
      letterSpacing: -0.2,
      color: color ?? WiseWebTokens.of(context).textPrimary,
    );
  }

  static TextStyle body(BuildContext context, {Color? color, double size = 16}) {
    return TextStyle(
      fontFamily: bodyFamily,
      fontSize: size,
      fontWeight: FontWeight.w400,
      height: 1.55,
      color: color ?? WiseWebTokens.of(context).textSecondary,
    );
  }

  static TextStyle money(
    BuildContext context, {
    Color? color,
    double size = 24,
    FontWeight weight = FontWeight.w700,
  }) {
    return TextStyle(
      fontFamily: bodyFamily,
      fontSize: size,
      fontWeight: weight,
      letterSpacing: -0.4,
      fontFeatures: const [FontFeature.tabularFigures()],
      color: color ?? WiseWebTokens.of(context).textPrimary,
    );
  }

  static TextStyle mono(BuildContext context, {Color? color, double size = 12.5}) {
    return TextStyle(
      fontFamily: monoFamily,
      fontSize: size,
      fontWeight: FontWeight.w500,
      height: 1.4,
      color: color ?? WiseWebTokens.of(context).textPrimary,
    );
  }
}

ThemeData buildWiseWebTheme(Brightness brightness) {
  final tokens = brightness == Brightness.dark
      ? WiseWebTokens.dark
      : WiseWebTokens.light;
  final scheme = ColorScheme(
    brightness: brightness,
    primary: tokens.brandPrimary,
    onPrimary: tokens.brandOnPrimary,
    secondary: tokens.info,
    onSecondary: tokens.brandOnPrimary,
    error: tokens.expense,
    onError: Colors.white,
    surface: tokens.surfaceCard,
    onSurface: tokens.textPrimary,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: tokens.canvas,
    fontFamily: WiseWebTypography.bodyFamily,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    hoverColor: tokens.brandPrimary.withValues(alpha: 0.06),
    focusColor: tokens.borderFocus.withValues(alpha: 0.16),
    dividerColor: tokens.borderSubtle,
    extensions: [tokens],
  );
}
