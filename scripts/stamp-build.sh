#!/usr/bin/env bash
# Write the build date and commit into every page's footer, replacing the
# <span class="build-id">dev</span> placeholder. Run in CI before the PDFs are built,
# so the field sheets carry the same version as the site.
#
# Usage: scripts/stamp-build.sh [site-dir]
set -euo pipefail

SITE_DIR="${1:-$(dirname "$0")/../site}"
SHA="${GITHUB_SHA:-$(git rev-parse HEAD)}"
REPO_URL="${GITHUB_SERVER_URL:-https://github.com}/${GITHUB_REPOSITORY:-havan/erkenhasat}"
DATE="$(date -u '+%Y-%m-%d %H:%M UTC')"
STAMP="$DATE · <a href=\"$REPO_URL/commit/$SHA\">${SHA:0:7}</a>"

grep -rl --include='*.html' '<span class="build-id">dev</span>' "$SITE_DIR" | while read -r f; do
  sed -i "s|<span class=\"build-id\">dev</span>|<span class=\"build-id\">$STAMP</span>|" "$f"
  echo "stamped $f"
done
