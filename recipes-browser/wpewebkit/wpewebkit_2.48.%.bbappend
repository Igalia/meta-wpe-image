FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Disable-accelerated-canvas-by-default.patch \
            file://0002-Enable-damage-propagation-by-default.patch \
            file://0003-Add-LAYER_BASED_SVG_ENGINE-envvar_v2.44.patch"

SRCBRANCH:class-devupstream = "main"
SRC_URI:class-devupstream = "git://github.com/WebKit/WebKit.git;protocol=https;branch=${SRCBRANCH} \
                             file://0001-Disable-accelerated-canvas-by-default.patch \
                             file://0002-Enable-damage-propagation-by-default.patch \
                             file://0003-Add-LAYER_BASED_SVG_ENGINE-envvar_v2.44.patch"
SRCREV:class-devupstream = "${AUTOREV}"

PV:class-devupstream = "trunk"

RCONFLICTS:${PN}:class-devupstream = ""

PACKAGECONFIG[sysprof] = "-DUSE_SYSTEM_SYSPROF_CAPTURE=ON, -DUSE_SYSTEM_SYSPROF_CAPTURE=OFF,"

PACKAGECONFIG:append = " experimental-wpe-platform"
PACKAGECONFIG:remove = "speech-synthesis"

