#! /bin/sh

set -e
. "$(dirname "$0")/init.sh"

run_in_server

obd cluster autodeploy "$OB_CLUSTER_NAME" -c "$TOOL_DIR/deploy.yaml"