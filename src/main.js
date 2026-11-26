import './styles/tokens.css';
import './styles/base.css';
import './styles/sections.css';
import './styles/motion.css';

import { createI18n } from './scripts/i18n.js';
import { initTheme } from './scripts/theme.js';
import { initDemos } from './scripts/demos.js';
import { initMotion } from './scripts/motion.js';

const i18n = createI18n();
const theme = initTheme(i18n.getLang);
i18n.subscribe(() => theme.refreshLabel());

initDemos(i18n);
initMotion();
