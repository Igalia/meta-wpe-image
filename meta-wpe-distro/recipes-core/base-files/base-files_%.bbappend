do_install:append () {
    # Remove the softlink to var/volatile/tmp. We want var/tmp persistent
    rm ${D}${localstatedir}/tmp
}
