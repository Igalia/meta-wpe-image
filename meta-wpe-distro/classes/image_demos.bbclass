DESCRIPTION += "for demos"

# nooelint: oelint.vars.outofcontext
IMAGE_FEATURES += "hwcodecs package-management"

inherit moonforge-image features_check

# Ship the list of installed packages in the image. The overlayfs-etc feature
# set by moonforge-image conflicts with package-management, so the target has
# neither rpm nor its database. This runs before the database is removed.
ROOTFS_POSTUNINSTALL_COMMAND += "write_target_image_manifest"

python write_target_image_manifest () {
    from oe.rootfs import image_list_installed_packages
    from oe.utils import format_pkg_list

    manifest = d.expand("${IMAGE_ROOTFS}${sysconfdir}/installed-packages")
    with open(manifest, "w") as f:
        f.write(format_pkg_list(image_list_installed_packages(d), "ver"))
}

IMAGE_LINGUAS = "en-us es-es"
GLIBC_GENERATE_LOCALES = "en_US.UTF-8 es_ES.UTF-8"

IMAGE_FSTYPES = "wic.bmap wic.bz2 tar.gz"

IMAGE_INSTALL:append = " \
    packagegroup-wpe-demos-tools \
    packagegroup-wpe-vulkan-demos \
    "

# PulseAudio only on RPi4/5: with dtoverlay=vc4-kms-v3d the ALSA compat is
# disabled (snd_bcm2835.enable_compat_alsa=0), so audio is processed through
# PulseAudio on the user D-Bus session.
# nooelint: oelint.vars.specific
IMAGE_INSTALL:append:raspberrypi4 = " packagegroup-wpe-pulseaudio"
# nooelint: oelint.vars.specific
IMAGE_INSTALL:append:raspberrypi4-64 = " packagegroup-wpe-pulseaudio"
# nooelint: oelint.vars.specific
IMAGE_INSTALL:append:raspberrypi5 = " packagegroup-wpe-pulseaudio"

