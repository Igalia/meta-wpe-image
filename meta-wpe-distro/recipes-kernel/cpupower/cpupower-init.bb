SUMMARY = "Init scripts for cpupower"
DESCRIPTION = "systemd service and default configuration to apply cpupower \
settings at boot."
HOMEPAGE = "https://github.com/Igalia/meta-wpe"

inherit systemd

LICENSE = "MIT"
LIC_FILES_CHKSUM ?= "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI += "file://cpupower.default \
            file://cpupower.service \
           "

do_install() {
    install -Dm644 ${WORKDIR}/cpupower.default ${D}${sysconfdir}/default/cpupower
    install -D -p -m0644 ${WORKDIR}/cpupower.service ${D}${systemd_system_unitdir}/cpupower.service
}

RDEPENDS:${PN} = "cpupower"

SYSTEMD_SERVICE:${PN} = "cpupower.service"
SYSTEMD_AUTO_ENABLE = "enable"

