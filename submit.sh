#! /bin/sh

set -e
. "$(dirname "$0")/.env"

SUBMIT_KEY="-----BEGIN PGP MESSAGE-----

hQEMA9Xz9e7smekIAQf9HzSz+sl5KnFkIo7cPqPSt6ljgXPY6Ztgrpo/V7d29m2V
XIaNpXp2ZB40CUDOVQFCk16mojVz/A5k1RUPnTzZhFsUWCJR/kvij4U+5QwbAf6z
8iMVZmrIq3+VAadddj0sViTRh+Pp7pSPv4kDvPJYtZFSRclgdJt3c8jrODACvkUy
Kcma+lWBEknfsnyDoXtd4TcklGUfOc5YfmQXyR77h7Iui46SiQrzSHQ0awxkL6ip
E66iNEtm1jCO6DaeUTORtdS5S3UWc+w8/28avUzYaL01U36kIsqbuTuWH2AdbhHd
RJUxFn6pa3xJGkLTsbDTuYlnGuqsA7fZ+hPIWr8B49JPAZlir79qBgdRmED2r2Sx
aY4ysaYKoMnA6tl08pDdPxJLZ2UpXHWHC+8mrMrpYITdhJzKuvk9bJpbnqqu9TnB
xzNFmawCnBOlf8TkUIjurg==
=zgGY
-----END PGP MESSAGE-----"
SUBMIT_KEY="$(echo "$SUBMIT_KEY" | gpg -d)"

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
sshpass -p "$SUBMIT_KEY" scp submit/observer.gz ccat3z@172.16.0.232:~/observer.gz

echo -e "\033[34mdone\033[0m"
EOF