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
"

SDK_EXTRA_TOOLS += "nativesdk-cmake nativesdk-ninja \
    nativesdk-wayland-dev \
    "

