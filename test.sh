#!/bin/bash

set -e
. "$(dirname "$0")/.env"

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "$0 [test case...]" >&2
  exit 0
fi

run_in_server
cd "$TOOL_DIR"

TEST_TMP_BASE_DIR=$HOME/test_tmp

for dir in /tmp /var/log
do
mkdir -p "$TEST_TMP_BASE_DIR/$dir"
done

TEST_CASES="$*"

for testname in ${TEST_CASES:-test/t/*.test}
do
  case=$(basename "$testname" .test)
  echo "test $case"
  /u01/obclient/bin/mysqltest --host=127.0.0.1 --port=2188 \
    --tmpdir="$TEST_TMP_BASE_DIR/tmp" \
    --logdir="$TEST_TMP_BASE_DIR/var/log" \
    --silent --user=root@test --database=test \
    --timer-file="$TEST_TMP_BASE_DIR/var/log/timer" \
    --tail-lines=20 \
    --test-file="./test/t/${case}.test" \
    --result-file="./test/r/${case}.result"
done
