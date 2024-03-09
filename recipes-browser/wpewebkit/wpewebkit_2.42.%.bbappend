FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Add-LAYER_BASED_SVG_ENGINE-envvar_v2.42.patch \
            file://0001-LBSE-Correct-animation-boundaries-avoiding-excessive.patch \
           "

SRC_URI:class-devupstream = "git://github.com/WebKit/webkit.git;protocol=https;branch=main"
S:class-devupstream = "${WORKDIR}/git"

SRCREV:class-devupstream = "33c49ff64449389431294ba0ace6f7d0ad6306b7"
# SRCREV:class-devupstream = "${AUTOREV}"

PV:class-devupstream = "trunk"

RCONFLICTS:${PN}:class-devupstream = ""

DEPENDS:class-devupstream += " libinput libbacktrace"
