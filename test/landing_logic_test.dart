import 'package:flutter_test/flutter_test.dart';
import 'package:wisewallet_landing/config/release_config.dart';
import 'package:wisewallet_landing/domain/finance_simulator.dart';
import 'package:wisewallet_landing/l10n/landing_strings.dart';

void main() {
  group('ReleaseConfig split-per-ABI contract', () {
    test('exposes 4 APK variants pointing to public wisewallet-web releases', () {
      expect(ReleaseConfig.publicRepoUrl,
          'https://github.com/Khairul2991/wisewallet-web');
      expect(ReleaseConfig.releasesPageUrl,
          'https://github.com/Khairul2991/wisewallet-web/releases');
      expect(ReleaseConfig.variants.length, 4);

      final ids = ReleaseConfig.variants.map((v) => v.id).toList();
      expect(ids, ['arm64-v8a', 'armeabi-v7a', 'x86_64', 'universal']);
      expect(ReleaseConfig.recommendedVariant.id, 'arm64-v8a');

      for (final variant in ReleaseConfig.variants) {
        final url = ReleaseConfig.downloadUrlFor(variant);
        expect(
          url,
          startsWith(
            'https://github.com/Khairul2991/wisewallet-web/releases/latest/download/',
          ),
        );
        expect(url, endsWith('.apk'));
      }
    });
  });

  group('FinanceSimulator invariants (PRD parity)', () {
    test('formats Rupiah cleanly without decimals', () {
      expect(formatRupiah(0), 'Rp0');
      expect(formatRupiah(2009000), 'Rp2.009.000');
      expect(formatRupiah(-50000), '-Rp50.000');
    });

    test('transfer keeps total balance and net cash flow strictly invariant', () {
      final res = simulateTransfer(
        sourceBalance: 2500000,
        destBalance: 1000000,
        amount: 650000,
        monthlyIncome: 7500000,
        monthlyExpense: 3200000,
      );

      expect(res.nextSourceBalance, 1850000);
      expect(res.nextDestBalance, 1650000);
      expect(res.totalBalanceBefore, res.totalBalanceAfter);
      expect(res.netCashFlowBefore, res.netCashFlowAfter);
    });

    test('budget status obeys <80% safe, 80-<100% warning, >=100% exceeded', () {
      final safe = evaluateBudget(limit: 1000000, spent: 799999, remainingDays: 10);
      expect(safe.health, BudgetHealth.safe);
      expect(safe.dailyLimit, 20000);

      final warn = evaluateBudget(limit: 1000000, spent: 800000, remainingDays: 10);
      expect(warn.health, BudgetHealth.warning);

      final exact100 = evaluateBudget(limit: 1000000, spent: 1000000, remainingDays: 5);
      expect(exact100.health, BudgetHealth.exceeded);
      expect(exact100.remaining, 0);

      final zeroDays = evaluateBudget(limit: 1000000, spent: 500000, remainingDays: 0);
      expect(zeroDays.dailyLimit, 500000);
    });

    test('savings rate returns null on zero income instead of dividing by zero', () {
      expect(computeSavingsRate(income: 0, expense: 100000), isNull);
      expect(computeSavingsRate(income: 10000000, expense: 6500000), closeTo(35.0, 0.01));
    });

    test('debt additions and installments lock once paid off', () {
      final initial = DebtSimulationState.sample();
      final added = initial.withAddition(250000);
      expect(added.totalPrincipal, initial.totalPrincipal + 250000);
      expect(added.isPaidOff, isFalse);

      final paid = added.payOffRemaining();
      expect(paid.remaining, 0);
      expect(paid.isPaidOff, isTrue);

      // Once paid off, further additions must be ignored (PRD §41 lock rule)
      final locked = paid.withAddition(100000);
      expect(locked.totalPrincipal, paid.totalPrincipal);
      expect(locked.isPaidOff, isTrue);
    });
  });

  group('Antislop copy hygiene (R-02, R-16)', () {
    test('zero em dashes and zero banned AI buzzwords in ID and EN strings', () {
      const bannedBuzzwords = [
        'ai powered',
        'ai-powered',
        'revolutionary',
        'next generation',
        'next-generation',
        'cutting edge',
        'cutting-edge',
        'seamless',
        'effortless',
        'ultimate',
        'game-changer',
      ];

      for (final locale in LandingLocale.values) {
        final strings = LandingStrings.of(locale);
        final texts = strings.allVisibleTexts();
        expect(texts, isNotEmpty);
        for (final text in texts) {
          expect(
            text.contains('—'),
            isFalse,
            reason: 'Em dash forbidden by R-02 in [$locale]: "$text"',
          );
          final lower = text.toLowerCase();
          for (final buzz in bannedBuzzwords) {
            expect(
              lower.contains(buzz),
              isFalse,
              reason: 'Buzzword "$buzz" forbidden by R-16 in [$locale]: "$text"',
            );
          }
        }
      }
    });
  });
}
