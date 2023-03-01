SUMMARY = "perf web engines utilities"
LICENSE = "LGPL-2.1+"
LIC_FILES_CHKSUM = "file://LGPL-2.1-or-later;md5=2a4f4fd2128ea2f65047ee63fbca9f68"

SRC_URI = "file://eglfs.conf \
           file://ps_mem.py \
           file://prof-cog \
           file://prof-qtwpe \
           file://prof-qtwebengine \
           file://qtwpe-eglfs \
           file://__init__.py \
           file://main.py \
           file://psrecord.py \
           file://LGPL-2.1-or-later \
"

S = "${WORKDIR}"

do_install() {
      install -d ${D}${datadir}/perf/
      install eglfs.conf ${D}${datadir}/perf/

      install -d ${D}${bindir}/
      install -m 0755 ps_mem.py ${D}${bindir}
      install -m 0755 qtwpe-eglfs ${D}${bindir}
      install -m 0755 prof-* ${D}${bindir}

      install -d ${D}${datadir}/perf/psrecord/
      install __init__.py ${D}${datadir}/perf/psrecord/
      install main.py ${D}${datadir}/perf/psrecord/
      install -m 0755 psrecord.py ${D}${bindir}/psrecord

}

FILES:${PN} += "${datadir}/perf/*"

RDEPENDS:${PN} += " python3-psutil"
