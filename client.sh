#! /bin/sh

set -e
. "$(dirname "$0")/init.sh"

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "$0 [tenant]" >&2
    exit 0
fi

ssh -t "$TEST_CLIENT" \
    "$OB_CLIENT" -c -uroot@${1:-test} -h"$TEST_SERVER_HOST" -P 2188 test