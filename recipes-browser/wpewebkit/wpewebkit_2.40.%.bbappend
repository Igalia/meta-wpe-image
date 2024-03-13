FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Add-LAYER_BASED_SVG_ENGINE-envvar.patch \
            file://0001-LBSE-Correct-animation-boundaries-avoiding-excessive.patch \
           "

# Available since >=2.40
PACKAGECONFIG:append = " webgl2"
