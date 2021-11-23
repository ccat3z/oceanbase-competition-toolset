#! /bin/sh

set -e
. "$(dirname "$0")/.env"

ssh -t "$TEST_CLIENT" \
    obclient -uroot@test -h"$TEST_SERVER_HOST" -P 2188 "$@"