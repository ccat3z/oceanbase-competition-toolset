#!/bin/bash

set -e
. "$(dirname "$0")/init.sh"

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "$0 [test case...]" >&2
  exit 0
fi

run_in_server
export PATH="/u01/obclient/bin:$PATH"
cd "$TOOL_DIR/test"
mkdir -p tmp var/log
OBMYSQL_PORT="${OB_PORT}" ./mysql_test/mysql-test.sh