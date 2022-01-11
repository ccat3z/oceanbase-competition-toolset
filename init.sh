#! /bin/sh

TOOL_PATH="$(realpath "$0")"
TOOL_ARGS="$*"
TOOL_DIR="$(dirname "$TOOL_PATH")"

[ ! -f "${TOOL_DIR}/.env" ] || . "${TOOL_DIR}/.env"

TEST_SERVER_HOST=test-server.comp.oceanbase.com
TEST_SERVER=root@$TEST_SERVER_HOST
TEST_CLIENT=test@test-client.comp.oceanbase.com

OB_CLUSTER_NAME="ob-benchmark"
OB_CLUSTER_SERVER_BINARY_PATH="/var/lib/ob-benchmark/bin/observer"

OB_CLIENT="/u01/obclient/bin/obclient"

log_i() {
    echo "$*" >&2
}

log_e() {
    echo -e "\033[31m$*\033[0m" >&2
}

run_in_server() {
    if [ "$__IN_REMOTE" != "y" ]; then
        sync_tools
        TOOL_IN_TEST_SERVER=${TOOL_REPO_IN_TEST_SERVER}/"$(basename "$TOOL_PATH")"
        # shellcheck disable=2087
        exec ssh -T "$TEST_SERVER" << EOF
export __IN_REMOTE=y
export REPO_DIR="${REPO_IN_TEST_SERVER}"
"${TOOL_IN_TEST_SERVER}" $TOOL_ARGS
EOF
    fi
}

ensure_git_repo() {
    if [ ! -d "$REPO_DIR/.git" ]; then
        log_e "$REPO_DIR should not be a sync source because it is not a git repo. Maybe you should skip the sync step on the server."
        exit 1
    fi
}

sync_tools() {
    (
        cd "${TOOL_DIR}" || exit 1
        rsync -a --delete --progress \
            --include='**.gitignore' \
            --exclude='/.git' '--filter=:- .gitignore' \
            "./" "$TEST_SERVER:$TOOL_REPO_IN_TEST_SERVER" < /dev/null
    ) >&2
}

if [ -z "$REPO_DIR" ]; then
    log_e "\$REPO_DIR is not set"
    exit 1
fi

if [ -d "$REPO_DIR/.git" ]; then
    BRANCH_NAME=$(cd $REPO_DIR && git symbolic-ref --short HEAD)
    test -n "$BRANCH_NAME" || exit 1

    REPO_IN_TEST_SERVER="/root/oceanbase"
    if [ "$BRANCH_NAME" != "master" ]; then
        REPO_IN_TEST_SERVER="${REPO_IN_TEST_SERVER}_${BRANCH_NAME}"
    fi
else # run on test server
    REPO_IN_TEST_SERVER="$REPO_DIR"
fi

TOOL_REPO_IN_TEST_SERVER="/root/ob-comp-tools"