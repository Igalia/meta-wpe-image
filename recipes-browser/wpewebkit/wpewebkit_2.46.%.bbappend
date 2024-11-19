FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Add-LAYER_BASED_SVG_ENGINE-envvar_v2.44.patch \
            file://0016-Remove-Float16Array-from-WebInspectorUI.patch \
            file://0001-REGRESSION-263237-main-WPE-Identifiers-for-touch-poi.patch \
            "

SRCREV:class-devupstream = "${AUTOREV}"

PV:class-devupstream = "trunk"

RCONFLICTS:${PN}:class-devupstream = ""

PACKAGECONFIG:append = " experimental-wpe-platform lbse offscreen-canvas"
PACKAGECONFIG:remove = "speech-synthesis"

FILES:${PN}-web-inspector-plugin += "${datadir}/wpe-webkit-*/inspector.gresource"
