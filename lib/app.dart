import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'l10n/landing_strings.dart';
import 'sections/capture_showcase_section.dart';
import 'sections/download_footer_section.dart';
import 'sections/financial_core_section.dart';
import 'sections/header_nav.dart';
import 'sections/hero_section.dart';
import 'sections/reports_export_section.dart';
import 'sections/security_privacy_section.dart';
import 'sections/specs_faq_section.dart';
import 'theme/wise_web_tokens.dart';
import 'widgets/motion_primitives.dart';

class WiseWalletLandingApp extends StatefulWidget {
  const WiseWalletLandingApp({
    super.key,
    this.initialThemeMode = ThemeMode.light,
    this.initialLocale = LandingLocale.id,
    this.initialReducedMotion = false,
    this.onLaunchUrl,
  });

  final ThemeMode initialThemeMode;
  final LandingLocale initialLocale;
  final bool initialReducedMotion;
  final void Function(String url)? onLaunchUrl;

  @override
  State<WiseWalletLandingApp> createState() => _WiseWalletLandingAppState();
}

class _WiseWalletLandingAppState extends State<WiseWalletLandingApp> {
  late ThemeMode _themeMode;
  late LandingLocale _locale;
  late bool _reducedMotion;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
    _locale = widget.initialLocale;
    _reducedMotion = widget.initialReducedMotion;
  }

  Future<void> _handleLaunchUrl(String rawUrl) async {
    if (widget.onLaunchUrl != null) {
      widget.onLaunchUrl!(rawUrl);
      return;
    }
    final uri = Uri.tryParse(rawUrl);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final strings = LandingStrings.of(_locale);
    return MaterialApp(
      title: 'WiseWallet | Offline-First Personal Finance',
      debugShowCheckedModeBanner: false,
      theme: buildWiseWebTheme(Brightness.light),
      darkTheme: buildWiseWebTheme(Brightness.dark),
      themeMode: _themeMode,
      home: _LandingPageShell(
        strings: strings,
        isDark: _themeMode == ThemeMode.dark,
        reducedMotion: _reducedMotion,
        onToggleTheme: () => setState(() {
          _themeMode =
              _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
        }),
        onToggleLocale: () => setState(() {
          _locale = _locale == LandingLocale.id
              ? LandingLocale.en
              : LandingLocale.id;
        }),
        onToggleReducedMotion: () => setState(() {
          _reducedMotion = !_reducedMotion;
        }),
        onLaunchUrl: _handleLaunchUrl,
      ),
    );
  }
}

class _LandingPageShell extends StatefulWidget {
  const _LandingPageShell({
    required this.strings,
    required this.isDark,
    required this.reducedMotion,
    required this.onToggleTheme,
    required this.onToggleLocale,
    required this.onToggleReducedMotion,
    required this.onLaunchUrl,
  });

  final LandingStrings strings;
  final bool isDark;
  final bool reducedMotion;
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleLocale;
  final VoidCallback onToggleReducedMotion;
  final ValueChanged<String> onLaunchUrl;

  @override
  State<_LandingPageShell> createState() => _LandingPageShellState();
}

