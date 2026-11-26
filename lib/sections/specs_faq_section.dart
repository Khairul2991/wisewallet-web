import 'package:flutter/material.dart';
import '../l10n/landing_strings.dart';
import '../theme/wise_web_tokens.dart';
import '../widgets/motion_primitives.dart';

/// Verified Technical Specification Matrix + Product-Specific FAQ Accordion (#spesifikasi, #faq).
class SpecsFaqSection extends StatefulWidget {
  const SpecsFaqSection({
    super.key,
    required this.strings,
    required this.reducedMotion,
    this.scrollListenable,
  });

  final LandingStrings strings;
  final bool reducedMotion;
  final Listenable? scrollListenable;

  @override
  State<SpecsFaqSection> createState() => _SpecsFaqSectionState();
}

class _SpecsFaqSectionState extends State<SpecsFaqSection> {
  int? _openFaqIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 960;

    final specsColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.strings.specsTitle,
          style: WiseWebTypography.sectionTitle(context),
        ),
        const SizedBox(height: 10),
        Text(
          widget.strings.specsSubtitle,
          style: WiseWebTypography.body(context),
        ),
        const SizedBox(height: 22),
        WiseSurfaceCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < widget.strings.specRows.length; i++)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: i.isOdd
                        ? tokens.surfaceElevated.withValues(alpha: 0.55)
                        : Colors.transparent,
                    border: i == 0
                        ? null
                        : Border(top: BorderSide(color: tokens.borderSubtle)),
                  ),
                  child: width >= 540
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 190,
                              child: Text(
                                widget.strings.specRows[i].area,
                                style: WiseWebTypography.body(
                                  context,
                                  size: 14,
                                  color: tokens.textPrimary,
                                ).copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                widget.strings.specRows[i].detail,
                                style: WiseWebTypography.body(
                                  context,
                                  size: 14,
                                  color: tokens.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.strings.specRows[i].area,
                              style: WiseWebTypography.body(
                                context,
                                size: 14,
                                color: tokens.textPrimary,
                              ).copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.strings.specRows[i].detail,
                              style: WiseWebTypography.body(
                                context,
                                size: 14,
                                color: tokens.textSecondary,
                              ),
                            ),
                          ],
                        ),
                ),
            ],
          ),
        ),
      ],
    );

    final faqColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.strings.faqTitle,
          style: WiseWebTypography.sectionTitle(context),
        ),
        const SizedBox(height: 10),
        Text(
          widget.strings.faqSubtitle,
          style: WiseWebTypography.body(context),
        ),
        const SizedBox(height: 22),
        for (var i = 0; i < widget.strings.faqItems.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _FaqAccordionTile(
              key: Key('faq_item_$i'),
              item: widget.strings.faqItems[i],
              expanded: _openFaqIndex == i,
              reducedMotion: widget.reducedMotion,
              onToggle: () => setState(
                () => _openFaqIndex = _openFaqIndex == i ? null : i,
              ),
            ),
          ),
      ],
    );

    return SectionContainer(
      backgroundColor: tokens.surfaceElevated.withValues(alpha: 0.55),
      child: ScrollReveal(
        reducedMotion: widget.reducedMotion,
        scrollListenable: widget.scrollListenable,
        child: isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 11, child: specsColumn),
                  const SizedBox(width: 36),
                  Expanded(flex: 10, child: faqColumn),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  specsColumn,
                  const SizedBox(height: 48),
                  faqColumn,
                ],
              ),
      ),
    );
  }
}

class _FaqAccordionTile extends StatelessWidget {
  const _FaqAccordionTile({
    super.key,
    required this.item,
    required this.expanded,
    required this.reducedMotion,
    required this.onToggle,
  });

  final FaqItem item;
  final bool expanded;
  final bool reducedMotion;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final tokens = WiseWebTokens.of(context);
    return WiseSurfaceCard(
      padding: EdgeInsets.zero,
      radius: WiseWebTokens.radiusMd,
      borderColor: expanded ? tokens.brandPrimary : tokens.borderSubtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            button: true,
            expanded: expanded,
            child: InkWell(
              onTap: onToggle,
              mouseCursor: SystemMouseCursors.click,
              borderRadius: BorderRadius.circular(WiseWebTokens.radiusMd),
              child: Container(
                constraints: const BoxConstraints(minHeight: 54),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.question,
                        style: WiseWebTypography.body(
                          context,
                          size: 15,
                          color: tokens.textPrimary,
                        ).copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 12),
                    AnimatedRotation(
                      turns: expanded ? 0.5 : 0.0,
                      duration: reducedMotion
                          ? Duration.zero
                          : const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: expanded
                            ? tokens.brandPrimary
                            : tokens.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (reducedMotion)
            if (expanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                child: Text(
                  item.answer,
                  style: WiseWebTypography.body(
                    context,
                    size: 14.5,
                    color: tokens.textSecondary,
                  ),
                ),
              )
            else
              const SizedBox.shrink()
          else
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                child: Text(
                  item.answer,
                  style: WiseWebTypography.body(
                    context,
                    size: 14.5,
                    color: tokens.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
