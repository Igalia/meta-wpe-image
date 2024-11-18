#! /bin/bash

set -e

apt-get update -y
apt-get install -y git ssh \
    build-essential \
    imagemagick tesseract-ocr ghostscript libdmtx0b libzbar0

pip install virtualenv

virtualenv .venv_robot_framework
. ./.venv_robot_framework/bin/activate

# Install Robot depends
pip install gitpython pygithub \
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

tail -f /dev/null
