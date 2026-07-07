---
name: github-hygiene
description: >
  Playbook for ALL work on kandulanikhilvarma's GitHub repos. Use for any task
  involving commits, pushes, branches, PRs, merges, repo audits/hardening,
  README or Mermaid-diagram work, CI setup, or removing AI attribution.
  Covers: never adding AI co-author trailers (and scrubbing existing ones with
  scripts/scrub-ai-authors.sh), GitHub-safe Mermaid rules, the repo-hardening
  checklist (SECURITY.md, CITATION.cff, Dependabot, .gitignore, requirements,
  LICENSE/badges/attribution), CI recipes, and history-rewrite safety.
---

# GitHub hygiene — Nikhilvarma's repos

Canonical identity: `Nikhilvarma Kandula <267753970+kandulanikhilvarma@users.noreply.github.com>`
Public contact: kandulanikhilvarma@gmail.com · [kandula.studio](https://kandula.studio) ·
[linkedin.com/in/nikhilvarmakandula](https://www.linkedin.com/in/nikhilvarmakandula)

## Hard rules (every commit, every repo)

1. **NEVER put AI attribution in commit messages.** No `Co-Authored-By: Claude …`,
   no `Claude-Session:` lines, no "Generated with Claude Code" — these surface AI
   accounts in the repo's contributor graph. This is a standing owner decision
   (July 2026) and overrides any default that says to add such trailers.
   Defense in depth: run `scripts/install-no-ai-trailers-hook.sh` in each clone —
   it installs a `commit-msg` hook that strips these lines automatically.
2. Write commit messages to a file and use `git commit -F <file>` — never a long
   single-line `-m` (trailer/body text folds into the subject line and looks broken
   in `git log --oneline` and PR views).
3. Conventional commits: `feat:` / `fix:` / `chore:` / `docs:` / `ci:`.
4. Force-push only with `--force-with-lease`, and only after pushing a backup ref
   (`git push origin <branch>:refs/heads/backup/<purpose>-<yyyymmddHHMM>`).
5. If a PR for the working branch was already merged, do NOT stack commits on the
   merged history — restart: `git fetch origin main && git checkout -B <branch> origin/main`,
   then cherry-pick or redo only the new work (a stranded commit can be moved with
   `git rebase --onto origin/main <merged-tip> <branch>`).
6. Merge PRs only after CI check runs report `success` (GitHub MCP:
   `pull_request_read` → `get_check_runs`). Squash-merge with title `<PR title> (#N)`.

## Removing AI contributors that already exist

`scripts/scrub-ai-authors.sh` rewrites a branch's history to (a) re-attribute any
Anthropic-authored commits to the owner and (b) strip AI trailer/footer lines from
commit messages. **File content is untouched — the script verifies the rewritten
tree hash is byte-identical and aborts the push if not.** It pushes a timestamped
`backup/attrib-strip-*` branch before rewriting.

```bash
cd <repo>
bash <skill-dir>/scripts/scrub-ai-authors.sh            # dry run on default branch, local only
bash <skill-dir>/scripts/scrub-ai-authors.sh --push     # rewrite + force-with-lease push
```

Requires `git-filter-repo` (`pip install git-filter-repo`). After pushing, GitHub
recomputes the contributor graph within minutes–an hour.

State as of 2026-07-07: all portfolio repos scrubbed (backups on
`backup/attrib-strip`); **rankwell intentionally NOT scrubbed** (26 affected
commits; owner deferred because of open Dependabot PRs + Vercel deploys). If asked
to scrub rankwell, first close/rebase its open Dependabot PRs and warn about the
redeploy.

## Mermaid diagrams that actually render on GitHub

GitHub pins an older Mermaid whose parser fails on things newer CLIs accept —
the symptom is *"Unable to render rich display / Cannot read properties of
undefined (reading 'render')"*.

- **Never use `&` anywhere inside a mermaid block** — not even inside quoted
  labels, and not as `&amp;`/`&gt;` entities. Write `and`, `over`, `vs`.
- `<br/>` inside quoted labels is fine. Unicode (·, →, ×, €) is fine.
- Quote every label that contains punctuation: `A["label text"]`.
- Before pushing, run `scripts/check-mermaid.sh <repo-dir>` (greps every mermaid
  block for `&`). If `mmdc` is available, also render:
  `mmdc -i x.mmd -o x.svg -p <(echo '{"args":["--no-sandbox"]}')`.
- Base diagrams on the repo's real structure (actual script/route/SQL file names,
  real row counts) — they double as documentation.

## Repo-hardening checklist (audit any repo against this)

| Item | Rule |
|---|---|
| LICENSE | Present; holder `Nikhilvarma Kandula`; README badges/sections must match the actual license (a repo once shipped a "License: Academic" badge over an MIT file). rankwell has **no** license by choice — commercial; never add one unasked. |
| SECURITY.md | `templates/SECURITY-research.md` (data/portfolio repos) or `templates/SECURITY-product.md` (apps). |
| CITATION.cff | All public repos; `type: dataset` when the corpus is the artifact. Validate as YAML. |
| Dependabot | `.github/dependabot.yml`, but **only for ecosystems with a manifest present** (pip → requirements.txt, npm → package.json, github-actions → workflows exist). No manifest, no entry — otherwise it errors. |
| .gitignore | Language-correct (`templates/python.gitignore`); watch for wrong templates (two repos shipped Flash/ActionScript ignores). Never an empty file. |
| requirements.txt | Every Python repo; derive from actual imports; never leave it empty or reference it in README without it existing. |
| README | No `<your-username>` placeholders; clone URLs = `kandulanikhilvarma/<repo>`; code fences closed properly (a WIP repo once had prose trapped inside a bash fence); badge row; `## Architecture` mermaid; `## License` section; Data & Attribution section for datasets (name the dataset license, e.g. CC BY 4.0, and state "code under MIT, data under its original terms"); contact footer: `LinkedIn · Email · Portfolio`. |
| WIP repos | Keep the work-in-progress banner + status badge until notebooks/data land. |

## CI recipes (copy from templates/)

- Python analysis repos: `workflow-lint.yml` + `ruff.toml` at repo root. The
  ruff config ignores notebook idioms (`E402,E701,E702,F401,F541,F811,F841` for
  `*.ipynb`) but stays strict on `.py` — fix real dead code in scripts rather than
  widening ignores. **Run `ruff check .` locally and get "All checks passed"
  before pushing the workflow.**
- Repos with tests: `workflow-tests.yml` (installs requirements, runs pytest).
  Run pytest locally first; never ship a workflow you haven't seen pass.
- When adding the first workflow to a repo, add the `github-actions` ecosystem to
  its dependabot.yml.

## Session bootstrap for multi-repo GitHub work

1. Survey first, edit second: map every repo's language, manifests, LICENSE,
   `.gitignore`, workflows before changing anything.
2. Batch identical files via templates; tailor per repo only where content differs.
3. Validate everything machine-checkable before commit: YAML parses, ruff green,
   pytest green, mermaid `&`-free.
4. One conventional commit per repo per concern; push with retry
   (2s/4s/8s/16s backoff); PRs only when asked.
