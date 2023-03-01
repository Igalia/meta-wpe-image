FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
FILESEXTRAPATHS:prepend:class-devupstream := "${THISDIR}/files:"

SRC_URI += " \
    file://cog-drm \
    file://cog-drm-kill-weston \
    file://cog-fdo \
    file://cog-fdo-ctl \
    file://cog-fdo-exported-wayland \
    file://cog-set-opaque-region_v0.14.patch \
"

SRC_URI:class-devupstream += " \
    file://cog-drm \
    file://cog-drm-kill-weston \
    file://cog-fdo \
    file://cog-fdo-ctl \
    file://cog-fdo-exported-wayland \
    file://cog-set-opaque-region_devupstream.patch \
"

do_install:append () {
    install -d ${D}/${bindir}/
    install -m 755 ${WORKDIR}/cog-drm ${D}/${bindir}/cog-drm
    install -m 755 ${WORKDIR}/cog-drm-kill-weston ${D}/${bindir}/cog-drm-kill-weston
    install -m 755 ${WORKDIR}/cog-fdo ${D}/${bindir}/cog-fdo
    install -m 755 ${WORKDIR}/cog-fdo-ctl ${D}/${bindir}/cog-fdo-ctl
    install -m 755 ${WORKDIR}/cog-fdo-exported-wayland ${D}/${bindir}/cog-fdo-exported-wayland
}

SRCREV:class-devupstream = "${AUTOREV}"

PV:class-devupstream = "trunk"

RDEPENDS:${PN} += "bash sudo"
RDEPENDS:${PN}:class-devupstream += "bash sudo"

