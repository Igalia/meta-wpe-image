FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://uinput.cfg \
            file://ikconfig.cfg \
            file://sched-ext.cfg \
"

# Enables pahole is required for Generate BTF type information
# (DEBUG_INFO_BTF).
#
# Ref: https://github.com/sched-ext/scx/blob/main/.github/workflows/sched-ext.config
KERNEL_DEBUG = "True"
