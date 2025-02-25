DESCRIPTION = "core-image-weston with WPEWebKit"

inherit image_browsers image_weston

IMAGE_INSTALL:append = " \
    wpewebkit \
    wpe-simple-launcher \
    python3-uinput \
    wpe-demos-videos-wolvic \
    wpe-demos-svg-tiger \
    wpe-demos-svg-toggler \
"

IMAGE_INSTALL:append:raspberrypi4 = " rpi-eeprom"
IMAGE_INSTALL:append:raspberrypi4-64 = " rpi-eeprom"
IMAGE_INSTALL:append:raspberrypi5 = " rpi-eeprom"

IMAGE_INSTALL:append:raspberrypi4-64 = " podman-demo-servo"
IMAGE_INSTALL:append:raspberrypi5 = " podman-demo-servo"

replace_default_apache2_htdocs () {
    mkdir -p ${IMAGE_ROOTFS}/usr/share/apache2/default-site/
    ln -sf /mnt/wpe-demos/ ${IMAGE_ROOTFS}/usr/share/apache2/default-site/htdocs/
}

ROOTFS_POSTPROCESS_COMMAND += "replace_default_apache2_htdocs; "

fakeroot do_populate_image () {
    chown -R weston:weston ${IMAGE_ROOTFS}/mnt/wpe-demos
}

IMAGE_PREPROCESS_COMMAND += "do_populate_image"
