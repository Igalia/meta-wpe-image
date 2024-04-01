FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Add-LAYER_BASED_SVG_ENGINE-envvar_v2.44.patch \
            file://0002-Fix-LBSE-blurriness_v2.44.patch \
            "

# SRCREV:class-devupstream = "${AUTOREV}"

PV:class-devupstream = "trunk"

RCONFLICTS:${PN}:class-devupstream = ""

