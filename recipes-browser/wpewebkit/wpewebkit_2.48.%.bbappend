FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Add-LAYER_BASED_SVG_ENGINE-envvar_v2.44.patch "

SRCBRANCH:class-devupstream = "main"
SRC_URI:class-devupstream = "git://github.com/WebKit/WebKit.git;protocol=https;branch=${SRCBRANCH} \
                             file://WPEPlatform-Disable-sync-observer-for-Wayland-screen.patch \
                             file://0001-Add-LAYER_BASED_SVG_ENGINE-envvar_v2.50.patch "
SRCREV:class-devupstream = "${AUTOREV}"

PV:class-devupstream = "trunk"

RCONFLICTS:${PN}:class-devupstream = ""

PACKAGECONFIG[sysprof] = "-DUSE_SYSTEM_SYSPROF_CAPTURE=ON, -DUSE_SYSTEM_SYSPROF_CAPTURE=OFF,"

PACKAGECONFIG:append = " experimental-wpe-platform"
PACKAGECONFIG:remove = "speech-synthesis"

TOOLCHAIN:aarch64 = "clang"
LIBCPLUSPLUS:aarch64 = "-stdlib=libc++"
