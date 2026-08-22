DESCRIPTION = "core-image-weston with all the dependencies required to use and install Cog/WPEWebKit"

inherit image_demos image_weston

IMAGE_INSTALL:append = " packagegroup-wpewebkit-depends"
