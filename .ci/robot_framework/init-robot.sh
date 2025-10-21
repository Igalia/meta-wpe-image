#! /bin/bash

LOCKFILE="/tmp/init-robot.lock"

# Create lock and ensure removal on exit
trap 'rm -f "$LOCKFILE"' EXIT
if [ -e "$LOCKFILE" ]; then
    echo "Script is already running. Exiting."
    exit 1
fi
touch "$LOCKFILE"

set -e

apt-get update -y
apt-get install -y git ssh \
    build-essential \
    imagemagick tesseract-ocr ghostscript libdmtx0b libzbar0 \
    chromium-driver

pip install --root-user-action ignore --upgrade pip

# Install Robot depends
pip install --root-user-action ignore \
            gitpython pygithub \
            robotframework \
            robotframework-doctestlibrary \
            robotframework-retryfailed \
            robotframework-seleniumlibrary \
            robotframework-sshlibrary

pushd robot_framework/html/
if [ ! -d "rbyers" ]; then
    git clone https://github.com/RByers/rbyers.github.io.git rbyers
fi
popd

rm "$LOCKFILE"

tail -f /dev/null
