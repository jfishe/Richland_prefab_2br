#!/usr/bin/env bash
# pre-commit hook using ghp-import to push HTML to Github Pages.
# Assumes:
#   HTML exists in docs folder.
#   ghp-import in PATH, e.g., `python -m pip install ghp-import`.
#   `git config ghppages.pathhtml <absolute path>/docs`. Defaults to
#   "$GIT_WORK_TREE/docs".
#   `git config ghppages.push true`. Otherwise skip publishing.

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
  pathhtml=$(git config ghppages.pathhtml || echo "$GIT_WORK_TREE/docs")
  say 'Pushing html to gh-pages...'
  ghp-import -n -o -p -f "$pathhtml"
  say_done
fi
