#! /bin/sh -e

# Identify the Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
else
    echo "Distribution identification file /etc/os-release is missing."
    exit 1
fi

# Function to install podman-compose on Fedora
install_fedora() {
    echo "Installing podman-compose on Fedora..."
    sudo yum install -y podman-compose pycodestyle python3-pyflakes shellcheck
}

# Function to install podman-compose on Debian or Ubuntu
install_debian_ubuntu() {
    echo "Installing podman-compose on $NAME..."
    sudo apt update
    sudo apt install -y podman-compose pycodestyle pyflakes3 shellcheck
}

# Installation process based on the identified distribution
case $ID in
    fedora)
        install_fedora
        ;;
    ubuntu | debian)
        install_debian_ubuntu
        ;;
    *)
        echo "Your distribution ($ID) is not supported by this script."
        exit 2
        ;;
esac

