FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG:append = " accessibility experimental-features lbse mediastream"

EXTRA_OECMAKE += " -DENABLE_SPEECH_SYNTHESIS=OFF"

# 2.40 fails to build with this experimental feature enabled
EXTRA_OECMAKE += " -DENABLE_WEB_CODECS=OFF"

