FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG:append = " experimental-features"

EXTRA_OECMAKE += " -DENABLE_SPEECH_SYNTHESIS=OFF"

