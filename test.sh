#!/bin/bash

set -e
. "$(dirname "$0")/init.sh"

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "$0 [test case...]" >&2
  exit 0
fi

run_in_server
export PATH="/u01/obclient/bin:$PATH"
OB_PORT=2188

# Prepare ob cluster
obd cluster redeploy "$OB_CLUSTER_NAME"
obd cluster tenant create ob-benchmark --tenant-name mysql

log_i "create user admin@sys..."
obclient -uroot@sys -h 127.0.0.1 -P "$OB_PORT" <<EOF
CREATE USER 'admin' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON *.* TO admin WITH GRANT OPTION;
EOF

log_i "create user admin@mysql..."
obclient -uroot@mysql -h 127.0.0.1 -P "$OB_PORT" <<EOF
CREATE USER 'admin' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON *.* TO admin WITH GRANT OPTION;
EOF

# Prepare test file
cd "$TOOL_DIR/test"
mkdir -p tmp var/log

# Run test
if [ -n "$1" ]; then
  OBMYSQL_PORT="${OB_PORT}" ./mysql_test/mysql-test.sh -s "$1"
else
  OBMYSQL_PORT="${OB_PORT}" ./mysql_test/mysql-test.sh
fi