import 'package:flutter/material.dart';
import '../domain/finance_simulator.dart';
import '../l10n/landing_strings.dart';
import '../theme/wise_web_tokens.dart';
import '../widgets/motion_primitives.dart';

/// Asymmetric split Hero section:
/// - Left: Editorial headline (no eyebrow pill badge per R-09), factual specs, 2 specific CTAs.
/// - Right: 3D-tilt interactive WiseWallet phone mockup + official 3-layer SVG logo reveal.
class HeroSection extends StatefulWidget {
  const HeroSection({
    super.key,
    required this.strings,
    required this.reducedMotion,
    required this.scrollOffset,
    required this.onDownloadTap,
    required this.onExploreTap,
  });

  final LandingStrings strings;
  final bool reducedMotion;
  final double scrollOffset;
  final VoidCallback onDownloadTap;
  final VoidCallback onExploreTap;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  int _phoneTabIndex = 0;
  int _splashReplayToken = 0;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 980;
    final parallaxY = widget.reducedMotion
        ? 0.0
        : (widget.scrollOffset * 0.08).clamp(0.0, 28.0);

    final leftColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Official 3-layer brand reveal paired with replay trigger
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WiseSplashLogoReveal(
              size: 62,
              reducedMotion: widget.reducedMotion,
              replayToken: _splashReplayToken,
            ),
            const SizedBox(width: 14),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.strings.brandName,
                    style: WiseWebTypography.cardTitle(context),
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    key: const Key('replay_splash_button'),
                    onTap: () => setState(() => _splashReplayToken++),
                    mouseCursor: SystemMouseCursors.click,
                    borderRadius: BorderRadius.circular(WiseWebTokens.radiusXs),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 2,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.replay_rounded,
                            size: 14,
                            color: tokens.brandPrimary,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              widget.strings.replaySplashLabel,
                              style: WiseWebTypography.body(
                                context,
                                size: 13,
                                color: tokens.brandPrimary,
                              ).copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Semantics(
          header: true,
          child: Text(
            widget.strings.heroHeadline,
            key: const Key('hero_headline'),
            style: WiseWebTypography.display(context),
          ),
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            widget.strings.heroSubtitle,
            style: WiseWebTypography.body(context, size: 17),
          ),
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            WiseWebButton(
              key: const Key('hero_primary_cta'),
              label: widget.strings.heroPrimaryCta,
              icon: Icons.download_rounded,
              reducedMotion: widget.reducedMotion,
              onPressed: widget.onDownloadTap,
            ),
            WiseWebButton(
              key: const Key('hero_secondary_cta'),
              label: widget.strings.heroSecondaryCta,
              icon: Icons.play_circle_outline_rounded,
              variant: WiseWebButtonVariant.outlined,
              reducedMotion: widget.reducedMotion,
              onPressed: widget.onExploreTap,
            ),
          ],
        ),
        const SizedBox(height: 32),
        // Factual architecture markers (zero fake stats)
        Wrap(
          spacing: 18,
          runSpacing: 12,
          children: [
            _FactualMarker(
              icon: Icons.storage_rounded,
              text: widget.strings.heroFactOffline,
            ),
            _FactualMarker(
              icon: Icons.no_accounts_outlined,
              text: widget.strings.heroFactNoLogin,
            ),
            _FactualMarker(
              icon: Icons.android_rounded,
              text: widget.strings.heroFactAndroid,
            ),
          ],
        ),
      ],
    );

    final rightStage = Transform.translate(
      offset: Offset(0, -parallaxY),
      child: Tilt3DContainer(
        reducedMotion: widget.reducedMotion,
        child: _InteractivePhoneStage(
          strings: widget.strings,
          activeTab: _phoneTabIndex,
          reducedMotion: widget.reducedMotion,
          onTabChanged: (idx) => setState(() => _phoneTabIndex = idx),
        ),
      ),
    );

    return SectionContainer(
      verticalPadding: EdgeInsets.only(
        top: isDesktop ? 56 : 32,
        bottom: isDesktop ? 76 : 48,
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 12, child: leftColumn),
                const SizedBox(width: 48),
                Expanded(flex: 10, child: rightStage),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                leftColumn,
                const SizedBox(height: 36),
                Center(child: rightStage),
              ],
            ),
    );
  }
}

