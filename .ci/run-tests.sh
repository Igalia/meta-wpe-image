#!/bin/sh

show_help() {
    cat<<EOF
Usage: $(basename "$0") [options]
Options:
  --force-recreate Recreate and build containers before running tests
  --help Show this help message
EOF
}

# Check arguments
force_recreate=false

for arg in "$@"; do
    case $arg in
        --force-recreate)
            force_recreate=true
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $arg"
            show_help
            exit 1
            ;;
    esac
done

# Run podman-compose only if --force-recreate is specified
if [ "$force_recreate" = true ]; then
    ./podman-compose.sh up --force-recreate --always-recreate-deps --build -d -t 4 > /dev/null 2>&1
fi

# Run the test script
podman exec -ti ci_robot_1 ./robot_framework/run-robot.sh


