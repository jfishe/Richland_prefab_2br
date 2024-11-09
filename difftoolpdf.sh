#!/usr/bin/env bash
# Requires:
#   git
#   latexdiff
#   latexmk

# Usage: difftoolpdf.sh <old> [<new>]
# Old and new can be any commit reference recognized by git checkout.
# E.g., difftoolpdf.sh v1.0 v1.1
# If <new> is omitted, use the current branch & commit.

# the directory of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# the temp directory used, within $DIR
# omit the -p parameter to create a temporal directory in the default location
WORK_DIR=`mktemp -d -p "$DIR"`

# check if tmp dir was created
if [[ ! "$WORK_DIR" || ! -d "$WORK_DIR" ]]; then
  echo "Could not create temp dir"
  exit 1
fi

# deletes the temp directory
function cleanup {
  rm -rf "$WORK_DIR"
  echo "Deleted temp working directory $WORK_DIR"
}

# register the cleanup function to be called on the EXIT signal
trap cleanup EXIT


git worktree add $WORK_DIR/old --no-checkout --detach
cd $WORK_DIR/old
git checkout $1
make tex --quiet
cd $DIR

git worktree add $WORK_DIR/new --no-checkout --detach
cd $WORK_DIR/new
git checkout $2
make tex --quiet
cd $DIR

latexdiff --preamble=pdfcomment.tex \
  $WORK_DIR/old/print/Richland_Prefab_2BR.tex $WORK_DIR/new/print/Richland_Prefab_2BR.tex \
  > $DIR/print/Richland_Prefab_2BR_diff.tex

git worktree remove $WORK_DIR/old
git worktree remove $WORK_DIR/new

cd $DIR/print
latexmk -quiet -xelatex Richland_Prefab_2BR_diff.tex
latexmk -c
