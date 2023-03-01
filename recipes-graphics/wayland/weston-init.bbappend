FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://weston.env \
            file://weston.ini \
            file://wayland-1.path \
            file://wayland-1.service \
            file://kill-demo \
            file://toggle-gallium-hud \
            file://cog-demo-run \
            file://demo-wpe-website \
            file://demo-wpe-duckduckgo\
            file://wpe_white.jpg \
            file://weston-terminal-configure-network \
           "

inherit useradd
GROUPADD_PARAM:${PN} += "; --gid 900 --system bot;"
USERADD_PARAM:${PN} += "; --uid 900 --system -p '' -s /bin/bash -g bot -G audio,input,video,weston -m bot;"

RDEPENDS:${PN} += "bash"

DIRFILES = "1"

FILES:${PN} += "\
    ${systemd_system_unitdir}/wayland-1.path \
    ${systemd_system_unitdir}/wayland-1.service \
    ${bindir}/kill-demo \
    ${bindir}/toggle-gallium-hud \
    ${bindir}/cog-demo-run \
    ${bindir}/demo-wpe-website \
    ${bindir}/demo-wpe-duckduckgo \
    ${datadir}/wpe_white.jpg \
    ${bindir}/weston-terminal-configure-network \
    "

do_install:append () {
    # Install Weston wayland-1 systemd service and path
    install -D -p -m0644 ${WORKDIR}/wayland-1.service ${D}${systemd_system_unitdir}/wayland-1.service
    install -D -p -m0644 ${WORKDIR}/wayland-1.path ${D}${systemd_system_unitdir}/wayland-1.path

    install -D -p -m0644 ${WORKDIR}/wpe_white.jpg ${D}${datadir}/wpe_white.jpg

    install -Dm755 ${WORKDIR}/kill-demo ${D}/${bindir}/kill-demo
    install -Dm755 ${WORKDIR}/toggle-gallium-hud ${D}/${bindir}/toggle-gallium-hud
    install -Dm755 ${WORKDIR}/cog-demo-run ${D}/${bindir}/cog-demo-run
    install -Dm755 ${WORKDIR}/demo-wpe-website ${D}/${bindir}/demo-wpe-website
    install -Dm755 ${WORKDIR}/demo-wpe-duckduckgo ${D}/${bindir}/demo-wpe-duckduckgo
    install -Dm755 ${WORKDIR}/weston-terminal-configure-network ${D}/${bindir}/weston-terminal-configure-network
}

SYSTEMD_SERVICE:${PN} += " wayland-1.path"
