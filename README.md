# Getting the BSP

* Install `repo`:  `apt-get install repo`
* Install the [required Yocto dependencies][yocto-deps] in your system.
* Create your workdir:

  ```bash
  CI_COMMIT_REF_NAME="main"
  YOCTO_RELEASE="kirkstone"

  mkdir -p ~/workdir/wpe-image
  cd ~/workdir/wpe-image
  repo init -u https://github.com/igalia/meta-wpe-image.git -m manifest-${YOCTO_RELEASE}.xml -b $CI_COMMIT_REF_NAME
  repo sync --force-sync
  ```

[yocto-deps]: https://docs.yoctoproject.org/ref-manual/system-requirements.html#required-packages-for-the-build-host

# Activating your work environment

Several environments can be defined your build environment. For example:

* RPI3:

  ```bash
  $ source setup-environment rpi3-mesa-wpe-nightly raspberrypi3-mesa poky-wayland layers.raspberrypi conf.wpe-nightly --update-config
  ```

* RPI4-64 using the propietary graphics stack (vc4graphics):

  ```bash
  $ source setup-environment rpi4-mesa-wpe-nightly raspberrypi4-64-mesa poky-wayland layers.raspberrypi conf.wpe-nightly --update-config
  ```

See more options running the command with no arguments:

```bash
$ source setup-environment
Usage: setup-environment targetname
       setup-environment targetname machine distro bblayers presets --update-config

Targets:

<<new>>
mynewone
...

Machines:

...

Distros:

poky-wayland

Bitbake layers:

...

Presets:

...
```

# Building the image

Once activated your working environment, you can build your target image:

```bash
 $ bitbake-layers show-recipes  "*image*" | grep -B 1 meta-wpe-image
core-image-weston-wpe:
  meta-wpe-image    1.0
...
```

```bash
rm -rf tmp
bitbake core-image-weston-wpe
```

The image will be available in `tmp/deploy/images/<<machine>>/`


# SDK Toolchain


## Preparing the SDK Toolchain

The following steps are for a Wandboard+mesa but you can reuse it with small changes for any other machine variant:

```bash
source setup-environment wandboard-mesa-wpe-base-trunk raspberrypi3-mesa poky-wayland layers.raspberrypi conf.wpe-nightly --update-config
rm -rf tmp
bitbake core-image-wpe-base -c populate_sdk
# The resulting image:
ls ./tmp/deploy/sdk/poky-wayland-*-raspberrypi3-mesa-toolchain-*.sh
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

## Running Cog browser:

* Cog with FDO backend in Weston: `/usr/bin/cog-fdo-exported-wayland https://wpewebkit.org`
* Cog with DRM backend directly in framebuffer: `/usr/bin/cog-drm-kill-weston https://wpewebkit.org`

All this commands will execute the browsers as `weston` user.

## How to contribute

Contributions are welcomed. Please send your patches as
[Pull Requests](https://github.com/Igalia/meta-wpe-image/pulls) or fill a
[Issue report](https://github.com/Igalia/meta-wpe-image/issues) in case you need
to ask for help.
