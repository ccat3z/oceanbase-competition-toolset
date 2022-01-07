#! /bin/sh

TEST_SERVER_HOST=test-server.comp.oceanbase.com
TEST_SERVER=root@$TEST_SERVER_HOST
TEST_CLIENT=test@test-client.comp.oceanbase.com

TOOL_PATH="$(realpath "$0")"
TOOL_ARGS="$*"
TOOL_DIR="$(dirname "$TOOL_PATH")"
REPO_DIR="$(realpath "${TOOL_PATH%tools/competition/*}")"

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
        TOOL_SHA="$(sha256sum < "$TOOL_PATH")"
        TOOL_IN_TEST_SERVER=${REPO_IN_TEST_SERVER}/tools/competition/${TOOL_PATH##*tools/competition/}
        # shellcheck disable=2087
        exec ssh -T "$TEST_SERVER" << EOF
TOOL_SHA_IN_TEST_SERVER=\$(sha256sum < $TOOL_IN_TEST_SERVER)
if [ "$TOOL_SHA" != "\$TOOL_SHA_IN_TEST_SERVER" ]; then
    echo "Tool on test server is outdated, please sync manually." >&2
    exit 1
fi

export __IN_REMOTE=y
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

if [ -d "$REPO_DIR/.git" ]; then
    BRANCH_NAME=$(git symbolic-ref --short HEAD)
    test -n "$BRANCH_NAME" || exit 1

    REPO_IN_TEST_SERVER="/root/oceanbase"
    if [ "$BRANCH_NAME" != "master" ]; then
        REPO_IN_TEST_SERVER="${REPO_IN_TEST_SERVER}_${BRANCH_NAME}"
    fi
else # run on test server
    REPO_IN_TEST_SERVER="$REPO_DIR"
fi