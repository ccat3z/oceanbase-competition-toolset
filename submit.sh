#! /bin/sh

set -e
. "$(dirname "$0")/.env"

cd "${REPO_DIR}"
"${TOOL_DIR}/build.sh" --no-setup

# shellcheck disable=2087
ssh -t "$TEST_SERVER" sh -e <<EOF
cd "${REPO_IN_TEST_SERVER}" || exit 1
rm -rf submit
mkdir submit

echo -e "\033[34mstrip...\033[0m"
strip build_release/src/observer/observer -o submit/observer || exit 1

echo -e "\033[34mgzip...\033[0m"
gzip submit/observer || exit 1

echo -e "\033[34msubmit...\033[0m"
scp submit/observer.gz ccat3z@172.16.0.232:~/observer.gz

echo -e "\033[34mdone\033[0m"
EOF