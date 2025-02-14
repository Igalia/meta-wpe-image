SUMMARY = "Multiple WPE demo"
DESCRIPTION = "This recipe installs multiple WPEWebKit demos"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEPENDS += "python3"

HOSTTOOLS += "ffmpeg"

SRC_URI = " \
    file://bin/ \
    file://htdocs/ \
    file://icons/ \
"

# demo-videos-wolvic
SRC_URI:append = " git://gitlab.igalia.com/teams/core/misc/demo-wolvic-videos.git;branch=main;protocol=https;name=demo-videos-wolvic;destsuffix=${S}/htdocs/demo-videos-wolvic"
SRCREV_demo-videos-wolvic = "${AUTOREV}"

S = "${WORKDIR}"

PACKAGES = "${PN}-svg-tiger ${PN}-svg-toggler ${PN}-videos-wolvic"

FILES:${PN}-svg-tiger = " \
    /usr/bin/demo-wpe-svg-tiger \
    /mnt/wpe-demos/demo-wpe-svg-tiger/ \
    /mnt/install/icons/demo-wpe-svg-tiger.png \
"

FILES:${PN}-svg-toggler = " \
    /usr/bin/demo-wpe-svg-toggler \
"

FILES:${PN}-videos-wolvic = " \
    /usr/bin/demo-videos-wolvic \
    /mnt/wpe-demos/demo-videos-wolvic/ \
    /mnt/install/icons/demo-videos-wolvic.png \
"

RDEPENDS:${PN}-svg-toggler = "bash"
RDEPENDS:${PN}-videos-wolvic = "perl"

python do_fetch:append() {
    import os
    import subprocess

    s_path = d.getVar('S')
    demo_videos_dir = os.path.join(s_path, "demo-videos-wolvic")
    download_script = os.path.join(s_path, "htdocs", "demo-videos-wolvic", "download.py")
    os.makedirs(demo_videos_dir, exist_ok=True)

    if os.path.isfile(download_script):
        try:
            subprocess.check_call(["python3", download_script],
                                  cwd=os.path.dirname(download_script))
            videos_dir = os.path.join(os.path.dirname(download_script),
                                      "videos")
            if os.path.isdir(videos_dir):
                subprocess.check_call(["mv", videos_dir, demo_videos_dir])
        except subprocess.CalledProcessError as e:
            bb.fatal(f"Failed to execute {download_script}: {e}")
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/bin/demo-* ${D}${bindir}/

    install -d ${D}/mnt/wpe-demos/
    cp -r ${WORKDIR}/htdocs/demo-videos-wolvic ${D}/mnt/wpe-demos/
    cp -r ${WORKDIR}/demo-videos-wolvic/videos ${D}/mnt/wpe-demos/demo-videos-wolvic/
    cp -r ${WORKDIR}/htdocs/demo-wpe-svg-tiger ${D}/mnt/wpe-demos/

    install -d ${D}/mnt/install/icons/
    install -m 644 ${WORKDIR}/icons/demo-videos-wolvic.png ${D}/mnt/install/icons/
    install -m 644 ${WORKDIR}/icons/demo-wpe-svg-tiger.png ${D}/mnt/install/icons/
}
