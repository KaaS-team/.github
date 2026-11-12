# .github

This repo holds the KaaS-team organisation profile page and the shared GitHub Actions workflows that the org's other repos call. Maintainers of those repos use the workflows, and anyone visiting the org on GitHub sees the profile.

## Install

There is nothing to install. Clone the repo to edit it; you need `git`, `bash` and `make`.

```sh
git clone https://github.com/KaaS-team/.github
cd .github
```

## First command

`make check` runs the docs check and its tests. It needs no network.

```sh
make check
```

```
scripts/check-docs.sh
docs check: ok
tests/check-docs-test.sh
ok   good docs pass
ok   missing link in README fails
ok   missing link in nested md fails
ok   unknown make target fails
ok   missing script fails
ok   links inside code fences are ignored
ok   this repo passes
```

The docs check fails when a relative link in any markdown file points to a missing file, or when a `sh` or `bash` block in this README names a script or make target that does not exist.

## What is here

| Path | What it is |
|---|---|
| `profile/README.md` | The org profile page shown on github.com/KaaS-team. Keep its repo table in step with the org's public repos. |
| `.github/workflows/bun-check.yml` | Reusable workflow: install Bun, run `make install`, then `make check`. |
| `.github/workflows/dco.yml` | Reusable workflow: every commit in a pull request must carry a matching `Signed-off-by` line. |
| `.github/workflows/mutations.yml` | Reusable workflow: install Bun, run `make install`, then `make check-mutations`. |
| `scripts/check-docs.sh` | The docs check. |
| `tests/check-docs-test.sh` | Tests for the docs check, using temporary fixture directories. |

The Bun workflows target the current Bun and TypeScript factory. The Go rewrite of the factory (a single `factory` binary) has no shared workflow here yet.

## Using a workflow

Call a workflow from another repo with a pinned tag. The `v1` tag exists.

```yaml
jobs:
  check:
    uses: KaaS-team/.github/.github/workflows/bun-check.yml@v1
```

`bun-check.yml` and `mutations.yml` take optional inputs `runner`, `bun-version` and `timeout-minutes`. The calling repo must define the `make` targets the workflow runs.

## Where to go next

- [kaas.team](https://kaas.team) for the project and services.
- [profile/README.md](profile/README.md) to edit the org profile.
- [LICENSE](LICENSE): Apache-2.0. Commits are signed off under the DCO (`git commit -s`).
