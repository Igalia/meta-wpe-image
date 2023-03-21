FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

S:class-devupstream = "${WORKDIR}/git"
SRC_URI:class-devupstream = "git://github.com/WebKit/webkit.git;protocol=https;branch=main"

# SRCREV:class-devupstream = "${AUTOREV}"
SRCREV:class-devupstream = "1de3be56f82b7fa7a908dc834666b1d1b4d706eb"

# XXX: Renderer process ran out of memory issue regression added in
# f822d46cdb31d1d3df1915a99c0413acbcb06fd1 for 32-bits builds
# Bug: https://bugs.webkit.org/show_bug.cgi?id=241012
# Date: Fri May 13 22:56:17 2022
# Revision frozen until this is fixed.

PV:class-devupstream = "trunk"

RCONFLICTS:${PN}:class-devupstream = ""

PACKAGECONFIG:append = " experimental-features"

# mediastream: Needed since >2.40.
PACKAGECONFIG:append:class-devupstream = " mediastream"

# PACKAGECONFIG:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'api-documentation', 'documentation', '' ,d)} instrospection"

EXTRA_OECMAKE += " -DENABLE_SPEECH_SYNTHESIS=OFF"

