#!/bin/sh

fatal() {
    echo "$@"
    exit 1
}

show_help() {
    cat<<EOF
Usage: $(basename "$0") [options] [TESTNAME...]
Options:
  --force-recreate Recreate and build containers before running tests
  --help Show this help message
EOF
}

TESTS_PATH="$(git rev-parse --show-toplevel)/.ci/robot_framework/tests/"

# Check arguments
force_recreate=false

ARGS=""
for arg in "$@"; do
    case $arg in
        --force-recreate)
            force_recreate=true
            ;;
        --help)
            show_help
            exit 0
            ;;
        --*)
            echo "Unknown option: $arg"
            show_help
            exit 1
            ;;
        *)
            if ! test -f "$arg" && ! test -f "$TESTS_PATH/$arg"; then
                fatal "File not found: '$arg'"
            fi
            ARGS="$ARGS $arg"
            ;;
    esac
done

# Run podman-compose only if --force-recreate is specified
if [ "$force_recreate" = true ]; then
    ./podman-compose.sh up --force-recreate --always-recreate-deps --build -d -t 4 > /dev/null 2>&1
fi

# Run the test script
podman exec -ti ci_robot_1 ./robot_framework/run-robot.sh "$ARGS"
