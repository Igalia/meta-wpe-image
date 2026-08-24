SUMMARY = "PulseAudio server and modules for WPE images"
DESCRIPTION = "PulseAudio server, modules and audio libraries used on boards \
where the ALSA compatibility layer is disabled and audio is routed through \
PulseAudio."

inherit packagegroup

# Needed on RPi4 (dtoverlay=vc4-kms-v3d) where the ALSA compatibility is
# disabled (snd_bcm2835.enable_compat_alsa=0), so audio is processed through
# PulseAudio on the user D-Bus session.
RDEPENDS:${PN} = "\
    libasound \
    libcap \
    libpulse \
    libpulsecore \
    libsndfile1 \
    pulseaudio-misc \
    pulseaudio-module-cli \
    pulseaudio-module-dbus-protocol \
    pulseaudio-module-loopback \
    pulseaudio-server \
    sbc \
"
