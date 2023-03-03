FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:class-nativesdk = " \
    file://OEToolchainConfig.cmake \
"

