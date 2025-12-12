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
    chromium-driver \
    webkit2gtk-driver

pip install --root-user-action ignore --upgrade pip

# Virtual display webkitgtk local webdriver headless
apt-get install -y xvfb
pip install --root-user-action ignore pyvirtualdisplay

# Install Robot depends
pip install --root-user-action ignore \
    gitpython==3.1.45 \
    pygithub==2.8.1 \
    robotframework==7.3.2 \
    robotframework-doctestlibrary==0.25.0 \
    robotframework-pythonlibcore==4.4.1 \
    robotframework-retryfailed==0.2.0 \
    robotframework-seleniumlibrary==6.8.0 \
    robotframework-sshlibrary==3.8.0

pushd robot_framework/html/
if [ ! -d "rbyers" ]; then
    git clone https://github.com/RByers/rbyers.github.io.git rbyers
fi
popd

rm "$LOCKFILE"

tail -f /dev/null
