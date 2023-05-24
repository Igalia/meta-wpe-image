FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Add-LAYER_BASED_SVG_ENGINE-envvar.patch"

# Available since >=2.40
PACKAGECONFIG:append = " webgl2 lbse"
