FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG:append = " experimental-features minibrowser"

# These warnings only exist in clang; guard them with the clang toolchain so
# GCC builds (e.g. the arm/imx machines) do not choke on unknown -W options.
CXXFLAGS:append:toolchain-clang = " -Wno-error=unsafe-buffer-usage -Wno-invalid-constexpr"
CFLAGS:append:toolchain-clang = " -Wno-error=unsafe-buffer-usage -Wno-invalid-constexpr"
