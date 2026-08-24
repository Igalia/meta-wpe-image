SUMMARY = "Simple WPE-based web launcher"
DESCRIPTION = "On-device WPEWebKit launcher that opens a URL and exposes a FIFO control channel through the wpe-ctl helper."
HOMEPAGE = "https://github.com/psaavedra/wpe-simple-launcher"

# nooelint: oelint.vars.fileextrapaths oelint.vars.outofcontext
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=dd93f6e0496294f589c3d561f96ffee4"

inherit meson pkgconfig

# nooelint: oelint.vars.dependsappend
DEPENDS = "glib-2.0-native wpewebkit"

SRC_URI = "git://git@github.com/psaavedra/wpe-simple-launcher.git;protocol=ssh;branch=psaavedra/fifo-ctrl \
           file://wpe-ctl \
           file://wpe-exported-wayland \
          "
SRCREV = "4d6ac73efff52b8ba6d1f39d17fa48c5e8f8e8ea"

S = "${WORKDIR}/git"

EXTRA_OECMAKE = ""

do_install:append () {
    install -d ${D}/${bindir}/
    install -m 755 ${B}/wpe-simple-launcher ${D}/${bindir}/wpe-simple-launcher
    install -m 755 ${WORKDIR}/wpe-ctl ${D}/${bindir}/wpe-ctl
    install -m 755 ${WORKDIR}/wpe-exported-wayland ${D}/${bindir}/wpe-exported-wayland
}

RDEPENDS:${PN} += "bash"
