DESCRIPTION = "Simple WPE-based web launcher"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=dd93f6e0496294f589c3d561f96ffee4"

inherit meson pkgconfig

DEPENDS = "glib-2.0-native wpewebkit"

SRCREV = "ca6175445ab527ab1318666536061150573adb5c"
SRC_URI = "git://git@github.com/psaavedra/wpe-simple-launcher.git;protocol=ssh;branch=main"

S = "${WORKDIR}/git"

EXTRA_OECMAKE = ""

do_install:append () {
    install -d ${D}/${bindir}/
    install -m 755 ${B}/wpe-simple-launcher ${D}/${bindir}/wpe-simple-launcher
}
