const CACHE_KEY = 'ww-release-sizes-v1';
const CACHE_TTL_MS = 10 * 60 * 1000;
const FETCH_TIMEOUT_MS = 5000;

export function formatAssetSize(bytes, lang = 'id') {
  if (typeof bytes !== 'number' || !Number.isFinite(bytes) || bytes <= 0) {
    return null;
  }
  const mb = (bytes / (1024 * 1024)).toFixed(1);
  return `${lang === 'id' ? mb.replace('.', ',') : mb} MB`;
}

export function extractReleaseAssetSizes(payload) {
  if (!payload || !Array.isArray(payload.assets)) {
    return {};
  }
  const sizes = {};
  for (const asset of payload.assets) {
    if (
      asset &&
      typeof asset.name === 'string' &&
      asset.name.endsWith('.apk') &&
      typeof asset.size === 'number' &&
      Number.isFinite(asset.size) &&
      asset.size > 0
    ) {
      sizes[asset.name] = asset.size;
    }
  }
  return sizes;
}

export async function fetchLatestReleaseSizes(apiUrl) {
  try {
    const cached = sessionStorage.getItem(CACHE_KEY);
    if (cached) {
      const parsed = JSON.parse(cached);
      if (
        parsed &&
        typeof parsed.ts === 'number' &&
        Date.now() - parsed.ts < CACHE_TTL_MS &&
        parsed.sizes &&
        Object.keys(parsed.sizes).length > 0
      ) {
        return parsed.sizes;
      }
    }
  } catch {
    // Ignore storage read errors
  }

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), FETCH_TIMEOUT_MS);
  try {
    const res = await fetch(apiUrl, {
      headers: { Accept: 'application/vnd.github+json' },
      signal: controller.signal,
    });
    if (!res.ok) return null;
    const data = await res.json();
    const sizes = extractReleaseAssetSizes(data);
    if (Object.keys(sizes).length === 0) return null;
    try {
      sessionStorage.setItem(CACHE_KEY, JSON.stringify({ ts: Date.now(), sizes }));
    } catch {
      // Ignore storage write errors
    }
    return sizes;
  } catch {
    return null;
  } finally {
    clearTimeout(timer);
  }
}
