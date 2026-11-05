#!/usr/bin/env node
// Full-page screenshot capture of a built Charcoal showcase (Flutter web).
// See tool/visual/README.md. Node >= 20 and playwright-core (+ a Chromium) required.
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import { fileURLToPath } from 'node:url';

const here = path.dirname(fileURLToPath(import.meta.url));

function parseArgs(argv) {
  const o = {};
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (!a.startsWith('--')) throw new Error(`unexpected argument ${a}`);
    const k = a.slice(2);
    const v = argv[i + 1] && !argv[i + 1].startsWith('--') ? argv[++i] : 'true';
    o[k] = v;
  }
  return o;
}

const args = parseArgs(process.argv.slice(2));
if (!args.build || !args.out || args.help) {
  console.log(`usage: node tool/visual/capture.mjs --build <web build dir> --out <root dir> [options]
  --renderer <name>       subdirectory under --out (default: wasm)
  --base-href <path>      base href the build was made with (default: /charcoal-flutter/)
  --pages <id,id,...>     subset of pages.json ids (default: all)
  --viewports <WxH,...>   subset (default: all)  --themes light,dark
  --pages-file <file>     default: tool/visual/pages.json next to this script
  --commit <sha> --flutter <version> --note <text>   recorded in manifest.json
  env: PLAYWRIGHT_CORE (path or module name, default playwright-core)
       CHARCOAL_CHROMIUM (chromium executable; default: newest under /mnt/data/tmp/cindy/ms-playwright)`);
  process.exit(args.help ? 0 : 2);
}

const renderer = args.renderer ?? 'wasm';
const baseHref = args['base-href'] ?? '/charcoal-flutter/';
const config = JSON.parse(fs.readFileSync(args['pages-file'] ?? path.join(here, 'pages.json'), 'utf8'));
const want = (v) => (v ? new Set(v.split(',')) : null);
const pageSel = want(args.pages), vpSel = want(args.viewports), themeSel = want(args.themes);
const pages = config.pages.filter((p) => !pageSel || pageSel.has(p.id));
const viewports = config.viewports.filter((v) => !vpSel || vpSel.has(v.name));
const themes = config.themes.filter((t) => !themeSel || themeSel.has(t));
const outDir = path.join(args.out, renderer);
fs.mkdirSync(outDir, { recursive: true });

function findChromium() {
  if (process.env.CHARCOAL_CHROMIUM) return process.env.CHARCOAL_CHROMIUM;
  const base = '/mnt/data/tmp/cindy/ms-playwright';
  if (!fs.existsSync(base)) return undefined; // let playwright use its own default
  const dirs = fs.readdirSync(base).filter((d) => /^chromium-\d+$/.test(d)).sort();
  return dirs.length ? path.join(base, dirs.at(-1), 'chrome-linux64', 'chrome') : undefined;
}

const pw = await import(process.env.PLAYWRIGHT_CORE ?? 'playwright-core');
const chromium = (pw.chromium ?? pw.default?.chromium);

// Static server on a free loopback port, serving --build under --base-href.
// No COOP/COEP headers, to match GitHub Pages (Skwasm runs single-threaded there too).
const mime = { '.html': 'text/html', '.js': 'text/javascript', '.mjs': 'text/javascript', '.wasm': 'application/wasm', '.json': 'application/json', '.png': 'image/png', '.otf': 'font/otf', '.ttf': 'font/ttf' };
const server = http.createServer((req, res) => {
  let p = decodeURIComponent(req.url.split('?')[0]);
  if (p.startsWith(baseHref)) p = '/' + p.slice(baseHref.length);
  if (p.endsWith('/')) p += 'index.html';
  const f = path.join(args.build, path.normalize(p));
  if (!f.startsWith(path.resolve(args.build)) || !fs.existsSync(f) || fs.statSync(f).isDirectory()) { res.writeHead(404); return res.end(); }
  res.writeHead(200, { 'content-type': mime[path.extname(f)] ?? 'application/octet-stream' });
  fs.createReadStream(f).pipe(res);
});
await new Promise((r) => server.listen(0, '127.0.0.1', r));
const port = server.address().port;
console.log(`serving ${args.build} on http://127.0.0.1:${port}${baseHref}`);

const browser = await chromium.launch({ executablePath: findChromium() });
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const results = [];
const failures = [];

async function textBoxes(page) {
  // Bounding boxes of semantic text nodes: used by visual_parity.dart to mask text.
  return page.evaluate(() => [...document.querySelectorAll('flt-semantics')]
    .filter((e) => e.querySelector(':scope > span') || e.getAttribute('aria-label'))
    .map((e) => e.getBoundingClientRect())
    .filter((r) => r.width > 0 && r.height > 0)
    .map((r) => [Math.round(r.x), Math.round(r.y), Math.round(r.width), Math.round(r.height)]));
}

async function stableShot(page) {
  let prev = await page.screenshot({ type: 'png' });
  for (let i = 0; i < 6; i++) {
    await sleep(350);
    const cur = await page.screenshot({ type: 'png' });
    if (Buffer.compare(prev, cur) === 0) return { buf: cur, stable: true };
    prev = cur;
  }
  return { buf: prev, stable: false };
}

async function scrollExcess(page) {
  return page.evaluate(() => Math.max(0, ...[...document.querySelectorAll('flt-semantics')]
    .filter((e) => /^(scroll|hidden|auto)$/.test(e.style.overflowY || e.style.overflow))
    .map((e) => e.scrollHeight - e.clientHeight)));
}

