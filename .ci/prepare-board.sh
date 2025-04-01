#! /bin/bash

set -eu

BASEPATH="$(dirname "$(readlink -f "$0")")"

SETUPENV="${BASEPATH}/setup-env.sh"

if [ ! -e "${SETUPENV}" ]
then
    echo "Please, create a ${SETUPENV} to run this command"
    exit 1
fi

# shellcheck source=./setup-env.sh
. "${SETUPENV}"

sshi() {
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "root@${TEST_BOARD_IP}" "$@"
}

scpi() {
    scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -r "$@" "root@${TEST_BOARD_IP}":
}

pushd "${BASEPATH}"
scpi scripts
scpi tests-baselines
popd

sshi "/usr/bin/kill-demo || true"
