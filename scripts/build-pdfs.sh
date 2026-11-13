#!/usr/bin/env bash
# Render each tool's printable field sheet to PDF with headless Chrome, in English and Turkish.
# The PDFs are written next to each tool's index.html (e.g. site/acidity/field-sheet-tr.pdf),
# so the "ready-made PDF" links on the page resolve once the site is deployed.
#
# Usage: scripts/build-pdfs.sh [site-dir]
# Needs google-chrome or chromium on PATH (preinstalled on GitHub's ubuntu-latest runners).
set -euo pipefail

SITE_DIR="$(cd "${1:-$(dirname "$0")/../site}" && pwd)"
CHROME="${CHROME:-$(command -v google-chrome || command -v chromium || command -v chromium-browser || true)}"
if [[ -z "$CHROME" ]]; then
  echo "error: no Chrome/Chromium found; set CHROME=/path/to/chrome" >&2
  exit 1
fi

# Tools that have a field sheet. Add a directory name here when a new tool gets one.
TOOLS=(acidity)
LANGS=(en tr)

PROFILE="$(mktemp -d)"
trap 'rm -rf "$PROFILE"' EXIT

for tool in "${TOOLS[@]}"; do
  page="$SITE_DIR/$tool/index.html"
  [[ -f "$page" ]] || { echo "error: $page not found" >&2; exit 1; }
  for lang in "${LANGS[@]}"; do
    out="$SITE_DIR/$tool/field-sheet-$lang.pdf"
    "$CHROME" --headless=new --no-sandbox --disable-gpu --user-data-dir="$PROFILE" \
      --no-pdf-header-footer --run-all-compositor-stages-before-draw --virtual-time-budget=10000 \
      --print-to-pdf="$out" "file://$page?lang=$lang" 2>/dev/null
    [[ -s "$out" ]] || { echo "error: $out was not created" >&2; exit 1; }
    echo "built $out ($(stat -c %s "$out") bytes)"
  done
done