async function run(vp, theme) {
  const mobile = vp.width < 1024; // _desktopLayoutMinWidth in example/lib/main.dart
  const ctx = await browser.newContext({ viewport: { width: vp.width, height: vp.height }, deviceScaleFactor: 1 });
  const page = await ctx.newPage();
  await page.goto(`http://127.0.0.1:${port}${baseHref}`);
  await page.waitForSelector('flt-glass-pane', { state: 'attached', timeout: 90000 });
  await page.waitForSelector('flt-semantics-placeholder', { state: 'attached', timeout: 90000 });
  await sleep(2500);
  await page.evaluate(() => document.querySelector('flt-semantics-placeholder')?.click());
  await page.waitForSelector('flt-semantics[role=button]', { state: 'attached', timeout: 30000 });
  await sleep(500);

  const neutral = async () => { await page.mouse.move(1, 1); await page.evaluate(() => document.activeElement?.blur?.()); await sleep(250); };
  const button = (name) => page.getByRole('button', { name, exact: typeof name === 'string' });

  if (theme === 'dark') {
    if (mobile) await page.getByRole('button', { name: 'Use dark mode' }).click({ force: true });
    else await page.getByRole('switch', { name: 'Dark mode' }).click({ force: true });
    await sleep(800);
  }

  let current = 'Overview';
  const goNav = async (label) => {
    if (mobile) {
      await page.getByRole('button', { name: 'Open navigation' }).click({ force: true });
      await sleep(600);
      await button(label).last().click({ force: true });
    } else {
      await button(label).first().click({ force: true });
    }
    current = label;
    await sleep(900);
  };

  for (const pg of pages) {
    const name = `${pg.id}.${theme}.${vp.name}`;
    try {
      await page.setViewportSize({ width: vp.width, height: vp.height });
      await sleep(300);
      if (current === pg.nav) await goNav('Overview');
      await goNav(pg.nav);
      for (const s of pg.steps ?? []) {
        const target = new RegExp(s.click.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'));
        await button(target).first().click({ force: true, timeout: 8000 });
        await sleep(1000);
      }
      await neutral();
      // Grow the viewport until no scroll container has overflow, then shoot the whole page.
      let h = vp.height;
      for (let i = 0; i < 4; i++) {
        const ex = await scrollExcess(page);
        if (ex <= 1) break;
        h = Math.min(h + ex + 4, 16000);
        await page.setViewportSize({ width: vp.width, height: h });
        await sleep(900);
        await neutral();
      }
      const { buf, stable } = await stableShot(page);
      const boxes = await textBoxes(page);
      const file = path.join(outDir, `${name}.png`);
      fs.writeFileSync(file, buf);
      fs.writeFileSync(path.join(outDir, `${name}.text.json`), JSON.stringify(boxes));
      const w = buf.readUInt32BE(16), hh = buf.readUInt32BE(20);
      results.push({ name, width: w, height: hh, stable, textBoxes: boxes.length });
      console.log(`${renderer} ${name} ${w}x${hh}${stable ? '' : ' UNSTABLE'}`);
    } catch (e) {
      failures.push({ name, error: String(e.message ?? e).split('\n')[0], optional: !!pg.optional });
      console.error(`FAIL ${name}: ${String(e.message ?? e).split('\n')[0]}`);
      // Recover to a known state for the next page.
      await page.reload(); await sleep(3500);
      await page.evaluate(() => document.querySelector('flt-semantics-placeholder')?.click()); await sleep(800);
      current = 'Overview';
      if (theme === 'dark') {
        if (mobile) await page.getByRole('button', { name: /Use (dark|light) mode/ }).click({ force: true }).catch(() => {});
        else await page.getByRole('switch', { name: 'Dark mode' }).click({ force: true }).catch(() => {});
        await sleep(800);
      }
    }
  }
  await ctx.close();
}

try {
  for (const vp of viewports) for (const theme of themes) await run(vp, theme);
} finally {
  await browser.close();
  server.close();
}

// manifest.json in the root: merged per renderer so wasm and canvaskit runs share one file.
const manifestPath = path.join(args.out, 'manifest.json');
const manifest = fs.existsSync(manifestPath) ? JSON.parse(fs.readFileSync(manifestPath, 'utf8')) : { images: {}, builds: {}, failures: {} };
if (args.commit) manifest.commit = args.commit;
if (args.flutter) manifest.flutter = args.flutter;
manifest.viewport_set = config.viewports.map((v) => v.name);
const dirSize = (d) => fs.readdirSync(d, { withFileTypes: true }).reduce((n, e) => n + (e.isDirectory() ? dirSize(path.join(d, e.name)) : fs.statSync(path.join(d, e.name)).size), 0);
manifest.builds[renderer] = { bytes: dirSize(args.build), base_href: baseHref, captured_at: new Date().toISOString(), note: args.note ?? '' };
for (const k of Object.keys(manifest.images)) if (k.startsWith(`${renderer}/`)) delete manifest.images[k];
for (const f of fs.readdirSync(outDir).filter((n) => n.endsWith('.png')).sort()) {
  const buf = fs.readFileSync(path.join(outDir, f));
  const r = results.find((x) => `${x.name}.png` === f);
  manifest.images[`${renderer}/${f}`] = { sha256: crypto.createHash('sha256').update(buf).digest('hex'), bytes: buf.length, width: buf.readUInt32BE(16), height: buf.readUInt32BE(20), stable: r?.stable ?? null };
}
manifest.failures[renderer] = failures;
fs.writeFileSync(manifestPath, JSON.stringify(manifest, null, 2) + '\n');
console.log(`${results.length} captured, ${failures.length} failed; manifest ${manifestPath}`);
process.exit(failures.some((f) => !f.optional) ? 1 : 0);
