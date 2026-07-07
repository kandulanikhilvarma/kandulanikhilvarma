#!/usr/bin/env bash
# install-no-ai-trailers-hook.sh — install a commit-msg hook into the current
# repo that strips AI attribution lines from every commit message before the
# commit is created. Prevention counterpart to scrub-ai-authors.sh.
#
# Usage (run from inside the repo):  install-no-ai-trailers-hook.sh
# Idempotent; preserves an existing commit-msg hook by chaining to it.

set -euo pipefail
git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
  || { echo "ERROR: not inside a git repository" >&2; exit 1; }

HOOKS_DIR=$(git rev-parse --git-path hooks)
HOOK="$HOOKS_DIR/commit-msg"
FILTER="$HOOKS_DIR/strip-ai-trailers"

cat > "$FILTER" <<'EOF'
#!/bin/sh
# strip-ai-trailers — remove AI attribution lines from a commit message file.
msg="$1"
tmp=$(mktemp)
grep -viE '^(co-authored-by:.*anthropic|claude-session:)|claude\.ai/code|claude\.com/claude-code|generated with \[claude code\]' "$msg" > "$tmp" || true
mv "$tmp" "$msg"
EOF
chmod +x "$FILTER"

if [ -f "$HOOK" ] && ! grep -q strip-ai-trailers "$HOOK"; then
  # chain: run the filter first, then the pre-existing hook
  mv "$HOOK" "$HOOK.chained"
  {
    echo '#!/bin/sh'
    echo "\"\$(dirname \"\$0\")/strip-ai-trailers\" \"\$1\""
    echo "exec \"\$(dirname \"\$0\")/commit-msg.chained\" \"\$@\""
  } > "$HOOK"
elif [ ! -f "$HOOK" ]; then
  {
    echo '#!/bin/sh'
    echo "exec \"\$(dirname \"\$0\")/strip-ai-trailers\" \"\$1\""
  } > "$HOOK"
fi
chmod +x "$HOOK"
echo "installed: $HOOK (strips AI attribution from all future commits in this clone)"
