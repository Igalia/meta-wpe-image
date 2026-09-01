SUMMARY = "core-image-weston with WPEWebKit"
DESCRIPTION = "core-image-weston with WPEWebKit"
LICENSE = "MIT"

inherit image_demos image_weston image_ssh_sftp

IMAGE_INSTALL:append = " \
    wpewebkit \
    wpe-simple-launcher \
"