class _LandingPageShellState extends State<_LandingPageShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;
  double _scrollOffset = 0.0;

  final Map<LandingSectionId, GlobalKey> _sectionKeys = {
    for (final id in LandingSectionId.values) id: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    final max = pos.maxScrollExtent <= 0 ? 1.0 : pos.maxScrollExtent;
    final nextProgress = (pos.pixels / max).clamp(0.0, 1.0);
    if ((nextProgress - _scrollProgress).abs() > 0.004 ||
        (pos.pixels - _scrollOffset).abs() > 4) {
      setState(() {
        _scrollProgress = nextProgress;
        _scrollOffset = pos.pixels;
      });
    }
  }

  void _scrollToSection(LandingSectionId id) {
    final targetContext = _sectionKeys[id]?.currentContext;
    if (targetContext == null) return;
    Scrollable.ensureVisible(
      targetContext,
      duration: widget.reducedMotion
          ? Duration.zero
          : const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    final effectiveReduced =
        widget.reducedMotion || MediaQuery.disableAnimationsOf(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: tokens.canvas,
      endDrawer: _MobileNavDrawer(
        strings: widget.strings,
        reducedMotion: effectiveReduced,
        onToggleReducedMotion: widget.onToggleReducedMotion,
        onNavigate: (id) {
          Navigator.of(context).pop();
          _scrollToSection(id);
        },
      ),
      body: Column(
        children: [
          HeaderNav(
            strings: widget.strings,
            scrollProgress: _scrollProgress,
            isDark: widget.isDark,
            reducedMotion: effectiveReduced,
            onToggleTheme: widget.onToggleTheme,
            onToggleLocale: widget.onToggleLocale,
            onToggleReducedMotion: widget.onToggleReducedMotion,
            onNavigate: _scrollToSection,
            onOpenMobileMenu: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HeroSection(
                    strings: widget.strings,
                    reducedMotion: effectiveReduced,
                    scrollOffset: _scrollOffset,
                    onDownloadTap: () =>
                        _scrollToSection(LandingSectionId.download),
                    onExploreTap: () =>
                        _scrollToSection(LandingSectionId.capture),
                  ),
                  KineticPrincipleStrip(
                    items: widget.strings.principleItems,
                    pauseLabel: widget.strings.principlesPause,
                    playLabel: widget.strings.principlesPlay,
                    reducedMotion: effectiveReduced,
                  ),
                  KeyedSubtree(
                    key: _sectionKeys[LandingSectionId.capture],
                    child: CaptureShowcaseSection(
                      strings: widget.strings,
                      reducedMotion: effectiveReduced,
                      scrollListenable: _scrollController,
                    ),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys[LandingSectionId.finance],
                    child: FinancialCoreSection(
                      strings: widget.strings,
                      reducedMotion: effectiveReduced,
                      scrollListenable: _scrollController,
                    ),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys[LandingSectionId.reports],
                    child: ReportsExportSection(
                      strings: widget.strings,
                      reducedMotion: effectiveReduced,
                      scrollListenable: _scrollController,
                    ),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys[LandingSectionId.security],
                    child: SecurityPrivacySection(
                      strings: widget.strings,
                      reducedMotion: effectiveReduced,
                      scrollListenable: _scrollController,
                    ),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys[LandingSectionId.specs],
                    child: SpecsFaqSection(
                      strings: widget.strings,
                      reducedMotion: effectiveReduced,
                      scrollListenable: _scrollController,
                    ),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys[LandingSectionId.download],
                    child: DownloadFooterSection(
                      strings: widget.strings,
                      reducedMotion: effectiveReduced,
                      onLaunchUrl: widget.onLaunchUrl,
                      onNavigate: _scrollToSection,
                      scrollListenable: _scrollController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileNavDrawer extends StatelessWidget {
  const _MobileNavDrawer({
    required this.strings,
    required this.reducedMotion,
    required this.onToggleReducedMotion,
    required this.onNavigate,
  });

  final LandingStrings strings;
  final bool reducedMotion;
  final VoidCallback onToggleReducedMotion;
  final ValueChanged<LandingSectionId> onNavigate;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    final entries = [
      (LandingSectionId.capture, strings.navCapture, Icons.mic_none_rounded),
      (LandingSectionId.finance, strings.navFinance, Icons.account_balance_wallet_outlined),
      (LandingSectionId.reports, strings.navReports, Icons.bar_chart_rounded),
      (LandingSectionId.security, strings.navSecurity, Icons.lock_outline_rounded),
      (LandingSectionId.specs, strings.navSpecs, Icons.fact_check_outlined),
      (LandingSectionId.download, strings.navDownload, Icons.download_rounded),
    ];

    return Drawer(
      backgroundColor: tokens.surfaceCard,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    strings.brandName,
                    style: WiseWebTypography.cardTitle(context),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: strings.closeMenuLabel,
                    icon: Icon(Icons.close_rounded, color: tokens.textPrimary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              for (final (id, label, icon) in entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
                    ),
                    leading: Icon(icon, color: tokens.brandPrimary, size: 20),
                    title: Text(
                      label,
                      style: WiseWebTypography.body(
                        context,
                        size: 15,
                        color: tokens.textPrimary,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    onTap: () => onNavigate(id),
                  ),
                ),
              const Spacer(),
              WiseWebButton(
                label: reducedMotion
                    ? strings.reducedMotionOn
                    : strings.reducedMotionOff,
                icon: reducedMotion
                    ? Icons.motion_photos_off_outlined
                    : Icons.animation_outlined,
                variant: WiseWebButtonVariant.outlined,
                reducedMotion: reducedMotion,
                onPressed: onToggleReducedMotion,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
