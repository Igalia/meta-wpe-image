FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
FILESEXTRAPATHS:prepend:class-devupstream := "${THISDIR}/files:"

SRC_URI:class-devupstream = "git://github.com/Igalia/cog.git;protocol=https;branch=master"
SRCREV:class-devupstream = "${AUTOREV}"

SRC_URI += " \
    file://cog-drm \
    file://cog-drm-kill-weston \
    file://cog-fdo \
    file://cog-fdo-ctl \
    file://cog-fdo-exported-wayland \
"

SRC_URI:class-devupstream += " \
    file://cog-drm \
    file://cog-drm-kill-weston \
    file://cog-fdo \
    file://cog-fdo-ctl \
    file://cog-fdo-exported-wayland \
    file://0001-wl-Add-safe-guards-for-touch-and-pointer-events.patch \
"

do_install:append () {
    install -d ${D}/${bindir}/
    install -m 755 ${WORKDIR}/cog-drm ${D}/${bindir}/cog-drm
    install -m 755 ${WORKDIR}/cog-drm-kill-weston ${D}/${bindir}/cog-drm-kill-weston
    install -m 755 ${WORKDIR}/cog-fdo ${D}/${bindir}/cog-fdo
    install -m 755 ${WORKDIR}/cog-fdo-ctl ${D}/${bindir}/cog-fdo-ctl
    install -m 755 ${WORKDIR}/cog-fdo-exported-wayland ${D}/${bindir}/cog-fdo-exported-wayland
}

PV:class-devupstream = "trunk"

RDEPENDS:${PN} += "bash"
RDEPENDS:${PN}:class-devupstream += "bash"

PACKAGECONFIG:append = " gtk4 libportal"

# Required for future 0.19
PACKAGECONFIG[libportal] = "-Dlibportal=enabled,-Dlibportal=disabled, libportal"


