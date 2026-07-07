#!/usr/bin/env bash
# scrub-ai-authors.sh — remove AI (Claude/Anthropic) attribution from git history.
#
# What it does to the target branch:
#   1. Pushes a timestamped backup ref (refs/heads/backup/attrib-strip-<ts>).
#   2. Re-attributes commits authored/committed as <noreply@anthropic.com> to you.
#   3. Strips these lines from every commit message:
#        Co-Authored-By: ... anthropic ...
#        Claude-Session: ...
#        any line containing claude.ai/code or claude.com/claude-code
#        "Generated with [Claude Code]" footers
#   4. Verifies the rewritten branch tree is BYTE-IDENTICAL to the original
#      (only metadata changed) — aborts before pushing if not.
#
# Usage (run from inside the repo):
#   scrub-ai-authors.sh [-b BRANCH] [-n "Your Name"] [-e you@example.com] [--push]
#
# Defaults: BRANCH = remote default branch; name/email = first non-Anthropic
# author found in history. Without --push the rewrite stays local so you can
# inspect it; rerun with --push (or push manually with --force-with-lease).
#
# Requires: git-filter-repo  (pip install git-filter-repo)

set -euo pipefail

BRANCH="" NAME="" EMAIL="" PUSH=0
while [ $# -gt 0 ]; do
  case "$1" in
    -b) BRANCH="$2"; shift 2 ;;
    -n) NAME="$2"; shift 2 ;;
    -e) EMAIL="$2"; shift 2 ;;
    --push) PUSH=1; shift ;;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown arg: $1 (see --help)" >&2; exit 2 ;;
  esac
done

git filter-repo --version >/dev/null 2>&1 \
  || { echo "ERROR: git-filter-repo not found. Install: pip install git-filter-repo" >&2; exit 1; }
git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
  || { echo "ERROR: not inside a git repository" >&2; exit 1; }
[ -z "$(git status --porcelain)" ] \
  || { echo "ERROR: worktree is dirty — commit or stash first" >&2; exit 1; }

URL=$(git remote get-url origin)

if [ -z "$BRANCH" ]; then
  BRANCH=$(git ls-remote --symref origin HEAD | awk '/^ref:/{sub("refs/heads/","",$2); print $2; exit}')
fi
if [ -z "$BRANCH" ]; then
  BRANCH=$(git symbolic-ref -q refs/remotes/origin/HEAD 2>/dev/null | sed 's@.*/@@' || true)
fi
if [ -z "$BRANCH" ]; then
  for c in main master; do
    if git ls-remote --exit-code --heads origin "$c" >/dev/null 2>&1; then BRANCH=$c; break; fi
  done
fi
[ -n "$BRANCH" ] || { echo "ERROR: could not determine default branch; pass -b" >&2; exit 1; }

echo "==> fetching origin/$BRANCH"
git fetch origin "$BRANCH"
git checkout -B "$BRANCH" "origin/$BRANCH" --quiet

if [ -z "$NAME" ] || [ -z "$EMAIL" ]; then
  ident=$(git log "$BRANCH" --format='%an|%ae' | grep -iv anthropic | head -1)
  [ -n "$NAME" ]  || NAME=${ident%%|*}
  [ -n "$EMAIL" ] || EMAIL=${ident##*|}
fi
[ -n "$NAME" ] && [ -n "$EMAIL" ] \
  || { echo "ERROR: could not infer identity; pass -n and -e" >&2; exit 1; }
echo "==> re-attributing Anthropic commits to: $NAME <$EMAIL>"

OLD_TIP=$(git rev-parse "$BRANCH")
OLD_TREE=$(git rev-parse "$BRANCH^{tree}")

TS=$(date +%Y%m%d%H%M%S)
BACKUP="backup/attrib-strip-$TS"
echo "==> pushing backup: $BACKUP"
git push origin "$OLD_TIP:refs/heads/$BACKUP"

TMPDIR_SCRUB=$(mktemp -d)
trap 'rm -rf "$TMPDIR_SCRUB"' EXIT

cat > "$TMPDIR_SCRUB/mailmap" <<EOF
$NAME <$EMAIL> <noreply@anthropic.com>
EOF

cat > "$TMPDIR_SCRUB/msg_cb.py" <<'EOF'
lines = message.split(b"\n")
out = []
for l in lines:
    s = l.strip().lower()
    if s.startswith(b"co-authored-by:") and b"anthropic" in s:
        continue
    if s.startswith(b"claude-session:"):
        continue
    if b"claude.ai/code" in s or b"claude.com/claude-code" in s:
        continue
    if b"generated with [claude code]" in s:
        continue
    out.append(l)
while out and out[-1].strip() == b"":
    out.pop()
return b"\n".join(out) + b"\n"
EOF

echo "==> rewriting $BRANCH"
git filter-repo --force --refs "$BRANCH" \
  --mailmap "$TMPDIR_SCRUB/mailmap" \
  --message-callback "$(cat "$TMPDIR_SCRUB/msg_cb.py")"

# filter-repo removes the origin remote — restore it
git remote get-url origin >/dev/null 2>&1 || git remote add origin "$URL"
git fetch origin "$BRANCH" --quiet || true

NEW_TREE=$(git rev-parse "$BRANCH^{tree}")
LEFT=$(git log "$BRANCH" --format='%an %ae%n%b' | grep -ic anthropic || true)

echo "==> old tip:  $OLD_TIP"
echo "==> new tip:  $(git rev-parse "$BRANCH")"
echo "==> anthropic references remaining: $LEFT"

if [ "$OLD_TREE" != "$NEW_TREE" ]; then
  echo "FATAL: tree hash changed ($OLD_TREE -> $NEW_TREE) — file content differs!" >&2
  echo "NOT pushing. Restore with: git checkout -B $BRANCH $OLD_TIP" >&2
  exit 1
fi
echo "==> tree identical: file content untouched ✓"

if [ "$PUSH" -eq 1 ]; then
  echo "==> force-with-lease pushing $BRANCH"
  git push --force-with-lease origin "$BRANCH"
  echo "==> done. Backup preserved at origin/$BACKUP"
  echo "    Contributor graph refreshes within minutes to an hour."
else
  echo "==> local rewrite complete (no --push given)."
  echo "    Inspect with: git log --format='%an <%ae> %s' $BRANCH"
  echo "    Publish with: git push --force-with-lease origin $BRANCH"
  echo "    Undo with:    git checkout -B $BRANCH $OLD_TIP"
fi
