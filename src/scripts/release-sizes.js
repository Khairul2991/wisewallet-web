export const RELEASE_SIZE_CACHE_KEY = 'ww-release-sizes-v2';
export const RELEASE_SIZE_CACHE_TTL_MS = 24 * 60 * 60 * 1000;
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

function getDefaultStorage() {
  try {
    return typeof localStorage !== 'undefined' ? localStorage : null;
  } catch {
    return null;
  }
}

export function readCachedReleaseSizes({ storage = getDefaultStorage(), now = Date.now() } = {}) {
  if (!storage) return null;
  try {
    const raw = storage.getItem(RELEASE_SIZE_CACHE_KEY);
    if (!raw) return null;
    const parsed = JSON.parse(raw);
    if (
      !parsed ||
      typeof parsed.ts !== 'number' ||
      !Number.isFinite(parsed.ts) ||
      !parsed.sizes ||
      typeof parsed.sizes !== 'object'
    ) {
      return null;
    }
    const cleanSizes = {};
    for (const [name, size] of Object.entries(parsed.sizes)) {
      if (name.endsWith('.apk') && typeof size === 'number' && Number.isFinite(size) && size > 0) {
        cleanSizes[name] = size;
      }
    }
    if (Object.keys(cleanSizes).length === 0) return null;
    return {
      sizes: cleanSizes,
      ts: parsed.ts,
      isFresh: now - parsed.ts < RELEASE_SIZE_CACHE_TTL_MS,
    };
  } catch {
    return null;
  }
}

export async function fetchLatestReleaseSizes(
  apiUrl,
  { storage = getDefaultStorage(), fetchImpl = globalThis.fetch, now = Date.now() } = {},
) {
  const cached = readCachedReleaseSizes({ storage, now });
  if (cached && cached.isFresh) {
    return cached.sizes;
  }

  if (typeof fetchImpl !== 'function') {
    return cached ? cached.sizes : null;
  }

  const controller = typeof AbortController !== 'undefined' ? new AbortController() : null;
  const timer = controller ? setTimeout(() => controller.abort(), FETCH_TIMEOUT_MS) : null;
  try {
    const res = await fetchImpl(apiUrl, {
      headers: { Accept: 'application/vnd.github+json' },
      ...(controller ? { signal: controller.signal } : {}),
    });
    if (!res || !res.ok) {
      return cached ? cached.sizes : null;
    }
    const data = await res.json();
    const sizes = extractReleaseAssetSizes(data);
    if (Object.keys(sizes).length === 0) {
      return cached ? cached.sizes : null;
    }
    if (storage) {
      try {
        storage.setItem(RELEASE_SIZE_CACHE_KEY, JSON.stringify({ ts: now, sizes }));
      } catch {
        // Ignore storage write errors
      }
    }
    return sizes;
  } catch {
    return cached ? cached.sizes : null;
  } finally {
    if (timer) clearTimeout(timer);
  }
}
