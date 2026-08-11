FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG:append = " experimental-features minibrowser"

CXXFLAGS:append = " -Wno-error=unsafe-buffer-usage -Wno-invalid-constexpr"
CFLAGS:append = " -Wno-error=unsafe-buffer-usage -Wno-invalid-constexpr"
