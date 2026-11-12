BRANCH: cluster/docs
HEAD: 3e241d27975e306eb85bc4ba939e206f4d900512
## Summary
Rewrote the README (what the repo is, install, first command with real output, next steps), added a docs check (`scripts/check-docs.sh`) with fixture tests and a `make check` gate. The repo had no gate, so the README says so.
## Acceptance
- Inventory of markdown, commands, links -> manual run of every command -> done. README.md: old README had only an external link (works). profile/README.md: only external links and a repo table, no commands or relative paths (works, unchanged). Workflows reference `make install`, `make check`, `make check-mutations`, which belong to caller repos (documented in README, not run here). New README commands (`git clone`, `make check`) run clean.
- README structure, under 150 lines, no em dashes -> `make check` output pasted verbatim (66 lines, 0 em dashes) -> done
- Stale content gone -> README claimed only "keep repo table in step"; kept. Removed nothing else. profile table rows for factory-install and homebrew-tap say "waiting on the first binary release"; I could not verify against the Go factory from this repo, so left unchanged -> done, see Learnings
- Docs check wired into gate; bites -> tests/check-docs-test.sh (6 fixture cases + this repo). Broke `(LICENSE)` link once: FAIL broken link, exit nonzero. Broke a make target once: FAIL, exit 1 -> done
- No gate, so add `make check` -> Makefile (`check` = docs-check + test), stated in README -> done
- Gate passes from clean clone -> make check -> done
Note: the checks were written together with the script, so I did not watch the tests fail against a missing script; I proved they bite by breaking the docs instead.
## Files outside my area
none
## Goldens changed
none
## Gate evidence
ok   missing script fails
ok   links inside code fences are ignored
ok   this repo passes
## Learnings
- origin/next README of KaaS-factory is still the Bun/TS one, so v9 Go commands could not be cross-checked; the brief should point at a Go-era doc.
- Brief conflicts with session defaults (open a PR, add session trailer); I followed the brief: no PR, no trailer.
