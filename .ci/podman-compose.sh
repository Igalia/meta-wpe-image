#! /bin/sh

set -e

if [ ! -e ./setup-env.sh ]
then
    echo "Please, create a ./setup-env.sh to run this command"
    exit 1
fi

. ./setup-env.sh
exec podman-compose "$@"
