FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Add-LAYER_BASED_SVG_ENGINE-envvar_v2.44.patch "

SRCBRANCH:class-devupstream = "main"
SRC_URI:class-devupstream = "git://github.com/WebKit/WebKit.git;protocol=https;branch=${SRCBRANCH} \
                             file://0001-Add-LAYER_BASED_SVG_ENGINE-envvar_v2.50.patch "
SRCREV:class-devupstream = "275cc71ab49a9e77631f34a8c7c2bdd5fd1b4695"
# SRCREV:class-devupstream = "${AUTOREV}"

PV:class-devupstream = "trunk"

RCONFLICTS:${PN}:class-devupstream = ""

PACKAGECONFIG[sysprof] = "-DUSE_SYSTEM_SYSPROF_CAPTURE=ON, -DUSE_SYSTEM_SYSPROF_CAPTURE=OFF,"

PACKAGECONFIG:append = " experimental-wpe-platform"
PACKAGECONFIG:remove = "speech-synthesis"

