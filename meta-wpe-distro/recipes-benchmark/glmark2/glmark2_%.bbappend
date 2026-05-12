PACKAGECONFIG_imxgpu3d = "${@bb.utils.contains('DISTRO_FEATURES', 'x11 opengl', 'x11-gl x11-gles2', '', d)} \
                  drm-gl drm-gles2"
