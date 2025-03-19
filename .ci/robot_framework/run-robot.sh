#! /bin/bash

set -e

. ./.venv_robot_framework/bin/activate

SETUPENV="./setup-env.sh"

if [ ! -e "${SETUPENV}" ]
then
    echo "${SETUPENV} not found in the current path (${PWD})"
    exit 1
fi

# shellcheck source=./setup-env.sh
. ${SETUPENV}

DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p "tests_results/${DATE}_robot_${TESTS_RESULTS}/"

rm -rf tests_results/robot
ln -s "${DATE}_robot_${TESTS_RESULTS}" tests_results/robot
cd "tests_results/${DATE}_robot_${TESTS_RESULTS}/"

# Copy the setup-env files.
cp ../../setup-env*sh .

if [[ "${TEST_BOARD_SETUP_SKIP}" != "yes" ]]
then
    ../../prepare-board.sh
fi

exec robot --name "WPE image tests" \
           --consolewidth 158 \
           --exclude skip \
           --test "Verify Full HD 30 FPS" \
           --skiponfailure ignoreonfail \
           --listener RetryFailed:2 \
           ../../robot_framework/tests/tests_*.robot

