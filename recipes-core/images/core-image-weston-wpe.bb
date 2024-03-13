DESCRIPTION = "core-image-weston with Cog/WPEWebKit"

inherit image_browsers image_weston

IMAGE_INSTALL:append = " \
    cog \
    wpebackend-fdo \
    wpewebkit \
"

