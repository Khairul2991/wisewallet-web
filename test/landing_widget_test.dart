import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wisewallet_landing/app.dart';
import 'package:wisewallet_landing/l10n/landing_strings.dart';

void main() {
  Future<void> pumpLanding(
    WidgetTester tester, {
    Size size = const Size(1440, 900),
    ThemeMode themeMode = ThemeMode.light,
    LandingLocale locale = LandingLocale.id,
    bool reducedMotion = true,
    void Function(String url)? onLaunchUrl,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      WiseWalletLandingApp(
        initialThemeMode: themeMode,
        initialLocale: locale,
        initialReducedMotion: reducedMotion,
        onLaunchUrl: onLaunchUrl,
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();
  }

  testWidgets(
      'renders cleanly without overflow across desktop, tablet, and mobile in light and dark mode',
      (tester) async {
    for (final size in const [
      Size(1440, 900),
      Size(768, 1024),
      Size(375, 812),
    ]) {
      for (final mode in const [ThemeMode.light, ThemeMode.dark]) {
        await pumpLanding(tester, size: size, themeMode: mode);
        expect(find.byKey(const Key('hero_headline')), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets('theme toggle, motion toggle, and bilingual ID/EN toggle update UI reactively',
      (tester) async {
    await pumpLanding(tester, size: const Size(1440, 900));

    expect(find.textContaining('Keuangan pribadi'), findsWidgets);

    await tester.tap(find.byKey(const Key('toggle_locale_button')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Personal finance'), findsWidgets);

    await tester.tap(find.byKey(const Key('toggle_theme_button')));
    await tester.pumpAndSettle();
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.dark);

    await tester.tap(find.byKey(const Key('toggle_motion_button')));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.ensureVisible(
      find.byKey(const Key('principle_strip_pause_button')),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byKey(const Key('principle_strip_pause_button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('principle_strip_pause_button')));
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });

  testWidgets('full element-by-element interactive click-through across all sections',
      (tester) async {
    final launchedUrls = <String>[];
    await pumpLanding(
      tester,
      size: const Size(1440, 900),
      onLaunchUrl: launchedUrls.add,
    );

    // 1. Hero phone tabs + Splash replay
    await tester.tap(find.byKey(const Key('hero_phone_tab_1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('hero_phone_tab_2')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('hero_phone_tab_3')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('hero_phone_tab_0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('replay_splash_button')));
    await tester.pumpAndSettle();

    // 2. Capture section: Voice presets + OCR crop & scan
    await tester.ensureVisible(find.byKey(const Key('capture_tab_voice')));
    await tester.tap(find.byKey(const Key('capture_tab_voice')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('voice_preset_1')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('voice_draft_card')), findsOneWidget);

    await tester.tap(find.byKey(const Key('capture_tab_ocr')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('ocr_preset_1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('ocr_crop_toggle')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('ocr_scan_button')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('ocr_result_card')), findsOneWidget);

    // 3. Financial Core tabs + interactive actions + UI states (R-27)
    await tester.ensureVisible(find.byKey(const Key('core_tab_budget')));
    await tester.tap(find.byKey(const Key('core_tab_budget')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('budget_slider')), findsOneWidget);
    await tester.tap(find.byKey(const Key('budget_scope_toggle')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('core_tab_calendar')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('calendar_first_day_toggle')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('core_tab_debts')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('debt_add_principal_btn')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('debt_pay_installment_btn')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('debt_pay_off_btn')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('debt_wallet_toggle')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('debt_reset_btn')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('core_tab_profiles')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('profile_switch_business')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('ui_state_empty')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sim_empty_state')), findsOneWidget);

    await tester.tap(find.byKey(const Key('ui_state_loading')));
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.byKey(const Key('sim_loading_state')), findsOneWidget);

    await tester.tap(find.byKey(const Key('ui_state_error')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sim_error_state')), findsOneWidget);

    await tester.tap(find.byKey(const Key('ui_state_normal')));
    await tester.pumpAndSettle();

    // 4. Reports & Export section: PDF ID/EN toggle & CSV tab
    await tester.ensureVisible(find.byKey(const Key('pdf_lang_toggle')));
    await tester.tap(find.byKey(const Key('pdf_lang_toggle')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Financial Report'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('export_tab_csv')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('export_tab_csv')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Tanggal,Jenis,Kategori'), findsOneWidget);

    // 5. Security section: Password vs Account Recovery v2 toggle
    await tester.ensureVisible(find.byKey(const Key('security_mode_account')));
    await tester.tap(find.byKey(const Key('security_mode_account')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('security_mode_password')));
    await tester.pumpAndSettle();

    // 6. FAQ Accordion toggle
    await tester.ensureVisible(find.byKey(const Key('faq_item_2')));
    await tester.tap(find.byKey(const Key('faq_item_2')));
    await tester.pumpAndSettle();

    // 7. Split-per-ABI Download selector + ABI guide dialog + URL launches
    await tester.ensureVisible(find.byKey(const Key('abi_card_armeabi-v7a')));
    await tester.tap(find.byKey(const Key('abi_card_armeabi-v7a')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('download_selected_apk_button')));
    await tester.tap(find.byKey(const Key('download_selected_apk_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('download_all_releases_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('check_abi_guide_button')));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.text('Mengerti'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);

    expect(
      launchedUrls,
      containsAll([
        'https://github.com/Khairul2991/wisewallet-web/releases/latest/download/app-armeabi-v7a-release.apk',
        'https://github.com/Khairul2991/wisewallet-web/releases',
      ]),
    );
  });

  testWidgets('mobile menu drawer opens and navigates cleanly at 375x812',
      (tester) async {
    await pumpLanding(tester, size: const Size(375, 812));

    expect(find.byKey(const Key('mobile_menu_button')), findsOneWidget);
    await tester.tap(find.byKey(const Key('mobile_menu_button')));
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsOneWidget);

    await tester.tap(find.byTooltip('Tutup menu'));
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
