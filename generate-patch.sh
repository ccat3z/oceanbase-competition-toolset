#! /bin/bash

set -e
. "$(dirname "$0")/init.sh"

ensure_git_repo

if [ -z "$CHORE_BRANCH" ]; then
    CHORE_BRANCH=chore
fi

if git branch --contains="$CHORE_BRANCH" | not grep -q '^\*'; then
    echo "current branch dosen't contain $CHORE_BRANCH" >&2
    exit 1
fi

git diff "$CHORE_BRANCH"