import 'package:flutter/material.dart';
import '../domain/finance_simulator.dart';
import '../l10n/landing_strings.dart';
import '../theme/wise_web_tokens.dart';
import '../widgets/motion_primitives.dart';

enum _SimUiState { normal, empty, loading, error }

/// Interactive Financial Core Playground (#keuangan):
/// 5 interactive modules (Wallets & Net-Zero Transfer, Budgets & Daily Limit,
/// Local Calendar & Recurring, Isolated Debts & Receivables, Local Multi-Profile)
/// plus an explicit UI State Switcher (Data / Empty / Loading / Error per R-27).
class FinancialCoreSection extends StatefulWidget {
  const FinancialCoreSection({
    super.key,
    required this.strings,
    required this.reducedMotion,
    this.scrollListenable,
  });

  final LandingStrings strings;
  final bool reducedMotion;
  final Listenable? scrollListenable;

  @override
  State<FinancialCoreSection> createState() => _FinancialCoreSectionState();
}

class _FinancialCoreSectionState extends State<FinancialCoreSection> {
  int _activeTab = 0;
  _SimUiState _uiState = _SimUiState.normal;

  // Transfer simulation state
  double _transferAmount = 500000;

  // Budget simulation state
  double _budgetSpent = 720000;
  bool _budgetAllWallets = true;

  // Calendar simulation state
  bool _startMonday = true;
  int _selectedDay = 20;

  // Debt simulation state
  DebtSimulationState _debt = DebtSimulationState.sample();

  // Multi-profile simulation state
  int _activeProfile = 0;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    final isEn = widget.strings.locale == LandingLocale.en;

