#! /bin/sh

set -e
. "$(dirname "$0")/init.sh"

# Parse args
NEED_SYNC=y
NEED_INIT=n
NEED_SETUP=y
RESTART_METHOD=restart
while [ -n "$1" ]; do
    case "$1" in
        --no-sync) NEED_SYNC=n ;;
        --init) NEED_INIT=y ;;
        --no-setup) NEED_SETUP=n ;;
        --redeploy) RESTART_METHOD=redeploy ;;
        --help) log_i "$0 [--no-sync] [--init] [--no-setup] [--help]"; exit 0 ;;
        *) log_e "Unknown arg: $1"; exit 1;
    esac
    shift
done

[ "$NEED_SYNC" = "y" ] && "$TOOL_DIR"/sync.sh

# shellcheck disable=SC2087
ssh -t "$TEST_SERVER" sh -e << EOF
    cd "$REPO_IN_TEST_SERVER" || exit 1

    umask 000 # Inherit directory mode (for public ccache)
    [ "$NEED_INIT" = "y" ] && ./build.sh release --init
    ./build.sh release -DOB_USE_CCACHE=ON --make

    if [ "$NEED_SETUP" = "y" ]; then
        echo "Setup..."
        obd cluster stop "$OB_CLUSTER_NAME"
        cp \$PWD/build_release/src/observer/observer "$OB_CLUSTER_SERVER_BINARY_PATH"
        obd cluster $RESTART_METHOD "$OB_CLUSTER_NAME"
        obd cluster tenant create ob-benchmark --tenant-name test || true
    fi
EOF