DESCRIPTION += "for demos"

# nooelint: oelint.vars.outofcontext
IMAGE_FEATURES += "hwcodecs ssh-server-openssh"

inherit moonforge-image features_check

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

# Allow dropbear/openssh to accept root logins if debug-tweaks or allow-root-login is enabled
ROOTFS_POSTPROCESS_COMMAND += "ssh_internal_sftp; "

#
# Set a valid internal-sftp
#
ssh_internal_sftp () {
        for config in sshd_config sshd_config_readonly; do
                if [ -e ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config ]; then
                        sed -i 's/^[#[:space:]]*Subsystem sftp.*/Subsystem sftp internal-sftp/' ${IMAGE_ROOTFS}${sysconfdir}/ssh/$config
                fi
        done
}

