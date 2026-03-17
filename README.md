# WPE Image meta layer for Yocto

This repository provides build configurations for generating WPE images using
the Yocto Project and kas. It supports multiple target devices (e.g. Raspberry
Pi 3, 4, and 5) and includes instructions for building an SDK toolchain.

# Getting the BSP

1. Install `kas` and the container engine:

   ```sh
   # default:
   sudo apt-get install docker-ce
   # alternative option:
   sudo apt-get install podman
   export KAS_CONTAINER_ENGINE=podman
   ```

   ```sh
   sudo apt-get install pipx
   pipx install kas>=5.0
   ```

1. Create your workdir:

   ```sh
   mkdir -p ~/workdir/wpe-image
   cd ~/workdir/wpe-image
   git clone https://github.com/igalia/meta-wpe-image.git
   cd meta-wpe-image
   ```

# Building the image

1. Define external paths for the download and the shared state cached dirs:

   ```sh
   export DL_DIR=$PWD/../cache/downloads/
   export SSTATE_DIR=$PWD/../cache/sstate-cache/
   ```

1. Build your target enviroment. Examples:

   * RPI3:

     ```sh
     export KAS_WORK_DIR="workdir/wpe-image-rpi3"
     mkdir -p ${KAS_WORK_DIR}
     kas-container build kas.yml:kas/machines/raspberrypi3-mesa.yml:kas/presets/wpe-nightly.yml
     ```

   * RPI4-64 using the propietary graphics stack (vc4graphics):

     ```sh
     export KAS_WORK_DIR="workdir/wpe-image-rpi4-64"
     mkdir -p ${KAS_WORK_DIR}
     kas-container build kas.yml:kas/machines/raspberrypi4-64-mesa.yml:kas/presets/wpe-nightly.yml
     ```

   * RPI5:

     ```sh
     export KAS_WORK_DIR="workdir/wpe-image-rpi5"
     mkdir -p ${KAS_WORK_DIR}
     kas-container build kas.yml:kas/machines/raspberrypi5.yml:kas/presets/wpe-nightly.yml
     ```

💡 **Tip**: Check the `kas/machines/` directory for additional target configurations.

After the build completes, the generated image will be located at:
`${KAS_WORK_DIR}/build/deploy/images/<<machine>>/`

# SDK Toolchain

1. Preparing the SDK Toolchain

   The following example targets `raspberrypi3-mesa`, but the same steps apply
   to other machines with minor adjustments.

   ```sh
   export KAS_WORK_DIR="workdir/wpe-image"
   BASE_IMAGE=core-image-wpe-base
   kas-container shell kas.yml:kas/machines/raspberrypi3-mesa.yml -c "bitbake ${BASE_IMAGE} -c populate_sdk"
   ```

   Check the resulting SDK installer:

   ```sh
   ls ${KAS_WORK_DIR}/build/tmp/deploy/sdk/poky-wayland-*-raspberrypi3-mesa-toolchain-*.sh
   ```

2. Installing the SDK Toolchain

   ```sh
   # execute the desired version
   ./tmp/deploy/sdk/poky-wayland-*-raspberrypi3-mesa-toolchain-*.sh -d ~/toolchain_env -y
   ```

3. Activate the SDK Toolchain

   ```sh
   . ~/toolchain_env/environment-setup-*
   ```

   Expected output includes variables such as:

   ```sh
   $ env | grep OE
   ...
   OECORE_NATIVE_SYSROOT="${HOME}"/toolchain_env/sysroots/x86_64-pokysdk-linux
   OECORE_TARGET_OS=linux-gnueabi
   OECORE_TARGET_ARCH=arm
   ...

   $ env | grep poky
   ...
   CC=arm-poky-linux-gnueabi-gcc  ...
   CXX=arm-poky-linux-gnueabi-g++ ...
   ...
   ```

# Running WPE launcher:

* Weston: `/usr/bin/wpe-exported-wayland https://wpewebkit.org`
* DRM: `export WPE_DISPLAY="wpe-display-drm"; /usr/bin/wpe-exported-wayland https://wpewebkit.org`

# How to contribute

Contributions are welcomed!. Please send your patches as
[Pull Requests](https://github.com/Igalia/meta-wpe-image/pulls) or fill a
[Issue report](https://github.com/Igalia/meta-wpe-image/issues) in case you need
to ask for help.

Please follow standard Yocto contribution guidelines and ensure patches are
well‑tested before submission.
