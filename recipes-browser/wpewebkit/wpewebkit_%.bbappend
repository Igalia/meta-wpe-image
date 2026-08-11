FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG:append = " experimental-features minibrowser"

CXXFLAGS:append = " -Wno-error=unsafe-buffer-usage"
CFLAGS:append = " -Wno-error=unsafe-buffer-usage"
