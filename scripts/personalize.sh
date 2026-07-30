#!/usr/bin/env bash
#
# Turn a fresh copy of the reserved-domain-placeholder template into a real
# holding site.
#
#   ./scripts/personalize.sh "Seth Martinez" sethmartinez.com
#
# Stamps the name and domain into every file that carries them, swaps in the
# site README, then removes itself — a generated repo shouldn't carry the
# template machinery around.

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: $(basename "$0") \"<Full Name>\" <domain.com>" >&2
  echo "   eg: $(basename "$0") \"Seth Martinez\" sethmartinez.com" >&2
  exit 64
fi

FULL_NAME="$1"
DOMAIN="$2"

if [[ "$DOMAIN" =~ ^(https?://|www\.) ]] || [[ ! "$DOMAIN" =~ ^[a-z0-9.-]+\.[a-z]+$ ]]; then
  echo "error: expected a bare apex domain, eg. sethmartinez.com — got '$DOMAIN'" >&2
  exit 64
fi

cd "$(dirname "$0")/.."

if [[ ! -f scripts/site-README.md ]]; then
  echo "error: this repository has already been personalized." >&2
  exit 1
fi

# sethmartinez.com -> sethmartinez ; ariel-martinez.com -> ariel-martinez
SLUG="${DOMAIN%%.*}"

mv scripts/site-README.md README.md

FULL_NAME="$FULL_NAME" DOMAIN="$DOMAIN" perl -pi -e '
  s/\{\{FULL_NAME\}\}/$ENV{FULL_NAME}/g;
  s/\{\{DOMAIN\}\}/$ENV{DOMAIN}/g;
' README.md AGENTS.md CNAME src/index.html package.json

# The package name is the only place the template's own name leaks through, and
# it has to stay in step with the lockfile or `npm ci` complains.
SLUG="$SLUG" perl -pi -e '
  s/"reserved-domain-placeholder"/"$ENV{SLUG}"/g;
' package.json package-lock.json

rm -rf scripts

echo "Personalized for $FULL_NAME at www.$DOMAIN."
echo
echo "Next:"
echo "  npm ci && npm run build     # confirm _site/ builds"
echo "  git add -A && git commit -m \"Hold $DOMAIN for $FULL_NAME\""
echo "  gh api -X PUT /repos/brandonmartinez/$SLUG/pages -f build_type=workflow"
