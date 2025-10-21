#!/bin/sh

################################################################################
# Environment variables definitions
#################################################################################

# export TEST_BOARD_SETUP_SKIP="yes"

export TEST_BOARD_WEBDRIVER_PORT="8888"

export TEST_BOARD_IP="192.168.1.105"
export TEST_BOARD_NAME="rpi5"

export TEST_WEBSERVER_IP="192.168.1.92"
export TEST_WEBSERVER_PORT="8008"

export TEST_WEBKIT_INSPECTOR_HTTP_SERVER_PORT="22322"

################################################################################
# Load local setup
#################################################################################

# XXX: Get the basepath from the environment
SETUPENVLOCAL="setup-env-local.sh"
APPBASEPATH="/app"
APPSETUPENVLOCAL="${APPBASEPATH}/${SETUPENVLOCAL}"

if [ -f "${APPSETUPENVLOCAL}" ]; then
    # shellcheck source=./setup-env.sh
    . "${APPSETUPENVLOCAL}"
elif [ -f "${SETUPENVLOCAL}" ]; then
    # shellcheck source=./setup-env.sh
    . "./${SETUPENVLOCAL}"
else
    echo "WARNING: Not ${APPSETUPENVLOCAL} nor ${SETUPENVLOCAL} found"
fi

