FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Add-LAYER_BASED_SVG_ENGINE-envvar_v2.50.patch "

SRCBRANCH:class-devupstream = "eng/GTK-WPE-Probe-dma-buf-mmap-capability-before-enabling-MemoryMappedGPUBuffer-path"
SRC_URI:class-devupstream = "git://github.com/nikolaszimmermann/WebKit.git;protocol=https;branch=${SRCBRANCH}"
SRCREV:class-devupstream = "21aebcdfd9607f82ae301be0ab068e090c195f6d"

PV:class-devupstream = "trunk"

RCONFLICTS:${PN}:class-devupstream = ""

PACKAGECONFIG:append = " wpe-platform"
PACKAGECONFIG:remove = "speech-synthesis"

TOOLCHAIN:aarch64 = "clang"
LIBCPLUSPLUS:aarch64 = "-stdlib=libc++"

FILES:${PN} += "${libdir}/mimalloc-3.2*"

# Added for 2.52.x
PACKAGECONFIG[libhyphen] = "-DUSE_LIBHYPHEN=ON,-DUSE_LIBHYPHEN=OFF,libhyphen"
