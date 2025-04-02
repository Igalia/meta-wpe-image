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

# Set tests to run.
TESTS_DIR="../../robot_framework/tests"
TESTS=()

ARGS=($@)
for each in ${ARGS[@]}; do
    testname="$TESTS_DIR/$(basename "$each")"
    TESTS+=($testname)
done

# In case no test set, run all tests.
if [[ ${#TESTS[@]} -eq 0 ]]; then
    TESTS+=("$TESTS_DIR/tests_*.robot")
fi

# Run tests.
exec robot --name "WPE image tests" \
           --consolewidth 158 \
           --exclude skip \
           --skiponfailure ignoreonfail \
           --listener RetryFailed:2 \
           "${TESTS[@]}"
