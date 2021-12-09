#! /bin/sh

set -e
. "$(dirname "$0")/.env"

benchmark() {
    HOST="$TEST_SERVER_HOST"
    PORT=2188
    USER=root@test
    DB=test
    THREADS=128
    TABLES=3
    # TIME=300
    REPORT_INTERVAL=10

    ssh -t "$TEST_CLIENT" sysbench \
        --db-ps-mode=disable --mysql-host=$HOST --mysql-port=$PORT \
        --rand-type=uniform --rand-seed=26765 \
        --mysql-user=$USER --mysql-db=$DB \
        --threads=$THREADS \
        --tables=$TABLES --table_size=$TABLE_SIZE \
        --warmup-time=$WARMUP_TIME \
        --time=$TIME --report-interval=$REPORT_INTERVAL \
        subplan "$@"
}

# Parse args
NEED_SETUP=y
NEED_RESTART=n
WARMUP_TIME=30
TIME=300
TABLE_SIZE=100000
while [ -n "$1" ]; do
    case "$1" in
        --no-setup) NEED_SETUP=n ;;
        --time) TIME=$2; shift;;
        --restart) NEED_RESTART=y;;
        --skip-warmup) WARMUP_TIME=0;;
        --size) TABLE_SIZE=$2; shift;;
        --help) log_i "$0 [--no-setup] [--time second] [--restart] [--skip-warmup] [--size table_size] [--help]"; exit 0 ;;
        *) log_e "Unknown arg: $1"; exit 1;
    esac
    shift
done

if [ "$NEED_SETUP" = "y" ]; then
    "$TOOL_DIR"/build.sh
    sleep 5s
elif [ "$NEED_RESTART" = "y" ]; then
    # shellcheck disable=SC2029
    ssh "$TEST_SERVER" \
        obd cluster restart "$OB_CLUSTER_NAME"
    sleep 5s
fi

benchmark cleanup
benchmark prepare
benchmark run