class _FactualMarker extends StatelessWidget {
  const _FactualMarker({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: tokens.brandPrimary),
        const SizedBox(width: 7),
        Flexible(
          child: Text(
            text,
            style: WiseWebTypography.body(
              context,
              size: 13.5,
              color: tokens.textPrimary,
            ).copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class _InteractivePhoneStage extends StatelessWidget {
  const _InteractivePhoneStage({
    required this.strings,
    required this.activeTab,
    required this.reducedMotion,
    required this.onTabChanged,
  });

  final LandingStrings strings;
  final int activeTab;
  final bool reducedMotion;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    final isEn = strings.locale == LandingLocale.en;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 410),
      child: WiseSurfaceCard(
        elevated: true,
        radius: WiseWebTokens.radiusXl,
        padding: const EdgeInsets.all(18),
        borderColor: tokens.borderStrong,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar inside phone mockup
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: tokens.primaryContainer,
                      borderRadius:
                          BorderRadius.circular(WiseWebTokens.radiusXs),
                    ),
                    child: Text(
                      strings.simulationTag,
                      overflow: TextOverflow.ellipsis,
                      style: WiseWebTypography.mono(
                        context,
                        size: 11,
                        color: tokens.brandPrimary,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.wifi_off_rounded, size: 15, color: tokens.income),
                const SizedBox(width: 5),
                Text(
                  'SQLite Local',
                  style: WiseWebTypography.mono(
                    context,
                    size: 11.5,
                    color: tokens.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Animated tab content inside phone
            AnimatedSwitcher(
              duration: reducedMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 240),
              switchInCurve: Curves.easeOutCubic,
              child: KeyedSubtree(
                key: ValueKey(activeTab),
                child: _buildPhoneBody(context, tokens, isEn),
              ),
            ),
            const SizedBox(height: 16),
            // Interactive bottom nav bar replicating WiseWallet's primary nav
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: tokens.surfaceElevated,
                borderRadius: BorderRadius.circular(WiseWebTokens.radiusMd),
                border: Border.all(color: tokens.borderSubtle),
              ),
              child: Row(
                children: [
                  _PhoneNavTab(
                    key: const Key('hero_phone_tab_0'),
                    icon: Icons.home_outlined,
                    label: strings.phoneTabHome,
                    selected: activeTab == 0,
                    onTap: () => onTabChanged(0),
                  ),
                  _PhoneNavTab(
                    key: const Key('hero_phone_tab_1'),
                    icon: Icons.calendar_month_outlined,
                    label: strings.phoneTabCalendar,
                    selected: activeTab == 1,
                    onTap: () => onTabChanged(1),
                  ),
                  _PhoneNavTab(
                    key: const Key('hero_phone_tab_2'),
                    icon: Icons.pie_chart_outline_rounded,
                    label: strings.phoneTabBudget,
                    selected: activeTab == 2,
                    onTap: () => onTabChanged(2),
                  ),
                  _PhoneNavTab(
                    key: const Key('hero_phone_tab_3'),
                    icon: Icons.handshake_outlined,
                    label: strings.phoneTabDebts,
                    selected: activeTab == 3,
                    onTap: () => onTabChanged(3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneBody(
    BuildContext context,
    WiseWebTokens tokens,
    bool isEn,
  ) {
    switch (activeTab) {
      case 1:
        return _PhoneCalendarPreview(tokens: tokens, isEn: isEn);
      case 2:
        return _PhoneBudgetPreview(tokens: tokens, isEn: isEn);
      case 3:
        return _PhoneDebtsPreview(tokens: tokens, isEn: isEn);
      default:
        return _PhoneHomePreview(tokens: tokens, isEn: isEn);
    }
  }
}

class _PhoneHomePreview extends StatelessWidget {
  const _PhoneHomePreview({required this.tokens, required this.isEn});

  final WiseWebTokens tokens;
  final bool isEn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: tokens.brandPrimary,
            borderRadius: BorderRadius.circular(WiseWebTokens.radiusMd),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEn ? 'Total Active Balance' : 'Total Saldo Aktif',
                style: WiseWebTypography.body(
                  context,
                  size: 12.5,
                  color: tokens.brandOnPrimary.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formatRupiah(12480000),
                style: WiseWebTypography.money(
                  context,
                  size: 26,
                  color: tokens.brandOnPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _MiniMetric(
                      label: isEn ? 'Income' : 'Pemasukan',
                      value: formatRupiah(8500000),
                      fg: tokens.brandOnPrimary,
                      icon: Icons.arrow_downward_rounded,
                    ),
                  ),
                  Expanded(
                    child: _MiniMetric(
                      label: isEn ? 'Expense' : 'Pengeluaran',
                      value: formatRupiah(3420000),
                      fg: tokens.brandOnPrimary,
                      icon: Icons.arrow_upward_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _WalletPill(
                name: isEn ? 'Cash' : 'Tunai',
                amount: formatRupiah(1250000),
                tokens: tokens,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _WalletPill(
                name: 'Bank BCA',
                amount: formatRupiah(9830000),
                tokens: tokens,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _WalletPill(
                name: 'GoPay',
                amount: formatRupiah(1400000),
                tokens: tokens,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _TxRow(
          title: isEn ? 'Groceries Alfamart (OCR)' : 'Belanja Alfamart (OCR)',
          subtitle: isEn ? 'Shopping · 14:15' : 'Belanja · 14:15',
          amount: '-${formatRupiah(34500)}',
          color: tokens.expense,
          icon: Icons.receipt_long_outlined,
        ),
        const SizedBox(height: 8),
        _TxRow(
          title: isEn ? 'Design Project (Voice)' : 'Proyek Desain (Suara)',
          subtitle: 'Freelance · 10:20',
          amount: '+${formatRupiah(2000000)}',
          color: tokens.income,
          icon: Icons.mic_none_rounded,
        ),
      ],
    );
  }
}

class _PhoneCalendarPreview extends StatelessWidget {
  const _PhoneCalendarPreview({required this.tokens, required this.isEn});

  final WiseWebTokens tokens;
  final bool isEn;

  @override
  Widget build(BuildContext context) {
    final days = isEn
        ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        : ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEn ? 'October 2026 (Local Date)' : 'Oktober 2026 (Tanggal Lokal)',
          style: WiseWebTypography.cardTitle(context).copyWith(fontSize: 15),
        ),
        const SizedBox(height: 10),
        Row(
          children: days
              .map(
                (d) => Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: WiseWebTypography.mono(
                        context,
                        size: 11,
                        color: tokens.textMuted,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          children: List.generate(14, (i) {
            final day = i + 12;
            final isSelected = day == 20;
            final hasIn = day == 15 || day == 20;
            final hasOut = day == 13 || day == 18 || day == 20 || day == 24;
            return Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? tokens.primaryContainer
                    : tokens.surfaceElevated,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? tokens.brandPrimary : tokens.borderSubtle,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$day',
                    style: WiseWebTypography.mono(
                      context,
                      size: 11.5,
                      color: isSelected
                          ? tokens.brandPrimary
                          : tokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (hasIn)
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: tokens.income,
                            shape: BoxShape.circle,
                          ),
                        ),
                      if (hasIn && hasOut) const SizedBox(width: 2),
                      if (hasOut)
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: tokens.expense,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        Text(
          isEn
              ? '20 Oct: +Rp2.000.000 income · -Rp34.500 expense (no UTC shift)'
              : '20 Okt: +Rp2.000.000 masuk · -Rp34.500 keluar (tanpa geser UTC)',
          style: WiseWebTypography.body(context, size: 12.5),
        ),
      ],
    );
  }
}

class _PhoneBudgetPreview extends StatelessWidget {
  const _PhoneBudgetPreview({required this.tokens, required this.isEn});

  final WiseWebTokens tokens;
  final bool isEn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MiniBudgetRow(
          label: isEn ? 'Food (All Wallets)' : 'Makanan (Semua Dompet)',
          status: isEn ? 'Safe · 62%' : 'Aman · 62%',
          ratio: 0.62,
          color: tokens.income,
          remainingText:
              '${isEn ? "Daily limit" : "Batas harian"}: ${formatRupiah(47500)}',
        ),
        const SizedBox(height: 10),
        _MiniBudgetRow(
          label: isEn ? 'Transport (GoPay)' : 'Transportasi (GoPay)',
          status: isEn ? 'Nearly Used · 86%' : 'Hampir Habis · 86%',
          ratio: 0.86,
          color: tokens.warning,
          remainingText:
              '${isEn ? "Remaining" : "Sisa"}: ${formatRupiah(70000)}',
        ),
        const SizedBox(height: 10),
        _MiniBudgetRow(
          label: isEn ? 'Entertainment' : 'Hiburan',
          status: isEn ? 'Over Budget · 108%' : 'Melebihi Anggaran · 108%',
          ratio: 1.0,
          color: tokens.expense,
          remainingText:
              '${isEn ? "Over by" : "Lebih"}: ${formatRupiah(40000)}',
        ),
      ],
    );
  }
}

class _PhoneDebtsPreview extends StatelessWidget {
  const _PhoneDebtsPreview({required this.tokens, required this.isEn});

  final WiseWebTokens tokens;
  final bool isEn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: tokens.surfaceElevated,
            borderRadius: BorderRadius.circular(WiseWebTokens.radiusMd),
            border: Border.all(color: tokens.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    isEn ? 'Receivable · Raka Pratama' : 'Piutang · Raka Pratama',
                    style: WiseWebTypography.cardTitle(context)
                        .copyWith(fontSize: 14.5),
                  ),
                  const Spacer(),
                  Text(
                    isEn ? 'Installment' : 'Dicicil',
                    style: WiseWebTypography.mono(
                      context,
                      size: 11.5,
                      color: tokens.warning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${isEn ? "Remaining" : "Sisa"}: ${formatRupiah(750000)} / ${formatRupiah(1200000)}',
                style: WiseWebTypography.money(context, size: 15),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: 0.375,
                  minHeight: 7,
                  backgroundColor: tokens.borderSubtle,
                  color: tokens.brandPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isEn
                    ? 'Isolated from Income, Expense & Budgets. Supports Add Principal and optional wallet mutation.'
                    : 'Terisolasi dari Pemasukan, Pengeluaran & Anggaran. Mendukung Tambah Pokok & dompet opsional.',
                style: WiseWebTypography.body(context, size: 12.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.label,
    required this.value,
    required this.fg,
    required this.icon,
  });

  final String label;
  final String value;
  final Color fg;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: fg.withValues(alpha: 0.85)),
        const SizedBox(width: 5),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: WiseWebTypography.body(
                  context,
                  size: 11,
                  color: fg.withValues(alpha: 0.8),
                ),
              ),
              Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: WiseWebTypography.money(context, size: 13.5, color: fg),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WalletPill extends StatelessWidget {
  const _WalletPill({
    required this.name,
    required this.amount,
    required this.tokens,
  });

  final String name;
  final String amount;
  final WiseWebTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: tokens.surfaceElevated,
        borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
        border: Border.all(color: tokens.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: WiseWebTypography.body(
              context,
              size: 11.5,
              color: tokens.textMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            amount,
            overflow: TextOverflow.ellipsis,
            style: WiseWebTypography.money(context, size: 12.5),
          ),
        ],
      ),
    );
  }
}

class _TxRow extends StatelessWidget {
  const _TxRow({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.color,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String amount;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: tokens.surfaceElevated,
        borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: WiseWebTypography.body(
                    context,
                    size: 13,
                    color: tokens.textPrimary,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: WiseWebTypography.body(
                    context,
                    size: 11.5,
                    color: tokens.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            amount,
            style: WiseWebTypography.money(context, size: 13, color: color),
          ),
        ],
      ),
    );
  }
}

class _MiniBudgetRow extends StatelessWidget {
  const _MiniBudgetRow({
    required this.label,
    required this.status,
    required this.ratio,
    required this.color,
    required this.remainingText,
  });

  final String label;
  final String status;
  final double ratio;
  final Color color;
  final String remainingText;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.surfaceElevated,
        borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: WiseWebTypography.body(
                    context,
                    size: 13,
                    color: tokens.textPrimary,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                status,
                style: WiseWebTypography.mono(context, size: 11.5, color: color),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 7,
              backgroundColor: tokens.borderSubtle,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            remainingText,
            style: WiseWebTypography.body(
              context,
              size: 11.5,
              color: tokens.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneNavTab extends StatelessWidget {
  const _PhoneNavTab({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        mouseCursor: SystemMouseCursors.click,
        borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          decoration: BoxDecoration(
            color: selected ? tokens.surfaceCard : Colors.transparent,
            borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
            border: selected ? Border.all(color: tokens.borderSubtle) : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: selected ? tokens.brandPrimary : tokens.textMuted,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: WiseWebTypography.body(
                  context,
                  size: 10.5,
                  color: selected ? tokens.brandPrimary : tokens.textMuted,
                ).copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
