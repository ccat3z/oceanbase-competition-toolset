#! /bin/sh

set -e
. "$(dirname "$0")/.env"

ensure_git_repo
cd "$REPO_DIR" || exit 1

# Parse args
WATCH=n
while [ -n "$1" ]; do
    case "$1" in
        --watch) WATCH=y ;;
        --help) log_i "$0 [--watch] [--help]"; exit 0 ;;
        *) log_e "Unknown arg: $1"; exit 1;
    esac
    shift
done

while :; do
    log_i "Starting rsync..."
    rsync -a --delete --progress \
        --include='**.gitignore' \
        --exclude='/.git' '--filter=:- .gitignore' \
        . "$TEST_SERVER:$REPO_IN_TEST_SERVER" < /dev/null
    RSYNC_RC=$?

    if [ "$WATCH" != "y" ]; then
        exit "$RSYNC_RC"
    fi
    sleep 2s
done