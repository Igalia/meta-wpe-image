SUMMARY = "Weston image with WPEWebKit and Cog install dependencies"
DESCRIPTION = "core-image-weston with all the dependencies required to use and install Cog/WPEWebKit"
LICENSE = "MIT"

inherit image_demos image_weston image_ssh_sftp

IMAGE_INSTALL:append = " packagegroup-wpewebkit-depends"
