DESCRIPTION += "with Weston"

# nooelint: oelint.vars.outofcontext
IMAGE_FEATURES += "weston"

REQUIRED_DISTRO_FEATURES = "opengl polkit wayland"

IMAGE_INSTALL:append = " \
    polkit \
    waylandeglinfo \
    weston \
    weston-init \
    weston-examples \
    weston-xwayland \
"

inherit extrausers

# Add the weston-init users (weston, plus the bot user created by the
# weston-init bbappend) to systemd-journal. Kept at image-assembly time via
# EXTRA_USERS_PARAMS, not weston-init useradd, because the systemd-journal
# group is not guaranteed to exist when the recipe-level useradd runs.
EXTRA_USERS_PARAMS += "usermod -a -G systemd-journal bot; usermod -a -G systemd-journal weston;"

SDK_EXTRA_TOOLS += "nativesdk-cmake nativesdk-ninja \
    nativesdk-wayland-dev \
    "

