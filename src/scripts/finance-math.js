export function formatRupiah(amount) {
  const n = Math.round(amount);
  const neg = n < 0;
  const digits = Math.abs(n).toString();
  let out = '';
  for (let i = 0; i < digits.length; i += 1) {
    const left = digits.length - i;
    if (i > 0 && left % 3 === 0) out += '.';
    out += digits[i];
  }
  return `${neg ? '-' : ''}Rp${out}`;
}

export function simulateTransfer({
  sourceBalance,
  destBalance,
  amount,
  monthlyIncome,
  monthlyExpense,
}) {
  const clamped = Math.max(0, Math.min(amount, sourceBalance));
  const nextSource = sourceBalance - clamped;
  const nextDest = destBalance + clamped;
  const totalBefore = sourceBalance + destBalance;
  const totalAfter = nextSource + nextDest;
  const net = monthlyIncome - monthlyExpense;
  return {
    nextSource,
    nextDest,
    totalBefore,
    totalAfter,
    netBefore: net,
    netAfter: net,
  };
}

export function evaluateBudget({ limit, spent, remainingDays }) {
  const safeLimit = limit <= 0 ? 1 : limit;
  const percent = (spent / safeLimit) * 100;
  const remaining = safeLimit - spent;
  let status = 'safe';
  if (percent >= 100) status = 'exceeded';
  else if (percent >= 80) status = 'warning';

  let dailyLimit = 0;
  if (remaining > 0) {
    dailyLimit = remainingDays <= 0 ? remaining : Math.floor(remaining / remainingDays);
  }

  return {
    limit: safeLimit,
    spent,
    remaining,
    percent,
    barWidth: Math.min(100, Math.max(0, percent)),
    dailyLimit,
    status,
  };
}

export function computeSavingsRate(income, expense) {
  if (income <= 0) return null;
  return ((income - expense) / income) * 100;
}

export function createSampleDebt() {
  return buildDebt(1000000, [200000], [450000], true);
}

function buildDebt(initialPrincipal, additions, payments, linkedWallet) {
  const totalAdditions = additions.reduce((a, b) => a + b, 0);
  const totalPrincipal = initialPrincipal + totalAdditions;
  const totalPaid = payments.reduce((a, b) => a + b, 0);
  const remaining = Math.max(0, totalPrincipal - totalPaid);
  return {
    initialPrincipal,
    additions,
    payments,
    linkedWallet,
    totalAdditions,
    totalPrincipal,
    totalPaid,
    remaining,
    isPaidOff: remaining === 0,
    progress: totalPrincipal === 0 ? 100 : Math.min(100, (totalPaid / totalPrincipal) * 100),
  };
}

export function addDebtPrincipal(state, amount) {
  if (state.isPaidOff || amount <= 0) return state;
  return buildDebt(
    state.initialPrincipal,
    [...state.additions, amount],
    state.payments,
    state.linkedWallet,
  );
}

export function payDebtInstallment(state, amount) {
  if (state.isPaidOff || amount <= 0) return state;
  const actual = Math.min(amount, state.remaining);
  return buildDebt(
    state.initialPrincipal,
    state.additions,
    [...state.payments, actual],
    state.linkedWallet,
  );
}

export function payOffDebt(state) {
  if (state.isPaidOff) return state;
  return payDebtInstallment(state, state.remaining);
}

export function toggleDebtWallet(state) {
  return buildDebt(
    state.initialPrincipal,
    state.additions,
    state.payments,
    !state.linkedWallet,
  );
}
