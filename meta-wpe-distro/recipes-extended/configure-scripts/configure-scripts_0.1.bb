SUMMARY = "configure utilities"
LICENSE = "LGPL-2.1+"
LIC_FILES_CHKSUM = "file://LGPL-2.1-or-later;md5=2a4f4fd2128ea2f65047ee63fbca9f68"

SRC_URI = "file://configure-network \
           file://configure-weston \
           file://su-configure-network \
           file://LGPL-2.1-or-later \
"

S = "${WORKDIR}"

do_install() {
      install -d ${D}${bindir}/
      install -m 0755 configure-network ${D}${bindir}
      install -m 0755 configure-weston ${D}${bindir}
      install -m 0755 su-configure-network ${D}${bindir}
}

FILES:${PN} += "${bindir}/*"

RDEPENDS:${PN} += " python3-core"
