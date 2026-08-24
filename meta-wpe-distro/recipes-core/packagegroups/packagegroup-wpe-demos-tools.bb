SUMMARY = "WPE demo image dev, debug and utility tools"
DESCRIPTION = "Development, debugging and system utility tools installed on \
the WPE demo images (debuggers, profilers, ALSA and network utilities, etc.)."

# Pulls machine-specific packages (perf, cpupower), so keep it per-machine
# instead of allarch, following oe-core packagegroup-core-tools-profile.
PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS:${PN} = "\
    alsa-tools \
    alsa-utils-aconnect \
    alsa-utils-alsactl \
    alsa-utils-alsaloop \
    alsa-utils-alsamixer \
    alsa-utils-alsatplg \
    alsa-utils-amixer \
    alsa-utils-aplay \
    alsa-utils-midi \
    alsa-utils-speakertest \
    apache2 \
    apache2-scripts \
    bridge-utils \
    configure-scripts \
    cpupower \
    cpupower-init \
    curl \
    dbus \
    dhcpcd \
    e2fsprogs-badblocks \
    e2fsprogs-e2fsck \
    e2fsprogs-mke2fs \
    e2fsprogs-resize2fs \
    e2fsprogs-tune2fs \
    gdb \
    gdbserver \
    git \
    gstreamer1.0-libav \
    htop \
    libtasn1 \
    lzo \
    nano \
    ntp \
    packagegroup-core-full-cmdline \
    parted \
    perf \
    pv \
    python3-uinput \
    smem \
    strace \
    stress-ng \
    systemd-analyze \
    valgrind \
    wpe-testbed \
"
