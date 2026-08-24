FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-drm-try-other-planes-that-may-support-fences.patch \
            file://0002-drm-fix-a-few-dma-buf-feedback-failure-reasons.patch \
            file://0003-drm-fix-issue-with-enum-being-wrongly-used.patch \
            file://0004-drm-avoid-dma-buf-feedback-endless-loop.patch \
"

# meta-raspberrypi already adds 0001-Adapt-weston-to-64-bit-plane-IDs.patch to
# SRC_URI, but its hunks do not apply on top of the DRM patches above. This
# layer ships an adapted copy of that patch in the weston/ dir; being a
# higher-priority layer, FILESEXTRAPATHS makes our copy override the
# meta-raspberrypi one (do not re-add it to SRC_URI, or it applies twice).
