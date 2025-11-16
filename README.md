# Getting the BSP

* Install `kas`:  `pip install kas`
* Install the [required Yocto dependencies][yocto-deps] in your system.
* Create your workdir:

  ```bash
  mkdir -p ~/workdir/wpe-image
  cd ~/workdir/wpe-image
  git clone https://github.com/igalia/meta-wpe-image.git
  cd meta-wpe-image
  ```

[yocto-deps]: https://docs.yoctoproject.org/ref-manual/system-requirements.html#required-packages-for-the-build-host

# Build

Several environments can be defined your build environment. For example:

* RPI3:

  ```bash
  export KAS_WORK_DIR="workdir"
  kas build kas.yml:kas/machines/raspberrypi3-mesa.yml:kas/presets/wpe-nightly.yml
  ```

* RPI4-64 using the propietary graphics stack (vc4graphics):

  ```bash
  export KAS_WORK_DIR="workdir"
  kas build kas.yml:kas/machines/raspberrypi4-64-mesa.yml:kas/presets/wpe-nightly.yml
  ```

* RPI5:

  ```bash
  export KAS_WORK_DIR="workdir"
  kas build kas.yml:kas/machines/raspberrypi5.yml:kas/presets/wpe-nightly.yml
  ```

The image will be available in `${KAS_WORK_DIR}build/deploy/images/<<machine>>/`


# SDK Toolchain

## Preparing the SDK Toolchain

The following steps are for a Wandboard+mesa but you can reuse it with small changes for any other machine variant:

```bash
BASE_IMAGE=core-image-wpe-base -c populate_sdk
kas shell kas.yml:kas/machines/raspberrypi3-mesa.yml -c "bitbake ${BASE_IMAGE} -c populate_sdk"
```

The resulting image:

```
ls ${KAS_WORK_DIR}/build/tmp/deploy/sdk/poky-wayland-*-raspberrypi3-mesa-toolchain-*.sh
```

## Installing the SDK Toolchain

```bash
# execute the desired version
./tmp/deploy/sdk/poky-wayland-*-raspberrypi3-mesa-toolchain-*.sh -d ~/toolchain_env -y
```

## Activating the SDK Toolchain

```bash
. ~/toolchain_env/environment-setup-*
```

```bash
$ env | grep OE
...
OECORE_SDK_VERSION=2.6.1
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

## Running WPE launcher:

* Weston: `/usr/bin/wpe-exported-wayland https://wpewebkit.org`
* DRM: `export WPE_DISPLAY="wpe-display-drm"; /usr/bin/wpe-exported-wayland https://wpewebkit.org`

## How to contribute

Contributions are welcomed. Please send your patches as
[Pull Requests](https://github.com/Igalia/meta-wpe-image/pulls) or fill a
[Issue report](https://github.com/Igalia/meta-wpe-image/issues) in case you need
to ask for help.
