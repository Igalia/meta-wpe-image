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

TESTS_DIR="../../robot_framework/tests"

# Select tests to run.
tests() {
    local ret=()

    # Parse arguments.
    ARGS=($@)
    for each in ${ARGS[@]}; do
        testname="$TESTS_DIR/$(basename "$each")"
        ret+=($testname)
    done

    # In case no test set, run all tests.
    if [[ ${#ret[@]} -eq 0 ]]; then
        tests_default
    else
        echo "${ret[@]}"
    fi
}

# Return all tests available.
#
# In the case of RPi3, skip 'motionmark' and 'canvas' tests.
tests_default() {
    local ret=()

    while read testname; do
        if isRPi3; then
            if [[ "$testname" == *motionmark.robot || "$testname" == *canvas.robot ]]; then
                continue
            fi
            ret+=($testname)
        fi
    done <<< $(find $TESTS_DIR -name "*.robot" -print)

    echo "${ret[@]}"
}

# Check host is RPi3.
isRPi3() {
    [[ $(hostname) =~ raspberrypi3 ]]
}

# Run tests.
exec robot --name "WPE image tests" \
           --consolewidth 158 \
           --exclude skip \
           --skiponfailure ignoreonfail \
           --listener RetryFailed:2 \
           $(tests "$@")
