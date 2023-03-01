DESCRIPTION = "core-image-weston with Cog/WPEWebKit"

inherit image_browsers image_weston

IMAGE_INSTALL:append = " \
    cog \
    perf-scripts \
    wpebackend-fdo \
    wpewebkit \
"

