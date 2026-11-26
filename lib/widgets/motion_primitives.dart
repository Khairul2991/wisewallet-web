import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/wise_web_tokens.dart';

/// Official 2,000 ms 3-layer SVG logo reveal choreography from
/// docs/wisewallet_motion_spec.md:
///   0-920 ms: Wallet fade (scale 0.96 -> 1.0 over 0-1560 ms)
///   400-1400 ms: Cyan card fade + slide up from +10%
///   840-1760 ms: W mark fade
///   1760-2000 ms: Exact source PNG crossfade
class WiseSplashLogoReveal extends StatefulWidget {
  const WiseSplashLogoReveal({
    super.key,
    required this.size,
    required this.reducedMotion,
    this.replayToken = 0,
  });

  final double size;
  final bool reducedMotion;
  final int replayToken;

  @override
  State<WiseSplashLogoReveal> createState() => _WiseSplashLogoRevealState();
}

class _WiseSplashLogoRevealState extends State<WiseSplashLogoReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    if (widget.reducedMotion) {
      _controller.value = 1.0;
    } else {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant WiseSplashLogoReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reducedMotion) {
      _controller.value = 1.0;
    } else if (widget.replayToken != oldWidget.replayToken ||
        oldWidget.reducedMotion != widget.reducedMotion) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _interval(double t, double startMs, double endMs, Curve curve) {
    final start = startMs / 2000.0;
    final end = endMs / 2000.0;
    if (t <= start) return 0.0;
    if (t >= end) return 1.0;
    return curve.transform((t - start) / (end - start));
  }

  @override
  Widget build(BuildContext context) {
    final disable = widget.reducedMotion || MediaQuery.disableAnimationsOf(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.size * 0.22),
      child: Container(
        width: widget.size,
        height: widget.size,
        color: const Color(0xFF1E5CD9),
        child: disable
            ? Image.asset(
                'assets/branding/wisewallet_app_icon_master.png',
                width: widget.size,
                height: widget.size,
                fit: BoxFit.contain,
                semanticLabel: 'WiseWallet logo',
              )
            : AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final t = _controller.value;
                  final walletOpacity = _interval(t, 0, 920, Curves.easeOutCubic);
                  final walletScale =
                      0.96 + 0.04 * _interval(t, 0, 1560, Curves.easeOutCubic);
                  final cardProgress =
                      _interval(t, 400, 1400, Curves.easeOutCubic);
                  final markOpacity =
                      _interval(t, 840, 1760, Curves.easeOutCubic);
                  final pngOpacity =
                      _interval(t, 1760, 2000, Curves.easeInOut);

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Opacity(
                        opacity: cardProgress,
                        child: Transform.translate(
                          offset: Offset(0, widget.size * 0.10 * (1 - cardProgress)),
                          child: SvgPicture.asset(
                            'assets/branding/wisewallet_splash_card.svg',
                            fit: BoxFit.contain,
                            excludeFromSemantics: true,
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: walletOpacity,
                        child: Transform.scale(
                          scale: walletScale,
                          child: SvgPicture.asset(
                            'assets/branding/wisewallet_splash_wallet.svg',
                            fit: BoxFit.contain,
                            excludeFromSemantics: true,
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: markOpacity,
                        child: SvgPicture.asset(
                          'assets/branding/wisewallet_splash_mark.svg',
                          fit: BoxFit.contain,
                          excludeFromSemantics: true,
                        ),
                      ),
                      Opacity(
                        opacity: pngOpacity,
                        child: Image.asset(
                          'assets/branding/wisewallet_app_icon_master.png',
                          fit: BoxFit.contain,
                          semanticLabel: 'WiseWallet logo',
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

enum WiseWebButtonVariant { primary, secondary, outlined, ghost }

/// Tactile button faithfully implementing ART_DIRECTION.md:
/// NoSplash, 0.98x scale + 1px sink on press, >= 44px touch target,
/// pointer cursor, and high-contrast keyboard focus ring.
class WiseWebButton extends StatefulWidget {
  const WiseWebButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = WiseWebButtonVariant.primary,
    this.icon,
    this.reducedMotion = false,
    this.compact = false,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final WiseWebButtonVariant variant;
  final IconData? icon;
  final bool reducedMotion;
  final bool compact;
  final String? semanticLabel;

  @override
  State<WiseWebButton> createState() => _WiseWebButtonState();
}

class _WiseWebButtonState extends State<WiseWebButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    final enabled = widget.onPressed != null;
    final disableMotion =
        widget.reducedMotion || MediaQuery.disableAnimationsOf(context);

    Color bg;
    Color fg;
    Color borderColor;
    switch (widget.variant) {
      case WiseWebButtonVariant.primary:
        bg = tokens.brandPrimary;
        fg = tokens.brandOnPrimary;
        borderColor = tokens.brandPrimary;
      case WiseWebButtonVariant.secondary:
        bg = tokens.primaryContainer;
        fg = tokens.brandPrimary;
        borderColor = tokens.brandPrimary.withValues(alpha: 0.25);
      case WiseWebButtonVariant.outlined:
        bg = tokens.surfaceCard;
        fg = tokens.textPrimary;
        borderColor = tokens.borderStrong;
      case WiseWebButtonVariant.ghost:
        bg = _hovered
            ? tokens.brandPrimary.withValues(alpha: 0.08)
            : Colors.transparent;
        fg = tokens.textPrimary;
        borderColor = Colors.transparent;
    }

    if (!enabled) {
      bg = tokens.surfaceElevated;
      fg = tokens.textMuted;
      borderColor = tokens.borderSubtle;
    } else if (_hovered && widget.variant == WiseWebButtonVariant.primary) {
      bg = Color.lerp(bg, tokens.textPrimary, 0.12)!;
    } else if (_hovered && widget.variant == WiseWebButtonVariant.outlined) {
      bg = tokens.surfaceElevated;
    }

    final Matrix4 transform = disableMotion
        ? Matrix4.identity()
        : (_pressed
            ? (Matrix4.identity()
              ..translateByDouble(0.0, 1.0, 0.0, 1.0)
              ..scaleByDouble(0.98, 0.98, 1.0, 1.0))
            : (_hovered && widget.variant == WiseWebButtonVariant.primary
                ? (Matrix4.identity()..translateByDouble(0.0, -1.5, 0.0, 1.0))
                : Matrix4.identity()));

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.semanticLabel ?? widget.label,
      child: FocusableActionDetector(
        enabled: enabled,
        mouseCursor:
            enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        onShowHoverHighlight: (v) => setState(() => _hovered = v),
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onPressed?.call();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
          onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
          onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: disableMotion
                ? Duration.zero
                : const Duration(milliseconds: 140),
            curve: Curves.easeOutCubic,
            transform: transform,
            transformAlignment: Alignment.center,
            constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
            padding: EdgeInsets.symmetric(
              horizontal: widget.compact ? 14 : 20,
              vertical: widget.compact ? 10 : 12,
            ),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(WiseWebTokens.radiusMd),
              border: Border.all(
                color: _focused ? tokens.borderFocus : borderColor,
                width: _focused ? 2.5 : 1.0,
              ),
              boxShadow: _focused
                  ? [
                      BoxShadow(
                        color: tokens.borderFocus.withValues(alpha: 0.35),
                        blurRadius: 0,
                        spreadRadius: 2,
                      ),
                    ]
                  : (widget.variant == WiseWebButtonVariant.primary && enabled
                      ? [
                          BoxShadow(
                            color: tokens.brandPrimary
                                .withValues(alpha: _hovered ? 0.24 : 0.14),
                            blurRadius: _hovered ? 18 : 12,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 18, color: fg),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    widget.label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: WiseWebTypography.bodyFamily,
                      fontSize: widget.compact ? 13.5 : 14.5,
                      fontWeight: FontWeight.w600,
                      color: fg,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Modern Tactile Fintech layered card surface with calibrated 1px border
/// and selective ambient shadow.
class WiseSurfaceCard extends StatelessWidget {
  const WiseSurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.radius = WiseWebTokens.radiusLg,
    this.elevated = false,
    this.backgroundColor,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool elevated;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? tokens.surfaceCard,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor ?? tokens.borderSubtle,
          width: 1,
        ),
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: tokens.ambientShadow,
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

/// Entrance reveal animation tuned for scroll rhythm. Respects reduced motion
/// immediately by rendering at full opacity and zero offset.
class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    super.key,
    required this.child,
    required this.reducedMotion,
    this.delay = Duration.zero,
    this.offsetY = 20,
    this.scrollListenable,
  });

  final Widget child;
  final bool reducedMotion;
  final Duration delay;
  final double offsetY;
  final Listenable? scrollListenable;

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    if (widget.reducedMotion) {
      _triggered = true;
      _controller.value = 1.0;
    } else {
      widget.scrollListenable?.addListener(_checkVisibility);
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
    }
  }

  @override
  void didUpdateWidget(covariant ScrollReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollListenable != widget.scrollListenable) {
      oldWidget.scrollListenable?.removeListener(_checkVisibility);
      if (!widget.reducedMotion && !_triggered) {
        widget.scrollListenable?.addListener(_checkVisibility);
      }
    }
    if (widget.reducedMotion) {
      _triggered = true;
      _controller.value = 1.0;
    }
  }

  void _checkVisibility() {
    if (!mounted || _triggered) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;
    final position = renderBox.localToGlobal(Offset.zero);
    final viewportHeight = MediaQuery.sizeOf(context).height;
    if (position.dy < viewportHeight * 0.94) {
      _triggered = true;
      widget.scrollListenable?.removeListener(_checkVisibility);
      if (widget.delay == Duration.zero) {
        _controller.forward();
      } else {
        Future<void>.delayed(widget.delay, () {
          if (mounted) _controller.forward();
        });
      }
    }
  }

  @override
  void dispose() {
    widget.scrollListenable?.removeListener(_checkVisibility);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disable = widget.reducedMotion || MediaQuery.disableAnimationsOf(context);
    if (disable) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final t = Curves.easeOutCubic.transform(_controller.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, widget.offsetY * (1 - t)),
            child: child,
          ),
        );
      },
    );
  }
}

/// Subtle pointer-driven 3D perspective tilt for the Hero Phone Stage on desktop.
class Tilt3DContainer extends StatefulWidget {
  const Tilt3DContainer({
    super.key,
    required this.child,
    required this.reducedMotion,
    this.maxRadians = 0.07,
  });

  final Widget child;
  final bool reducedMotion;
  final double maxRadians;

  @override
  State<Tilt3DContainer> createState() => _Tilt3DContainerState();
}

class _Tilt3DContainerState extends State<Tilt3DContainer> {
  double _rotX = 0.0;
  double _rotY = 0.0;

  void _onHover(PointerHoverEvent event, BoxConstraints constraints) {
    if (widget.reducedMotion || MediaQuery.disableAnimationsOf(context)) return;
    if (constraints.maxWidth <= 0 || constraints.maxHeight <= 0) return;
    final nx = (event.localPosition.dx / constraints.maxWidth) * 2 - 1;
    final ny = (event.localPosition.dy / constraints.maxHeight) * 2 - 1;
    setState(() {
      _rotY = nx.clamp(-1.0, 1.0) * widget.maxRadians;
      _rotX = -ny.clamp(-1.0, 1.0) * widget.maxRadians;
    });
  }

  void _onExit(PointerExitEvent _) {
    if (_rotX != 0.0 || _rotY != 0.0) {
      setState(() {
        _rotX = 0.0;
        _rotY = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final disable = widget.reducedMotion || MediaQuery.disableAnimationsOf(context);
    if (disable) return widget.child;

    return LayoutBuilder(
      builder: (context, constraints) {
        final matrix = Matrix4.identity()
          ..setEntry(3, 2, 0.0012)
          ..rotateX(_rotX)
          ..rotateY(_rotY);

        return MouseRegion(
          onHover: (e) => _onHover(e, constraints),
          onExit: _onExit,
          child: TweenAnimationBuilder<Matrix4>(
            tween: Matrix4Tween(begin: Matrix4.identity(), end: matrix),
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) => Transform(
              transform: value,
              alignment: Alignment.center,
              child: child,
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Pauseable horizontal principle marquee strip (R-19 & R-39 compliant):
/// Includes explicit Pause/Play button, pauses on hover, and renders a static
/// wrapped chip layout under reduced motion.
class KineticPrincipleStrip extends StatefulWidget {
  const KineticPrincipleStrip({
    super.key,
    required this.items,
    required this.pauseLabel,
    required this.playLabel,
    required this.reducedMotion,
  });

  final List<String> items;
  final String pauseLabel;
  final String playLabel;
  final bool reducedMotion;

  @override
  State<KineticPrincipleStrip> createState() => _KineticPrincipleStripState();
}

class _KineticPrincipleStripState extends State<KineticPrincipleStrip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ticker;
  bool _userPaused = false;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ticker = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 34),
    );
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant KineticPrincipleStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnimation();
  }

  void _syncAnimation() {
    if (widget.reducedMotion || _userPaused || _hovered) {
      _ticker.stop();
    } else if (!_ticker.isAnimating) {
      _ticker.repeat();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  Widget _buildChip(BuildContext context, String label) {
    final tokens = WiseWebTokens.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: tokens.surfaceCard,
        borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
        border: Border.all(color: tokens.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_outlined,
            size: 15,
            color: tokens.brandPrimary,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: WiseWebTypography.body(
                context,
                size: 13.5,
                color: tokens.textPrimary,
              ).copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    final disable = widget.reducedMotion || MediaQuery.disableAnimationsOf(context);
    final width = MediaQuery.sizeOf(context).width;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: tokens.surfaceElevated,
        border: Border.symmetric(
          horizontal: BorderSide(color: tokens.borderSubtle),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width < 640 ? 16 : 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (disable)
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: widget.items
                        .map((item) => _buildChip(context, item))
                        .toList(),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: MouseRegion(
                          onEnter: (_) {
                            setState(() => _hovered = true);
                            _syncAnimation();
                          },
                          onExit: (_) {
                            setState(() => _hovered = false);
                            _syncAnimation();
                          },
                          child: ClipRect(
                            child: SizedBox(
                              height: 44,
                              child: AnimatedBuilder(
                                animation: _ticker,
                                builder: (context, _) {
                                  const approxTrackWidth = 2200.0;
                                  final dx =
                                      -(_ticker.value * approxTrackWidth) %
                                          approxTrackWidth;
                                  return OverflowBox(
                                    alignment: Alignment.centerLeft,
                                    maxWidth: double.infinity,
                                    child: Transform.translate(
                                      offset: Offset(dx, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          for (var pass = 0; pass < 2; pass++)
                                            for (final item in widget.items)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 12,
                                                ),
                                                child: _buildChip(context, item),
                                              ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      WiseWebButton(
                        key: const Key('principle_strip_pause_button'),
                        label: _userPaused
                            ? widget.playLabel
                            : widget.pauseLabel,
                        icon: _userPaused
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded,
                        variant: WiseWebButtonVariant.outlined,
                        compact: true,
                        reducedMotion: widget.reducedMotion,
                        onPressed: () {
                          setState(() => _userPaused = !_userPaused);
                          _syncAnimation();
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shared centered content container maintaining clean breathing margins across
/// desktop (1440px), tablet (768px), and mobile (375px).
class SectionContainer extends StatelessWidget {
  const SectionContainer({
    super.key,
    required this.child,
    this.verticalPadding,
    this.backgroundColor,
    this.maxWidth = 1200,
  });

  final Widget child;
  final EdgeInsetsGeometry? verticalPadding;
  final Color? backgroundColor;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width >= 1024
        ? 40.0
        : width >= 640
            ? 28.0
            : 18.0;
    final defaultVert = width >= 900 ? 84.0 : 52.0;

    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: verticalPadding ??
          EdgeInsets.symmetric(vertical: defaultVert),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontal),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Decorative animated wave equalizer painted for the Offline Voice simulator.
class VoiceWavePainter extends CustomPainter {
  VoiceWavePainter({
    required this.phase,
    required this.active,
    required this.barColor,
    required this.idleColor,
  });

  final double phase;
  final bool active;
  final Color barColor;
  final Color idleColor;

  @override
  void paint(Canvas canvas, Size size) {
    const barCount = 24;
    final gap = size.width / barCount;
    final paint = Paint()
      ..color = active ? barColor : idleColor
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < barCount; i++) {
      final x = gap * i + gap / 2;
      final envelope = math.sin((i / (barCount - 1)) * math.pi);
      final wave = active
          ? (0.25 + 0.75 * (0.5 + 0.5 * math.sin(phase * 2 * math.pi + i * 0.65)))
          : 0.22;
      final barHeight = math.max(6.0, size.height * envelope * wave);
      final top = (size.height - barHeight) / 2;
      canvas.drawLine(Offset(x, top), Offset(x, top + barHeight), paint);
    }
  }

  @override
  bool shouldRepaint(covariant VoiceWavePainter oldDelegate) =>
      oldDelegate.phase != phase ||
      oldDelegate.active != active ||
      oldDelegate.barColor != barColor;
}
