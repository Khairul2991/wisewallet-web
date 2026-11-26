import { COPY } from '../data/content.js';

const LANG_KEY = 'ww-lang';

export function createI18n() {
  let lang = 'id';
  try {
    const saved = localStorage.getItem(LANG_KEY);
    if (saved === 'id' || saved === 'en') lang = saved;
  } catch {
    // Default to Indonesian
  }

  const listeners = new Set();

  function applyStaticCopy() {
    const dict = COPY[lang];
    document.documentElement.lang = lang;
    document.title = dict.pageTitle;

    document.querySelectorAll('[data-i18n]').forEach((el) => {
      const key = el.getAttribute('data-i18n');
      if (key && typeof dict[key] === 'string') {
        el.textContent = dict[key];
      }
    });

    const skipLink = document.querySelector('.skip-link');
    if (skipLink) {
      skipLink.textContent = lang === 'id' ? 'Lewati ke konten utama' : 'Skip to main content';
    }

    const mobileReports = document.getElementById('mobile-nav-reports');
    if (mobileReports) {
      mobileReports.textContent = lang === 'id' ? 'Laporan' : 'Reports';
    }

    const langBtn = document.getElementById('lang-toggle');
    if (langBtn) {
      langBtn.textContent = lang.toUpperCase();
      langBtn.setAttribute(
        'aria-label',
        lang === 'id' ? 'Switch language to English' : 'Ganti bahasa ke Bahasa Indonesia',
      );
    }
  }

  function setLang(next) {
    if (next !== 'id' && next !== 'en') return;
    lang = next;
    try {
      localStorage.setItem(LANG_KEY, lang);
    } catch {
      // Ignore storage errors
    }
    applyStaticCopy();
    listeners.forEach((fn) => fn(lang));
  }

  const langBtn = document.getElementById('lang-toggle');
  langBtn?.addEventListener('click', () => {
    setLang(lang === 'id' ? 'en' : 'id');
  });

  applyStaticCopy();

  return {
    getLang: () => lang,
    getCopy: () => COPY[lang],
    subscribe(fn) {
      listeners.add(fn);
    },
  };
}
