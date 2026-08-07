#!/usr/bin/env bash
# Deploy step invoked by `make publish` to push HTML to Github Pages via
# ghp-import (run standalone through uv, not installed as a project dep).
# Assumes:
#   HTML exists in docs folder.
#   uv in PATH to run ghp-import (`uvx ghp-import`).
#   `git config ghppages.pathhtml <absolute path>/docs`. Defaults to
#   "<repo toplevel>/docs".
#   `git config ghppages.push true`. Otherwise skip publishing.

set -euo pipefail

if git config --get-colorbool color.interactive
then
  # See https://github.com/vimwiki/vimwiki/blob/master/doc/logo.svg
  say_prefix='\e[90mghp\e[92m|\e[37mimport\e[0m'
else
  say_prefix='ghp-import'
fi

say () {
  printf '%b: %s' "$say_prefix" "$*"
}

say_done () {
  printf 'done.\n'
}

# Update gh-pages
if test "$(git config --bool ghppages.push || echo false)" = true
then
  pathhtml=$(git config ghppages.pathhtml || echo "$(git rev-parse --show-toplevel)/docs")
  say 'Pushing html to gh-pages...'
  uvx ghp-import -n -o -p -f "$pathhtml"
  say_done
fi
