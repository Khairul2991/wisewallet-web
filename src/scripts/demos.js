import { CONTACT_EMAIL, COPY, OCR_PRESETS, RELEASE_CONFIG, VOICE_PRESETS } from '../data/content.js';
import releaseSizesSnapshot from '../data/release-sizes-snapshot.json';
import { buildContactMailtoUrl } from './contact.js';
import {
  addDebtPrincipal,
  computeSavingsRate,
  createSampleDebt,
  evaluateBudget,
  formatRupiah,
  payDebtInstallment,
  payOffDebt,
  simulateTransfer,
  toggleDebtWallet,
} from './finance-math.js';
import {
  fetchLatestReleaseSizes,
  formatAssetSize,
  readCachedReleaseSizes,
} from './release-sizes.js';

const CHECK_SVG = `<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>`;
const CHEVRON_SVG = `<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polyline points="6 9 12 15 18 9"></polyline></svg>`;

export function initDemos(i18n) {
  const state = {
    phoneTab: 'home',
    captureTab: 'manual',
    manualFilter: 'all',
    voicePresetIdx: 0,
    voiceSpeaking: false,
    ocrPresetIdx: 0,
    ocrCrop: false,
    ocrScanned: true,
    coreTab: 'transfer',
    transferAmount: 750000,
    budgetSpent: 650000,
    budgetAllWallets: true,
    calStartMonday: true,
    calSelectedDay: 5,
    debt: createSampleDebt(),
    profileIdx: 0,
    exportTab: 'pdf',
    pdfLang: 'id',
    privacyMode: 'passphrase',
    openFaq: 0,
    emailCopied: false,
    releaseSizes: {
      ...(releaseSizesSnapshot?.sizes ?? {}),
      ...(readCachedReleaseSizes()?.sizes ?? {}),
    },
  };

  let voiceTimer = null;
  let ocrTimer = null;
  let copyEmailTimer = null;

  const isId = () => i18n.getLang() === 'id';

  /* ---------- 1. Hero Interactive Phone ---------- */
  function renderPhone() {
    const id = isId();
    const screen = document.getElementById('hero-phone-screen');
    if (!screen) return;

    const tabLabels = {
      home: id ? 'Beranda' : 'Home',
      calendar: id ? 'Kalender' : 'Calendar',
      budget: id ? 'Anggaran' : 'Budgets',
      debts: id ? 'Utang' : 'Debts',
    };

    document.querySelectorAll('[data-phone-tab]').forEach((btn) => {
      const key = btn.getAttribute('data-phone-tab');
      btn.textContent = tabLabels[key] || key;
      btn.setAttribute('aria-selected', String(key === state.phoneTab));
    });

    if (state.phoneTab === 'home') {
      screen.innerHTML = `
        <div class="phone-balance-box">
          <div class="phone-balance-label">${id ? 'Total Saldo Semua Dompet' : 'Total Balance Across Wallets'}</div>
          <div class="phone-balance-val money">Rp12.450.000</div>
          <div class="phone-io-row">
            <div>
              <div style="opacity:0.82;">${id ? 'Pemasukan' : 'Income'}</div>
              <strong class="money">+Rp8.500.000</strong>
            </div>
            <div>
              <div style="opacity:0.82;">${id ? 'Pengeluaran' : 'Expense'}</div>
              <strong class="money">-Rp3.420.000</strong>
            </div>
          </div>
        </div>
        <div class="phone-wallets">
          <div class="phone-wallet-chip"><span>Bank BCA</span><strong class="money">Rp7,9 jt</strong></div>
          <div class="phone-wallet-chip"><span>GoPay</span><strong class="money">Rp2,5 jt</strong></div>
          <div class="phone-wallet-chip"><span>${id ? 'Tunai' : 'Cash'}</span><strong class="money">Rp2,0 jt</strong></div>
        </div>
        <div class="phone-tx-list">
          <div class="phone-tx">
            <div><strong>${id ? 'Makan Siang Kantor' : 'Office Lunch'}</strong><small>GoPay · 12:25</small></div>
            <span class="money text-expense">-Rp45.000</span>
          </div>
          <div class="phone-tx">
            <div><strong>${id ? 'Gaji Bulanan' : 'Monthly Salary'}</strong><small>Bank BCA · 08:00</small></div>
            <span class="money text-income">+Rp8.500.000</span>
          </div>
        </div>
      `;
    } else if (state.phoneTab === 'calendar') {
      screen.innerHTML = `
        <div class="phone-tx" style="margin-bottom:10px;background:var(--brand-soft);color:var(--brand);">
          <strong>${id ? 'Oktober 2026' : 'October 2026'}</strong>
          <span class="money">+Rp5.080.000</span>
        </div>
        <div class="phone-tx-list">
          <div class="phone-tx">
            <div><strong>${id ? 'Tanggal 5 · Gaji & Belanja' : 'Day 5 · Salary & Groceries'}</strong><small>${id ? '2 transaksi tercatat' : '2 transactions logged'}</small></div>
            <span class="money text-income">+Rp8,2 jt</span>
          </div>
          <div class="phone-tx">
            <div><strong>${id ? 'Tanggal 10 · Langganan Rutin' : 'Day 10 · Routine Bill'}</strong><small>${id ? 'Internet rumah otomatis' : 'Automatic home internet'}</small></div>
            <span class="money text-expense">-Rp350.000</span>
          </div>
          <div class="phone-tx">
            <div><strong>${id ? 'Tanggal 14 · Kopi Sore' : 'Day 14 · Afternoon Coffee'}</strong><small>${id ? 'Dicatat lewat suara' : 'Logged by voice'}</small></div>
            <span class="money text-expense">-Rp28.000</span>
          </div>
        </div>
      `;
    } else if (state.phoneTab === 'budget') {
      screen.innerHTML = `
        <div class="phone-tx-list">
          <div class="draft-field">
            <div style="display:flex;justify-content:space-between;font-size:0.86rem;">
              <strong>${id ? 'Makanan & Minuman' : 'Food & Drinks'}</strong>
              <span class="money text-income">65%</span>
            </div>
            <div class="progress-track"><div class="progress-fill" style="width:65%;"></div></div>
            <span>${id ? 'Sisa Rp525.000 · Aman Rp35.000/hari' : 'Left Rp525.000 · Safe Rp35.000/day'}</span>
          </div>
          <div class="draft-field">
            <div style="display:flex;justify-content:space-between;font-size:0.86rem;">
              <strong>${id ? 'Transportasi' : 'Transport'}</strong>
              <span class="money text-warning">84%</span>
            </div>
            <div class="progress-track"><div class="progress-fill" style="width:84%;background:var(--warning);"></div></div>
            <span>${id ? 'Hampir mencapai batas bulanan' : 'Approaching monthly limit'}</span>
          </div>
        </div>
      `;
    } else {
      screen.innerHTML = `
        <div class="phone-tx-list">
          <div class="draft-field">
            <div style="display:flex;justify-content:space-between;font-size:0.88rem;">
              <strong>${id ? 'Piutang · Raka' : 'Receivable · Raka'}</strong>
              <span class="money text-brand">Rp750.000</span>
            </div>
            <div class="progress-track"><div class="progress-fill" style="width:38%;background:var(--brand);"></div></div>
            <span>${id ? 'Sudah dibayar Rp450.000 dari Rp1.200.000' : 'Paid Rp450.000 of Rp1.200.000'}</span>
          </div>
          <div class="phone-tx">
            <div><strong>${id ? 'Utang · Patungan Makan' : 'Debt · Team Dinner'}</strong><small>${id ? 'Jatuh tempo Jumat' : 'Due Friday'}</small></div>
            <span class="money text-expense">Rp120.000</span>
          </div>
        </div>
      `;
    }
  }

  /* ---------- 2. 3-Way Capture Showcase ---------- */
  function renderCapture() {
    const id = isId();
    const copy = i18n.getCopy();
    const stage = document.getElementById('capture-stage');
    if (!stage) return;

    document.querySelectorAll('[data-capture-tab]').forEach((btn) => {
      btn.setAttribute('aria-selected', String(btn.getAttribute('data-capture-tab') === state.captureTab));
    });

    if (state.captureTab === 'manual') {
      const items = [
        {
          type: 'expense',
          name: id ? 'Belanja Mingguan' : 'Weekly Groceries',
          meta: 'Bank BCA · 18:10',
          val: '-Rp245.000',
        },
        {
          type: 'income',
          name: id ? 'Bonus Proyek' : 'Project Bonus',
          meta: 'Bank BCA · 15:00',
          val: '+Rp1.500.000',
        },
        {
          type: 'expense',
          name: id ? 'Kopi & Roti' : 'Coffee & Bakery',
          meta: 'GoPay · 09:20',
          val: '-Rp42.000',
        },
      ].filter((item) => state.manualFilter === 'all' || item.type === state.manualFilter);

      stage.innerHTML = `
        <div class="split-panel">
          <div>
            <h3 style="font-size:1.3rem;">${copy.manualTitle}</h3>
            <p style="margin-top:10px;color:var(--text-secondary);">${copy.manualDesc}</p>
            <ul class="clean-list">
              <li>${CHECK_SVG}<span>${copy.manualB1}</span></li>
              <li>${CHECK_SVG}<span>${copy.manualB2}</span></li>
              <li>${CHECK_SVG}<span>${copy.manualB3}</span></li>
            </ul>
          </div>
          <div>
            <div style="display:flex;gap:8px;flex-wrap:wrap;margin-bottom:12px;">
              <button type="button" class="btn btn-sm ${state.manualFilter === 'all' ? 'btn-soft' : 'btn-outlined'}" data-manual-filter="all">${id ? 'Semua' : 'All'}</button>
              <button type="button" class="btn btn-sm ${state.manualFilter === 'income' ? 'btn-soft' : 'btn-outlined'}" data-manual-filter="income">${id ? 'Pemasukan' : 'Income'}</button>
              <button type="button" class="btn btn-sm ${state.manualFilter === 'expense' ? 'btn-soft' : 'btn-outlined'}" data-manual-filter="expense">${id ? 'Pengeluaran' : 'Expense'}</button>
            </div>
            <div class="phone-tx-list" style="margin-top:0;">
              ${items
                .map(
                  (tx) => `
                  <div class="phone-tx">
                    <div><strong>${tx.name}</strong><small>${tx.meta}</small></div>
                    <span class="money ${tx.type === 'income' ? 'text-income' : 'text-expense'}">${tx.val}</span>
                  </div>`,
                )
                .join('')}
            </div>
          </div>
        </div>
      `;
    } else if (state.captureTab === 'voice') {
      const p = VOICE_PRESETS[state.voicePresetIdx];
      stage.innerHTML = `
        <div class="split-panel">
          <div>
            <h3 style="font-size:1.3rem;">${copy.voiceTitle}</h3>
            <p style="margin-top:10px;color:var(--text-secondary);">${copy.voiceDesc}</p>
            <p style="margin-top:14px;font-size:0.86rem;font-weight:600;color:var(--text-muted);">${copy.voicePrompt}</p>
            <div class="preset-stack">
              ${VOICE_PRESETS.map(
                (item, idx) => `
                <button type="button" class="preset-btn" data-voice-preset="${idx}" aria-pressed="${idx === state.voicePresetIdx}">
                  <span>"${item.phrase}"</span>
                </button>`,
              ).join('')}
            </div>
          </div>
          <div>
            <div style="display:flex;align-items:center;justify-content:space-between;gap:8px;">
              <strong style="font-size:0.95rem;">${id ? 'Pratinjau Sebelum Disimpan' : 'Draft Before Saving'}</strong>
              <span class="tag-sim">${copy.offlineTag}</span>
            </div>
            <div class="voice-wave ${state.voiceSpeaking ? 'is-speaking' : ''}" aria-hidden="true">
              ${Array.from({ length: 14 }, () => '<span class="voice-bar"></span>').join('')}
            </div>
            <div class="draft-grid">
              <div class="draft-field">
                <span>${id ? 'Jenis' : 'Type'}</span>
                <strong class="${p.isIncome ? 'text-income' : 'text-expense'}">${p.isIncome ? (id ? 'Pemasukan' : 'Income') : id ? 'Pengeluaran' : 'Expense'}</strong>
              </div>
              <div class="draft-field">
                <span>${id ? 'Nominal' : 'Amount'}</span>
                <strong class="money">${formatRupiah(p.amount)}</strong>
              </div>
              <div class="draft-field">
                <span>${id ? 'Kategori' : 'Category'}</span>
                <strong>${id ? p.category.id : p.category.en}</strong>
              </div>
              <div class="draft-field">
                <span>${id ? 'Dompet' : 'Wallet'}</span>
                <strong>${p.wallet}</strong>
              </div>
              <div class="draft-field">
                <span>${id ? 'Waktu' : 'Time'}</span>
                <strong>${id ? p.when.id : p.when.en}</strong>
              </div>
              <div class="draft-field">
                <span>${id ? 'Keterangan' : 'Description'}</span>
                <strong>${p.desc}</strong>
              </div>
            </div>
            <div class="notice-box ${p.isWarning ? 'notice-warning' : 'notice-income'}">
              <span>${id ? p.tip.id : p.tip.en}</span>
            </div>
          </div>
        </div>
      `;
    } else {
      const r = OCR_PRESETS[state.ocrPresetIdx];
      stage.innerHTML = `
        <div class="split-panel">
          <div>
            <h3 style="font-size:1.3rem;">${copy.ocrTitle}</h3>
            <p style="margin-top:10px;color:var(--text-secondary);">${copy.ocrDesc}</p>
            <div style="display:flex;gap:8px;flex-wrap:wrap;margin-top:16px;">
              ${OCR_PRESETS.map(
                (item, idx) => `
                <button type="button" class="btn btn-sm ${idx === state.ocrPresetIdx ? 'btn-soft' : 'btn-outlined'}" data-ocr-preset="${idx}">
                  ${id ? item.label.id : item.label.en}
                </button>`,
              ).join('')}
            </div>
            <div class="receipt-box ${state.ocrCrop ? 'crop-on' : ''}" id="ocr-receipt-box">
              <div class="receipt-crop-frame" aria-hidden="true"></div>
              <div class="ocr-laser" aria-hidden="true"></div>
              <pre style="margin:0;font-family:var(--font-body);white-space:pre-wrap;">${r.lines.join('\n')}</pre>
            </div>
            <div style="display:flex;gap:10px;flex-wrap:wrap;margin-top:14px;">
              <button type="button" class="btn btn-sm ${state.ocrCrop ? 'btn-soft' : 'btn-outlined'}" id="ocr-crop-btn" aria-pressed="${state.ocrCrop}">
                ${copy.ocrCrop}
              </button>
              <button type="button" class="btn btn-sm btn-primary" id="ocr-scan-btn">
                ${copy.ocrScan}
              </button>
            </div>
          </div>
          <div>
            <div style="display:flex;align-items:center;justify-content:space-between;gap:8px;margin-bottom:14px;">
              <strong style="font-size:0.95rem;">${id ? 'Hasil Pembacaan Otomatis' : 'Extracted Draft'}</strong>
              <span class="tag-sim">${state.ocrScanned ? (id ? 'Siap Disimpan' : 'Ready to Save') : id ? 'Memindai...' : 'Scanning...'}</span>
            </div>
            <div class="draft-grid">
              <div class="draft-field">
                <span>${id ? 'Nama Toko' : 'Merchant'}</span>
                <strong>${r.merchant}</strong>
              </div>
              <div class="draft-field">
                <span>${id ? 'Total Belanja' : 'Total Amount'}</span>
                <strong class="money text-expense">${formatRupiah(r.amount)}</strong>
              </div>
              <div class="draft-field">
                <span>${id ? 'Tanggal & Jam' : 'Date & Time'}</span>
                <strong>${r.date}</strong>
              </div>
              <div class="draft-field">
                <span>${id ? 'Kategori' : 'Category'}</span>
                <strong>${id ? r.category.id : r.category.en}</strong>
              </div>
            </div>
            <div class="notice-box notice-income">
              <span>${copy.ocrCleanup}</span>
            </div>
          </div>
        </div>
      `;
    }
  }

  /* ---------- 3. Financial Core 5-Tab Playground ---------- */
  function renderCore() {
    const id = isId();
    const stage = document.getElementById('core-stage');
    if (!stage) return;

    document.querySelectorAll('[data-core-tab]').forEach((btn) => {
      btn.setAttribute('aria-selected', String(btn.getAttribute('data-core-tab') === state.coreTab));
    });

    if (state.coreTab === 'transfer') {
      const res = simulateTransfer({
        sourceBalance: 4500000,
        destBalance: 1500000,
        amount: state.transferAmount,
        monthlyIncome: 8500000,
        monthlyExpense: 3420000,
      });

      stage.innerHTML = `
        <h3 style="font-size:1.28rem;">${id ? 'Pindah saldo antar dompet tanpa mengacaukan laporan' : 'Move money between wallets without skewing reports'}</h3>
        <p style="margin-top:8px;color:var(--text-secondary);">
          ${id ? 'Geser nominal transfer dari Bank BCA ke Tunai. Total uang dan hitungan pengeluaran bulanan Anda tetap sama persis.' : 'Slide the transfer amount from Bank BCA to Cash. Your total balance and monthly expense stay untouched.'}
        </p>
        <div class="range-row">
          <div class="range-head">
            <label for="transfer-slider" style="font-weight:600;">${id ? 'Nominal pindah dompet' : 'Transfer amount'}</label>
            <strong class="money text-brand" id="transfer-amount-val">${formatRupiah(state.transferAmount)}</strong>
          </div>
          <input class="range-input" id="transfer-slider" type="range" min="100000" max="4500000" step="50000" value="${state.transferAmount}" />
        </div>
        <div class="kpi-grid">
          <div class="kpi-tile"><span>Bank BCA</span><strong class="money" id="tf-source">${formatRupiah(res.nextSource)}</strong></div>
          <div class="kpi-tile"><span>${id ? 'Tunai' : 'Cash'}</span><strong class="money" id="tf-dest">${formatRupiah(res.nextDest)}</strong></div>
          <div class="kpi-tile"><span>${id ? 'Total Saldo (Tetap)' : 'Total Balance (Unchanged)'}</span><strong class="money text-brand" id="tf-total">${formatRupiah(res.totalAfter)}</strong></div>
          <div class="kpi-tile"><span>${id ? 'Sisa Dana Bulan Ini (Tetap)' : 'Monthly Net Flow (Unchanged)'}</span><strong class="money text-income" id="tf-net">${formatRupiah(res.netAfter)}</strong></div>
        </div>
      `;
    } else if (state.coreTab === 'budget') {
      const limit = state.budgetAllWallets ? 1000000 : 600000;
      const evalRes = evaluateBudget({ limit, spent: state.budgetSpent, remainingDays: 10 });
      const colorVar =
        evalRes.status === 'exceeded'
          ? 'var(--expense)'
          : evalRes.status === 'warning'
            ? 'var(--warning)'
            : 'var(--income)';
      const softVar =
        evalRes.status === 'exceeded'
          ? 'var(--expense-soft)'
          : evalRes.status === 'warning'
            ? 'var(--warning-soft)'
            : 'var(--income-soft)';
      const statusLabel =
        evalRes.status === 'exceeded'
          ? id
            ? 'Melebihi Batas'
            : 'Over Budget'
          : evalRes.status === 'warning'
            ? id
              ? 'Hampir Habis'
              : 'Almost Full'
            : id
              ? 'Masih Aman'
              : 'On Track';

      stage.innerHTML = `
        <div style="display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;">
          <div>
            <h3 style="font-size:1.28rem;">${id ? 'Pantau batas belanja bulanan dan sisa harian' : 'Track monthly spending limits and daily allowance'}</h3>
            <p style="margin-top:6px;color:var(--text-secondary);">
              ${id ? 'Atur anggaran untuk semua dompet atau khusus satu dompet saja. Warna berubah otomatis saat mendekati batas.' : 'Set a budget for all wallets or a single wallet. Indicators change automatically as you approach the limit.'}
            </p>
          </div>
          <button type="button" class="btn btn-sm btn-soft" id="budget-scope-btn">
            ${state.budgetAllWallets ? (id ? 'Cakupan: Semua Dompet (Rp1 jt)' : 'Scope: All Wallets (Rp1M)') : id ? 'Cakupan: Khusus GoPay (Rp600 rb)' : 'Scope: GoPay Only (Rp600k)'}
          </button>
        </div>

        <div class="range-row">
          <div class="range-head">
            <label for="budget-slider" style="font-weight:600;">${id ? 'Simulasi total belanja kategori Makanan' : 'Simulated Food spending'}</label>
            <span class="status-pill" id="budget-status-pill" style="background:${softVar};color:${colorVar};">${statusLabel} · ${Math.round(evalRes.percent)}%</span>
          </div>
          <input class="range-input" id="budget-slider" type="range" min="100000" max="1250000" step="25000" value="${state.budgetSpent}" />
          <div class="progress-track">
            <div class="progress-fill" id="budget-bar" style="width:${evalRes.barWidth}%;background:${colorVar};"></div>
          </div>
        </div>

        <div class="kpi-grid">
          <div class="kpi-tile"><span>${id ? 'Terpakai' : 'Spent'}</span><strong class="money" id="bd-spent">${formatRupiah(evalRes.spent)}</strong></div>
          <div class="kpi-tile"><span>${id ? 'Batas Anggaran' : 'Budget Limit'}</span><strong class="money">${formatRupiah(evalRes.limit)}</strong></div>
          <div class="kpi-tile"><span>${evalRes.remaining >= 0 ? (id ? 'Sisa Anggaran' : 'Remaining') : id ? 'Kelebihan' : 'Overspent'}</span><strong class="money" style="color:${colorVar};" id="bd-rem">${formatRupiah(Math.abs(evalRes.remaining))}</strong></div>
          <div class="kpi-tile"><span>${id ? 'Batas Aman Harian (10 hari)' : 'Safe Daily Limit (10 days)'}</span><strong class="money text-brand" id="bd-daily">${formatRupiah(evalRes.dailyLimit)}</strong></div>
        </div>
      `;
    } else if (state.coreTab === 'calendar') {
      const headers = state.calStartMonday
        ? id
          ? ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min']
          : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        : id
          ? ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab']
          : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

      const events = {
        2: [{ label: id ? 'Belanja Pasar' : 'Market Groceries', val: '-Rp135.000', inc: false }],
        5: [
          { label: id ? 'Gaji Bulanan' : 'Monthly Salary', val: '+Rp8.500.000', inc: true },
          { label: id ? 'Bayar Listrik' : 'Electricity Bill', val: '-Rp290.000', inc: false },
        ],
        10: [{ label: id ? 'Internet Rumah (Rutin)' : 'Home Internet (Recurring)', val: '-Rp350.000', inc: false }],
        14: [{ label: id ? 'Kopi & Camilan' : 'Coffee & Snacks', val: '-Rp48.000', inc: false }],
      };

      const selectedEvents = events[state.calSelectedDay] || [];

      stage.innerHTML = `
        <div style="display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;">
          <div>
            <h3 style="font-size:1.28rem;">${id ? 'Lihat pemasukan & pengeluaran per tanggal' : 'Browse daily cash flow on a clean calendar'}</h3>
            <p style="margin-top:6px;color:var(--text-secondary);">
              ${id ? 'Titik hijau menandakan pemasukan dan merah menandakan pengeluaran. Tagihan rutin bulanan tercatat otomatis.' : 'Green dots mark income and red dots mark expenses. Monthly recurring bills are logged automatically.'}
            </p>
          </div>
          <button type="button" class="btn btn-sm btn-outlined" id="cal-week-btn">
            ${state.calStartMonday ? (id ? 'Awal Pekan: Senin' : 'Week Starts: Monday') : id ? 'Awal Pekan: Minggu' : 'Week Starts: Sunday'}
          </button>
        </div>

        <div class="split-panel" style="margin-top:16px;">
          <div>
            <div class="cal-grid">
              ${headers.map((h) => `<div class="cal-head">${h}</div>`).join('')}
              ${Array.from({ length: 14 }, (_, idx) => {
                const day = idx + 1;
                const dayEv = events[day] || [];
                const hasIn = dayEv.some((e) => e.inc);
                const hasOut = dayEv.some((e) => !e.inc);
                return `
                  <button type="button" class="cal-cell" data-cal-day="${day}" aria-pressed="${day === state.calSelectedDay}">
                    <span>${day}</span>
                    <span class="cal-dots">
                      ${hasIn ? '<span class="dot-in" aria-hidden="true"></span>' : ''}
                      ${hasOut ? '<span class="dot-out" aria-hidden="true"></span>' : ''}
                    </span>
                  </button>`;
              }).join('')}
            </div>
          </div>

          <div>
            <strong style="font-size:0.95rem;">${id ? `Catatan Tanggal ${state.calSelectedDay} Oktober` : `Transactions on Oct ${state.calSelectedDay}`}</strong>
            <div class="phone-tx-list">
              ${
                selectedEvents.length
                  ? selectedEvents
                      .map(
                        (e) => `
                        <div class="phone-tx">
                          <strong>${e.label}</strong>
                          <span class="money ${e.inc ? 'text-income' : 'text-expense'}">${e.val}</span>
                        </div>`,
                      )
                      .join('')
                  : `<div class="phone-tx"><span style="color:var(--text-muted);">${id ? 'Tidak ada pengeluaran pada tanggal ini. Pilih tanggal 2, 5, 10, atau 14.' : 'No activity on this day. Try selecting day 2, 5, 10, or 14.'}</span></div>`
              }
            </div>
          </div>
        </div>
      `;
    } else if (state.coreTab === 'debts') {
      const d = state.debt;
      stage.innerHTML = `
        <div style="display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;">
          <div>
            <h3 style="font-size:1.28rem;">${id ? 'Catat cicilan utang dan piutang dengan jelas' : 'Track debts, installments, and payoffs cleanly'}</h3>
            <p style="margin-top:6px;color:var(--text-secondary);">
              ${id ? 'Anda bisa menambah pokok pinjaman, mencatat cicilan, atau melunasi sekaligus. Setelah lunas, catatan otomatis terkunci rapi.' : 'Add principal, log partial payments, or mark paid off. Once settled, the record locks automatically.'}
            </p>
          </div>
          <span class="status-pill" style="background:${d.isPaidOff ? 'var(--income-soft)' : 'var(--brand-soft)'};color:${d.isPaidOff ? 'var(--income)' : 'var(--brand)'};">
            ${d.isPaidOff ? (id ? 'Sudah Lunas' : 'Paid Off') : id ? 'Sedang Berjalan' : 'Active'}
          </span>
        </div>

        <div class="progress-track" style="margin-top:16px;">
          <div class="progress-fill" style="width:${d.progress}%;background:${d.isPaidOff ? 'var(--income)' : 'var(--brand)'};"></div>
        </div>

        <div class="kpi-grid">
          <div class="kpi-tile"><span>${id ? 'Total Pokok' : 'Total Principal'}</span><strong class="money">${formatRupiah(d.totalPrincipal)}</strong></div>
          <div class="kpi-tile"><span>${id ? 'Sudah Dibayar' : 'Paid So Far'}</span><strong class="money text-income">${formatRupiah(d.totalPaid)}</strong></div>
          <div class="kpi-tile"><span>${id ? 'Sisa Tagihan' : 'Remaining'}</span><strong class="money ${d.remaining > 0 ? 'text-expense' : 'text-income'}">${formatRupiah(d.remaining)}</strong></div>
        </div>

        <div style="display:flex;flex-wrap:wrap;gap:10px;margin-top:16px;">
          <button type="button" class="btn btn-sm btn-outlined" id="debt-add-btn" ${d.isPaidOff ? 'disabled' : ''}>
            ${id ? '+ Tambah Rp200 rb' : '+ Add Rp200k'}
          </button>
          <button type="button" class="btn btn-sm btn-soft" id="debt-pay-btn" ${d.isPaidOff ? 'disabled' : ''}>
            ${id ? 'Bayar Cicilan Rp250 rb' : 'Pay Rp250k'}
          </button>
          <button type="button" class="btn btn-sm btn-primary" id="debt-settle-btn" ${d.isPaidOff ? 'disabled' : ''}>
            ${id ? 'Tandai Lunas' : 'Mark Paid Off'}
          </button>
          <button type="button" class="btn btn-sm btn-outlined" id="debt-wallet-btn">
            ${d.linkedWallet ? (id ? 'Potong Saldo Dompet: Aktif' : 'Update Wallet Balance: On') : id ? 'Catat Saja: Saldo Tetap' : 'Record Only: Wallet Unchanged'}
          </button>
          <button type="button" class="btn btn-sm btn-outlined" id="debt-reset-btn">
            ${id ? 'Ulangi Simulasi' : 'Reset Demo'}
          </button>
        </div>
      `;
    } else {
      const profiles = [
        {
          name: id ? 'Pribadi' : 'Personal',
          balance: 'Rp12.450.000',
          wallets: id ? 'Bank BCA · GoPay · Tunai' : 'Bank BCA · GoPay · Cash',
          note: id ? 'Untuk pengeluaran harian, gaji, dan tabungan pribadi.' : 'For everyday spending, salary, and personal savings.',
        },
        {
          name: id ? 'Usaha Kecil' : 'Small Business',
          balance: 'Rp28.900.000',
          wallets: id ? 'Rekening Bisnis · Kas Toko' : 'Business Bank · Store Cash',
          note: id ? 'Pisahkan modal, omzet, dan biaya stok agar tidak tercampur uang pribadi.' : 'Keep revenue and inventory costs completely separate from personal funds.',
        },
        {
          name: id ? 'Rumah Tangga' : 'Household',
          balance: 'Rp6.800.000',
          wallets: id ? 'Kas Bersama · Belanja Bulanan' : 'Shared Cash · Monthly Groceries',
          note: id ? 'Atur tagihan listrik, air, dan belanja dapur dalam ruang tersendiri.' : 'Manage utilities and groceries in their own dedicated workspace.',
        },
      ];
      const active = profiles[state.profileIdx];
      stage.innerHTML = `
        <h3 style="font-size:1.28rem;">${id ? 'Pisahkan catatan pribadi, bisnis, dan keluarga' : 'Separate personal, business, and household books'}</h3>
        <p style="margin-top:8px;color:var(--text-secondary);">
          ${id ? 'Setiap profil punya dompet, kategori, anggaran, dan laporan masing-masing sehingga saldo tidak pernah tercampur.' : 'Each profile keeps its own wallets, categories, budgets, and reports cleanly isolated.'}
        </p>
        <div style="display:flex;flex-wrap:wrap;gap:10px;margin-top:16px;">
          ${profiles
            .map(
              (p, idx) => `
              <button type="button" class="btn btn-sm ${idx === state.profileIdx ? 'btn-primary' : 'btn-outlined'}" data-profile-idx="${idx}">
                ${p.name}
              </button>`,
            )
            .join('')}
        </div>
        <div class="kpi-grid">
          <div class="kpi-tile"><span>${id ? 'Profil Aktif' : 'Active Profile'}</span><strong>${active.name}</strong></div>
          <div class="kpi-tile"><span>${id ? 'Total Saldo Profil' : 'Profile Balance'}</span><strong class="money text-brand">${active.balance}</strong></div>
          <div class="kpi-tile"><span>${id ? 'Dompet Terpisah' : 'Dedicated Wallets'}</span><strong>${active.wallets}</strong></div>
        </div>
        <p style="margin-top:14px;color:var(--text-secondary);font-size:0.92rem;">${active.note}</p>
      `;
    }
  }

  /* ---------- 4. Reports & Export ---------- */
  function renderReports() {
    const id = isId();
    const chartHeading = document.getElementById('reports-chart-heading');
    const donutLabel = document.getElementById('donut-label');
    const trendTitle = document.getElementById('trend-title');
    const trendDelta = document.getElementById('trend-delta');
    const savingsPill = document.getElementById('savings-rate-pill');
    const legend = document.getElementById('reports-legend');
    const expPdfBtn = document.getElementById('exp-tab-pdf');
    const expCsvBtn = document.getElementById('exp-tab-csv');
    const expStage = document.getElementById('export-preview-stage');

    if (chartHeading) chartHeading.textContent = id ? 'Ringkasan Bulan Ini' : 'This Month Summary';
    if (donutLabel) donutLabel.textContent = id ? 'Keluar' : 'Spent';
    if (trendTitle) trendTitle.textContent = id ? 'Tren Sisa Dana (6 Bulan)' : '6-Month Net Flow Trend';
    if (trendDelta) trendDelta.textContent = id ? 'Stabil positif' : 'Steady surplus';

    const rate = computeSavingsRate(8500000, 3420000);
    if (savingsPill && rate !== null) {
      savingsPill.textContent = id ? `Tersimpan ${Math.round(rate)}%` : `${Math.round(rate)}% Saved`;
    }

    if (legend) {
      const rows = [
        { color: '#60a5fa', name: id ? 'Makanan & Minuman' : 'Food & Drinks', val: 'Rp1.540.000 (45%)' },
        { color: '#34d399', name: id ? 'Tagihan & Rutin' : 'Bills & Utilities', val: 'Rp920.000 (27%)' },
        { color: '#fbbf24', name: id ? 'Transportasi' : 'Transport', val: 'Rp580.000 (17%)' },
        { color: '#fca5a5', name: id ? 'Belanja Lainnya' : 'Other Shopping', val: 'Rp380.000 (11%)' },
      ];
      legend.innerHTML = rows
        .map(
          (r) => `
          <li class="legend-item">
            <span class="legend-left"><span class="legend-dot" style="background:${r.color};"></span>${r.name}</span>
            <strong class="money" style="color:var(--band-text);">${r.val}</strong>
          </li>`,
        )
        .join('');
    }

    if (expPdfBtn) {
      expPdfBtn.textContent = id ? 'Laporan PDF' : 'PDF Report';
      expPdfBtn.setAttribute('aria-selected', String(state.exportTab === 'pdf'));
    }
    if (expCsvBtn) {
      expCsvBtn.textContent = id ? 'Excel / CSV' : 'Excel / CSV';
      expCsvBtn.setAttribute('aria-selected', String(state.exportTab === 'csv'));
    }

    if (!expStage) return;

    if (state.exportTab === 'pdf') {
      const pdfId = state.pdfLang === 'id';
      expStage.innerHTML = `
        <div style="display:flex;align-items:center;justify-content:space-between;gap:10px;margin-top:14px;flex-wrap:wrap;">
          <span style="font-size:0.84rem;color:var(--band-muted);">${id ? 'Pilih bahasa dokumen PDF:' : 'Choose PDF language:'}</span>
          <div style="display:flex;gap:6px;">
            <button type="button" class="band-tab" style="min-height:36px;padding:4px 10px;font-size:0.8rem;" data-pdf-lang="id" aria-pressed="${pdfId}">Indonesia</button>
            <button type="button" class="band-tab" style="min-height:36px;padding:4px 10px;font-size:0.8rem;" data-pdf-lang="en" aria-pressed="${!pdfId}">English</button>
          </div>
        </div>
        <div class="pdf-sheet">
          <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;">
            <strong style="font-size:0.98rem;">${pdfId ? 'Laporan Keuangan Bulanan' : 'Monthly Financial Report'}</strong>
            <span style="font-size:0.78rem;color:#475569;">${pdfId ? 'Oktober 2026' : 'October 2026'}</span>
          </div>
          <div class="pdf-row"><span>${pdfId ? 'Total Pemasukan' : 'Total Income'}</span><strong class="money" style="color:#047857;">Rp8.500.000</strong></div>
          <div class="pdf-row"><span>${pdfId ? 'Total Pengeluaran' : 'Total Expense'}</span><strong class="money" style="color:#b91c1c;">Rp3.420.000</strong></div>
          <div class="pdf-row"><span>${pdfId ? 'Sisa Bersih' : 'Net Savings'}</span><strong class="money" style="color:#1e5cd9;">Rp5.080.000</strong></div>
          <div class="pdf-row"><span>${pdfId ? 'Kategori Terbesar' : 'Top Category'}</span><strong>${pdfId ? 'Makanan (45%)' : 'Food (45%)'}</strong></div>
        </div>
      `;
    } else {
      expStage.innerHTML = `
        <div class="pdf-sheet" style="font-family:var(--font-body);font-size:0.83rem;overflow-x:auto;">
          <div style="font-weight:700;margin-bottom:8px;">${id ? 'Pratinjau Tabel Excel / CSV' : 'Excel / CSV Spreadsheet Preview'}</div>
          <div class="pdf-row"><strong>${id ? 'Tanggal' : 'Date'}</strong><strong>${id ? 'Kategori' : 'Category'}</strong><strong>${id ? 'Nominal' : 'Amount'}</strong></div>
          <div class="pdf-row"><span>2026-10-05</span><span>${id ? 'Gaji' : 'Salary'}</span><span class="money">+8.500.000</span></div>
          <div class="pdf-row"><span>2026-10-05</span><span>${id ? 'Listrik' : 'Electricity'}</span><span class="money">-290.000</span></div>
          <div class="pdf-row"><span>2026-10-14</span><span>${id ? 'Makanan' : 'Food'}</span><span class="money">-48.000</span></div>
        </div>
        <p style="margin-top:10px;font-size:0.84rem;color:var(--band-muted);">
          ${id ? 'Langsung rapi dibuka di Microsoft Excel maupun Google Sheets untuk olah data lanjutan.' : 'Opens cleanly in Microsoft Excel and Google Sheets for further analysis.'}
        </p>
      `;
    }
  }

  /* ---------- 5. Privacy Cloud Backup Flow ---------- */
  function renderPrivacy() {
    const id = isId();
    const copy = i18n.getCopy();
    const descEl = document.getElementById('privacy-mode-desc');
    const flowEl = document.getElementById('privacy-flow-steps');

    document.querySelectorAll('[data-privacy-mode]').forEach((btn) => {
      btn.setAttribute('aria-pressed', String(btn.getAttribute('data-privacy-mode') === state.privacyMode));
    });

    if (descEl) {
      descEl.textContent = state.privacyMode === 'passphrase' ? copy.modePassDesc : copy.modeGoogleDesc;
    }

    if (!flowEl) return;

    const steps =
      state.privacyMode === 'passphrase'
        ? [
            {
              tag: id ? 'Langkah 1' : 'Step 1',
              title: id ? 'Data di HP Anda' : 'Records on Phone',
              desc: id ? 'Catatan lokal disiapkan sebelum dikirim.' : 'Local records are packaged on your device.',
            },
            {
              tag: id ? 'Langkah 2' : 'Step 2',
              title: id ? 'Dikunci Sandi Pribadi' : 'Locked by Your Password',
              desc: id ? 'Diacak di perangkat memakai sandi yang hanya Anda tahu.' : 'Scrambled on-device using your private password.',
            },
            {
              tag: id ? 'Langkah 3' : 'Step 3',
              title: id ? 'Disimpan Terkunci' : 'Stored Locked',
              desc: id ? 'Cadangan aman tersimpan tanpa bisa dibaca pihak lain.' : 'Stored safely so nobody else can read it.',
            },
            {
              tag: id ? 'Langkah 4' : 'Step 4',
              title: id ? 'Pulihkan di HP Baru' : 'Restore on New Phone',
              desc: id ? 'Masukkan sandi Anda untuk membuka kembali seluruh data.' : 'Enter your password to restore everything cleanly.',
            },
          ]
        : [
            {
              tag: id ? 'Langkah 1' : 'Step 1',
              title: id ? 'Data di HP Anda' : 'Records on Phone',
              desc: id ? 'Catatan lokal disiapkan otomatis.' : 'Local records are prepared automatically.',
            },
            {
              tag: id ? 'Langkah 2' : 'Step 2',
              title: id ? 'Kunci Otomatis' : 'Automatic Protection',
              desc: id ? 'Dilindungi tanpa perlu mengingat sandi tambahan.' : 'Protected without remembering an extra password.',
            },
            {
              tag: id ? 'Langkah 3' : 'Step 3',
              title: id ? 'Terhubung Akun Google' : 'Linked to Google',
              desc: id ? 'Tersimpan terpisah di akun Google milik Anda sendiri.' : 'Saved under your own Google account.',
            },
            {
              tag: id ? 'Langkah 4' : 'Step 4',
              title: id ? 'Login & Pulihkan' : 'Sign In & Restore',
              desc: id ? 'Masuk di HP baru dan semua catatan kembali utuh.' : 'Sign in on a new phone and restore safely.',
            },
          ];

    flowEl.innerHTML = steps
      .map(
        (s, idx) => `
        <div class="flow-step ${idx === 0 ? 'is-active' : ''}">
          <small>${s.tag}</small>
          <strong>${s.title}</strong>
          <p>${s.desc}</p>
        </div>`,
      )
      .join('');
  }

  /* ---------- 6. FAQ, Download Variants & Install Guide ---------- */
  function renderFaqAndDownload() {
    const id = isId();
    const copy = i18n.getCopy();

    const faqList = document.getElementById('faq-list');
    if (faqList) {
      faqList.innerHTML = copy.faqs
        .map(
          (item, idx) => `
          <div class="faq-item">
            <button
              type="button"
              class="faq-trigger"
              data-faq-idx="${idx}"
              aria-expanded="${idx === state.openFaq}"
              aria-controls="faq-panel-${idx}"
            >
              <span>${item.q}</span>
              ${CHEVRON_SVG}
            </button>
            <div class="faq-body" id="faq-panel-${idx}" ${idx === state.openFaq ? '' : 'hidden'}>
              <p>${item.a}</p>
            </div>
          </div>`,
        )
        .join('');
    }

    const lang = i18n.getLang();
    const downloadMeta = document.getElementById('download-meta');
    if (downloadMeta) {
      const primaryVariant = RELEASE_CONFIG.variants.find((v) => v.recommended) || RELEASE_CONFIG.variants[0];
      const liveMainSize = primaryVariant
        ? formatAssetSize(state.releaseSizes[primaryVariant.fileName], lang)
        : null;
      downloadMeta.textContent = liveMainSize ? `${copy.dlMeta} · ${liveMainSize}` : copy.dlMeta;
    }

    const altList = document.getElementById('alt-abi-list');
    if (altList) {
      altList.innerHTML = RELEASE_CONFIG.variants
        .map((v) => {
          const liveSize = formatAssetSize(state.releaseSizes[v.fileName], lang);
          const fallbackSize =
            v.size == null ? null : typeof v.size === 'string' ? v.size : id ? v.size.id : v.size.en;
          const sizeLabel = liveSize || fallbackSize;
          const hintText = `${id ? v.hint.id : v.hint.en}${sizeLabel ? ` · ${sizeLabel}` : ''}`;
          return `
          <div class="alt-abi-row">
            <div>
              <strong>${id ? v.title.id : v.title.en}</strong>
              <small>${hintText}</small>
            </div>
            <a class="btn btn-sm ${v.recommended ? 'btn-primary' : 'btn-outlined'}" href="${v.url}" rel="noopener noreferrer">
              ${id ? 'Unduh' : 'Download'}
            </a>
          </div>`;
        })
        .join('');
    }

    const closeVersionsBtn = document.querySelector('[data-close-dialog="versions-dialog"]');
    if (closeVersionsBtn) {
      closeVersionsBtn.setAttribute('aria-label', id ? 'Tutup pilihan versi' : 'Close version picker');
    }

    const guideSteps = document.getElementById('guide-steps-list');
    if (guideSteps) {
      guideSteps.innerHTML = copy.guideSteps.map((step) => `<li>${step}</li>`).join('');
    }

    const subjectInput = document.getElementById('contact-subject');
    if (subjectInput) {
      subjectInput.setAttribute('placeholder', copy.contactSubjectPlaceholder);
    }
    const messageInput = document.getElementById('contact-message');
    if (messageInput) {
      messageInput.setAttribute('placeholder', copy.contactMessagePlaceholder);
    }
    const copyEmailBtn = document.getElementById('copy-email-btn');
    if (copyEmailBtn) {
      copyEmailBtn.textContent = state.emailCopied ? copy.contactCopiedBtn : copy.contactCopyBtn;
    }
    const contactError = document.getElementById('contact-error');
    if (contactError && !contactError.hidden) {
      contactError.textContent = copy.contactErrorEmpty;
    }
  }

  /* ---------- Event Delegation ---------- */
  document.addEventListener('click', (e) => {
    const phoneBtn = e.target.closest('[data-phone-tab]');
    if (phoneBtn) {
      state.phoneTab = phoneBtn.getAttribute('data-phone-tab');
      renderPhone();
      return;
    }

    const captureBtn = e.target.closest('[data-capture-tab]');
    if (captureBtn) {
      state.captureTab = captureBtn.getAttribute('data-capture-tab');
      renderCapture();
      return;
    }

    const filterBtn = e.target.closest('[data-manual-filter]');
    if (filterBtn) {
      state.manualFilter = filterBtn.getAttribute('data-manual-filter');
      renderCapture();
      return;
    }

    const voiceBtn = e.target.closest('[data-voice-preset]');
    if (voiceBtn) {
      state.voicePresetIdx = Number(voiceBtn.getAttribute('data-voice-preset'));
      state.voiceSpeaking = true;
      renderCapture();
      clearTimeout(voiceTimer);
      voiceTimer = setTimeout(() => {
        state.voiceSpeaking = false;
        const wave = document.querySelector('.voice-wave');
        wave?.classList.remove('is-speaking');
      }, 1500);
      return;
    }

    const ocrPreset = e.target.closest('[data-ocr-preset]');
    if (ocrPreset) {
      state.ocrPresetIdx = Number(ocrPreset.getAttribute('data-ocr-preset'));
      state.ocrScanned = true;
      renderCapture();
      return;
    }

    if (e.target.closest('#ocr-crop-btn')) {
      state.ocrCrop = !state.ocrCrop;
      renderCapture();
      return;
    }

    if (e.target.closest('#ocr-scan-btn')) {
      state.ocrScanned = false;
      renderCapture();
      const box = document.getElementById('ocr-receipt-box');
      if (box) {
        box.classList.remove('is-scanning');
        void box.offsetWidth;
        box.classList.add('is-scanning');
      }
      clearTimeout(ocrTimer);
      ocrTimer = setTimeout(() => {
        state.ocrScanned = true;
        renderCapture();
      }, 950);
      return;
    }

    const coreBtn = e.target.closest('[data-core-tab]');
    if (coreBtn) {
      state.coreTab = coreBtn.getAttribute('data-core-tab');
      renderCore();
      return;
    }

    if (e.target.closest('#budget-scope-btn')) {
      state.budgetAllWallets = !state.budgetAllWallets;
      renderCore();
      return;
    }

    if (e.target.closest('#cal-week-btn')) {
      state.calStartMonday = !state.calStartMonday;
      renderCore();
      return;
    }

    const calDayBtn = e.target.closest('[data-cal-day]');
    if (calDayBtn) {
      state.calSelectedDay = Number(calDayBtn.getAttribute('data-cal-day'));
      renderCore();
      return;
    }

    if (e.target.closest('#debt-add-btn')) {
      state.debt = addDebtPrincipal(state.debt, 200000);
      renderCore();
      return;
    }

    if (e.target.closest('#debt-pay-btn')) {
      state.debt = payDebtInstallment(state.debt, 250000);
      renderCore();
      return;
    }

    if (e.target.closest('#debt-settle-btn')) {
      state.debt = payOffDebt(state.debt);
      renderCore();
      return;
    }

    if (e.target.closest('#debt-wallet-btn')) {
      state.debt = toggleDebtWallet(state.debt);
      renderCore();
      return;
    }

    if (e.target.closest('#debt-reset-btn')) {
      state.debt = createSampleDebt();
      renderCore();
      return;
    }

    const profileBtn = e.target.closest('[data-profile-idx]');
    if (profileBtn) {
      state.profileIdx = Number(profileBtn.getAttribute('data-profile-idx'));
      renderCore();
      return;
    }

    const expBtn = e.target.closest('[data-export-tab]');
    if (expBtn) {
      state.exportTab = expBtn.getAttribute('data-export-tab');
      renderReports();
      return;
    }

    const pdfLangBtn = e.target.closest('[data-pdf-lang]');
    if (pdfLangBtn) {
      state.pdfLang = pdfLangBtn.getAttribute('data-pdf-lang');
      renderReports();
      return;
    }

    const privBtn = e.target.closest('[data-privacy-mode]');
    if (privBtn) {
      state.privacyMode = privBtn.getAttribute('data-privacy-mode');
      renderPrivacy();
      return;
    }

    const faqBtn = e.target.closest('[data-faq-idx]');
    if (faqBtn) {
      const idx = Number(faqBtn.getAttribute('data-faq-idx'));
      state.openFaq = state.openFaq === idx ? -1 : idx;
      renderFaqAndDownload();
      return;
    }

    // Native <dialog> open / close controls
    if (e.target.closest('#open-guide-btn')) {
      document.getElementById('install-guide-dialog')?.showModal();
      return;
    }

    if (e.target.closest('#open-versions-btn')) {
      document.getElementById('versions-dialog')?.showModal();
      return;
    }

    if (e.target.closest('#mobile-menu-open')) {
      document.getElementById('mobile-menu-dialog')?.showModal();
      return;
    }

    const closeBtn = e.target.closest('[data-close-dialog]');
    if (closeBtn) {
      const dialogId = closeBtn.getAttribute('data-close-dialog');
      document.getElementById(dialogId)?.close();
      return;
    }

    // Close mobile menu automatically when clicking any nav link inside it
    if (e.target.closest('#mobile-menu-dialog a')) {
      document.getElementById('mobile-menu-dialog')?.close();
    }
  });

  // Live range slider updates without rebuilding the slider DOM
  document.addEventListener('input', (e) => {
    if (e.target.id === 'transfer-slider') {
      state.transferAmount = Number(e.target.value);
      const res = simulateTransfer({
        sourceBalance: 4500000,
        destBalance: 1500000,
        amount: state.transferAmount,
        monthlyIncome: 8500000,
        monthlyExpense: 3420000,
      });
      const valEl = document.getElementById('transfer-amount-val');
      const srcEl = document.getElementById('tf-source');
      const dstEl = document.getElementById('tf-dest');
      if (valEl) valEl.textContent = formatRupiah(state.transferAmount);
      if (srcEl) srcEl.textContent = formatRupiah(res.nextSource);
      if (dstEl) dstEl.textContent = formatRupiah(res.nextDest);
    }

    if (e.target.id === 'budget-slider') {
      state.budgetSpent = Number(e.target.value);
      const limit = state.budgetAllWallets ? 1000000 : 600000;
      const evalRes = evaluateBudget({ limit, spent: state.budgetSpent, remainingDays: 10 });
      const id = isId();
      const colorVar =
        evalRes.status === 'exceeded'
          ? 'var(--expense)'
          : evalRes.status === 'warning'
            ? 'var(--warning)'
            : 'var(--income)';
      const softVar =
        evalRes.status === 'exceeded'
          ? 'var(--expense-soft)'
          : evalRes.status === 'warning'
            ? 'var(--warning-soft)'
            : 'var(--income-soft)';
      const statusLabel =
        evalRes.status === 'exceeded'
          ? id
            ? 'Melebihi Batas'
            : 'Over Budget'
          : evalRes.status === 'warning'
            ? id
              ? 'Hampir Habis'
              : 'Almost Full'
            : id
              ? 'Masih Aman'
              : 'On Track';

      const pill = document.getElementById('budget-status-pill');
      const bar = document.getElementById('budget-bar');
      const spentEl = document.getElementById('bd-spent');
      const remEl = document.getElementById('bd-rem');
      const dailyEl = document.getElementById('bd-daily');
      if (pill) {
        pill.textContent = `${statusLabel} · ${Math.round(evalRes.percent)}%`;
        pill.style.background = softVar;
        pill.style.color = colorVar;
      }
      if (bar) {
        bar.style.width = `${evalRes.barWidth}%`;
        bar.style.background = colorVar;
      }
      if (spentEl) spentEl.textContent = formatRupiah(evalRes.spent);
      if (remEl) {
        remEl.textContent = formatRupiah(Math.abs(evalRes.remaining));
        remEl.style.color = colorVar;
      }
      if (dailyEl) dailyEl.textContent = formatRupiah(evalRes.dailyLimit);
    }
  });

  // Contact form direct mailto composer & 1-tap copy email
  const contactForm = document.getElementById('contact-form');
  const contactSubject = document.getElementById('contact-subject');
  const contactMessage = document.getElementById('contact-message');
  const contactError = document.getElementById('contact-error');

  function clearContactError() {
    if (contactError && !contactError.hidden) {
      contactError.hidden = true;
      contactError.textContent = '';
    }
  }

  contactSubject?.addEventListener('input', clearContactError);
  contactMessage?.addEventListener('input', clearContactError);

  contactForm?.addEventListener('submit', (e) => {
    e.preventDefault();
    const subjectVal = contactSubject?.value ?? '';
    const messageVal = contactMessage?.value ?? '';
    const mailtoUrl = buildContactMailtoUrl(CONTACT_EMAIL, subjectVal, messageVal);
    if (!mailtoUrl) {
      if (contactError) {
        contactError.textContent = i18n.getCopy().contactErrorEmpty;
        contactError.hidden = false;
      }
      if (!subjectVal.trim()) {
        contactSubject?.focus();
      } else {
        contactMessage?.focus();
      }
      return;
    }
    clearContactError();
    window.location.href = mailtoUrl;
  });

  document.getElementById('copy-email-btn')?.addEventListener('click', async () => {
    let copied = false;
    try {
      if (navigator.clipboard?.writeText) {
        await navigator.clipboard.writeText(CONTACT_EMAIL);
        copied = true;
      }
    } catch {
      copied = false;
    }
    if (!copied) {
      try {
        const tmp = document.createElement('textarea');
        tmp.value = CONTACT_EMAIL;
        tmp.setAttribute('readonly', '');
        tmp.style.position = 'fixed';
        tmp.style.opacity = '0';
        document.body.appendChild(tmp);
        tmp.select();
        copied = document.execCommand('copy');
        document.body.removeChild(tmp);
      } catch {
        copied = false;
      }
    }
    if (!copied) return;
    state.emailCopied = true;
    renderFaqAndDownload();
    clearTimeout(copyEmailTimer);
    copyEmailTimer = setTimeout(() => {
      state.emailCopied = false;
      renderFaqAndDownload();
    }, 2500);
  });

  // Backdrop click light-dismiss for native <dialog>
  document.querySelectorAll('dialog.wise-dialog').forEach((dlg) => {
    dlg.addEventListener('click', (e) => {
      if (e.target === dlg) dlg.close();
    });
  });

  function renderAll() {
    renderPhone();
    renderCapture();
    renderCore();
    renderReports();
    renderPrivacy();
    renderFaqAndDownload();
  }

  renderAll();
  i18n.subscribe(renderAll);

  fetchLatestReleaseSizes(RELEASE_CONFIG.apiLatestUrl).then((sizes) => {
    if (sizes && Object.keys(sizes).length > 0) {
      state.releaseSizes = sizes;
      renderFaqAndDownload();
    }
  });
}
