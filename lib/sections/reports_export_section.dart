import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../domain/finance_simulator.dart';
import '../l10n/landing_strings.dart';
import '../theme/wise_web_tokens.dart';
import '../widgets/motion_primitives.dart';

/// Editorial Contrast Band (#laporan):
/// Animated CustomPainter Donut & Trend Charts + Deterministic Insights +
/// Live Bilingual PDF Preview (ID <-> EN) & RFC 4180 CSV Preview.
class ReportsExportSection extends StatefulWidget {
  const ReportsExportSection({
    super.key,
    required this.strings,
    required this.reducedMotion,
    this.scrollListenable,
  });

  final LandingStrings strings;
  final bool reducedMotion;
  final Listenable? scrollListenable;

  @override
  State<ReportsExportSection> createState() => _ReportsExportSectionState();
}

class _ReportsExportSectionState extends State<ReportsExportSection>
    with SingleTickerProviderStateMixin {
  int _exportTab = 0; // 0: PDF, 1: CSV
  bool _pdfInEnglish = false;
  late final AnimationController _chartController;

  @override
  void initState() {
    super.initState();
    _chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    if (widget.reducedMotion) {
      _chartController.value = 1.0;
    } else {
      _chartController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant ReportsExportSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reducedMotion) {
      _chartController.value = 1.0;
    } else if (oldWidget.reducedMotion && !widget.reducedMotion) {
      _chartController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _chartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 960;
    final isEn = widget.strings.locale == LandingLocale.en;
    final savingsRate = computeSavingsRate(income: 8500000, expense: 3420000)!;

    final chartPanel = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: tokens.contrastBandSurface,
        borderRadius: BorderRadius.circular(WiseWebTokens.radiusLg),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  isEn
                      ? 'Category Breakdown & Monthly Trend'
                      : 'Proporsi Kategori & Tren Bulanan',
                  style: WiseWebTypography.cardTitle(
                    context,
                    color: tokens.contrastBandText,
                  ),
                ),
              ),
              Text(
                widget.strings.simulationTag,
                style: WiseWebTypography.mono(
                  context,
                  size: 11,
                  color: const Color(0xFF7DD3FC),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Animated Donut + Legend
          AnimatedBuilder(
            animation: _chartController,
            builder: (context, _) {
              final p = Curves.easeOutCubic.transform(_chartController.value);
              return Wrap(
                spacing: 24,
                runSpacing: 20,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CustomPaint(
                      painter: _DonutChartPainter(progress: p),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isEn ? 'Expense' : 'Keluar',
                              style: WiseWebTypography.body(
                                context,
                                size: 11.5,
                                color: tokens.contrastBandMuted,
                              ),
                            ),
                            Text(
                              'Rp3,42 jt',
                              style: WiseWebTypography.money(
                                context,
                                size: 15,
                                color: tokens.contrastBandText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LegendRow(
                        color: const Color(0xFF60A5FA),
                        label: isEn ? 'Food (42%)' : 'Makanan (42%)',
                        value: formatRupiah(1436400),
                      ),
                      const SizedBox(height: 8),
                      _LegendRow(
                        color: const Color(0xFF34D399),
                        label: isEn ? 'Bills (28%)' : 'Tagihan (28%)',
                        value: formatRupiah(957600),
                      ),
                      const SizedBox(height: 8),
                      _LegendRow(
                        color: const Color(0xFFFBBF24),
                        label: isEn ? 'Transport (18%)' : 'Transportasi (18%)',
                        value: formatRupiah(615600),
                      ),
                      const SizedBox(height: 8),
                      _LegendRow(
                        color: const Color(0xFFFCA5A5),
                        label: isEn ? 'Shopping (12%)' : 'Belanja (12%)',
                        value: formatRupiah(410400),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 22),
          // Animated Trend Line
          SizedBox(
            width: double.infinity,
            height: 88,
            child: AnimatedBuilder(
              animation: _chartController,
              builder: (context, _) => CustomPaint(
                painter: _TrendLinePainter(
                  progress: Curves.easeOutCubic.transform(_chartController.value),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ContrastMetric(
                label: widget.strings.reportsTopCategoryLabel,
                value: isEn ? 'Food (42%)' : 'Makanan (42%)',
                accent: const Color(0xFF60A5FA),
              ),
              _ContrastMetric(
                label: widget.strings.reportsSavingsRateLabel,
                value: '${savingsRate.toStringAsFixed(1)}%',
                accent: const Color(0xFF34D399),
              ),
              _ContrastMetric(
                label: widget.strings.reportsNetCashFlowLabel,
                value: '+${formatRupiah(5080000)}',
                accent: const Color(0xFF7DD3FC),
              ),
            ],
          ),
        ],
      ),
    );

    final exportPanel = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: tokens.contrastBandSurface,
        borderRadius: BorderRadius.circular(WiseWebTokens.radiusLg),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _DarkTabChip(
                key: const Key('export_tab_pdf'),
                label: widget.strings.reportsPdfTab,
                selected: _exportTab == 0,
                onTap: () => setState(() => _exportTab = 0),
              ),
              _DarkTabChip(
                key: const Key('export_tab_csv'),
                label: widget.strings.reportsCsvTab,
                selected: _exportTab == 1,
                onTap: () => setState(() => _exportTab = 1),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (_exportTab == 0) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.strings.reportsPdfLangHint,
                    style: WiseWebTypography.body(
                      context,
                      size: 13.5,
                      color: tokens.contrastBandMuted,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _DarkTabChip(
                  key: const Key('pdf_lang_toggle'),
                  label: _pdfInEnglish ? 'PDF: English' : 'PDF: Indonesia',
                  selected: true,
                  onTap: () => setState(() => _pdfInEnglish = !_pdfInEnglish),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Realistic crisp document sheet preview (light paper sheet for authenticity)
            AnimatedSwitcher(
              duration: widget.reducedMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 220),
              child: Container(
                key: ValueKey(_pdfInEnglish),
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(WiseWebTokens.radiusMd),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _pdfInEnglish
                                ? 'WiseWallet · Financial Report'
                                : 'WiseWallet · Laporan Keuangan',
                            style: WiseWebTypography.cardTitle(
                              context,
                              color: const Color(0xFF0F172A),
                            ).copyWith(fontSize: 15),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '2026-10',
                          style: WiseWebTypography.mono(
                            context,
                            size: 11.5,
                            color: const Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20, color: Color(0xFFE2E8F0)),
                    _PdfRow(
                      label: _pdfInEnglish ? 'Total Income' : 'Total Pemasukan',
                      value: formatRupiah(8500000),
                      valueColor: const Color(0xFF047857),
                    ),
                    _PdfRow(
                      label: _pdfInEnglish ? 'Total Expenses' : 'Total Pengeluaran',
                      value: formatRupiah(3420000),
                      valueColor: const Color(0xFFB91C1C),
                    ),
                    _PdfRow(
                      label: _pdfInEnglish ? 'Net Cash Flow' : 'Arus Kas Bersih',
                      value: formatRupiah(5080000),
                      valueColor: const Color(0xFF1E5CD9),
                    ),
                    _PdfRow(
                      label: _pdfInEnglish
                          ? 'Top Spending Category'
                          : 'Kategori dengan Pengeluaran Terbesar',
                      value: _pdfInEnglish ? 'Food (42%)' : 'Makanan (42%)',
                      valueColor: const Color(0xFF0F172A),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _pdfInEnglish
                          ? 'Includes multi-page transaction table with repeating headers, budget statuses, and native Share Sheet (application/pdf).'
                          : 'Termasuk tabel transaksi multi-halaman dengan header berulang, progres anggaran, dan bagikan via Native Share Sheet (application/pdf).',
                      style: WiseWebTypography.body(
                        context,
                        size: 12.5,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Text(
              isEn
                  ? 'UTF-8 RFC 4180 CSV with 7 consistent columns and spreadsheet formula-injection neutralization (=, +, -, @ escaped cleanly).'
                  : 'CSV UTF-8 standar RFC 4180 dengan 7 kolom konsisten dan pengamanan teks berawalan operator formula spreadsheet agar aman dibuka di Excel/Sheets.',
              style: WiseWebTypography.body(
                context,
                size: 14,
                color: tokens.contrastBandMuted,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF09101E),
                borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  'Tanggal,Jenis,Kategori,Akun,Deskripsi,Jumlah,Catatan\n'
                  '2026-10-20,PENGELUARAN,Belanja,Tunai,"Alfamart Sudirman",34500,"Roti, Susu"\n'
                  '2026-10-20,PEMASUKAN,Freelance,Bank BCA,"Proyek Desain",2000000,"dp tahap satu"',
                  style: WiseWebTypography.mono(
                    context,
                    size: 12,
                    color: const Color(0xFFE2E8F0),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );

    return SectionContainer(
      backgroundColor: tokens.contrastBandBg,
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
                    widget.strings.reportsTitle,
                    style: WiseWebTypography.sectionTitle(
                      context,
                      color: tokens.contrastBandText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.strings.reportsSubtitle,
                    style: WiseWebTypography.body(
                      context,
                      color: tokens.contrastBandMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 11, child: chartPanel),
                      const SizedBox(width: 28),
                      Expanded(flex: 10, child: exportPanel),
                    ],
                  )
                : Column(
                    children: [
                      chartPanel,
                      const SizedBox(height: 22),
                      exportPanel,
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  _DonutChartPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2) - 14;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const stroke = 18.0;

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = Colors.white.withValues(alpha: 0.08);
    canvas.drawCircle(center, radius, track);

    final segments = [
      (0.42, const Color(0xFF60A5FA)),
      (0.28, const Color(0xFF34D399)),
      (0.18, const Color(0xFFFBBF24)),
      (0.12, const Color(0xFFFCA5A5)),
    ];

    var startAngle = -math.pi / 2;
    for (final (fraction, color) in segments) {
      final sweep = (fraction * 2 * math.pi * progress) - 0.04;
      if (sweep > 0) {
        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.butt
          ..color = color;
        canvas.drawArc(rect, startAngle, sweep, false, paint);
      }
      startAngle += fraction * 2 * math.pi * progress;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter old) =>
      old.progress != progress;
}

class _TrendLinePainter extends CustomPainter {
  _TrendLinePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1;
    for (var i = 0; i < 3; i++) {
      final y = size.height * (i / 2);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    _drawSeries(
      canvas,
      size,
      points: const [0.58, 0.45, 0.40, 0.28, 0.22, 0.16],
      color: const Color(0xFF34D399),
    );
    _drawSeries(
      canvas,
      size,
      points: const [0.78, 0.72, 0.65, 0.70, 0.56, 0.62],
      color: const Color(0xFFFCA5A5),
    );
  }

  void _drawSeries(
    Canvas canvas,
    Size size, {
    required List<double> points,
    required Color color,
  }) {
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = (size.width / (points.length - 1)) * i;
      final y = size.height * points[i];
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevX = (size.width / (points.length - 1)) * (i - 1);
        final prevY = size.height * points[i - 1];
        final midX = (prevX + x) / 2;
        path.cubicTo(midX, prevY, midX, y, x, y);
      }
    }

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round
      ..color = color;

    for (final metric in path.computeMetrics()) {
      final extracted = metric.extractPath(0, metric.length * progress);
      canvas.drawPath(extracted, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendLinePainter old) =>
      old.progress != progress;
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Text(
          label,
          style: WiseWebTypography.body(
            context,
            size: 13.5,
            color: const Color(0xFFCBD5E1),
          ),
        ),
        Text(
          value,
          style: WiseWebTypography.money(
            context,
            size: 13.5,
            color: const Color(0xFFF8FAFC),
          ),
        ),
      ],
    );
  }
}

class _ContrastMetric extends StatelessWidget {
  const _ContrastMetric({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: WiseWebTypography.body(
              context,
              size: 11.5,
              color: const Color(0xFFCBD5E1),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: WiseWebTypography.money(context, size: 15, color: accent),
          ),
        ],
      ),
    );
  }
}

class _DarkTabChip extends StatelessWidget {
  const _DarkTabChip({
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
    return InkWell(
      onTap: onTap,
      mouseCursor: SystemMouseCursors.click,
      borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
      child: Container(
        constraints: const BoxConstraints(minHeight: 40),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF60A5FA)
              : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
        ),
        child: Text(
          label,
          style: WiseWebTypography.body(
            context,
            size: 13.5,
            color: selected
                ? const Color(0xFF0F172A)
                : const Color(0xFFF8FAFC),
          ).copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _PdfRow extends StatelessWidget {
  const _PdfRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: WiseWebTypography.body(
                context,
                size: 13.5,
                color: const Color(0xFF475569),
              ),
            ),
          ),
          Text(
            value,
            style: WiseWebTypography.money(
              context,
              size: 14,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
