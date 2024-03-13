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
            file://24x24-blank.png \
            file://wpe_white.jpg \
            file://application-exit-symbolic.symbolic.png \
            file://find-location-symbolic.symbolic.png \
            file://go-next-symbolic-rtl.symbolic.png \
            file://go-next-symbolic.symbolic.png \
            file://network-wireless-acquiring-symbolic.symbolic.png \
            file://user-home-symbolic.symbolic.png \
            file://utilities-terminal-symbolic.symbolic.png \
            file://view-refresh-symbolic.symbolic.png \
            file://web-browser-symbolic.symbolic.png \
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
    ${datadir}/24x24-blank.png \
    ${datadir}/application-exit-symbolic.symbolic.png \
    ${datadir}/find-location-symbolic.symbolic.png \
    ${datadir}/go-next-symbolic-rtl.symbolic.png \
    ${datadir}/go-next-symbolic.symbolic.png \
    ${datadir}/network-wireless-acquiring-symbolic.symbolic.png \
    ${datadir}/user-home-symbolic.symbolic.png \
    ${datadir}/utilities-terminal-symbolic.symbolic.png \
    ${datadir}/view-refresh-symbolic.symbolic.png \
    ${datadir}/web-browser-symbolic.symbolic.png \
    ${datadir}/wpe_white.jpg \
    ${bindir}/weston-terminal-configure-network \
    "

do_install:append () {
    # Install Weston wayland-1 systemd service and path
    install -D -p -m0644 ${WORKDIR}/wayland-1.service ${D}${systemd_system_unitdir}/wayland-1.service
    install -D -p -m0644 ${WORKDIR}/wayland-1.path ${D}${systemd_system_unitdir}/wayland-1.path

    install -d -D -p -m0755 ${D}${datadir}/
    install -D -p -m0644 ${WORKDIR}/24x24-blank.png                                  ${D}${datadir}/
    install -D -p -m0644 ${WORKDIR}/application-exit-symbolic.symbolic.png           ${D}${datadir}/
    install -D -p -m0644 ${WORKDIR}/find-location-symbolic.symbolic.png              ${D}${datadir}/
    install -D -p -m0644 ${WORKDIR}/go-next-symbolic-rtl.symbolic.png                ${D}${datadir}/
    install -D -p -m0644 ${WORKDIR}/go-next-symbolic.symbolic.png                    ${D}${datadir}/
    install -D -p -m0644 ${WORKDIR}/network-wireless-acquiring-symbolic.symbolic.png ${D}${datadir}/
    install -D -p -m0644 ${WORKDIR}/user-home-symbolic.symbolic.png                  ${D}${datadir}/
    install -D -p -m0644 ${WORKDIR}/utilities-terminal-symbolic.symbolic.png         ${D}${datadir}/
    install -D -p -m0644 ${WORKDIR}/view-refresh-symbolic.symbolic.png               ${D}${datadir}/
    install -D -p -m0644 ${WORKDIR}/web-browser-symbolic.symbolic.png                ${D}${datadir}/
    install -D -p -m0644 ${WORKDIR}/wpe_white.jpg                                    ${D}${datadir}/

    install -Dm755 ${WORKDIR}/kill-demo ${D}/${bindir}/kill-demo
    install -Dm755 ${WORKDIR}/toggle-gallium-hud ${D}/${bindir}/toggle-gallium-hud
    install -Dm755 ${WORKDIR}/cog-demo-run ${D}/${bindir}/cog-demo-run
    install -Dm755 ${WORKDIR}/demo-wpe-website ${D}/${bindir}/demo-wpe-website
    install -Dm755 ${WORKDIR}/demo-wpe-duckduckgo ${D}/${bindir}/demo-wpe-duckduckgo
    install -Dm755 ${WORKDIR}/weston-terminal-configure-network ${D}/${bindir}/weston-terminal-configure-network
}

SYSTEMD_SERVICE:${PN} += " wayland-1.path"
