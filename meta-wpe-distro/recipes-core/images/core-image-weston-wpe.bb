DESCRIPTION = "core-image-weston with WPEWebKit"

inherit image_demos image_weston

IMAGE_INSTALL:append = " \
    wpewebkit \
    wpe-simple-launcher \
"

