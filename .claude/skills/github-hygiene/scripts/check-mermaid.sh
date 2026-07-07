#!/usr/bin/env bash
# check-mermaid.sh — verify Markdown Mermaid blocks are GitHub-safe.
# GitHub's pinned Mermaid fails on '&' inside blocks (even quoted labels or as
# HTML entities), showing "Unable to render rich display".
#
# Usage: check-mermaid.sh [dir]   (default: current directory; scans *.md)

set -euo pipefail
DIR="${1:-.}"
fail=0
while IFS= read -r -d '' f; do
  bad=$(awk '/^```mermaid/{flag=1; next} /^```/{flag=0} flag && /&/' "$f" || true)
  if [ -n "$bad" ]; then
    fail=1
    echo "UNSAFE: $f"
    echo "$bad" | sed 's/^/    /'
  fi
done < <(find "$DIR" -name '*.md' -not -path '*/node_modules/*' -not -path '*/.git/*' -print0)

if [ "$fail" -eq 0 ]; then
  echo "OK: no '&' inside any mermaid block under $DIR"
else
  echo ""
  echo "Fix: replace '&' with 'and' (and '&gt;'/'&lt;' with 'over'/'under') inside mermaid blocks."
  exit 1
fi
