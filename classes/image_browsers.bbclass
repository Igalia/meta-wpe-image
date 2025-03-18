DESCRIPTION += " for browsers"
LICENSE = "MIT"

IMAGE_FEATURES += "splash package-management hwcodecs ssh-server-openssh"

inherit core-image features_check extrausers

IMAGE_LINGUAS = "en-us es-es"
GLIBC_GENERATE_LOCALES = "en_US.UTF-8 es_ES.UTF-8"

# IMAGE_OVERHEAD_FACTOR = "1.5"
# IMAGE_ROOTFS_EXTRA_SPACE = "2097152"

IMAGE_FSTYPES = "wic.bmap wic.bz2 tar.gz"

EXTRA_USERS_PARAMS += "usermod -a -G systemd-journal bot; usermod -a -G systemd-journal weston;"

EXTRA_IMAGE_FEATURES .= " debug-tweaks"
## EXTRA_IMAGE_FEATURES .= " debug-tweaks dbg-pkgs tools-debug tools-profile"
# By default, the Yocto build system strips symbols from the binaries it
# packages, which makes it difficult to use some of the tools.
#
# You can prevent that by setting the INHIBIT_PACKAGE_STRIP variable to "1" in
# your local.conf when you build the image:
# INHIBIT_PACKAGE_STRIP = "1"

IMAGE_INSTALL:append = " \
    libtasn1 git htop nano strace bridge-utils \
    ntp curl dhcpcd lzo \
    alsa-tools \
    alsa-utils-alsamixer \
    alsa-utils-alsatplg \
    alsa-utils-midi \
    alsa-utils-aplay \
    alsa-utils-amixer \
    alsa-utils-aconnect \
    alsa-utils-speakertest \
    alsa-utils-alsactl \
    alsa-utils-alsaloop \
    apache2 apache2-scripts \
    configure-scripts \
    cpupower cpupower-init \
    dbus \
    e2fsprogs-e2fsck e2fsprogs-mke2fs e2fsprogs-tune2fs e2fsprogs-badblocks e2fsprogs-resize2fs \
    gdb \
    gdbserver \
    glmark2 \
    gstreamer1.0-libav \
    mesa-demos \
    packagegroup-core-full-cmdline \
    parted pv \
    perf \
    python3-uinput \
    openssh-sftp \
    openssh-sftp-server \
    smem \
    stress-ng \
    systemd-analyze \
    valgrind \
    weston-xwayland \
    wpe-testbed \
    "

# Dependencies for graphic demos based on Vulkan
IMAGE_INSTALL:append = " \
    assimp \
    glfw \
    glm \
    vulkan-headers \
    libsdl2-image \
    "

# PulseAudio. Needed for RPI4 (`dtoverlay=vc4-kms-v3d`) because the ALSA
# compatibility is disabled (`snd_bcm2835.enable_compat_alsa=0`) so the
# sound is processed using Pulseaudio through the user D-Bus session
PULSEAUDIO_INSTALL= " \
    libcap \
    libpulse \
    libpulsecore \
    libsndfile1 \
    pulseaudio-server \
    pulseaudio-module-loopback \
    pulseaudio-misc \
    pulseaudio-module-cli \
    pulseaudio-module-dbus-protocol \
    libasound \
    sbc \
"
IMAGE_INSTALL:append:raspberrypi4 = " ${PULSEAUDIO_INSTALL}"
IMAGE_INSTALL:append:raspberrypi4-64 = " ${PULSEAUDIO_INSTALL}"
IMAGE_INSTALL:append:raspberrypi5 = " ${PULSEAUDIO_INSTALL}"

# Add podman only for ARM64 bits arch
IMAGE_INSTALL:append:aarch64 = " podman"

# Add perf only for ARM64 bits arch
IMAGE_INSTALL:append:aarch64 = " \
    perf \
    perf-scripts \
"

SDK_EXTRA_TOOLS += "nativesdk-cmake nativesdk-ninja \
    nativesdk-perl-module-findbin \
    nativesdk-perl-misc \
    nativesdk-gperf \
    nativesdk-unifdef \
    "

TOOLCHAIN_HOST_TASK:append = "${SDK_EXTRA_TOOLS}"
TOOLCHAIN_TARGET_TASK:append = " openjpeg-staticdev"
TOOLCHAIN_TARGET_TASK:append = " libjxl"
TOOLCHAIN_TARGET_TASK:remove = "target-sdk-provides-dummy"

PACKAGECONFIG:append:pn-php = " apache2"

# Allow dropbear/openssh to accept root logins if debug-tweaks or allow-root-login is enabled
ROOTFS_POSTPROCESS_COMMAND += "ssh_internal_sftp; "

#
# Set a valid internal-sftp
#
ssh_internal_sftp () {
        for config in sshd_config sshd_config_readonly; do
                if [ -e ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config ]; then
                        sed -i 's/^[#[:space:]]*Subsystem sftp.*/Subsystem sftp internal-sftp/' ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config
                fi
        done
}

