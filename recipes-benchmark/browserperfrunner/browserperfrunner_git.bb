SUMMARY = "Browser performance benchmark runner scripts"
DESCRIPTION = "This provides a recipe for running run-benchmark and \
               browserperfdash-benchmark perf test scripts"
HOMEPAGE = "https://github.com/Igalia/browserperfrunner"

LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://browserperfdash-benchmark;md5=5de144702cd7cf4dfde864c5174fb818"

# destsuffix keeps the unpack dir matching the default S (${WORKDIR|UNPACKDIR}/${BP})
# on releases older than whinlatter, where the git fetcher unpacks to 'git' instead
SRC_URI = "git://github.com/psaavedra/browserperfrunner.git;protocol=https;branch=update-20260707-1;destsuffix=${BP}"
SRCREV = "d52d7916a68d1a814d18720aedb89e373309a9e1"

inherit python3-dir

PACKAGES = "${PN}"

FILES:${PN} += "${PYTHON_SITEPACKAGES_DIR}"

# benchmark_builder invokes svn, patch and tar to fetch and prepare the
# benchmark sources, github_downloader calls /usr/bin/curl, and the plan
# create scripts need make (dromaeo), perl (sunspider), ruby (jetstream)
# and python (kraken). The linux browser driver uses python3-pygobject
# with the Gtk 3.0 typelib to query the screen resolution.
# Note: the dromaeo plan additionally needs the crc32 tool (Archive::Zip),
# which is not provided by any wrynose layer.
RDEPENDS:${PN} = " \
    curl \
    gobject-introspection \
    gtk+3 \
    make \
    patch \
    perl \
    procps \
    psmisc \
    python3-core \
    python3-modules \
    python3-psutil \
    python3-pygobject \
    python3-setuptools \
    ruby \
    subversion \
"

do_install() {
    install -d ${D}${bindir}
    install -d ${D}${PYTHON_SITEPACKAGES_DIR}
    install -m 0755 ${S}/browserperfdash-benchmark ${D}${bindir}
    install -m 0755 ${S}/run-benchmark ${D}${bindir}
    # webkitpy/__init__.py resolves the bundled WebKit libraries
    # (webkitcorepy, webkitscmpy, webkitbugspy, webkitexpectationspy) from a
    # 'libraries' directory next to the webkitpy package, and uses
    # libraries/autoinstalled as the AutoInstall download location for the
    # remaining third-party python dependencies (downloaded on first import,
    # so the target needs network access and a writable site-packages dir).
    tar -C ${S} -cf - webkitpy libraries | tar -C ${D}${PYTHON_SITEPACKAGES_DIR} --no-same-owner -xf -
}
