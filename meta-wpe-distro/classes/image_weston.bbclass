DESCRIPTION += " with Weston"

IMAGE_FEATURES += "weston"

REQUIRED_DISTRO_FEATURES = "opengl wayland"

IMAGE_INSTALL:append = " \
    waylandeglinfo \
    weston \
    weston-init \
    weston-examples \
"

SDK_EXTRA_TOOLS += "nativesdk-cmake nativesdk-ninja \
    nativesdk-wayland-dev \
    "

