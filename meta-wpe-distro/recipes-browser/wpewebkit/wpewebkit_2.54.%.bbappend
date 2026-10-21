FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRCBRANCH:class-devupstream = "fix-seconds-suppress-clang18"
SRC_URI:class-devupstream = "git://github.com/psaavedra/WebKit.git;protocol=https;branch=${SRCBRANCH}"
# nooelint: oelint.vars.autorev oelint.append.protvars.SRCREV
SRCREV:class-devupstream = "${AUTOREV}"

# nooelint: oelint.var.order.PV oelint.append.protvars.PV
PV:class-devupstream = "trunk"

PACKAGECONFIG:remove = "speech-synthesis"

RCONFLICTS:${PN}:class-devupstream = ""

TOOLCHAIN:aarch64 = "clang"
LIBCPLUSPLUS:aarch64 = "-stdlib=libc++"
