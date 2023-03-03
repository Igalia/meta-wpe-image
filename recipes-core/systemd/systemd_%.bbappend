FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG:append = " coredump"

SRC_URI += "file://0001-login-Use-770-mode-instead-of-700-for-the-run-user.patch \
            file://0001-coredump-set-external-storage.patch \
           "

