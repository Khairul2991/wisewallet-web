import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, '..');

const failures = [];
function check(name, fn) {
  try {
    fn();
    console.log(`PASS  ${name}`);
  } catch (err) {
    failures.push(`${name}: ${err.message}`);
    console.error(`FAIL  ${name}\n      ${err.message}`);
  }
}

// 1. Domain math invariants
const mathMod = await import('../src/scripts/finance-math.js');
check('formatRupiah formats positive, zero, and negative amounts', () => {
  assert.equal(mathMod.formatRupiah(0), 'Rp0');
  assert.equal(mathMod.formatRupiah(2009000), 'Rp2.009.000');
  assert.equal(mathMod.formatRupiah(-50000), '-Rp50.000');
});

check('simulateTransfer preserves total balance and net cash flow', () => {
  const res = mathMod.simulateTransfer({
    sourceBalance: 4500000,
    destBalance: 1500000,
    amount: 750000,
    monthlyIncome: 8500000,
    monthlyExpense: 3420000,
  });
  assert.equal(res.nextSource, 3750000);
  assert.equal(res.nextDest, 2250000);
  assert.equal(res.totalBefore, res.totalAfter);
  assert.equal(res.netBefore, res.netAfter);
});

check('evaluateBudget respects <80% safe, 80-<100% warning, >=100% exceeded', () => {
  assert.equal(mathMod.evaluateBudget({ limit: 1000000, spent: 790000, remainingDays: 10 }).status, 'safe');
  assert.equal(mathMod.evaluateBudget({ limit: 1000000, spent: 800000, remainingDays: 10 }).status, 'warning');
  assert.equal(mathMod.evaluateBudget({ limit: 1000000, spent: 1000000, remainingDays: 5 }).status, 'exceeded');
  assert.equal(mathMod.evaluateBudget({ limit: 1000000, spent: 500000, remainingDays: 0 }).dailyLimit, 500000);
});

check('computeSavingsRate handles zero income safely', () => {
  assert.equal(mathMod.computeSavingsRate(0, 50000), null);
  assert.ok(Math.abs(mathMod.computeSavingsRate(10000000, 6500000) - 35) < 0.01);
});

check('debt helpers lock once paid off', () => {
  let d = mathMod.createSampleDebt();
  d = mathMod.addDebtPrincipal(d, 200000);
  assert.equal(d.totalPrincipal, 1400000);
  d = mathMod.payOffDebt(d);
  assert.equal(d.remaining, 0);
  assert.equal(d.isPaidOff, true);
  const locked = mathMod.addDebtPrincipal(d, 100000);
  assert.equal(locked.totalPrincipal, 1400000);
});

// 2. Content & release contract
const contentMod = await import('../src/data/content.js');
const releaseSizesMod = await import('../src/scripts/release-sizes.js');
check('Release config points all 4 APK variants to public wisewallet releases', () => {
  assert.equal(contentMod.RELEASE_CONFIG.releasesUrl, 'https://github.com/Khairul2991/wisewallet/releases');
  assert.equal(
    contentMod.RELEASE_CONFIG.apiLatestUrl,
    'https://api.github.com/repos/Khairul2991/wisewallet/releases/latest',
  );
  assert.equal(contentMod.RELEASE_CONFIG.variants.length, 4);
  const ids = contentMod.RELEASE_CONFIG.variants.map((v) => v.id);
  assert.deepEqual(ids, ['arm64-v8a', 'armeabi-v7a', 'x86_64', 'universal']);
  for (const v of contentMod.RELEASE_CONFIG.variants) {
    assert.ok(v.url.startsWith('https://github.com/Khairul2991/wisewallet/releases/latest/download/'));
    assert.ok(v.url.endsWith('.apk'));
  }
});

check('Release size helpers format real APK byte counts for ID and EN and ignore non-APK assets', () => {
  assert.equal(releaseSizesMod.formatAssetSize(63227462, 'id'), '60,3 MB');
  assert.equal(releaseSizesMod.formatAssetSize(63227462, 'en'), '60.3 MB');
  assert.equal(releaseSizesMod.formatAssetSize(108583015, 'id'), '103,6 MB');
  assert.equal(releaseSizesMod.formatAssetSize(0, 'id'), null);
  assert.equal(releaseSizesMod.formatAssetSize(-5, 'en'), null);

  const map = releaseSizesMod.extractReleaseAssetSizes({
    assets: [
      { name: 'app-arm64-v8a-release.apk', size: 63227462 },
      { name: 'checksums.txt', size: 512 },
      { name: 'broken.apk', size: 0 },
    ],
  });
  assert.deepEqual(map, { 'app-arm64-v8a-release.apk': 63227462 });
});

// 3. Copy hygiene: zero em dashes, zero buzzwords, zero developer jargon
const indexHtml = fs.readFileSync(path.join(root, 'index.html'), 'utf8');
const contentSource = fs.readFileSync(path.join(root, 'src/data/content.js'), 'utf8');
const combinedCopy = `${indexHtml}\n${contentSource}`;

check('Zero em dashes (R-02) across index.html and content.js', () => {
  assert.equal(combinedCopy.includes('—'), false, 'Found forbidden em dash character');
});

