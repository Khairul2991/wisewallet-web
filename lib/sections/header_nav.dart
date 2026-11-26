import 'package:flutter/material.dart';
import '../l10n/landing_strings.dart';
import '../theme/wise_web_tokens.dart';
import '../widgets/motion_primitives.dart';

enum LandingSectionId {
  capture,
  finance,
  reports,
  security,
  specs,
  download,
}

/// Sticky compact top bar with real scroll progress rail, section anchors,
/// Light/Dark toggle, ID/EN toggle, Reduced Motion toggle, and explicit mobile Menu button.
class HeaderNav extends StatelessWidget {
  const HeaderNav({
    super.key,
    required this.strings,
    required this.scrollProgress,
    required this.isDark,
    required this.reducedMotion,
    required this.onToggleTheme,
    required this.onToggleLocale,
    required this.onToggleReducedMotion,
    required this.onNavigate,
    required this.onOpenMobileMenu,
  });

  final LandingStrings strings;
  final double scrollProgress;
  final bool isDark;
  final bool reducedMotion;
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleLocale;
  final VoidCallback onToggleReducedMotion;
  final ValueChanged<LandingSectionId> onNavigate;
  final VoidCallback onOpenMobileMenu;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final showDesktopNav = width >= 1060;
    final horizontal = width >= 1024
        ? 40.0
        : width >= 640
            ? 24.0
            : 14.0;

    return Material(
      color: tokens.surfaceCard.withValues(alpha: 0.96),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontal,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    // Brand mark + name
                    Flexible(
                      flex: showDesktopNav ? 0 : 1,
                      fit: showDesktopNav ? FlexFit.loose : FlexFit.tight,
                      child: InkWell(
                        onTap: () => onNavigate(LandingSectionId.capture),
                        mouseCursor: SystemMouseCursors.click,
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 4,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: Image.asset(
                                  'assets/branding/wisewallet_app_icon_master.png',
                                  width: 32,
                                  height: 32,
                                  semanticLabel: 'WiseWallet',
                                ),
                              ),
                              if (width >= 380) ...[
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    strings.brandName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily:
                                          WiseWebTypography.headingFamily,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.4,
                                      color: tokens.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (showDesktopNav) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _NavLink(
                                label: strings.navCapture,
                                onTap: () =>
                                    onNavigate(LandingSectionId.capture),
                              ),
                              _NavLink(
                                label: strings.navFinance,
                                onTap: () =>
                                    onNavigate(LandingSectionId.finance),
                              ),
                              _NavLink(
                                label: strings.navReports,
                                onTap: () =>
                                    onNavigate(LandingSectionId.reports),
                              ),
                              _NavLink(
                                label: strings.navSecurity,
                                onTap: () =>
                                    onNavigate(LandingSectionId.security),
                              ),
                              _NavLink(
                                label: strings.navSpecs,
                                onTap: () => onNavigate(LandingSectionId.specs),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else
                      const SizedBox(width: 8),
                    // Utility controls
                    _CompactIconToggle(
                      key: const Key('toggle_locale_button'),
                      tooltip: strings.locale == LandingLocale.id
                          ? 'Switch to English'
                          : 'Ganti ke Bahasa Indonesia',
                      label: strings.locale == LandingLocale.id ? 'ID' : 'EN',
                      onPressed: onToggleLocale,
                    ),
                    const SizedBox(width: 6),
                    _CompactIconToggle(
                      key: const Key('toggle_theme_button'),
                      tooltip: isDark
                          ? strings.themeSwitchToLight
                          : strings.themeSwitchToDark,
                      icon: isDark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                      onPressed: onToggleTheme,
                    ),
                    if (width >= 520) ...[
                      const SizedBox(width: 6),
                      _CompactIconToggle(
                        key: const Key('toggle_motion_button'),
                        tooltip: reducedMotion
                            ? strings.reducedMotionOn
                            : strings.reducedMotionOff,
                        icon: reducedMotion
                            ? Icons.motion_photos_off_outlined
                            : Icons.animation_outlined,
                        active: reducedMotion,
                        onPressed: onToggleReducedMotion,
                      ),
                    ],
                    const SizedBox(width: 8),
                    if (showDesktopNav)
                      WiseWebButton(
                        key: const Key('header_download_cta'),
                        label: strings.navDownload,
                        icon: Icons.download_rounded,
                        compact: true,
                        reducedMotion: reducedMotion,
                        onPressed: () => onNavigate(LandingSectionId.download),
                      )
                    else
                      WiseWebButton(
                        key: const Key('mobile_menu_button'),
                        label: strings.menuLabel,
                        icon: Icons.menu_rounded,
                        variant: WiseWebButtonVariant.outlined,
                        compact: true,
                        reducedMotion: reducedMotion,
                        onPressed: onOpenMobileMenu,
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Scroll progress bar & subtle divider
          Stack(
            children: [
              Container(
                height: 2,
                width: double.infinity,
                color: tokens.borderSubtle,
              ),
              if (!reducedMotion)
                Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: scrollProgress.clamp(0.0, 1.0),
                    child: Container(
                      height: 2.5,
                      color: tokens.brandPrimary,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: WiseWebTypography.body(
              context,
              size: 14,
              color: _hovered ? tokens.brandPrimary : tokens.textSecondary,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class _CompactIconToggle extends StatelessWidget {
  const _CompactIconToggle({
    super.key,
    required this.tooltip,
    required this.onPressed,
    this.icon,
    this.label,
    this.active = false,
  });

  final String tooltip;
  final VoidCallback onPressed;
  final IconData? icon;
  final String? label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        child: InkWell(
          onTap: onPressed,
          mouseCursor: SystemMouseCursors.click,
          borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
          child: Container(
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? tokens.primaryContainer : tokens.surfaceElevated,
              borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
              border: Border.all(
                color: active ? tokens.brandPrimary : tokens.borderSubtle,
              ),
            ),
            child: label != null
                ? Text(
                    label!,
                    style: WiseWebTypography.mono(
                      context,
                      size: 13,
                      color: active ? tokens.brandPrimary : tokens.textPrimary,
                    ).copyWith(fontWeight: FontWeight.w600),
                  )
                : Icon(
                    icon,
                    size: 19,
                    color: active ? tokens.brandPrimary : tokens.textPrimary,
                  ),
          ),
        ),
      ),
    );
  }
}
