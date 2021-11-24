#! /bin/sh

set -e
. "$(dirname "$0")/.env"

run_in_server

PID=$(pgrep observer)
if [ ${#PID} -eq 0 ]
then
    echo "observer not running"
    exit 1
fi

CACHE_DIR=$HOME/.cache/oceanbase-perf
[ -d "$CACHE_DIR" ] || mkdir -p "$CACHE_DIR"
cd "$CACHE_DIR"

RECORD_DURATION=${1:-5}

set -x
perf record -F 99 --call-graph fp -p "$PID" --proc-map-timeout 5000 \
    -o perf.data -- sleep "$RECORD_DURATION"
perf script -i perf.data > perf.unfold
"$TOOL_DIR/stackcollapse-perf.pl" perf.unfold > perf.folded
"$TOOL_DIR/flamegraph.pl" perf.folded
