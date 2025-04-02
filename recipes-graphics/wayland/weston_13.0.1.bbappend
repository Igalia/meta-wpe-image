FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-drm-try-other-planes-that-may-support-fences.patch \
            file://0002-drm-fix-a-few-dma-buf-feedback-failure-reasons.patch \
            file://0003-drm-fix-issue-with-enum-being-wrongly-used.patch \
            file://0004-drm-avoid-dma-buf-feedback-endless-loop.patch \
"
