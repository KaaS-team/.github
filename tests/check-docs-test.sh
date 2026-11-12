#!/usr/bin/env bash
# Proves scripts/check-docs.sh passes on good docs and fails on each kind of breakage.
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
fails=0
expect() { # name expected-exit dir
  out=$("$here/scripts/check-docs.sh" "$3" 2>&1); rc=$?
  if [ "$rc" -eq "$2" ]; then echo "ok   $1"; else echo "FAIL $1 (exit $rc, want $2)"; echo "$out"; fails=1; fi
}
mk() { rm -rf "$tmp/w"; mkdir -p "$tmp/w/docs" "$tmp/w/scripts"; printf 'ok:\n\ttrue\n' > "$tmp/w/Makefile"
  : > "$tmp/w/scripts/run.sh"; : > "$tmp/w/docs/a.md"; }

mk; printf '[a](docs/a.md#x) [w](https://x.test)\n```sh\nmake ok\n./scripts/run.sh\n```\n' > "$tmp/w/README.md"
expect "good docs pass" 0 "$tmp/w"
mk; printf '[a](docs/missing.md)\n' > "$tmp/w/README.md"
expect "missing link in README fails" 1 "$tmp/w"
mk; printf '[a](../nope.md)\n' > "$tmp/w/docs/b.md"; printf 'hi\n' > "$tmp/w/README.md"
expect "missing link in nested md fails" 1 "$tmp/w"
mk; printf '```bash\nmake nothere\n```\n' > "$tmp/w/README.md"
expect "unknown make target fails" 1 "$tmp/w"
mk; printf '```sh\n./scripts/gone.sh\n```\n' > "$tmp/w/README.md"
expect "missing script fails" 1 "$tmp/w"
mk; printf '```\n[x](nope.md)\n```\n' > "$tmp/w/README.md"
expect "links inside code fences are ignored" 0 "$tmp/w"
expect "this repo passes" 0 "$here"
exit $fails
