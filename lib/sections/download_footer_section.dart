import 'package:flutter/material.dart';
import '../config/release_config.dart';
import '../l10n/landing_strings.dart';
import '../theme/wise_web_tokens.dart';
import '../widgets/motion_primitives.dart';
import 'header_nav.dart';

/// Split-per-ABI APK Download Center (#unduh) + Compact Purposeful Footer.
class DownloadFooterSection extends StatefulWidget {
  const DownloadFooterSection({
    super.key,
    required this.strings,
    required this.reducedMotion,
    required this.onLaunchUrl,
    required this.onNavigate,
    this.scrollListenable,
  });

  final LandingStrings strings;
  final bool reducedMotion;
  final ValueChanged<String> onLaunchUrl;
  final ValueChanged<LandingSectionId> onNavigate;
  final Listenable? scrollListenable;

  @override
  State<DownloadFooterSection> createState() => _DownloadFooterSectionState();
}

class _DownloadFooterSectionState extends State<DownloadFooterSection> {
  String _selectedVariantId = ReleaseConfig.recommendedVariant.id;

  ApkVariant get _selectedVariant => ReleaseConfig.variants.firstWhere(
        (v) => v.id == _selectedVariantId,
        orElse: () => ReleaseConfig.recommendedVariant,
      );

  void _openAbiGuideDialog() {
    final tokens = WiseWebTokens.of(context);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: tokens.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WiseWebTokens.radiusLg),
          side: BorderSide(color: tokens.borderSubtle),
        ),
        title: Row(
          children: [
            Icon(Icons.perm_device_info_rounded, color: tokens.brandPrimary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.strings.downloadAbiGuideTitle,
                style: WiseWebTypography.cardTitle(dialogContext),
              ),
            ),
          ],
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Text(
            widget.strings.downloadAbiGuideBody,
            style: WiseWebTypography.body(dialogContext, size: 14.5),
          ),
        ),
        actions: [
          WiseWebButton(
            label: widget.strings.locale == LandingLocale.en ? 'Got it' : 'Mengerti',
            compact: true,
            reducedMotion: widget.reducedMotion,
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    final isEn = widget.strings.locale == LandingLocale.en;
    final selected = _selectedVariant;
    final downloadUrl = ReleaseConfig.downloadUrlFor(selected);

    return Column(
      children: [
        SectionContainer(
          child: ScrollReveal(
            reducedMotion: widget.reducedMotion,
            scrollListenable: widget.scrollListenable,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.strings.downloadTitle,
                        style: WiseWebTypography.sectionTitle(context),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.strings.downloadSubtitle,
                        style: WiseWebTypography.body(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                // 4 Split-per-ABI selector cards (2x2 on desktop, 1 col on mobile)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cols = constraints.maxWidth >= 820 ? 2 : 1;
                    final cardWidth = cols == 2
                        ? (constraints.maxWidth - 16) / 2
                        : constraints.maxWidth;

                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        for (final variant in ReleaseConfig.variants)
                          SizedBox(
                            width: cardWidth,
                            child: _AbiOptionCard(
                              key: Key('abi_card_${variant.id}'),
                              variant: variant,
                              selected: variant.id == _selectedVariantId,
                              isEn: isEn,
                              recommendedBadge:
                                  widget.strings.downloadRecommendedBadge,
                              onSelect: () => setState(
                                () => _selectedVariantId = variant.id,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Focused action bar for the chosen ABI
                WiseSurfaceCard(
                  elevated: true,
                  padding: const EdgeInsets.all(22),
                  borderColor: tokens.brandPrimary.withValues(alpha: 0.4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${selected.fileName} (${selected.estimatedSizeLabel})',
                                style: WiseWebTypography.mono(
                                  context,
                                  size: 13.5,
                                  color: tokens.brandPrimary,
                                ).copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'v${ReleaseConfig.appVersion} · ${ReleaseConfig.minAndroidLabel} · ${isEn ? selected.deviceHintEn : selected.deviceHintId}',
                                style: WiseWebTypography.body(
                                  context,
                                  size: 13.5,
                                  color: tokens.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              WiseWebButton(
                                key: const Key('download_selected_apk_button'),
                                label:
                                    '${widget.strings.downloadPrimaryCtaPrefix} (${selected.abiLabel})',
                                icon: Icons.download_rounded,
                                reducedMotion: widget.reducedMotion,
                                onPressed: () =>
                                    widget.onLaunchUrl(downloadUrl),
                              ),
                              WiseWebButton(
                                key: const Key('download_all_releases_button'),
                                label: widget.strings.downloadAllReleasesCta,
                                icon: Icons.open_in_new_rounded,
                                variant: WiseWebButtonVariant.outlined,
                                reducedMotion: widget.reducedMotion,
                                onPressed: () => widget.onLaunchUrl(
                                  ReleaseConfig.releasesPageUrl,
                                ),
                              ),
                              WiseWebButton(
                                key: const Key('check_abi_guide_button'),
                                label: widget.strings.downloadCheckAbiCta,
                                icon: Icons.help_outline_rounded,
                                variant: WiseWebButtonVariant.ghost,
                                reducedMotion: widget.reducedMotion,
                                onPressed: _openAbiGuideDialog,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        widget.strings.downloadIosNote,
                        style: WiseWebTypography.body(
                          context,
                          size: 13,
                          color: tokens.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Compact purposeful footer (zero 4-column template filler per R-05)
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: tokens.surfaceCard,
            border: Border(top: BorderSide(color: tokens.borderSubtle)),
          ),
          child: SectionContainer(
            verticalPadding: const EdgeInsets.symmetric(vertical: 34),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 24,
                  runSpacing: 18,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
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
                        const SizedBox(width: 10),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.strings.brandName,
                                style: WiseWebTypography.cardTitle(context)
                                    .copyWith(fontSize: 16),
                              ),
                              Text(
                                widget.strings.footerEthos,
                                style: WiseWebTypography.body(
                                  context,
                                  size: 13,
                                  color: tokens.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 14,
                      runSpacing: 8,
                      children: [
                        _FooterAnchor(
                          label: widget.strings.navCapture,
                          onTap: () =>
                              widget.onNavigate(LandingSectionId.capture),
                        ),
                        _FooterAnchor(
                          label: widget.strings.navFinance,
                          onTap: () =>
                              widget.onNavigate(LandingSectionId.finance),
                        ),
                        _FooterAnchor(
                          label: widget.strings.navReports,
                          onTap: () =>
                              widget.onNavigate(LandingSectionId.reports),
                        ),
                        _FooterAnchor(
                          label: widget.strings.navSecurity,
                          onTap: () =>
                              widget.onNavigate(LandingSectionId.security),
                        ),
                        _FooterAnchor(
                          label: 'GitHub Releases',
                          onTap: () => widget.onLaunchUrl(
                            ReleaseConfig.releasesPageUrl,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Divider(color: tokens.borderSubtle, height: 1),
                const SizedBox(height: 14),
                Text(
                  widget.strings.footerCopyright,
                  style: WiseWebTypography.body(
                    context,
                    size: 12.5,
                    color: tokens.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AbiOptionCard extends StatelessWidget {
  const _AbiOptionCard({
    super.key,
    required this.variant,
    required this.selected,
    required this.isEn,
    required this.recommendedBadge,
    required this.onSelect,
  });

  final ApkVariant variant;
  final bool selected;
  final bool isEn;
  final String recommendedBadge;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onSelect,
        mouseCursor: SystemMouseCursors.click,
        borderRadius: BorderRadius.circular(WiseWebTokens.radiusLg),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: selected ? tokens.primaryContainer : tokens.surfaceCard,
            borderRadius: BorderRadius.circular(WiseWebTokens.radiusLg),
            border: Border.all(
              color: selected ? tokens.brandPrimary : tokens.borderSubtle,
              width: selected ? 2.0 : 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(
                    selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_off_rounded,
                    size: 20,
                    color: selected ? tokens.brandPrimary : tokens.textMuted,
                  ),
                  Text(
                    variant.abiLabel,
                    style: WiseWebTypography.mono(
                      context,
                      size: 14,
                      color: selected
                          ? tokens.brandPrimary
                          : tokens.textPrimary,
                    ).copyWith(fontWeight: FontWeight.w700),
                  ),
                  if (variant.isRecommended)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: tokens.incomeContainer,
                        borderRadius:
                            BorderRadius.circular(WiseWebTokens.radiusXs),
                      ),
                      child: Text(
                        recommendedBadge,
                        style: WiseWebTypography.mono(
                          context,
                          size: 11,
                          color: tokens.income,
                        ).copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  Text(
                    '· ${variant.estimatedSizeLabel}',
                    style: WiseWebTypography.mono(
                      context,
                      size: 12,
                      color: tokens.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                isEn ? variant.titleEn : variant.titleId,
                style: WiseWebTypography.cardTitle(context)
                    .copyWith(fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                isEn ? variant.targetSummaryEn : variant.targetSummaryId,
                style: WiseWebTypography.body(
                  context,
                  size: 13.5,
                  color: tokens.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterAnchor extends StatelessWidget {
  const _FooterAnchor({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    return InkWell(
      onTap: onTap,
      mouseCursor: SystemMouseCursors.click,
      borderRadius: BorderRadius.circular(WiseWebTokens.radiusXs),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Text(
          label,
          style: WiseWebTypography.body(
            context,
            size: 13.5,
            color: tokens.textSecondary,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