check('Zero AI buzzwords (R-16) and zero developer jargon in user-facing copy', () => {
  const lower = combinedCopy.toLowerCase();
  const forbidden = [
    'ai powered',
    'ai-powered',
    'revolutionary',
    'next generation',
    'cutting edge',
    'seamless',
    'effortless',
    'game-changer',
    'fr-003',
    'order by date',
    'prd 2.0',
    'pragma',
    'targetsdk',
    'pbkdf2',
    'hmac-sha256',
    'flag_secure',
    'rfc 4180',
    'whisper.cpp',
    'paddleocr',
    'phase 19',
    'wisehighlightedtext',
    'database v11',
    'darwin notifications',
    'split-per-abi',
    'utc iso-8601',
    'bek 256',
  ];
  for (const word of forbidden) {
    assert.equal(lower.includes(word), false, `Found forbidden term "${word}"`);
  }
});

// 4. HTML semantics, anchors, and asset weight
check('HTML semantics, landmarks, single H1, and non-blocking head (R-39, R-40)', () => {
  assert.ok(indexHtml.includes('<html lang="id">'), 'Missing <html lang="id">');
  assert.ok(indexHtml.includes('<meta name="color-scheme" content="light dark">'), 'Missing color-scheme meta');
  assert.equal(/user-scalable\s*=\s*no|maximum-scale\s*=\s*1(\.0)?/i.test(indexHtml), false, 'Viewport blocks zoom');
  assert.ok(indexHtml.includes('<header'), 'Missing <header>');
  assert.ok(indexHtml.includes('<nav'), 'Missing <nav>');
  assert.ok(indexHtml.includes('<main'), 'Missing <main>');
  assert.ok(indexHtml.includes('<footer'), 'Missing <footer>');
  const h1Count = (indexHtml.match(/<h1\b/g) || []).length;
  assert.equal(h1Count, 1, `Expected 1 <h1>, found ${h1Count}`);
  assert.ok(indexHtml.includes('fetchpriority="high"'), 'Hero image missing fetchpriority="high"');
  assert.ok(indexHtml.includes('href="./assets/favicon.svg"'), 'Missing rounded SVG favicon link');
  assert.ok(indexHtml.includes('id="versions-dialog"'), 'Missing versions picker dialog');
  assert.ok(fs.existsSync(path.join(root, 'public/assets/favicon.svg')), 'Missing public/assets/favicon.svg');
});

check('Every internal anchor href="#..." maps to a real id in index.html (R-24)', () => {
  const ids = new Set([...indexHtml.matchAll(/\bid="([^"]+)"/g)].map((m) => m[1]));
  const hrefs = [...indexHtml.matchAll(/href="#([^"]+)"/g)].map((m) => m[1]);
  assert.ok(hrefs.length > 0, 'No internal anchor links found');
  for (const target of hrefs) {
    assert.ok(ids.has(target), `Broken anchor link href="#${target}"`);
  }
});

check('Every <img> has alt, width, and height, and PNG assets stay lightweight (<40KB)', () => {
  const imgs = [...indexHtml.matchAll(/<img\b[^>]*>/g)].map((m) => m[0]);
  assert.ok(imgs.length > 0, 'Expected at least one <img>');
  for (const tag of imgs) {
    assert.ok(/\balt="/.test(tag), `Missing alt on ${tag}`);
    assert.ok(/\bwidth="/.test(tag), `Missing width on ${tag}`);
    assert.ok(/\bheight="/.test(tag), `Missing height on ${tag}`);
  }
  const assetsDir = path.join(root, 'public/assets');
  for (const file of fs.readdirSync(assetsDir)) {
    if (file.endsWith('.png')) {
      const size = fs.statSync(path.join(assetsDir, file)).size;
      assert.ok(size < 40 * 1024, `${file} is ${size} bytes (must be < 40KB)`);
    }
  }
});

// 5. WCAG AA Contrast verification (R-25)
function lum(hex) {
  const rgb = hex.slice(1).match(/.{2}/g).map((h) => parseInt(h, 16) / 255);
  const lin = rgb.map((c) => (c <= 0.03928 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4));
  return 0.2126 * lin[0] + 0.7152 * lin[1] + 0.0722 * lin[2];
}
function contrast(a, b) {
  const l1 = lum(a);
  const l2 = lum(b);
  return (Math.max(l1, l2) + 0.05) / (Math.min(l1, l2) + 0.05);
}

check('All Light and Dark theme color tokens pass WCAG AA >= 4.5:1 (R-25)', () => {
  const pairs = [
    ['#0F172A', '#F8FAFC'],
    ['#475569', '#FFFFFF'],
    ['#475569', '#F8FAFC'],
    ['#5B6B82', '#FFFFFF'],
    ['#FFFFFF', '#1E5CD9'],
    ['#1E5CD9', '#EEF4FF'],
    ['#047857', '#ECFDF5'],
    ['#B91C1C', '#FEF2F2'],
    ['#B45309', '#FFFBEB'],
    ['#F8FAFC', '#0F172A'],
    ['#CBD5E1', '#1E293B'],
    ['#94A3B8', '#0F172A'],
    ['#0F172A', '#60A5FA'],
    ['#34D399', '#1E293B'],
    ['#FCA5A5', '#1E293B'],
    ['#FBBF24', '#1E293B'],
  ];
  for (const [fg, bg] of pairs) {
    const r = contrast(fg, bg);
    assert.ok(r >= 4.5, `Contrast ${fg} on ${bg} is ${r.toFixed(2)}:1 (< 4.5)`);
  }
});

if (failures.length > 0) {
  console.error(`\n${failures.length} check(s) failed.`);
  process.exit(1);
}
console.log('\nAll automated site checks passed!');
