SUMMARY = "Podman Servo demo"
DESCRIPTION = "This recipe runs Servo on a Pod"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEPENDS += "podman"

SRC_URI = " \
    file://bin/ \
    file://icons/ \
"

S = "${WORKDIR}"

RDEPENDS:${PN} += "bash"

FILES:${PN} = " \
    /usr/bin/podman-demo-servo \
    /mnt/install/icons/podman-demo-servo.png \
"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/bin/podman-demo-servo ${D}${bindir}/

    install -d ${D}/mnt/install/icons/
    install -m 644 ${WORKDIR}/icons/podman-demo-servo.png ${D}/mnt/install/icons/
}
