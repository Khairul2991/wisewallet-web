import 'package:flutter/foundation.dart';

/// Deterministic Rupiah formatter matching WiseWallet's integer-only money rules.
String formatRupiah(int amount) {
  final isNegative = amount < 0;
  final digits = amount.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;
    if (i > 0 && remaining % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(digits[i]);
  }
  return '${isNegative ? '-' : ''}Rp${buffer.toString()}';
}

enum BudgetHealth { safe, warning, exceeded }

@immutable
class BudgetEvalResult {
  const BudgetEvalResult({
    required this.limit,
    required this.spent,
    required this.remaining,
    required this.progressPercent,
    required this.clampedBarFactor,
    required this.dailyLimit,
    required this.health,
  });

  final int limit;
  final int spent;
  final int remaining;
  final double progressPercent;
  final double clampedBarFactor;
  final int dailyLimit;
  final BudgetHealth health;
}

/// Evaluates monthly budget progress using PRD FR-015 / FR-016 thresholds:
/// <80% safe, 80% to <100% warning, >=100% exceeded (exact 100% is exceeded).
BudgetEvalResult evaluateBudget({
  required int limit,
  required int spent,
  required int remainingDays,
}) {
  final safeLimit = limit <= 0 ? 1 : limit;
  final rawPercent = (spent / safeLimit) * 100.0;
  final remaining = safeLimit - spent;
  final BudgetHealth health;
  if (rawPercent >= 100.0) {
    health = BudgetHealth.exceeded;
  } else if (rawPercent >= 80.0) {
    health = BudgetHealth.warning;
  } else {
    health = BudgetHealth.safe;
  }

  final int dailyLimit;
  if (remaining <= 0) {
    dailyLimit = 0;
  } else if (remainingDays <= 0) {
    dailyLimit = remaining;
  } else {
    dailyLimit = remaining ~/ remainingDays;
  }

  return BudgetEvalResult(
    limit: safeLimit,
    spent: spent,
    remaining: remaining,
    progressPercent: rawPercent,
    clampedBarFactor: (rawPercent / 100.0).clamp(0.0, 1.0),
    dailyLimit: dailyLimit,
    health: health,
  );
}

@immutable
class TransferSimResult {
  const TransferSimResult({
    required this.nextSourceBalance,
    required this.nextDestBalance,
    required this.totalBalanceBefore,
    required this.totalBalanceAfter,
    required this.netCashFlowBefore,
    required this.netCashFlowAfter,
  });

  final int nextSourceBalance;
  final int nextDestBalance;
  final int totalBalanceBefore;
  final int totalBalanceAfter;
  final int netCashFlowBefore;
  final int netCashFlowAfter;
}

/// Demonstrates WiseWallet's strict net-zero transfer invariant (PRD FR-024):
/// Transfers move money across wallets without altering total balance or net cash flow.
TransferSimResult simulateTransfer({
  required int sourceBalance,
  required int destBalance,
  required int amount,
  required int monthlyIncome,
  required int monthlyExpense,
}) {
  final clamped = amount.clamp(0, sourceBalance);
  final nextSource = sourceBalance - clamped;
  final nextDest = destBalance + clamped;
  final totalBefore = sourceBalance + destBalance;
  final totalAfter = nextSource + nextDest;
  final netCashFlow = monthlyIncome - monthlyExpense;

  return TransferSimResult(
    nextSourceBalance: nextSource,
    nextDestBalance: nextDest,
    totalBalanceBefore: totalBefore,
    totalBalanceAfter: totalAfter,
    netCashFlowBefore: netCashFlow,
    netCashFlowAfter: netCashFlow,
  );
}

/// Savings rate calculator with strict zero-income guard (PRD 11.10).
double? computeSavingsRate({required int income, required int expense}) {
  if (income <= 0) return null;
  return ((income - expense) / income) * 100.0;
}

@immutable
class DebtSimulationState {
  const DebtSimulationState({
    required this.personName,
    required this.initialPrincipal,
    required this.additions,
    required this.payments,
    required this.linkedToWallet,
  });

  factory DebtSimulationState.sample() => const DebtSimulationState(
        personName: 'Raka Pratama',
        initialPrincipal: 1000000,
        additions: [200000],
        payments: [450000],
        linkedToWallet: true,
      );

  final String personName;
  final int initialPrincipal;
  final List<int> additions;
  final List<int> payments;
  final bool linkedToWallet;

  int get totalAdditions => additions.fold(0, (a, b) => a + b);
  int get totalPrincipal => initialPrincipal + totalAdditions;
  int get totalPaid => payments.fold(0, (a, b) => a + b);
  int get remaining => (totalPrincipal - totalPaid).clamp(0, totalPrincipal);
  bool get isPaidOff => remaining == 0;
  double get progress => totalPrincipal == 0 ? 1.0 : totalPaid / totalPrincipal;

  DebtSimulationState copyWith({
    bool? linkedToWallet,
  }) =>
      DebtSimulationState(
        personName: personName,
        initialPrincipal: initialPrincipal,
        additions: additions,
        payments: payments,
        linkedToWallet: linkedToWallet ?? this.linkedToWallet,
      );

  DebtSimulationState withAddition(int amount) {
    if (isPaidOff || amount <= 0) return this;
    return DebtSimulationState(
      personName: personName,
      initialPrincipal: initialPrincipal,
      additions: [...additions, amount],
      payments: payments,
      linkedToWallet: linkedToWallet,
    );
  }

  DebtSimulationState withPayment(int amount) {
    if (isPaidOff || amount <= 0) return this;
    final actual = amount > remaining ? remaining : amount;
    return DebtSimulationState(
      personName: personName,
      initialPrincipal: initialPrincipal,
      additions: additions,
      payments: [...payments, actual],
      linkedToWallet: linkedToWallet,
    );
  }

  DebtSimulationState payOffRemaining() {
    if (isPaidOff) return this;
    return withPayment(remaining);
  }
}

@immutable
class VoicePreset {
  const VoicePreset({
    required this.id,
    required this.spokenPhrase,
    required this.typeId,
    required this.typeEn,
    required this.isIncome,
    required this.amount,
    required this.categoryId,
    required this.categoryEn,
    required this.wallet,
    required this.dateLabelId,
    required this.dateLabelEn,
    required this.timeLabel,
    required this.description,
    required this.notes,
    required this.reviewHintId,
    required this.reviewHintEn,
    required this.isEstimatedTime,
  });

  final String id;
  final String spokenPhrase;
  final String typeId;
  final String typeEn;
  final bool isIncome;
  final int amount;
  final String categoryId;
  final String categoryEn;
  final String wallet;
  final String dateLabelId;
  final String dateLabelEn;
  final String timeLabel;
  final String description;
  final String notes;
  final String reviewHintId;
  final String reviewHintEn;
  final bool isEstimatedTime;
}

@immutable
class OcrReceiptPreset {
  const OcrReceiptPreset({
    required this.id,
    required this.labelId,
    required this.labelEn,
    required this.merchant,
    required this.rawLines,
    required this.extractedDate,
    required this.extractedTime,
    required this.totalAmount,
    required this.categoryId,
    required this.categoryEn,
    required this.notes,
  });

  final String id;
  final String labelId;
  final String labelEn;
  final String merchant;
  final List<String> rawLines;
  final String extractedDate;
  final String extractedTime;
  final int totalAmount;
  final String categoryId;
  final String categoryEn;
  final String notes;
}
