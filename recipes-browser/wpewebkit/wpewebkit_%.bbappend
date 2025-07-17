FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

EXTRA_OECMAKE += "-DUSE_GSTREAMER_WEBRTC=OFF"

PACKAGECONFIG:append = " experimental-features minibrowser webrtc libwebrtc"
