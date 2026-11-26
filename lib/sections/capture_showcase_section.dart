import 'package:flutter/material.dart';
import '../domain/finance_simulator.dart';
import '../l10n/landing_strings.dart';
import '../theme/wise_web_tokens.dart';
import '../widgets/motion_primitives.dart';

/// 3-Way On-Device Capture Showcase (#alur-catat):
/// Manual Form, Offline Hybrid Voice Simulator (animated equalizer + 7-field draft),
/// and Offline PaddleOCR Receipt Scanner (crop toggle + animated scanline + cleanup).
class CaptureShowcaseSection extends StatefulWidget {
  const CaptureShowcaseSection({
    super.key,
    required this.strings,
    required this.reducedMotion,
    this.scrollListenable,
  });

  final LandingStrings strings;
  final bool reducedMotion;
  final Listenable? scrollListenable;

  @override
  State<CaptureShowcaseSection> createState() => _CaptureShowcaseSectionState();
}

class _CaptureShowcaseSectionState extends State<CaptureShowcaseSection>
    with TickerProviderStateMixin {
  int _activeChapter = 0; // 0: manual, 1: voice, 2: ocr
  int _voicePresetIndex = 0;
  bool _voiceSimulating = false;
  int _ocrPresetIndex = 0;
  bool _ocrCropEnabled = true;
  bool _ocrScanning = false;
  bool _ocrDone = false;

  late final AnimationController _waveController;
  late final AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  Future<void> _selectVoicePreset(int index) async {
    setState(() {
      _voicePresetIndex = index;
      _voiceSimulating = !widget.reducedMotion;
    });
    if (widget.reducedMotion) return;
    _waveController.repeat();
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    _waveController.stop();
    setState(() => _voiceSimulating = false);
  }

  Future<void> _runOcrScan() async {
    setState(() {
      _ocrScanning = !widget.reducedMotion;
      _ocrDone = widget.reducedMotion;
    });
    if (widget.reducedMotion) return;
    await _scanController.forward(from: 0.0);
    if (!mounted) return;
    setState(() {
      _ocrScanning = false;
      _ocrDone = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 940;
    final isEn = widget.strings.locale == LandingLocale.en;

    return SectionContainer(
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
                    widget.strings.captureTitle,
                    style: WiseWebTypography.sectionTitle(context),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.strings.captureSubtitle,
                    style: WiseWebTypography.body(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // Chapter selector tabs (non-color-only active border indicator)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _ChapterTab(
                    key: const Key('capture_tab_manual'),
                    icon: Icons.edit_note_rounded,
                    label: widget.strings.captureTabManual,
                    selected: _activeChapter == 0,
                    onTap: () => setState(() => _activeChapter = 0),
                  ),
                  const SizedBox(width: 10),
                  _ChapterTab(
                    key: const Key('capture_tab_voice'),
                    icon: Icons.mic_none_rounded,
                    label: widget.strings.captureTabVoice,
                    selected: _activeChapter == 1,
                    onTap: () => setState(() => _activeChapter = 1),
                  ),
                  const SizedBox(width: 10),
                  _ChapterTab(
                    key: const Key('capture_tab_ocr'),
                    icon: Icons.document_scanner_outlined,
                    label: widget.strings.captureTabOcr,
                    selected: _activeChapter == 2,
                    onTap: () => setState(() => _activeChapter = 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AnimatedSwitcher(
              duration: widget.reducedMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOutCubic,
              child: KeyedSubtree(
                key: ValueKey(_activeChapter),
                child: _buildChapterContent(context, tokens, isWide, isEn),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChapterContent(
    BuildContext context,
    WiseWebTokens tokens,
    bool isWide,
    bool isEn,
  ) {
    if (_activeChapter == 0) {
      return _buildManualChapter(context, tokens, isWide, isEn);
    }
    if (_activeChapter == 1) {
      return _buildVoiceChapter(context, tokens, isWide, isEn);
    }
    return _buildOcrChapter(context, tokens, isWide, isEn);
  }

  Widget _buildManualChapter(
    BuildContext context,
    WiseWebTokens tokens,
    bool isWide,
    bool isEn,
  ) {
    final narrative = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.strings.manualHeading,
          style: WiseWebTypography.cardTitle(context).copyWith(fontSize: 22),
        ),
        const SizedBox(height: 12),
        Text(widget.strings.manualBody, style: WiseWebTypography.body(context)),
        const SizedBox(height: 20),
        for (final bullet in widget.strings.manualBullets)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    size: 18,
                    color: tokens.income,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    bullet,
                    style: WiseWebTypography.body(
                      context,
                      size: 15,
                      color: tokens.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );

    final preview = WiseSurfaceCard(
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  isEn
                      ? 'Separated Date & Time Semantics'
                      : 'Pemisahan Tanggal & Jam Lokal',
                  style: WiseWebTypography.cardTitle(context)
                      .copyWith(fontSize: 16),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'FR-003',
                style: WiseWebTypography.mono(
                  context,
                  size: 12,
                  color: tokens.brandPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _FieldMockRow(
            label: isEn ? 'Local Calendar Date' : 'Tanggal Kejadian Lokal',
            value: '2026-10-20',
            badge: isEn ? 'No UTC shift' : 'Bebas geser UTC',
          ),
          const SizedBox(height: 10),
          _FieldMockRow(
            label: isEn ? 'Local Clock Time' : 'Jam Kejadian Lokal',
            value: '14:30 (24h)',
            badge: 'HH:mm',
          ),
          const SizedBox(height: 10),
          _FieldMockRow(
            label: isEn ? 'DB Audit Timestamp' : 'Audit Timestamp Database',
            value: '2026-10-20T07:35:12Z',
            badge: 'UTC ISO-8601',
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: tokens.surfaceElevated,
              borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
            ),
            child: Text(
              'ORDER BY date DESC, time DESC, createdAt DESC, id DESC',
              style: WiseWebTypography.mono(
                context,
                size: 12,
                color: tokens.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );

    return isWide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 11, child: narrative),
              const SizedBox(width: 36),
              Expanded(flex: 10, child: preview),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [narrative, const SizedBox(height: 24), preview],
          );
  }

  Widget _buildVoiceChapter(
    BuildContext context,
    WiseWebTokens tokens,
    bool isWide,
    bool isEn,
  ) {
    final preset = LandingStrings.voicePresets[_voicePresetIndex];

    final controls = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.strings.voiceHeading,
          style: WiseWebTypography.cardTitle(context).copyWith(fontSize: 22),
        ),
        const SizedBox(height: 12),
        Text(widget.strings.voiceBody, style: WiseWebTypography.body(context)),
        const SizedBox(height: 18),
        Text(
          widget.strings.voiceHint,
          style: WiseWebTypography.body(
            context,
            size: 14,
            color: tokens.textPrimary,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < LandingStrings.voicePresets.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              key: Key('voice_preset_$i'),
              onTap: () => _selectVoicePreset(i),
              mouseCursor: SystemMouseCursors.click,
              borderRadius: BorderRadius.circular(WiseWebTokens.radiusMd),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 48),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _voicePresetIndex == i
                      ? tokens.primaryContainer
                      : tokens.surfaceCard,
                  borderRadius: BorderRadius.circular(WiseWebTokens.radiusMd),
                  border: Border.all(
                    color: _voicePresetIndex == i
                        ? tokens.brandPrimary
                        : tokens.borderSubtle,
                    width: _voicePresetIndex == i ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.mic_rounded,
                      size: 18,
                      color: _voicePresetIndex == i
                          ? tokens.brandPrimary
                          : tokens.textMuted,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '"${LandingStrings.voicePresets[i].spokenPhrase}"',
                        style: WiseWebTypography.body(
                          context,
                          size: 14,
                          color: tokens.textPrimary,
                        ).copyWith(
                          fontWeight: _voicePresetIndex == i
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );

    final draftPanel = WiseSurfaceCard(
      key: const Key('voice_draft_card'),
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.strings.voiceDraftTitle,
                  style: WiseWebTypography.cardTitle(context)
                      .copyWith(fontSize: 16),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.strings.simulationTag,
                style: WiseWebTypography.mono(
                  context,
                  size: 11,
                  color: tokens.brandPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Live voice waveform visualizer
          Container(
            width: double.infinity,
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: tokens.surfaceElevated,
              borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
            ),
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, _) => CustomPaint(
                painter: VoiceWavePainter(
                  phase: _waveController.value,
                  active: _voiceSimulating,
                  barColor: tokens.brandPrimary,
                  idleColor: tokens.brandPrimary.withValues(alpha: 0.45),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _DraftChip(
                label: isEn ? 'Type' : 'Jenis',
                value: isEn ? preset.typeEn : preset.typeId,
                accent: preset.isIncome ? tokens.income : tokens.expense,
              ),
              _DraftChip(
                label: isEn ? 'Amount' : 'Nominal',
                value: formatRupiah(preset.amount),
                accent: tokens.brandPrimary,
              ),
              _DraftChip(
                label: isEn ? 'Category' : 'Kategori',
                value: isEn ? preset.categoryEn : preset.categoryId,
              ),
              _DraftChip(
                label: isEn ? 'Wallet' : 'Dompet',
                value: preset.wallet,
              ),
              _DraftChip(
                label: isEn ? 'Date & Time' : 'Tanggal & Jam',
                value:
                    '${isEn ? preset.dateLabelEn : preset.dateLabelId} · ${preset.timeLabel}',
                accent: preset.isEstimatedTime ? tokens.warning : tokens.income,
              ),
              _DraftChip(
                label: isEn ? 'Description' : 'Deskripsi',
                value: preset.description,
              ),
              if (preset.notes.isNotEmpty)
                _DraftChip(
                  label: isEn ? 'Notes' : 'Catatan',
                  value: preset.notes,
                ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: preset.isEstimatedTime
                  ? tokens.warningContainer
                  : tokens.incomeContainer,
              borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  preset.isEstimatedTime
                      ? Icons.info_outline_rounded
                      : Icons.check_circle_outline_rounded,
                  size: 18,
                  color: preset.isEstimatedTime ? tokens.warning : tokens.income,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isEn ? preset.reviewHintEn : preset.reviewHintId,
                    style: WiseWebTypography.body(
                      context,
                      size: 13,
                      color: preset.isEstimatedTime
                          ? tokens.warning
                          : tokens.income,
                    ).copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.strings.voiceDraftDisclaimer,
            style: WiseWebTypography.body(
              context,
              size: 12,
              color: tokens.textMuted,
            ),
          ),
        ],
      ),
    );

    return isWide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 11, child: controls),
              const SizedBox(width: 32),
              Expanded(flex: 11, child: draftPanel),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [controls, const SizedBox(height: 24), draftPanel],
          );
  }

  Widget _buildOcrChapter(
    BuildContext context,
    WiseWebTokens tokens,
    bool isWide,
    bool isEn,
  ) {
    final receipt = LandingStrings.ocrPresets[_ocrPresetIndex];

    final left = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.strings.ocrHeading,
          style: WiseWebTypography.cardTitle(context).copyWith(fontSize: 22),
        ),
        const SizedBox(height: 12),
        Text(widget.strings.ocrBody, style: WiseWebTypography.body(context)),
        const SizedBox(height: 18),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var i = 0; i < LandingStrings.ocrPresets.length; i++)
              WiseWebButton(
                key: Key('ocr_preset_$i'),
                label: isEn
                    ? LandingStrings.ocrPresets[i].labelEn
                    : LandingStrings.ocrPresets[i].labelId,
                variant: _ocrPresetIndex == i
                    ? WiseWebButtonVariant.secondary
                    : WiseWebButtonVariant.outlined,
                compact: true,
                reducedMotion: widget.reducedMotion,
                onPressed: () => setState(() {
                  _ocrPresetIndex = i;
                  _ocrDone = false;
                }),
              ),
          ],
        ),
        const SizedBox(height: 16),
        // Receipt visual preview with optional interactive crop box & laser scanline
        WiseSurfaceCard(
          padding: const EdgeInsets.all(16),
          backgroundColor: tokens.surfaceElevated,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final line in receipt.rawLines)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        line,
                        style: WiseWebTypography.mono(
                          context,
                          size: 12.5,
                          color: tokens.textPrimary,
                        ),
                      ),
                    ),
                ],
              ),
              if (_ocrCropEnabled)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: tokens.brandPrimary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              if (_ocrScanning)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _scanController,
                    builder: (context, _) => Align(
                      alignment: Alignment(0, -1 + 2 * _scanController.value),
                      child: Container(
                        height: 3,
                        color: tokens.brandAccentCyan,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            WiseWebButton(
              key: const Key('ocr_scan_button'),
              label: _ocrScanning
                  ? widget.strings.ocrScanningLabel
                  : widget.strings.ocrScanButton,
              icon: Icons.document_scanner_rounded,
              reducedMotion: widget.reducedMotion,
              onPressed: _ocrScanning ? null : _runOcrScan,
            ),
            WiseWebButton(
              key: const Key('ocr_crop_toggle'),
              label: widget.strings.ocrCropToggle,
              icon: _ocrCropEnabled
                  ? Icons.crop_rounded
                  : Icons.crop_free_rounded,
              variant: _ocrCropEnabled
                  ? WiseWebButtonVariant.secondary
                  : WiseWebButtonVariant.outlined,
              compact: true,
              reducedMotion: widget.reducedMotion,
              onPressed: () =>
                  setState(() => _ocrCropEnabled = !_ocrCropEnabled),
            ),
          ],
        ),
      ],
    );

    final right = WiseSurfaceCard(
      key: const Key('ocr_result_card'),
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _ocrDone ? Icons.check_circle_rounded : Icons.receipt_outlined,
                color: _ocrDone ? tokens.income : tokens.brandPrimary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _ocrDone
                      ? (isEn
                          ? 'PaddleOCR Extracted Draft'
                          : 'Draft Hasil Ekstraksi PaddleOCR')
                      : (isEn
                          ? 'Preview Output (Click Scan to Run)'
                          : 'Pratinjau Output (Klik Pindai)'),
                  style: WiseWebTypography.cardTitle(context)
                      .copyWith(fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _FieldMockRow(
            label: isEn ? 'Merchant / Description' : 'Merchant / Deskripsi',
            value: receipt.merchant,
            badge: _ocrDone
                ? (isEn ? 'Reviewed' : 'Siap ditinjau')
                : (isEn ? 'Pending' : 'Menunggu'),
          ),
          const SizedBox(height: 10),
          _FieldMockRow(
            label: isEn ? 'Total Amount' : 'Total Nominal',
            value: formatRupiah(receipt.totalAmount),
            badge: 'PP-OCRv4',
          ),
          const SizedBox(height: 10),
          _FieldMockRow(
            label: isEn ? 'Date & Time' : 'Tanggal & Jam',
            value: '${receipt.extractedDate} · ${receipt.extractedTime}',
            badge: isEn ? 'Local' : 'Lokal',
          ),
          const SizedBox(height: 10),
          _FieldMockRow(
            label: isEn ? 'Category & Notes' : 'Kategori & Catatan',
            value:
                '${isEn ? receipt.categoryEn : receipt.categoryId} · ${receipt.notes}',
            badge: isEn ? 'Editable' : 'Dapat diubah',
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: tokens.incomeContainer,
              borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.delete_sweep_outlined, size: 18, color: tokens.income),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.strings.ocrCleanupNotice,
                    style: WiseWebTypography.body(
                      context,
                      size: 13,
                      color: tokens.income,
                    ).copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return isWide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 11, child: left),
              const SizedBox(width: 32),
              Expanded(flex: 10, child: right),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [left, const SizedBox(height: 24), right],
          );
  }
}

