#!/usr/bin/env bash
# Docs check. Usage: scripts/check-docs.sh [root]   (root defaults to the repo root)
# Fails when:
#   1. a relative link in any markdown file points to a missing file, or
#   2. a fenced sh/bash block in README.md runs a script or make target that does not exist.
set -u
root=${1:-$(cd "$(dirname "$0")/.." && pwd)}
cd "$root" || exit 2
bad=0

fail() { echo "FAIL: $*"; bad=1; }

# 1. Relative links, inline form [text](target). Fenced code is skipped.
while IFS= read -r md; do
  dir=$(dirname "$md")
  awk '/^```/ {f=!f; next} !f' "$md" | grep -o '\]([^)]*)' | sed 's/^](//; s/)$//' |
  while IFS= read -r target; do
    target=${target%% *}
    case $target in
      ''|'#'*|http://*|https://*|mailto:*) continue ;;
    esac
    path=${target%%#*}; path=${path%%\?*}
    [ -z "$path" ] && continue
    case $path in /*) full=".$path" ;; *) full="$dir/$path" ;; esac
    [ -e "$full" ] || echo "BROKEN $md -> $target"
  done
done < <(find . -name '*.md' -not -path './.git/*' | sort) > .docs-check.tmp
if [ -s .docs-check.tmp ]; then
  while IFS= read -r l; do fail "${l/BROKEN /broken link: }"; done < .docs-check.tmp
fi
rm -f .docs-check.tmp

# 2. Fenced sh/bash blocks in README.md: scripts and make targets must exist.
if [ -f README.md ]; then
  blocks=$(awk '/^```(sh|bash)[ ]*$/ {f=1; next} /^```/ {f=0} f' README.md)
  while IFS= read -r line; do
    line=${line#"\$ "}
    set -- $line
    [ $# -eq 0 ] && continue
    case $1 in
      make)
        shift
        for t in "$@"; do
          case $t in -*|*=*) continue ;; esac
          if [ ! -f Makefile ] || ! grep -Eq "^$t:" Makefile; then fail "README names make target '$t' that Makefile lacks"; fi
        done ;;
      ./*|scripts/*|tests/*)
        [ -f "$1" ] || fail "README names script '$1' that does not exist" ;;
    esac
  done <<< "$blocks"
fi

[ $bad -eq 0 ] && echo "docs check: ok"
exit $bad
