FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# nooelint: oelint.vars.srcurifile
SRC_URI += "file://0001-Add-LAYER_BASED_SVG_ENGINE-envvar_v2.52.patch "
SRCBRANCH:class-devupstream = "main"
SRC_URI:class-devupstream = "git://github.com/WebKit/WebKit.git;protocol=https;branch=${SRCBRANCH}"
# Temporarily disabled because this patch is not updated:
# file://0001-Add-LAYER_BASED_SVG_ENGINE-envvar_v2.52.patch
# nooelint: oelint.vars.autorev oelint.append.protvars.SRCREV
SRCREV:class-devupstream = "${AUTOREV}"

# nooelint: oelint.var.order.PV oelint.append.protvars.PV
PV:class-devupstream = "trunk"

PACKAGECONFIG:append = " wpe-platform"
PACKAGECONFIG:remove = "speech-synthesis"

RCONFLICTS:${PN}:class-devupstream = ""

EXTRA_OECMAKE:append:class-devupstream = " -DUSE_VULKAN=OFF"
EXTRA_OECMAKE:append:class-devupstream = " -DCMAKE_DISABLE_PRECOMPILE_HEADERS=ON"

TOOLCHAIN:aarch64 = "clang"
LIBCPLUSPLUS:aarch64 = "-stdlib=libc++"

# nooelint: oelint.var.order.FILES
FILES:${PN} += "${libdir}/mimalloc-3.2*"

# Added for 2.54.x
PACKAGECONFIG[spellcheck] = "-DENABLE_SPELLCHECK=ON,-DENABLE_SPELLCHECK=OFF,enchant2"
