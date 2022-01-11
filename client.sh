#! /bin/sh

set -e
. "$(dirname "$0")/init.sh"

ssh -t "$TEST_CLIENT" \
    "$OB_CLIENT" -c -uroot@${1:-test} -h"$TEST_SERVER_HOST" -P 2188 test