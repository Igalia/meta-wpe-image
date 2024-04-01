FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Add-LAYER_BASED_SVG_ENGINE-envvar_v2.42.patch \
            file://0001-LBSE-Correct-animation-boundaries-avoiding-excessive.patch \
            file://Fix-LBSE-blurriness.patch \
           "

