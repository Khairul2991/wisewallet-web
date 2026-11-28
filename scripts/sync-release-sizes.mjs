import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { RELEASE_CONFIG } from '../src/data/content.js';
import { extractReleaseAssetSizes } from '../src/scripts/release-sizes.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const snapshotPath = path.resolve(__dirname, '../src/data/release-sizes-snapshot.json');

const headers = {
  Accept: 'application/vnd.github+json',
  'User-Agent': 'WiseWallet-Landing-Sync',
};
if (process.env.GITHUB_TOKEN) {
  headers.Authorization = `Bearer ${process.env.GITHUB_TOKEN}`;
}

try {
  const res = await fetch(RELEASE_CONFIG.apiLatestUrl, { headers });
  if (!res.ok) {
    console.warn(`sync-release-sizes: GitHub API returned HTTP ${res.status}; keeping existing snapshot.`);
    process.exit(0);
  }
  const data = await res.json();
  const sizes = extractReleaseAssetSizes(data);
  if (Object.keys(sizes).length === 0) {
    console.warn('sync-release-sizes: No APK assets found; keeping existing snapshot.');
    process.exit(0);
  }
  const snapshot = {
    tagName: typeof data.tag_name === 'string' ? data.tag_name : null,
    checkedAt: new Date().toISOString(),
    sizes,
  };
  fs.writeFileSync(snapshotPath, `${JSON.stringify(snapshot, null, 2)}\n`, 'utf8');
  console.log(`sync-release-sizes: Updated snapshot for ${snapshot.tagName ?? 'latest'} (${Object.keys(sizes).length} APKs).`);
} catch (err) {
  console.warn(`sync-release-sizes: ${err.message}; keeping existing snapshot.`);
}
