#!/bin/bash
set -euo pipefail

# Obtain system architecture from podman info or fallback to uname
_ARCH=$(podman info | grep arch | awk '{ print $2 }')
ARCH=${ARCH:-$_ARCH}

# Variables with defaults, override by environment if set
PYTHON_RELEASE=${PYTHON_RELEASE:-stable}
VERSION=$(git describe --dirty --always)
REGISTRY=${REGISTRY:-docker.io}
REGISTRY_USER=${REGISTRY_USER:-user}
REGISTRY_PASSWORD=${REGISTRY_PASSWORD:-password}
REGISTRY_PATH=${REGISTRY_PATH:-igalia}
IMAGE=${IMAGE:-meta-wpe-image-ci-robot}
IMAGE_DOCKER="docker://${REGISTRY}/${REGISTRY_PATH}/${IMAGE}:${PYTHON_RELEASE}-${ARCH}"

# Ensure containers config directory exists and write registries.conf securely
mkdir -p ~/.config/containers
cat > ~/.config/containers/registries.conf << EOF
unqualified-search-registries = ['${REGISTRY}']
EOF

# Start and build containers
./podman-compose.sh up --force-recreate --always-recreate-deps --build -d

# Container and lock file variables
container=ci_robot_1
lockfile=/tmp/init-robot.lock

# Wait for container initialization indicated by presence of lock file
while podman exec "$container" test -f "$lockfile"; do
  echo "Waiting for container init to finish..."
  sleep 20
done

# Commit container state to image
podman commit "$container" meta-wpe-image-ci-robot

# Login to container registry securely using --password-stdin
echo "${REGISTRY_PASSWORD}" | podman login -u "${REGISTRY_USER}" --password-stdin "${REGISTRY}"

# Push images to registry
podman push "${IMAGE}" "${IMAGE_DOCKER}"
podman push "${IMAGE}" "${IMAGE_DOCKER}-${VERSION}"

# Summary output
echo
echo "🚀 >>> Pushed Docker image:"
echo "    📦 Registry: ${REGISTRY}"
echo "    🖥️ Platform: ${ARCH}"
echo "    🏷️ Images: ${IMAGE_DOCKER} (${IMAGE_DOCKER}-${VERSION})"

