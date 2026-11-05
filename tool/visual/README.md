# Visual baseline capture and parity

Tools used to prove that the Material migration keeps the showcase visually
equivalent. The baseline for commit `de89016` lives at
`/mnt/data/charcoal-baseline/de89016/` (deliverable, never delete).

## Files

| File | Purpose |
| --- | --- |
| `tool/visual/pages.json` | page id -> how to reach it, viewports, themes |
| `tool/visual/capture.mjs` | Node + Playwright full-page capture of a built showcase |
| `tool/visual_parity.dart` | compares two capture roots, reports non-text pixel diff % |

## Baseline layout

```
<root>/manifest.json            commit, Flutter version, build sizes, sha256 per image
<root>/<renderer>/<page>.<light|dark>.<WxH>.png
<root>/<renderer>/<page>.<light|dark>.<WxH>.text.json   text boxes [x,y,w,h] used as the parity mask
<root>/reference-goldens/{linux,macos}                  copy of packages/charcoal_ui/test/goldens
```

`<renderer>` is `wasm` (the Pages build) or `canvaskit`. Viewports are
1440x900, 390x844 and 320x700 (width below 1024 gets the mobile shell). Images
are full page: the viewport is grown until no scroll container overflows, so
the sidebar/header are stretched to the page height.

## Capturing

```
cd example
flutter build web --release --wasm --base-href /charcoal-flutter/ --output <build-dir>
cd ..
export PLAYWRIGHT_CORE=/path/to/node_modules/playwright-core/index.mjs   # npm i playwright-core
export CHARCOAL_CHROMIUM=/path/to/chrome                                  # optional
node tool/visual/capture.mjs --build <build-dir> --out <root> --renderer wasm \
     --commit $(git rev-parse HEAD) --flutter 3.47.x
# subsets: --pages buttons,fields --viewports 1440x900 --themes dark
```

The script serves the build on a free 127.0.0.1 port (stopped on exit), enables
Flutter's accessibility tree and drives the sidebar by clicking semantic
buttons by exact name, so the app needs no patch. New pages must be reachable
by a button name; add them to `pages.json` (`nav` plus optional `steps`).
Screenshots are retaken until two consecutive frames are identical (otherwise
`stable: false` in `manifest.json`). `manifest.json` merges per renderer.

## Parity

```
dart run tool/visual_parity.dart --baseline /mnt/data/charcoal-baseline/de89016 --new <root> \
     [--renderer wasm] [--pages buttons,fields] [--threshold 0.5] [--tolerance 6] \
     [--side-by-side <dir>] [--no-text-mask]
```

For each baseline image it prints the percentage of non-text pixels that differ
(any channel off by more than `--tolerance`). Text is masked using the union of
the text boxes of both images; area present in only one image (different page
size) counts as different. Exit code 1 if any image exceeds `--threshold`
(default 0.5, per the plan) or is missing in `--new`; `--side-by-side` writes
old-left/new-right PNGs for failing images (`--side-by-side-all true` for all).
Page ids that do not exist any more (e.g. `app-bloom`) are skipped with
`--pages`, or reported MISSING otherwise.

Note: every baseline page must exist in the new capture; the Bloom entry is
planned for deletion, so restrict `--pages` accordingly.
