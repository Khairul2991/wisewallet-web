const STORAGE_KEY = 'ww-color-scheme';

const SUN_ICON = `<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="4"></circle><path d="M12 2v2"></path><path d="M12 20v2"></path><path d="m4.93 4.93 1.41 1.41"></path><path d="m17.66 17.66 1.41 1.41"></path><path d="M2 12h2"></path><path d="M20 12h2"></path><path d="m6.34 17.66-1.41 1.41"></path><path d="m19.07 4.93-1.41 1.41"></path></svg>`;
const MOON_ICON = `<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z"></path></svg>`;

function getSystemScheme() {
  return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
}

function getEffectiveScheme() {
  const meta = document.querySelector('meta[name="color-scheme"]');
  const content = meta?.getAttribute('content');
  if (content === 'light' || content === 'dark') return content;
  return getSystemScheme();
}

export function initTheme(getLang) {
  const toggleBtn = document.getElementById('theme-toggle');
  const meta = document.querySelector('meta[name="color-scheme"]');
  if (!toggleBtn || !meta) return { refreshLabel() {} };

  function syncButton() {
    const current = getEffectiveScheme();
    const isDark = current === 'dark';
    const lang = getLang();
    toggleBtn.innerHTML = isDark ? SUN_ICON : MOON_ICON;
    toggleBtn.setAttribute('aria-pressed', String(isDark));
    toggleBtn.setAttribute(
      'aria-label',
      lang === 'id'
        ? isDark
          ? 'Ganti ke mode terang'
          : 'Ganti ke mode gelap'
        : isDark
          ? 'Switch to light theme'
          : 'Switch to dark theme',
    );
  }

  function applyScheme(next) {
    meta.setAttribute('content', next);
    try {
      localStorage.setItem(STORAGE_KEY, next);
    } catch {
      // Ignore storage quota / privacy mode errors
    }
    syncButton();
  }

  toggleBtn.addEventListener('click', () => {
    const next = getEffectiveScheme() === 'dark' ? 'light' : 'dark';
    applyScheme(next);
  });

  window.addEventListener('storage', (e) => {
    if (e.key === STORAGE_KEY && (e.newValue === 'light' || e.newValue === 'dark')) {
      meta.setAttribute('content', e.newValue);
      syncButton();
    }
  });

  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', syncButton);
  syncButton();

  return { refreshLabel: syncButton };
}