class _ChapterTab extends StatelessWidget {
  const _ChapterTab({
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
    return InkWell(
      onTap: onTap,
      mouseCursor: SystemMouseCursors.click,
      borderRadius: BorderRadius.circular(WiseWebTokens.radiusMd),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(WiseWebTokens.radiusMd),
        child: Container(
          constraints: const BoxConstraints(minHeight: 46),
          decoration: BoxDecoration(
            color: selected ? tokens.surfaceCard : tokens.surfaceElevated,
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
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 18,
                      color: selected
                          ? tokens.brandPrimary
                          : tokens.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: WiseWebTypography.body(
                        context,
                        size: 14.5,
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
                width: 48,
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

class _FieldMockRow extends StatelessWidget {
  const _FieldMockRow({
    required this.label,
    required this.value,
    required this.badge,
  });

  final String label;
  final String value;
  final String badge;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: tokens.surfaceElevated,
        borderRadius: BorderRadius.circular(WiseWebTokens.radiusSm),
        border: Border.all(color: tokens.borderSubtle),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: WiseWebTypography.body(
                    context,
                    size: 12,
                    color: tokens.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: WiseWebTypography.body(
                    context,
                    size: 14.5,
                    color: tokens.textPrimary,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: tokens.surfaceCard,
              borderRadius: BorderRadius.circular(WiseWebTokens.radiusXs),
              border: Border.all(color: tokens.borderSubtle),
            ),
            child: Text(
              badge,
              style: WiseWebTypography.mono(
                context,
                size: 11,
                color: tokens.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DraftChip extends StatelessWidget {
  const _DraftChip({
    required this.label,
    required this.value,
    this.accent,
  });

  final String label;
  final String value;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              size: 11,
              color: tokens.textMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: WiseWebTypography.body(
              context,
              size: 13.5,
              color: accent ?? tokens.textPrimary,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