    return SectionContainer(
      backgroundColor: tokens.surfaceElevated.withValues(alpha: 0.65),
      child: ScrollReveal(
        reducedMotion: widget.reducedMotion,
        scrollListenable: widget.scrollListenable,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.strings.coreTitle,
                        style: WiseWebTypography.sectionTitle(context),
                      ),
                      const SizedBox(height: 10),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 680),
                        child: Text(
                          widget.strings.coreSubtitle,
                          style: WiseWebTypography.body(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Primary module tabs (horizontal scroll on narrow viewports)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _CoreTab(
                    key: const Key('core_tab_transfer'),
                    label: widget.strings.coreTabTransfer,
                    icon: Icons.swap_horiz_rounded,
                    selected: _activeTab == 0,
                    onTap: () => setState(() {
                      _activeTab = 0;
                      _uiState = _SimUiState.normal;
                    }),
                  ),
                  const SizedBox(width: 8),
                  _CoreTab(
                    key: const Key('core_tab_budget'),
                    label: widget.strings.coreTabBudget,
                    icon: Icons.donut_large_rounded,
                    selected: _activeTab == 1,
                    onTap: () => setState(() {
                      _activeTab = 1;
                      _uiState = _SimUiState.normal;
                    }),
                  ),
                  const SizedBox(width: 8),
                  _CoreTab(
                    key: const Key('core_tab_calendar'),
                    label: widget.strings.coreTabCalendar,
                    icon: Icons.calendar_today_rounded,
                    selected: _activeTab == 2,
                    onTap: () => setState(() {
                      _activeTab = 2;
                      _uiState = _SimUiState.normal;
                    }),
                  ),
                  const SizedBox(width: 8),
                  _CoreTab(
                    key: const Key('core_tab_debts'),
                    label: widget.strings.coreTabDebts,
                    icon: Icons.handshake_outlined,
                    selected: _activeTab == 3,
                    onTap: () => setState(() {
                      _activeTab = 3;
                      _uiState = _SimUiState.normal;
                    }),
                  ),
                  const SizedBox(width: 8),
                  _CoreTab(
                    key: const Key('core_tab_profiles'),
                    label: widget.strings.coreTabProfiles,
                    icon: Icons.switch_account_outlined,
                    selected: _activeTab == 4,
                    onTap: () => setState(() {
                      _activeTab = 4;
                      _uiState = _SimUiState.normal;
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // Explicit UI state resilience bar (Antislop R-27)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  widget.strings.uiStateLabel,
                  style: WiseWebTypography.body(
                    context,
                    size: 13,
                    color: tokens.textMuted,
                  ),
                ),
                _StatePill(
                  key: const Key('ui_state_normal'),
                  label: widget.strings.uiStateNormal,
                  selected: _uiState == _SimUiState.normal,
                  onTap: () => setState(() => _uiState = _SimUiState.normal),
                ),
                _StatePill(
                  key: const Key('ui_state_empty'),
                  label: widget.strings.uiStateEmpty,
                  selected: _uiState == _SimUiState.empty,
                  onTap: () => setState(() => _uiState = _SimUiState.empty),
                ),
                _StatePill(
                  key: const Key('ui_state_loading'),
                  label: widget.strings.uiStateLoading,
                  selected: _uiState == _SimUiState.loading,
                  onTap: () => setState(() => _uiState = _SimUiState.loading),
                ),
                _StatePill(
                  key: const Key('ui_state_error'),
                  label: widget.strings.uiStateError,
                  selected: _uiState == _SimUiState.error,
                  onTap: () => setState(() => _uiState = _SimUiState.error),
                ),
              ],
            ),
            const SizedBox(height: 20),
            WiseSurfaceCard(
              elevated: true,
              padding: const EdgeInsets.all(24),
              child: AnimatedSwitcher(
                duration: widget.reducedMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 240),
                child: KeyedSubtree(
                  key: ValueKey('$_activeTab-$_uiState'),
                  child: _buildPanelBody(context, tokens, isEn),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanelBody(
    BuildContext context,
    WiseWebTokens tokens,
    bool isEn,
  ) {
    if (_uiState == _SimUiState.empty) {
      return _buildResilientState(
        key: const Key('sim_empty_state'),
        icon: Icons.inbox_outlined,
        accent: tokens.brandPrimary,
        title: widget.strings.emptyStateTitle,
        body: widget.strings.emptyStateBody,
        actionLabel: widget.strings.emptyStateAction,
        onAction: () => setState(() => _uiState = _SimUiState.normal),
      );
    }
    if (_uiState == _SimUiState.loading) {
      return Padding(
        key: const Key('sim_loading_state'),
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              children: [
                LinearProgressIndicator(
                  color: tokens.brandPrimary,
                  backgroundColor: tokens.primaryContainer,
                ),
                const SizedBox(height: 18),
                Text(
                  widget.strings.loadingStateTitle,
                  textAlign: TextAlign.center,
                  style: WiseWebTypography.cardTitle(context),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.strings.loadingStateBody,
                  textAlign: TextAlign.center,
                  style: WiseWebTypography.body(context, size: 14.5),
                ),
              ],
            ),
          ),
        ),
      );
    }
    if (_uiState == _SimUiState.error) {
      return _buildResilientState(
        key: const Key('sim_error_state'),
        icon: Icons.error_outline_rounded,
        accent: tokens.expense,
        title: widget.strings.errorStateTitle,
        body: widget.strings.errorStateBody,
        actionLabel: widget.strings.errorStateAction,
        onAction: () => setState(() => _uiState = _SimUiState.normal),
      );
    }

    switch (_activeTab) {
      case 0:
        return _buildTransferSimulator(context, tokens, isEn);
      case 1:
        return _buildBudgetSimulator(context, tokens, isEn);
      case 2:
        return _buildCalendarSimulator(context, tokens, isEn);
      case 3:
        return _buildDebtSimulator(context, tokens, isEn);
      default:
        return _buildProfilesSimulator(context, tokens, isEn);
    }
  }

  Widget _buildResilientState({
    required Key key,
    required IconData icon,
    required Color accent,
    required String title,
    required String body,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: accent),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: WiseWebTypography.cardTitle(context),
              ),
              const SizedBox(height: 8),
              Text(
                body,
                textAlign: TextAlign.center,
                style: WiseWebTypography.body(context, size: 14.5),
              ),
              const SizedBox(height: 18),
              WiseWebButton(
                label: actionLabel,
                variant: WiseWebButtonVariant.secondary,
                reducedMotion: widget.reducedMotion,
                onPressed: onAction,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransferSimulator(
    BuildContext context,
    WiseWebTokens tokens,
    bool isEn,
  ) {
    final res = simulateTransfer(
      sourceBalance: 4500000,
      destBalance: 1500000,
      amount: _transferAmount.round(),
      monthlyIncome: 8500000,
      monthlyExpense: 3420000,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEn
              ? 'Net-Zero Wallet Transfers & Account Archiving'
              : 'Transfer Antar Dompet Net-Zero & Perlindungan Arsip Akun',
          style: WiseWebTypography.cardTitle(context),
        ),
        const SizedBox(height: 8),
        Text(
          isEn
              ? 'Drag the slider to transfer funds from Bank BCA to Cash. Notice Total Balance and Net Cash Flow never drift. Used accounts are archived (soft-deleted) rather than wiped so history stays intact.'
              : 'Geser slider untuk memindahkan dana dari Bank BCA ke Tunai. Perhatikan Total Saldo dan Arus Kas Bersih tetap konstan. Akun yang pernah dipakai otomatis diarsipkan (soft delete) agar histori tidak rusak.',
          style: WiseWebTypography.body(context, size: 15),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 10,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              isEn ? 'Transfer amount:' : 'Nominal transfer:',
              style: WiseWebTypography.body(
                context,
                size: 14,
                color: tokens.textPrimary,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              formatRupiah(_transferAmount.round()),
              style: WiseWebTypography.money(
                context,
                size: 18,
                color: tokens.brandPrimary,
              ),
            ),
          ],
        ),
        Slider(
          key: const Key('transfer_slider'),
          value: _transferAmount,
          min: 0,
          max: 3000000,
          divisions: 30,
          activeColor: tokens.brandPrimary,
          label: formatRupiah(_transferAmount.round()),
          onChanged: (v) => setState(() => _transferAmount = v),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _MetricCard(
              label: 'Bank BCA (${isEn ? "Source" : "Sumber"})',
              value: formatRupiah(res.nextSourceBalance),
              accent: tokens.expense,
            ),
            _MetricCard(
              label: '${isEn ? "Cash" : "Tunai"} (${isEn ? "Destination" : "Tujuan"})',
              value: formatRupiah(res.nextDestBalance),
              accent: tokens.income,
            ),
            _MetricCard(
              label: isEn ? 'Total Balance (Unchanged)' : 'Total Saldo (Tetap)',
              value: formatRupiah(res.totalBalanceAfter),
              accent: tokens.brandPrimary,
            ),
            _MetricCard(
              label: isEn ? 'Net Cash Flow (Unchanged)' : 'Arus Kas Bersih (Tetap)',
              value: formatRupiah(res.netCashFlowAfter),
              accent: tokens.info,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBudgetSimulator(
    BuildContext context,
    WiseWebTokens tokens,
    bool isEn,
  ) {
    final limit = _budgetAllWallets ? 1000000 : 600000;
    final eval = evaluateBudget(
      limit: limit,
      spent: _budgetSpent.round(),
      remainingDays: 10,
    );

    final Color statusColor;
    final Color statusBg;
    final String statusLabel;
    final IconData statusIcon;
    switch (eval.health) {
      case BudgetHealth.safe:
        statusColor = tokens.income;
        statusBg = tokens.incomeContainer;
        statusLabel = isEn ? 'Safe (<80%)' : 'Aman (<80%)';
        statusIcon = Icons.check_circle_outline_rounded;
      case BudgetHealth.warning:
        statusColor = tokens.warning;
        statusBg = tokens.warningContainer;
        statusLabel = isEn ? 'Nearly Used (80% to <100%)' : 'Hampir Habis (80% sampai <100%)';
        statusIcon = Icons.warning_amber_rounded;
      case BudgetHealth.exceeded:
        statusColor = tokens.expense;
        statusBg = tokens.expenseContainer;
        statusLabel = isEn ? 'Over Budget (>=100%)' : 'Melebihi Anggaran (>=100%)';
        statusIcon = Icons.report_outlined;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 10,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              isEn
                  ? 'Monthly Budget & Daily Remaining Limit'
                  : 'Anggaran Bulanan & Batas Harian Tersisa',
              style: WiseWebTypography.cardTitle(context),
            ),
            WiseWebButton(
              key: const Key('budget_scope_toggle'),
              label: _budgetAllWallets
                  ? (isEn ? 'Scope: All Wallets' : 'Cakupan: Semua Dompet')
                  : (isEn ? 'Scope: GoPay Only' : 'Cakupan: Dompet GoPay'),
              variant: WiseWebButtonVariant.secondary,
              compact: true,
              reducedMotion: widget.reducedMotion,
              onPressed: () =>
                  setState(() => _budgetAllWallets = !_budgetAllWallets),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          isEn
              ? 'Slide spent amount to watch exact PRD thresholds: exact 100% immediately enters Over Budget, while Daily Remaining Limit divides remaining funds across the remaining days of the month.'
              : 'Geser pengeluaran untuk melihat ambang batas PRD secara langsung: tepat 100% langsung masuk Melebihi Anggaran, dan Batas Harian Tersisa membagi sisa anggaran dengan sisa hari bulan berjalan.',
          style: WiseWebTypography.body(context, size: 15),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '${isEn ? "Spent" : "Terpakai"}: ${formatRupiah(eval.spent)} / ${formatRupiah(eval.limit)}',
              style: WiseWebTypography.money(context, size: 17),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusIcon, size: 16, color: statusColor),
                  const SizedBox(width: 6),
                  Text(
                    '$statusLabel · ${eval.progressPercent.round()}%',
                    style: WiseWebTypography.mono(
                      context,
                      size: 12,
                      color: statusColor,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: eval.clampedBarFactor),
            duration: widget.reducedMotion
                ? Duration.zero
                : const Duration(milliseconds: 220),
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 12,
              backgroundColor: tokens.surfaceElevated,
              color: statusColor,
            ),
          ),
        ),
        Slider(
          key: const Key('budget_slider'),
          value: _budgetSpent,
          min: 100000,
          max: 1200000,
          divisions: 22,
          activeColor: statusColor,
          label: formatRupiah(_budgetSpent.round()),
          onChanged: (v) => setState(() => _budgetSpent = v),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _MetricCard(
              label: isEn ? 'Remaining Budget' : 'Sisa Anggaran',
              value: formatRupiah(eval.remaining),
              accent: eval.remaining < 0 ? tokens.expense : tokens.income,
            ),
            _MetricCard(
              label: isEn ? 'Daily Remaining Limit (10 days left)' : 'Batas Harian Tersisa (10 hari)',
              value: formatRupiah(eval.dailyLimit),
              accent: tokens.brandPrimary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendarSimulator(
    BuildContext context,
    WiseWebTokens tokens,
    bool isEn,
  ) {
    final headers = _startMonday
        ? (isEn
            ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
            : ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'])
        : (isEn
            ? ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
            : ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 10,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              isEn
                  ? 'Local Calendar Grid & Idempotent Recurring Engine'
                  : 'Kalender Lokal & Mesin Transaksi/Anggaran Berulang',
              style: WiseWebTypography.cardTitle(context),
            ),
            WiseWebButton(
              key: const Key('calendar_first_day_toggle'),
              label: _startMonday
                  ? (isEn ? 'Week starts: Monday' : 'Awal minggu: Senin')
                  : (isEn ? 'Week starts: Sunday' : 'Awal minggu: Minggu'),
              variant: WiseWebButtonVariant.secondary,
              compact: true,
              reducedMotion: widget.reducedMotion,
              onPressed: () => setState(() => _startMonday = !_startMonday),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          isEn
              ? 'Select a date to inspect daily local transactions. Recurring rules run catch-up automatically on startup with month-end clamping (Jan 31 -> Feb 28/29) and DB-level UNIQUE(recurringRuleId, occurrenceDate) idempotency.'
              : 'Klik tanggal untuk melihat aktivitas harian lokal. Aturan berulang otomatis melakukan catch-up saat aplikasi dibuka, mendukung tanggal akhir bulan (31 Jan ke 28/29 Feb), dan dijamin anti-duplikasi di level SQLite.',
          style: WiseWebTypography.body(context, size: 15),
        ),
        const SizedBox(height: 16),
        Row(
          children: headers
              .map(
                (h) => Expanded(
                  child: Center(
                    child: Text(
                      h,
                      style: WiseWebTypography.mono(
                        context,
                        size: 12,
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
          childAspectRatio: 1.5,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          children: List.generate(14, (i) {
            final day = i + 15;
            final selected = day == _selectedDay;
            final hasIn = day == 15 || day == 20 || day == 25;
            final hasOut = day == 16 || day == 18 || day == 20 || day == 24;
            return InkWell(
              onTap: () => setState(() => _selectedDay = day),
              mouseCursor: SystemMouseCursors.click,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  color: selected
                      ? tokens.primaryContainer
                      : tokens.surfaceElevated,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selected ? tokens.brandPrimary : tokens.borderSubtle,
                    width: selected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$day',
                      style: WiseWebTypography.mono(
                        context,
                        size: 12.5,
                        color: selected
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
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: tokens.income,
                              shape: BoxShape.circle,
                            ),
                          ),
                        if (hasIn && hasOut) const SizedBox(width: 3),
                        if (hasOut)
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: tokens.expense,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: tokens.surfaceElevated,
            borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
          ),
          child: Text(
            isEn
                ? 'Selected 2026-10-$_selectedDay: ${_selectedDay == 25 ? "Monthly recurring salary auto-generated (idempotent)" : _selectedDay == 20 ? "Income +Rp2.000.000 & Receipt OCR Expense -Rp34.500" : "Daily local transactions filtered strictly by YYYY-MM-DD."}'
                : 'Tanggal 2026-10-$_selectedDay: ${_selectedDay == 25 ? "Transaksi berulang bulanan (Gaji) terbit otomatis & idempoten" : _selectedDay == 20 ? "Pemasukan +Rp2.000.000 & Struk OCR -Rp34.500" : "Daftar transaksi harian lokal difilter murni berdasarkan YYYY-MM-DD."}',
            style: WiseWebTypography.body(
              context,
              size: 14,
              color: tokens.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDebtSimulator(
    BuildContext context,
    WiseWebTokens tokens,
    bool isEn,
  ) {
    final statusLabel = _debt.isPaidOff
        ? (isEn ? 'Paid Off (Locked)' : 'Lunas (Terkunci)')
        : (isEn ? 'Installment' : 'Dicicil');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 10,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              isEn
                  ? 'Debts & Receivables (Schema v10 to v11)'
                  : 'Utang & Piutang Lengkap (Schema v10 sampai v11)',
              style: WiseWebTypography.cardTitle(context),
            ),
            WiseWebButton(
              key: const Key('debt_wallet_toggle'),
              label: _debt.linkedToWallet
                  ? (isEn ? 'Wallet: Bank BCA (Auto-Mutate)' : 'Dompet: Bank BCA (Mutasi Saldo)')
                  : (isEn ? 'Mode: Without Wallet' : 'Mode: Tanpa Dompet'),
              variant: WiseWebButtonVariant.secondary,
              compact: true,
              reducedMotion: widget.reducedMotion,
              onPressed: () => setState(
                () => _debt =
                    _debt.copyWith(linkedToWallet: !_debt.linkedToWallet),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          isEn
              ? 'Add more principal directly onto an existing record without duplicate cards, log partial payments, or settle in one tap. Once Paid Off, the record locks automatically.'
              : 'Tambahkan pokok pinjaman langsung ke catatan aktif tanpa membuat kartu duplikat, catat cicilan bertahap, atau tekan Lunasi Sisa. Begitu berstatus Lunas, catatan otomatis terkunci.',
          style: WiseWebTypography.body(context, size: 15),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _MetricCard(
              label: isEn ? 'Initial Principal' : 'Pokok Awal',
              value: formatRupiah(_debt.initialPrincipal),
              accent: tokens.textPrimary,
            ),
            _MetricCard(
              label: isEn ? 'Total Additions' : 'Total Tambahan',
              value: formatRupiah(_debt.totalAdditions),
              accent: tokens.info,
            ),
            _MetricCard(
              label: isEn ? 'Paid' : 'Terbayar',
              value: formatRupiah(_debt.totalPaid),
              accent: tokens.income,
            ),
            _MetricCard(
              label: '${isEn ? "Remaining" : "Sisa"} ($statusLabel)',
              value: formatRupiah(_debt.remaining),
              accent: _debt.isPaidOff ? tokens.income : tokens.warning,
            ),
          ],
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: _debt.progress,
            minHeight: 10,
            backgroundColor: tokens.surfaceElevated,
            color: _debt.isPaidOff ? tokens.income : tokens.brandPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            WiseWebButton(
              key: const Key('debt_add_principal_btn'),
              label: isEn ? 'Add Principal (+Rp150k)' : 'Tambah Utang (+Rp150rb)',
              variant: WiseWebButtonVariant.secondary,
              compact: true,
              reducedMotion: widget.reducedMotion,
              onPressed: _debt.isPaidOff
                  ? null
                  : () => setState(() => _debt = _debt.withAddition(150000)),
            ),
            WiseWebButton(
              key: const Key('debt_pay_installment_btn'),
              label: isEn ? 'Log Installment (-Rp250k)' : 'Catat Cicilan (-Rp250rb)',
              compact: true,
              reducedMotion: widget.reducedMotion,
              onPressed: _debt.isPaidOff
                  ? null
                  : () => setState(() => _debt = _debt.withPayment(250000)),
            ),
            WiseWebButton(
              key: const Key('debt_pay_off_btn'),
              label: isEn ? 'Pay Off Remaining' : 'Lunasi Sisa',
              variant: WiseWebButtonVariant.outlined,
              compact: true,
              reducedMotion: widget.reducedMotion,
              onPressed: _debt.isPaidOff
                  ? null
                  : () => setState(() => _debt = _debt.payOffRemaining()),
            ),
            WiseWebButton(
              key: const Key('debt_reset_btn'),
              label: 'Reset',
              variant: WiseWebButtonVariant.ghost,
              compact: true,
              reducedMotion: widget.reducedMotion,
              onPressed: () =>
                  setState(() => _debt = DebtSimulationState.sample()),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfilesSimulator(
    BuildContext context,
    WiseWebTokens tokens,
    bool isEn,
  ) {
    final isPersonal = _activeProfile == 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEn
              ? 'Isolated Local Multi-Profile (No Online Accounts Needed)'
              : 'Multi-Profil Lokal Terisolasi (Tanpa Akun Online)',
          style: WiseWebTypography.cardTitle(context),
        ),
        const SizedBox(height: 8),
        Text(
          isEn
              ? 'Separate personal spending, household budgets, or side-business cash flow inside one Android device. Every profile isolates its own wallets, categories, budgets, debts, and recurring rules.'
              : 'Pisahkan catatan pribadi, keuangan keluarga, atau usaha sampingan dalam satu perangkat. Setiap profil mengisolasi dompet, kategori, transaksi, anggaran, utang-piutang, dan aturan berulangnya sendiri.',
          style: WiseWebTypography.body(context, size: 15),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            WiseWebButton(
              key: const Key('profile_switch_personal'),
              label: isEn ? 'Personal Profile' : 'Profil Pribadi',
              variant: isPersonal
                  ? WiseWebButtonVariant.primary
                  : WiseWebButtonVariant.outlined,
              compact: true,
              reducedMotion: widget.reducedMotion,
              onPressed: () => setState(() => _activeProfile = 0),
            ),
            WiseWebButton(
              key: const Key('profile_switch_business'),
              label: isEn ? 'Side Business Profile' : 'Profil Usaha Sampingan',
              variant: !isPersonal
                  ? WiseWebButtonVariant.primary
                  : WiseWebButtonVariant.outlined,
              compact: true,
              reducedMotion: widget.reducedMotion,
              onPressed: () => setState(() => _activeProfile = 1),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: isPersonal
              ? [
                  _MetricCard(
                    label: isEn ? 'Active Wallets' : 'Dompet Aktif',
                    value: 'Tunai · Bank BCA · GoPay',
                    accent: tokens.brandPrimary,
                  ),
                  _MetricCard(
                    label: isEn ? 'Profile Balance' : 'Saldo Profil',
                    value: formatRupiah(12480000),
                    accent: tokens.income,
                  ),
                ]
              : [
                  _MetricCard(
                    label: isEn ? 'Active Wallets' : 'Dompet Aktif',
                    value: 'Kas Toko · Rekening Operasional',
                    accent: tokens.brandPrimary,
                  ),
                  _MetricCard(
                    label: isEn ? 'Profile Balance' : 'Saldo Profil',
                    value: formatRupiah(28950000),
                    accent: tokens.income,
                  ),
                ],
        ),
      ],
    );
  }
}

class _CoreTab extends StatelessWidget {
  const _CoreTab({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    return InkWell(
      onTap: onTap,
      mouseCursor: SystemMouseCursors.click,
      borderRadius: BorderRadius.circular(WiseWebTokens.radiusMd),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(WiseWebTokens.radiusMd),
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          decoration: BoxDecoration(
            color: selected ? tokens.surfaceCard : Colors.transparent,
            borderRadius: BorderRadius.circular(WiseWebTokens.radiusMd),
            border: Border.all(
              color: selected ? tokens.brandPrimary : tokens.borderSubtle,
              width: selected ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 17,
                      color: selected
                          ? tokens.brandPrimary
                          : tokens.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: WiseWebTypography.body(
                        context,
                        size: 14,
                        color: selected
                            ? tokens.brandPrimary
                            : tokens.textPrimary,
                      ).copyWith(
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 3,
                width: 44,
                decoration: BoxDecoration(
                  color: selected ? tokens.brandPrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatePill extends StatelessWidget {
  const _StatePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    return InkWell(
      onTap: onTap,
      mouseCursor: SystemMouseCursors.click,
      borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
      child: Container(
        constraints: const BoxConstraints(minHeight: 36),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? tokens.primaryContainer : tokens.surfaceCard,
          borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
          border: Border.all(
            color: selected ? tokens.brandPrimary : tokens.borderSubtle,
          ),
        ),
        child: Text(
          label,
          style: WiseWebTypography.body(
            context,
            size: 12.5,
            color: selected ? tokens.brandPrimary : tokens.textSecondary,
          ).copyWith(fontWeight: selected ? FontWeight.w700 : FontWeight.w500),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    return Container(
      constraints: const BoxConstraints(minWidth: 210),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: tokens.surfaceElevated,
        borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
        border: Border.all(color: tokens.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: WiseWebTypography.body(
              context,
              size: 12,
              color: tokens.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: WiseWebTypography.money(context, size: 16, color: accent),
          ),
        ],
      ),
    );
  }
}
