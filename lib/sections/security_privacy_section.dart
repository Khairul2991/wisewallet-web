import 'package:flutter/material.dart';
import '../l10n/landing_strings.dart';
import '../theme/wise_web_tokens.dart';
import '../widgets/motion_primitives.dart';

/// Cryptographic Security & Privacy Flow (#keamanan):
/// Interactive switch between With Password (Zero-Knowledge) and Without Password
/// (Account Recovery v2) with an animated data-flow pipeline + 3 explicit boundaries.
class SecurityPrivacySection extends StatefulWidget {
  const SecurityPrivacySection({
    super.key,
    required this.strings,
    required this.reducedMotion,
    this.scrollListenable,
  });

  final LandingStrings strings;
  final bool reducedMotion;
  final Listenable? scrollListenable;

  @override
  State<SecurityPrivacySection> createState() => _SecurityPrivacySectionState();
}

class _SecurityPrivacySectionState extends State<SecurityPrivacySection>
    with SingleTickerProviderStateMixin {
  bool _passwordMode = true;
  late final AnimationController _packetController;

  @override
  void initState() {
    super.initState();
    _packetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
    if (!widget.reducedMotion) {
      _packetController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant SecurityPrivacySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reducedMotion) {
      _packetController.stop();
    } else if (!_packetController.isAnimating) {
      _packetController.repeat();
    }
  }

  @override
  void dispose() {
    _packetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    final isEn = widget.strings.locale == LandingLocale.en;
    final steps = _passwordMode
        ? [
            ('SQLite Lokal', 'Schema v11 JSON'),
            ('BEK 256-bit', 'AES-256-GCM (96b/128b)'),
            ('PBKDF2 600K', isEn ? 'Wrap BEK with KEK' : 'Bungkus BEK via KEK'),
            ('.wwbak + SHA-256', 'users/{uid}/backups'),
          ]
        : [
            ('SQLite Lokal', 'Schema v11 JSON'),
            ('Key 256-bit', 'AES-256-GCM (v2)'),
            ('Firebase UID', 'Security Rules + Blob 32B'),
            ('.wwbak + SHA-256', 'users/{uid}/backups'),
          ];

    return SectionContainer(
      child: ScrollReveal(
        reducedMotion: widget.reducedMotion,
        scrollListenable: widget.scrollListenable,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 740),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.strings.securityTitle,
                    style: WiseWebTypography.sectionTitle(context),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.strings.securitySubtitle,
                    style: WiseWebTypography.body(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            // Interactive Cryptographic Pipeline Card
            WiseSurfaceCard(
              elevated: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      WiseWebButton(
                        key: const Key('security_mode_password'),
                        label: widget.strings.securityModePassword,
                        icon: Icons.key_rounded,
                        variant: _passwordMode
                            ? WiseWebButtonVariant.primary
                            : WiseWebButtonVariant.outlined,
                        compact: true,
                        reducedMotion: widget.reducedMotion,
                        onPressed: () => setState(() => _passwordMode = true),
                      ),
                      WiseWebButton(
                        key: const Key('security_mode_account'),
                        label: widget.strings.securityModeAccount,
                        icon: Icons.verified_user_outlined,
                        variant: !_passwordMode
                            ? WiseWebButtonVariant.primary
                            : WiseWebButtonVariant.outlined,
                        compact: true,
                        reducedMotion: widget.reducedMotion,
                        onPressed: () => setState(() => _passwordMode = false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  // Animated directional pipeline nodes
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final horizontal = constraints.maxWidth >= 760;
                      return AnimatedBuilder(
                        animation: _packetController,
                        builder: (context, _) {
                          final activeNode = widget.reducedMotion
                              ? -1
                              : (_packetController.value * steps.length)
                                  .floor()
                                  .clamp(0, steps.length - 1);

                          if (horizontal) {
                            return Row(
                              children: [
                                for (var i = 0; i < steps.length; i++) ...[
                                  Expanded(
                                    child: _PipelineNode(
                                      stepNumber: i + 1,
                                      title: steps[i].$1,
                                      subtitle: steps[i].$2,
                                      highlighted: activeNode == i,
                                    ),
                                  ),
                                  if (i < steps.length - 1)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 18,
                                        color: activeNode == i
                                            ? tokens.brandPrimary
                                            : tokens.textMuted,
                                      ),
                                    ),
                                ],
                              ],
                            );
                          }
                          return Column(
                            children: [
                              for (var i = 0; i < steps.length; i++) ...[
                                _PipelineNode(
                                  stepNumber: i + 1,
                                  title: steps[i].$1,
                                  subtitle: steps[i].$2,
                                  highlighted: activeNode == i,
                                ),
                                if (i < steps.length - 1)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    child: Icon(
                                      Icons.arrow_downward_rounded,
                                      size: 18,
                                      color: activeNode == i
                                          ? tokens.brandPrimary
                                          : tokens.textMuted,
                                    ),
                                  ),
                              ],
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  AnimatedSwitcher(
                    duration: widget.reducedMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 220),
                    child: Container(
                      key: ValueKey(_passwordMode),
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: tokens.surfaceElevated,
                        borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
                        border: Border.all(color: tokens.borderSubtle),
                      ),
                      child: Text(
                        _passwordMode
                            ? widget.strings.securityPasswordExplain
                            : widget.strings.securityAccountExplain,
                        style: WiseWebTypography.body(
                          context,
                          size: 14.5,
                          color: tokens.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // 3 Distinct security boundaries (asymmetric row/stack, not uniform AI feature cards)
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 860;
                final items = [
                  _SecurityBoundaryBlock(
                    icon: Icons.fingerprint_rounded,
                    accent: tokens.brandPrimary,
                    title: widget.strings.securityBoundaryAppLockTitle,
                    body: widget.strings.securityBoundaryAppLockBody,
                  ),
                  _SecurityBoundaryBlock(
                    icon: Icons.screenshot_monitor_outlined,
                    accent: tokens.warning,
                    title: widget.strings.securityBoundaryScreenshotTitle,
                    body: widget.strings.securityBoundaryScreenshotBody,
                  ),
                  _SecurityBoundaryBlock(
                    icon: Icons.restore_rounded,
                    accent: tokens.income,
                    title: widget.strings.securityBoundaryRestoreTitle,
                    body: widget.strings.securityBoundaryRestoreBody,
                  ),
                ];

                if (wide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 10, child: items[0]),
                      const SizedBox(width: 20),
                      Expanded(flex: 9, child: items[1]),
                      const SizedBox(width: 20),
                      Expanded(flex: 11, child: items[2]),
                    ],
                  );
                }
                return Column(
                  children: [
                    items[0],
                    const SizedBox(height: 16),
                    items[1],
                    const SizedBox(height: 16),
                    items[2],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PipelineNode extends StatelessWidget {
  const _PipelineNode({
    required this.stepNumber,
    required this.title,
    required this.subtitle,
    required this.highlighted,
  });

  final int stepNumber;
  final String title;
  final String subtitle;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlighted ? tokens.primaryContainer : tokens.surfaceElevated,
        borderRadius: BorderRadius.circular(WiseWebTokens.radiusMd),
        border: Border.all(
          color: highlighted ? tokens.brandPrimary : tokens.borderSubtle,
          width: highlighted ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '0$stepNumber',
            style: WiseWebTypography.mono(
              context,
              size: 11,
              color: highlighted ? tokens.brandPrimary : tokens.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: WiseWebTypography.body(
              context,
              size: 14.5,
              color: tokens.textPrimary,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: WiseWebTypography.mono(
              context,
              size: 11.5,
              color: tokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityBoundaryBlock extends StatelessWidget {
  const _SecurityBoundaryBlock({
    required this.icon,
    required this.accent,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color accent;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    return WiseSurfaceCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
            ),
            child: Icon(icon, size: 22, color: accent),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: WiseWebTypography.cardTitle(context).copyWith(fontSize: 17),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: WiseWebTypography.body(
              context,
              size: 14.5,
              color: tokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
