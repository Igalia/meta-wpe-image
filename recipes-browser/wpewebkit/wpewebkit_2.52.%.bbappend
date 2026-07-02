FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Add-LAYER_BASED_SVG_ENGINE-envvar_v2.52.patch "
SRCBRANCH:class-devupstream = "main"
SRC_URI:class-devupstream = "git://github.com/WebKit/WebKit.git;protocol=https;branch=${SRCBRANCH} \
                             file://0001-bmalloc-libpas-fix-atomic-build-with-gcc13.patch"

# Temporarily disabled because this patch is not updated:
# file://0001-Add-LAYER_BASED_SVG_ENGINE-envvar_v2.52.patch
SRCREV:class-devupstream = "${AUTOREV}"

PV:class-devupstream = "trunk"

RCONFLICTS:${PN}:class-devupstream = ""

EXTRA_OECMAKE:append:class-devupstream = " -DUSE_VULKAN=OFF"
EXTRA_OECMAKE:append:class-devupstream = " -DCMAKE_DISABLE_PRECOMPILE_HEADERS=ON"
EXTRA_OECMAKE:append:class-devupstream = " -DCMAKE_C_STANDARD=11 -DCMAKE_CXX_STANDARD=17"

PACKAGECONFIG:append = " wpe-platform"
PACKAGECONFIG:remove = "speech-synthesis"

# TOOLCHAIN:aarch64 = "clang"
# LIBCPLUSPLUS:aarch64 = "-stdlib=libc++"

FILES:${PN} += "${libdir}/mimalloc-3.2*"

# Added for 2.54.x
PACKAGECONFIG[spellcheck] = "-DENABLE_SPELLCHECK=ON,-DENABLE_SPELLCHECK=OFF,enchant2"
