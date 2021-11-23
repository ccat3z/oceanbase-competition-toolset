#! /bin/sh

set -e
. "$(dirname "$0")/.env"

benchmark() {
    HOST="$TEST_SERVER_HOST"
    PORT=2188
    USER=root@test
    DB=test
    THREADS=128
    TABLE_SIZE=100000
    TABLES=3
    TIME=300
    REPORT_INTERVAL=10

    ssh -t "$TEST_CLIENT" sysbench \
        --db-ps-mode=disable --mysql-host=$HOST --mysql-port=$PORT \
        --rand-type=uniform --rand-seed=26765 \
        --mysql-user=$USER --mysql-db=$DB \
        --threads=$THREADS \
        --tables=$TABLES --table_size=$TABLE_SIZE \
        --time=$TIME --report-interval=$REPORT_INTERVAL \
        subplan "$@"
}

# Parse args
NEED_SETUP=y
while [ -n "$1" ]; do
    case "$1" in
        --no-setup) NEED_SETUP=n ;;
        --help) log_i "$0 [--no-setup] [--help]"; exit 0 ;;
        *) log_e "Unknown arg: $1"; exit 1;
    esac
    shift
done

if [ "$NEED_SETUP" = "y" ]; then
    "$TOOL_DIR"/build.sh
    obd cluster tenant create ob-benchmark --tenant-name test || true
fi

benchmark cleanup
benchmark prepare
benchmark run